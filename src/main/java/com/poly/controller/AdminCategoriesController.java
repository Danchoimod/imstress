package com.poly.controller;

import com.poly.beans.CategoryBean;
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
        // FIX QUAN TRỌNG: Khởi tạo CategoryBean nếu chưa tồn tại
        // Điều này ngăn chặn lỗi NullPointerException khi JSP truy cập ${bean.xyz}
        if (req.getAttribute("bean") == null) {
            req.setAttribute("bean", new CategoryBean());
        }

        RequestDispatcher rd = req.getRequestDispatcher("/views/admin/categories.jsp");
        rd.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        // Giữ lại logic bean để đảm bảo không lỗi nếu form submit bị gọi
        CategoryBean bean = new CategoryBean();

        try {
            BeanUtils.populate(bean, req.getParameterMap());
            req.setAttribute("bean", bean);
            // Bỏ qua logic xử lý form ở đây vì nó đã được chuyển sang AJAX/API

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
        }

        req.getRequestDispatcher("/views/admin/categories.jsp").forward(req, resp);
    }
}