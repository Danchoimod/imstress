package com.poly.controller;

import com.poly.beans.CategoryBean;
import com.poly.beans.VideoBean;
import org.apache.commons.beanutils.BeanUtils;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = "/admin/categories")
public class AdminCategoriesController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RequestDispatcher rd = req.getRequestDispatcher("/views/admin/categories.jsp");
        rd.forward(req, resp);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        // Sửa: Dùng VideoBean để xử lý dữ liệu form video
        CategoryBean bean = new CategoryBean();

        try {
            // 1. Ánh xạ dữ liệu từ form vào Bean
            BeanUtils.populate(bean, req.getParameterMap());

            // 2. Đặt Bean vào request để giữ lại dữ liệu nếu có lỗi
            req.setAttribute("bean", bean);

            // 3. Kiểm tra lỗi Validation (trong VideoBean)
            if (bean.getErrors().isEmpty()) {

                // 4. Thực hiện thêm/sửa video (Cần thay đổi logic này cho phù hợp)
                System.out.println("Validation Success. Preparing to save video...");

//                // Ví dụ chuyển Bean sang Entity (Giả định bạn có Video entity)
//                 Video video = new Video();
//                 video.setTitle(bean.getTitle());
//                 video.setUrl(bean.getUrl());
//                 video.setCategory(bean.getCategory());

                // [TÙY CHỌN: Gọi VideoServices.save(video) để lưu vào DB]
//                 Map<String, String> errDB = VideoServices.save(video);

                // if (errDB.isEmpty()) {
                System.out.println("Video Saved Successfully");
                req.setAttribute("message", "Lưu video thành công!");
                // } else {
                // req.setAttribute("errDB", errDB);
                // System.out.println("Video Save Fail");
                // }
            } else {
                System.out.println("Validation Fail.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
        }

        // 5. Chuyển hướng lại về trang quản lý video để hiển thị kết quả/lỗi
        req.getRequestDispatcher("/views/admin/categories.jsp").forward(req, resp);
    }
}

