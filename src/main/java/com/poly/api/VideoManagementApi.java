package com.poly.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.poly.entities.Category;
import com.poly.entities.Video;
import com.poly.entities.User;
import com.poly.services.CategoryServices;
import com.poly.services.VideoServices;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/api/admin/videos"})
public class VideoManagementApi extends HttpServlet {
    private final Gson gson = new GsonBuilder().serializeNulls().create();

    private void sendJson(HttpServletResponse resp, int status, Object data) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().println(gson.toJson(data));
    }

    // GET: Lấy danh sách tất cả video
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<Video> videos = VideoServices.getAllVideo();
            List<Map<String, Object>> responses = new ArrayList<>();

            for (Video video : videos) {
                Map<String, Object> responseMap = new HashMap<>();
                responseMap.put("id", video.getId());
                responseMap.put("title", video.getTitle());
                responseMap.put("desc", video.getDesc());
                responseMap.put("poster", video.getPoster());
                responseMap.put("url", video.getUrl());
                responseMap.put("createAt", video.getCreateAt() != null ? video.getCreateAt().toString() : "");
                responseMap.put("viewCount", video.getViewCount());
                responseMap.put("status", video.getStatus());

                if (video.getCategory() != null) {
                    responseMap.put("catId", video.getCategory().getId());
                    responseMap.put("catName", video.getCategory().getName());
                } else {
                    responseMap.put("catId", null);
                    responseMap.put("catName", "Không có");
                }

                if (video.getUser() != null) {
                    responseMap.put("authId", video.getUser().getId());
                    responseMap.put("authName", video.getUser().getName());
                } else {
                    responseMap.put("authId", null);
                    responseMap.put("authName", "Không rõ");
                }

                responses.add(responseMap);
            }

            sendJson(resp, HttpServletResponse.SC_OK, responses);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "Lỗi server khi tải danh sách video: " + e.getMessage());
            sendJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, error);
        }
    }

    // POST: Xử lý Thêm, Sửa, Xóa, Ẩn/Hiện
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        // Lấy tham số action để phân loại hành động
        String action = req.getParameter("action");

        if ("delete".equalsIgnoreCase(action)) {
            deleteVideo(req, resp);
        } else if ("toggle".equalsIgnoreCase(action)) { // <--- THÊM MỚI: Xử lý ẩn/hiện
            toggleVideoStatus(req, resp);
        } else {
            addOrUpdateVideo(req, resp);
        }
    }

    // Phương thức xử lý ẩn/hiện video (THÊM MỚI)
    private void toggleVideoStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int videoId = Integer.parseInt(req.getParameter("videoId"));
            int status = Integer.parseInt(req.getParameter("status")); // 0: Ẩn, 1: Hiện

            HttpSession session = req.getSession();
            User currentUser = (User) session.getAttribute("user");
            int userId = (currentUser != null) ? currentUser.getId() : 1;

            // Tìm video theo ID (Giả sử VideoServices có hàm findById)
            Video video = VideoServices.findById(videoId);

            if (video != null) {
                video.setStatus(status);
                // Cập nhật lại video. Lưu ý lấy categoryId từ video cũ để không bị null
                int catId = (video.getCategory() != null) ? video.getCategory().getId() : 1;

                String errorMsg = VideoServices.updateVideo(video, userId, catId);

                if (errorMsg == null) {
                    Map<String, Object> result = new HashMap<>();
                    result.put("status", "success");
                    result.put("message", "Đã " + (status == 1 ? "hiện" : "ẩn") + " video thành công!");
                    sendJson(resp, HttpServletResponse.SC_OK, result);
                } else {
                    Map<String, String> error = new HashMap<>();
                    error.put("message", errorMsg);
                    sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, error);
                }
            } else {
                Map<String, String> error = new HashMap<>();
                error.put("message", "Video không tồn tại!");
                sendJson(resp, HttpServletResponse.SC_NOT_FOUND, error);
            }
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("message", "Lỗi xử lý: " + e.getMessage());
            sendJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, error);
        }
    }

    private void addOrUpdateVideo(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            HttpSession session = req.getSession();
            User currentUser = (User) session.getAttribute("user");
            int userId = (currentUser != null) ? currentUser.getId() : 1;

            String title = req.getParameter("title");
            String url = req.getParameter("url");
            String poster = req.getParameter("poster");
            String categoryName = req.getParameter("category");
            String description = req.getParameter("description");
            String videoIdParam = req.getParameter("videoId");

            Category category = CategoryServices.getCategoryByName(categoryName);
            if (category == null) {
                Map<String, Object> result = new HashMap<>();
                result.put("status", "error");
                result.put("message", "Danh mục không tồn tại!");
                sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, result);
                return;
            }

            Video video = new Video();
            video.setTitle(title);
            video.setDesc(description);
            video.setPoster(poster);
            video.setUrl(url);
            video.setStatus(1); // Mặc định Active khi thêm mới

            String errorMsg;

            if (videoIdParam != null && !videoIdParam.isEmpty()) {
                video.setId(Integer.parseInt(videoIdParam));
                // Khi update ở form, vẫn giữ logic cũ
                errorMsg = VideoServices.updateVideo(video, userId, category.getId());
            } else {
                video.setCreateAt(new Date(System.currentTimeMillis()));
                video.setViewCount(0);
                errorMsg = VideoServices.addVideo(video, userId, category.getId());
            }

            if (errorMsg == null) {
                Map<String, Object> result = new HashMap<>();
                result.put("status", "success");
                result.put("message", (videoIdParam != null && !videoIdParam.isEmpty()) ?
                        "Cập nhật video thành công!" : "Thêm video thành công!");
                sendJson(resp, HttpServletResponse.SC_OK, result);
            } else {
                Map<String, Object> result = new HashMap<>();
                result.put("status", "error");
                result.put("message", errorMsg);
                sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, result);
            }

        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "Lỗi server: " + e.getMessage());
            sendJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, error);
        }
    }

    private void deleteVideo(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String videoIdParam = req.getParameter("videoId");

        if (videoIdParam == null || videoIdParam.isEmpty()) {
            Map<String, Object> error = new HashMap<>();
            error.put("status", false);
            error.put("message", "Thiếu tham số videoId");
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, error);
            return;
        }

        try {
            int videoId = Integer.parseInt(videoIdParam);
            HttpSession session = req.getSession();
            User currentUser = (User) session.getAttribute("user");
            int userId = (currentUser != null) ? currentUser.getId() : 1;

            String errorMsg = VideoServices.deleteVideo(videoId, userId);

            if (errorMsg == null) {
                Map<String, Object> result = new HashMap<>();
                result.put("status", true);
                result.put("message", "Xóa video thành công!");
                sendJson(resp, HttpServletResponse.SC_OK, result);
            } else {
                Map<String, Object> result = new HashMap<>();
                result.put("status", false);
                result.put("message", "Lỗi: " + errorMsg);
                sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, result);
            }

        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> error = new HashMap<>();
            error.put("status", false);
            error.put("message", "Lỗi server: " + e.getMessage());
            sendJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, error);
        }
    }
}