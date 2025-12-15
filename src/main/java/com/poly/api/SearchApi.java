package com.poly.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.poly.entities.Video;
import com.poly.reponse.VideoReponse;
import com.poly.services.VideoServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = "/api/search")
public class SearchApi extends HttpServlet {
    private final Gson gson = new GsonBuilder().serializeNulls().create();

    private void sendJson(HttpServletResponse resp, int status, Object data) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().println(gson.toJson(data));
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String keyword = req.getParameter("q");

        // Kiểm tra keyword có rỗng không
        if (keyword == null || keyword.trim().isEmpty()) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Vui lòng nhập từ khóa tìm kiếm");
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, error);
            return;
        }

        try {
            // Gọi service tìm kiếm
            List<Video> videos = VideoServices.searchVideosByTitle(keyword.trim());
            List<VideoReponse> responses = new ArrayList<>();

            // Ánh xạ Entity sang Response DTO
            for (Video entity : videos) {
                VideoReponse response = new VideoReponse();
                response.setId(entity.getId());
                response.setTitle(entity.getTitle());
                response.setDesc(entity.getDesc());
                response.setPoster(entity.getPoster());
                response.setUrl(entity.getUrl());
                response.setCreateAt(entity.getCreateAt());
                response.setStatus(entity.getStatus());
                responses.add(response);
            }

            sendJson(resp, HttpServletResponse.SC_OK, responses);

        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "Lỗi server khi tìm kiếm: " + e.getMessage());
            sendJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, error);
        }
    }
}