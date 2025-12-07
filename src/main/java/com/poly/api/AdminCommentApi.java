// File: com.poly.api.AdminCommentApi.java

package com.poly.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.poly.entities.Comment;
import com.poly.reponse.CommentResponse; // Sử dụng DTO đã có
import com.poly.services.CommentServices;
import org.apache.commons.beanutils.BeanUtils;

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

@WebServlet(urlPatterns = "/api/admin/comments")
public class AdminCommentApi extends HttpServlet {
    private final Gson gson = new GsonBuilder().serializeNulls().create();

    // Hàm tiện ích để gửi phản hồi JSON
    private void sendJson(HttpServletResponse resp, int status, Object data) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().println(gson.toJson(data));
    }

    // GET: Lấy danh sách tất cả bình luận
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Lấy tất cả comment từ Service
            List<Comment> comments = CommentServices.getAllComments();
            List<Map<String, Object>> responses = new ArrayList<>();

            for (Comment entity : comments) {
                Map<String, Object> responseMap = new HashMap<>();

                // Sử dụng BeanUtils hoặc ánh xạ thủ công các trường cơ bản
                responseMap.put("id", entity.getId());
                responseMap.put("content", entity.getContent());
                responseMap.put("status", entity.isStatus());

                // Ánh xạ các trường liên quan đến Entity (User, Video, Parent Comment)
                responseMap.put("userName", entity.getUser() != null ? entity.getUser().getName() : "Anonymous");
                responseMap.put("parentCommentId", entity.getComment() != null ? entity.getComment().getId() : null);

                // Thêm Video ID cần thiết cho liên kết trong bảng admin
                responseMap.put("video", Map.of("id", entity.getVideo() != null ? entity.getVideo().getId() : 0));

                responses.add(responseMap);
            }

            sendJson(resp, HttpServletResponse.SC_OK, responses);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "Lỗi server khi tải danh sách bình luận: " + e.getMessage());
            sendJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, error);
        }
    }

    // POST: Cập nhật Status (true/false)
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String commentIdParam = req.getParameter("commentId");
        String action = req.getParameter("action"); // Phải là 'status'
        String valueParam = req.getParameter("value"); // 'true' hoặc 'false'

        if (commentIdParam == null || action == null || valueParam == null || !action.equals("status")) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Thiếu tham số bắt buộc hoặc action không hợp lệ.");
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, error);
            return;
        }

        try {
            int commentId = Integer.parseInt(commentIdParam);
            // Chuyển đổi chuỗi "true"/"false" thành boolean
            boolean newStatus = Boolean.parseBoolean(valueParam);

            boolean success = CommentServices.updateCommentStatus(commentId, newStatus);

            String message = newStatus ? "Hiện bình luận thành công." : "Ẩn bình luận thành công.";

            if (success) {
                Map<String, Object> result = new HashMap<>();
                result.put("status", "success");
                result.put("message", message);
                sendJson(resp, HttpServletResponse.SC_OK, result);
            } else {
                Map<String, Object> result = new HashMap<>();
                result.put("status", "error");
                result.put("message", "Không tìm thấy bình luận hoặc lỗi DB.");
                sendJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, result);
            }

        } catch (NumberFormatException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "commentId không phải là số.");
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, error);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "Lỗi server trong quá trình cập nhật: " + e.getMessage());
            sendJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, error);
        }
    }
}