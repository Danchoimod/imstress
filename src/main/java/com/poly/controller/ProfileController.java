package com.poly.controller;

import com.poly.beans.ProfileBean;
import com.poly.beans.VideoBean;
import com.poly.util.Utils;
import org.apache.commons.beanutils.BeanUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/profile","/user/profile/update"})

public class ProfileController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String userID = Utils.getCookieValue(Utils.COOKIE_KEY_USER_ID, req);
        String role = Utils.getCookieValue(Utils.COOKIE_KEY_ROLE, req);

        if (userID == null || userID.isEmpty()) {
            // 2. Nếu không tìm thấy Cookie, chuyển hướng đến trang Đăng nhập
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return; // Dừng xử lý
        }
        req.getRequestDispatcher("/views/user/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        String path = req.getServletPath();
        String userID = Utils.getCookieValue(Utils.COOKIE_KEY_USER_ID, req);
        String role = Utils.getCookieValue(Utils.COOKIE_KEY_ROLE, req);
        try {
            ProfileBean bean = new ProfileBean(); //khời tạo bean để chứa dữ liệu từ form
            BeanUtils.populate(bean, req.getParameterMap());
            req.setAttribute("bean", bean); //truyền đối tượng vào jsp
            if (bean.getErrors().isEmpty()) {

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
            req.setAttribute("errors", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
            throw new RuntimeException(e);
        }
        req.getRequestDispatcher("/views/user/profile.jsp").forward(req, resp);

    }
}

