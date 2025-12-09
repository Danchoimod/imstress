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

// SỬA LỖI CẤU TRÚC: Chỉ định một endpoint duy nhất
@WebServlet(urlPatterns = {"/api/admin/videos"})
public class VideoManagementApi extends HttpServlet {
    private final Gson gson = new GsonBuilder().serializeNulls().create();

    private void sendJson(HttpServletResponse resp, int status, Object data) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().println(gson.toJson(data));
    }

    // GET: Lấy danh sách tất cả video với thông tin đầy đủ
    @Override
    @Operation(
            summary = "Lấy danh sách tất cả video",
            responses = {
                    @ApiResponse(responseCode = "200", description = "Thành công"),
                    @ApiResponse(responseCode = "500", description = "Lỗi Server")
            }
    )
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

                // Thông tin category
                if (video.getCategory() != null) {
                    responseMap.put("catId", video.getCategory().getId());
                    responseMap.put("catName", video.getCategory().getName());
                } else {
                    responseMap.put("catId", null);
                    responseMap.put("catName", "Không có");
                }

                // Thông tin user/author
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

    // POST: Xử lý Thêm mới và Cập nhật video hoặc Xóa video
    @Override
    @Operation(
            summary = "Thêm mới, cập nhật hoặc xóa video",
            responses = {
                    @ApiResponse(responseCode = "200", description = "Thành công"),
                    @ApiResponse(responseCode = "400", description = "Sai tham số"),
                    @ApiResponse(responseCode = "500", description = "Lỗi Server")
            }
    )
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        // String path = req.getServletPath(); // KHÔNG DÙNG path nữa

        // SỬA LỖI CẤU TRÚC: Lấy tham số 'action'
        String action = req.getParameter("action");

        if ("delete".equalsIgnoreCase(action)) { // Kiểm tra action
            deleteVideo(req, resp);
        } else {
            addOrUpdateVideo(req, resp);
        }
    }

    private void addOrUpdateVideo(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            // Lấy userId từ session hoặc dùng user mặc định nếu chưa đăng nhập
            HttpSession session = req.getSession();
            User currentUser = (User) session.getAttribute("user");

            // Nếu không có user trong session, sử dụng userId mặc định = 1
            int userId = 1;
            if (currentUser != null) {
                userId = currentUser.getId();
            }

            // Lấy tham số trực tiếp từ request - KHÔNG VALIDATION
            String title = req.getParameter("title");
            String url = req.getParameter("url");
            String poster = req.getParameter("poster");
            String categoryName = req.getParameter("category");
            String description = req.getParameter("description");
            String videoIdParam = req.getParameter("videoId");

            // Lấy category
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
            video.setStatus(1); // Active

            String errorMsg;

            if (videoIdParam != null && !videoIdParam.isEmpty()) {
                // Update Logic
                video.setId(Integer.parseInt(videoIdParam));
                errorMsg = VideoServices.updateVideo(video, userId, category.getId());
            } else {
                // Add Logic
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
            error.put("error", "Lỗi server trong quá trình thêm/sửa video: " + e.getMessage());
            sendJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, error);
        }
    }

    private void deleteVideo(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // NOTE: Logic xóa này vẫn giữ nguyên, nhưng nó được gọi bằng action=delete
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

            // Lấy userId từ session hoặc dùng user mặc định nếu chưa đăng nhập
            HttpSession session = req.getSession();
            User currentUser = (User) session.getAttribute("user");

            int userId = 1;
            if (currentUser != null) {
                userId = currentUser.getId();
            }

            // Thực hiện xóa
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

        } catch (NumberFormatException e) {
            Map<String, Object> error = new HashMap<>();
            error.put("status", false);
            error.put("message", "videoId không hợp lệ");
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, error);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> error = new HashMap<>();
            error.put("status", false);
            error.put("message", "Lỗi server trong quá trình xóa: " + e.getMessage());
            sendJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, error);
        }
    }
}