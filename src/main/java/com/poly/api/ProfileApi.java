package com.poly.api;

import com.google.gson.Gson;
import com.poly.entities.User;
import com.poly.services.UserServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(urlPatterns = "/api/profile/update")
public class ProfileApi extends HttpServlet {
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        try {
            // Đọc dữ liệu JSON (chứa ID, Name, Email, Phone) từ body
            User updatedUser = gson.fromJson(req.getReader(), User.class);

            if (updatedUser == null || updatedUser.getId() == null) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().println("{\"error\":\"Thiếu thông tin người dùng hoặc ID.\"}");
                return;
            }

            // Gọi Service để cập nhật profile
            boolean success = UserServices.updateUserProfile(updatedUser);

            if (success) {
                resp.setStatus(HttpServletResponse.SC_OK);
                Map<String, String> result = new HashMap<>();
                result.put("message", "Cập nhật profile thành công!");
                resp.getWriter().println(gson.toJson(result));
            } else {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().println("{\"error\":\"Cập nhật profile thất bại. Vui lòng kiểm tra ID và dữ liệu.\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().println("{\"error\":\"Lỗi server khi xử lý yêu cầu: " + e.getMessage() + "\"}");
        }
    }
}