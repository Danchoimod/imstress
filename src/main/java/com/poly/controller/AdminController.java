package com.poly.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/admin/video/add","/admin/video/edit"})
public class AdminController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        String path = req.getServletPath();

        if(path.equals("/admin/video/add")) {
            req.getRequestDispatcher("/views/admin/video/add.jsp").forward(req, resp);
            return;
        }
        if(path.equals("/admin/video/edit")) {
            req.getRequestDispatcher("/views/admin/video/edit.jsp").forward(req, resp);
            return;
        }

        req.getRequestDispatcher("/views/.jsp").forward(req, resp);

    }
}

