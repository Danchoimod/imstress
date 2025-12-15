package com.poly.controller;

import com.poly.beans.LoginBean;
import com.poly.beans.RegisterBean;
import com.poly.entities.User;
import com.poly.services.UserServices;
import com.poly.util.Cookies;
import com.poly.util.Utils;
import org.apache.commons.beanutils.BeanUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@WebServlet(urlPatterns = {"/auth/register","/auth/login", "/auth/logout"})
public class AuthController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if(path.equals("/auth/register")){
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
        if(path.equals("/auth/register")) {
            register(req, resp);
        } else if (path.equals("/auth/login")) {
            login(req, resp);
        }
    }

    private void register(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        // khi nhấn nút đăng ký
        try {
            RegisterBean bean = new RegisterBean();

            BeanUtils.populate(bean, req.getParameterMap()); // thư viện tự động lấy getparemter

            req.setAttribute("bean", bean);

            if (bean.getErrors().isEmpty()) {
//				thực hiện đăng ký tài khoản
//				convert bean to entity
                User user = new User();
                user.setUsername(bean.getUsername());
                user.setPassword(bean.getPassword());
                user.setEmail(bean.getEmail());
                user.setPhone(bean.getPhone());
                user.setName(bean.getName());

                Map<String, String> errDB = UserServices.register(user);

                if (errDB.isEmpty()) {
                    System.out.println("Register Success");
                    resp.sendRedirect(req.getContextPath() + "/");
                    return;
                } else {
                    req.setAttribute("errDB", errDB);
                    System.out.println("Register Fail");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        req.getRequestDispatcher("/views/user/register.jsp").forward(req, resp);

    }

    private void login(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        LoginBean bean = new LoginBean();

        try {
            System.out.println("debugg");

            BeanUtils.populate(bean, req.getParameterMap());

            req.setAttribute("bean", bean);

            if (bean.getErrors().isEmpty()) {
//				Kiểm tra đăng nhập. nếu thành công lưu userId và role vào cookie
                User user = UserServices.Login(bean.getUsernameOrEmail(), bean.getPassword());
                Utils.setCookie(Utils.COOKIE_KEY_USER_ID, String.valueOf(user.getId()), resp);
                Utils.setCookie(Utils.COOKIE_KEY_ROLE, String.valueOf(user.getRole()), resp);
                System.out.println("login success");
                resp.sendRedirect(req.getContextPath() + "/");
                return;
            }
        } catch (Exception e) {
            bean.setPassword("lỗi đăng nhập");
            req.setAttribute("bean", bean);
        }

        req.getRequestDispatcher("/views/user/login.jsp").forward(req, resp);


    }

    private void logout(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("Logout - Clearing all cookies");
        Utils.clearCookie(req, resp);
        resp.sendRedirect(req.getContextPath() + "/auth/login");
    }
}

