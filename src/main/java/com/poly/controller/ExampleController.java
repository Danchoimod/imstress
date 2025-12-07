package com.poly.controller;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(urlPatterns = {"/example", "/example/delete"})
public class ExampleController extends HttpServlet {
    int index = 0; //giá trị index tăng lên


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(); //tạo seasson
        Map<Integer, String> map = (Map<Integer, String>) session.getAttribute("map");
        if (map == null) {
            map = new HashMap<>();
            session.setAttribute("map", map);

        }

        String path = req.getServletPath();
        if ("/example/delete".equals(path)) {
            String id = req.getParameter("id");
            if (id != null) {
                try {
                    Integer key = Integer.valueOf(id);
                    map.remove(key);
                    session.setAttribute("map", map);
                } catch (NumberFormatException e) {
                    // handle invalid id
                }
            }
        }

        req.setAttribute("map", map);
        req.getRequestDispatcher("/views/user/example.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        HttpSession session = req.getSession();

        String a = req.getParameter("exampleinput");


        // Lấy map từ session (nếu có)
        Map<Integer, String> map = (Map<Integer, String>) session.getAttribute("map");
        if (map == null) {
            map = new HashMap<>();
        }

        // Lưu dữ liệu mới vào map
        map.put(index++, a);

        // Truyền dữ liệu vào map
        session.setAttribute("map", map);

        // Gửi lại map để hiển thị trên JSP
        req.setAttribute("map", map);
        req.getRequestDispatcher("/views/user/example.jsp").forward(req, resp);

    }

}
