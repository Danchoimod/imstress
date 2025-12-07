package com.poly.api;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.poly.reponse.DashboardReponse;
import com.poly.services.DashboardServices; // Import DashboardServices


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = "/api/dashboard")
public class DashboardApi extends HttpServlet {

    // Khai báo nhãn cho các chỉ số KPI theo thứ tự trong SQL
    private static final String[] KPI_LABELS = {
            "TotalUsers",
            "TotalVideos",
            "TotalComments",
            "TotalCategories"
    };

    // Đối tượng ObjectMapper dùng để chuyển đổi Java Object sang JSON
    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // 1. Cấu hình Content Type và Encoding cho phản hồi JSON
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        List<DashboardReponse> responses = new ArrayList<>();

        try {
            // 2. Gọi Service để lấy các giá trị KPI (List<Long>)
            List<Long> kpiValues = DashboardServices.getNumber();

            // Kiểm tra và xử lý kết quả
            if (kpiValues != null && kpiValues.size() == KPI_LABELS.length) {
                // 3. Đóng gói kết quả vào List<DashboardReponse>
                for (int i = 0; i < KPI_LABELS.length; i++) {
                    DashboardReponse response = new DashboardReponse();
                    response.setLabel(KPI_LABELS[i]);
                    response.setValue(kpiValues.get(i));
                    responses.add(response);
                }
            } else {
                // Xử lý trường hợp service trả về null hoặc thiếu dữ liệu
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // Mã lỗi 500
                mapper.writeValue(resp.getWriter(), "Lỗi: Không đủ dữ liệu KPI từ Service.");
                return;
            }

            // 4. Chuyển đổi List<DashboardReponse> sang JSON và gửi về client
            mapper.writeValue(resp.getWriter(), responses);

        } catch (Exception e) {
            // Bắt lỗi chung trong quá trình xử lý (ví dụ: lỗi JPA, lỗi JSON)
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // Mã lỗi 500
            mapper.writeValue(resp.getWriter(), "Lỗi server trong quá trình xử lý API: " + e.getMessage());
            e.printStackTrace();
        }
    }
}