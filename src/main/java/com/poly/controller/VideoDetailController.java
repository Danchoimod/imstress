package com.poly.controller;

import com.poly.services.VideoServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = "/videodetail")
public class VideoDetailController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String videoIdParam = req.getParameter("id");
        if (videoIdParam != null) {
            try {
                int videoId = Integer.parseInt(videoIdParam);
                VideoServices.increaseViewCount(videoId);
            } catch (NumberFormatException ignored) {
            }
        }
        req.getRequestDispatcher("/views/user/videoDetail.jsp").forward(req, resp);
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
    }
}
