package com.poly.controller;

import com.poly.beans.LoginBean;
import com.poly.beans.RegisterBean;
import com.poly.entities.User;
import com.poly.services.UserServices;
import com.poly.util.Cookies;
import com.poly.util.Utils;
import org.apache.commons.beanutils.BeanUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

@WebServlet(urlPatterns = {"/auth/register", "/auth/login", "/auth/logout"})
public class AuthController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Lấy thông báo từ Session (nếu có) để hiển thị 1 lần rồi xóa ngay (Flash Message)
        HttpSession session = req.getSession();
        if (session.getAttribute("successMessage") != null) {
            req.setAttribute("successMessage", session.getAttribute("successMessage"));
            session.removeAttribute("successMessage");
        }
        if (session.getAttribute("errorMessage") != null) {
            req.setAttribute("errorMessage", session.getAttribute("errorMessage"));
            session.removeAttribute("errorMessage");
        }

        String path = req.getServletPath();
        if (path.equals("/auth/register")) {
            req.getRequestDispatcher("/views/user/register.jsp").forward(req, resp);
        } else if (path.equals("/auth/login")) {
            req.getRequestDispatcher("/views/user/login.jsp").forward(req, resp);
        } else if (path.equals("/auth/logout")) {
            logout(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if (path.equals("/auth/register")) {
            register(req, resp);
        } else if (path.equals("/auth/login")) {
            login(req, resp);
        }
    }

    private void register(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        try {
            RegisterBean bean = new RegisterBean();
            BeanUtils.populate(bean, req.getParameterMap());
            req.setAttribute("bean", bean);

            if (bean.getErrors().isEmpty()) {
                User user = new User();
                user.setUsername(bean.getUsername());
                user.setPassword(bean.getPassword());
                user.setEmail(bean.getEmail());
                user.setPhone(bean.getPhone());
                user.setName(bean.getName());

                Map<String, String> errDB = UserServices.register(user);

                if (errDB.isEmpty()) {
                    // Đăng ký thành công: Lưu thông báo vào Session và Redirect sang Login
                    HttpSession session = req.getSession();
                    session.setAttribute("successMessage", "Đăng ký thành công! Vui lòng đăng nhập.");
                    resp.sendRedirect(req.getContextPath() + "/auth/login");
                    return;
                } else {
                    // Lỗi từ DB (trùng email/user): Forward lại trang Register
                    req.setAttribute("errDB", errDB);
                    req.setAttribute("errorMessage", "Đăng ký thất bại. Vui lòng kiểm tra lại thông tin.");
                }
            } else {
                req.setAttribute("errorMessage", "Vui lòng kiểm tra lại các trường dữ liệu.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
        }

        req.getRequestDispatcher("/views/user/register.jsp").forward(req, resp);
    }

    private void login(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        LoginBean bean = new LoginBean();

        try {
            BeanUtils.populate(bean, req.getParameterMap());
            req.setAttribute("bean", bean);

            if (bean.getErrors().isEmpty()) {
                User user = UserServices.Login(bean.getUsernameOrEmail(), bean.getPassword());

                if (user != null) {
                    // Đăng nhập thành công
                    Utils.setCookie(Utils.COOKIE_KEY_USER_ID, String.valueOf(user.getId()), resp);
                    Utils.setCookie(Utils.COOKIE_KEY_ROLE, String.valueOf(user.getRole()), resp);

                    // Có thể thêm thông báo chào mừng vào Session nếu muốn hiển thị ở trang chủ
                    // HttpSession session = req.getSession();
                    // session.setAttribute("successMessage", "Chào mừng quay trở lại!");

                    resp.sendRedirect(req.getContextPath() + "/");
                    return;
                } else {
                    // Đăng nhập thất bại (User null hoặc logic trả về null)
                    req.setAttribute("errorMessage", "Tài khoản hoặc mật khẩu không chính xác!");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Bắt lỗi khi service ném exception (ví dụ sai pass)
            req.setAttribute("errorMessage", "Tài khoản hoặc mật khẩu không chính xác!");
        }

        req.getRequestDispatcher("/views/user/login.jsp").forward(req, resp);
    }

    private void logout(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Utils.clearCookie(req, resp);
        HttpSession session = req.getSession();
        session.setAttribute("successMessage", "Đăng xuất thành công!");
        resp.sendRedirect(req.getContextPath() + "/auth/login");
    }
}