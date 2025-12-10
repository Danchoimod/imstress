package com.poly.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.poly.entities.Favourites;
import com.poly.entities.Video;
import com.poly.reponse.VideoReponse;
import com.poly.services.FavServices;
import com.poly.util.Utils;

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

@WebServlet(urlPatterns = "/api/fav")
public class FavApi extends HttpServlet {
    private final Gson gson = new GsonBuilder().serializeNulls().create();

    // Helper method to get user ID from cookie
    private Integer getUserIdFromCookie(HttpServletRequest req) {
        String userIdStr = Utils.getCookieValue(Utils.COOKIE_KEY_USER_ID, req);
        try {
            return userIdStr != null ? Integer.parseInt(userIdStr) : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private void sendJson(HttpServletResponse resp, int status, Object data) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().println(gson.toJson(data));
    }


    // GET: Lấy danh sách video yêu thích (hoặc kiểm tra trạng thái yêu thích)
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer userId = getUserIdFromCookie(req);
        String videoIdParam = req.getParameter("videoId");

        if (userId == null) {
            sendJson(resp, HttpServletResponse.SC_UNAUTHORIZED, Map.of("error", "Vui lòng đăng nhập."));
            return;
        }

        try {
            if (videoIdParam != null) {
                // Yêu cầu kiểm tra trạng thái yêu thích của một video cụ thể
                int videoId = Integer.parseInt(videoIdParam);
                Favourites fav = FavServices.findFavorite(userId, videoId);
                sendJson(resp, HttpServletResponse.SC_OK, Map.of("isFavorited", fav != null));

            } else {
                // Yêu cầu lấy danh sách video yêu thích của người dùng
                List<Video> videos = FavServices.getFavoritesByUserId(userId);
                List<VideoReponse> responses = new ArrayList<>();

                // Ánh xạ (Mapping) từ Video Entity sang VideoReponse
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
            }

        } catch (NumberFormatException e) {
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, Map.of("error", "Định dạng ID không hợp lệ."));
        } catch (Exception e) {
            e.printStackTrace();
            sendJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, Map.of("error", "Lỗi server khi tải dữ liệu yêu thích."));
        }
    }

    // POST: Thêm/Xóa yêu thích (Toggle)
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer userId = getUserIdFromCookie(req);
        String videoIdParam = req.getParameter("videoId");

        if (userId == null) {
            sendJson(resp, HttpServletResponse.SC_UNAUTHORIZED, Map.of("error", "Vui lòng đăng nhập để thực hiện chức năng này."));
            return;
        }

        if (videoIdParam == null) {
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, Map.of("error", "Thiếu tham số videoId."));
            return;
        }

        try {
            int videoId = Integer.parseInt(videoIdParam);

            // Thực hiện toggle
            boolean isNowFavorited = FavServices.toggleFavorite(userId, videoId);

            Map<String, Object> result = new HashMap<>();
            result.put("status", "success");
            result.put("action", isNowFavorited ? "favorited" : "unfavorited");
            result.put("message", isNowFavorited ? "Đã thêm vào mục yêu thích!" : "Đã xóa khỏi mục yêu thích!");

            sendJson(resp, HttpServletResponse.SC_OK, result);

        } catch (NumberFormatException e) {
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, Map.of("error", "Định dạng videoId không hợp lệ."));
        } catch (Exception e) {
            e.printStackTrace();
            sendJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, Map.of("error", "Lỗi server khi cập nhật yêu thích."));
        }
    }
}