// File: com.poly.api.CommentApi.java
package com.poly.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.poly.entities.Comment;
import com.poly.reponse.CommentResponse;
import com.poly.services.CommentServices;
import com.poly.util.Utils; // Cần import Utils để đọc cookie

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

@WebServlet(urlPatterns = "/api/comment")
public class CommentApi extends HttpServlet {
    private final Gson gson = new GsonBuilder().serializeNulls().create();

    // Helper methods
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


    // Xử lý GET: Hiển thị danh sách comment theo video ID
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        List<CommentResponse> responsecomment = new ArrayList<>();

        String videoIdParam = req.getParameter("videoid"); // Lấy tham số "videoid"
        if (videoIdParam == null) {
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, Map.of("error", "Missing videoid parameter"));
            return;
        }

        try {
            int videoId = Integer.parseInt(videoIdParam);

            List<Comment> comments = CommentServices.getCommentbyID(videoId);
            for (Comment entity : comments) {
                CommentResponse response = new CommentResponse();
                response.setId(entity.getId());
                response.setContent(entity.getContent());
                response.setStatus(entity.isStatus());

                // ✅ CẬP NHẬT: Ánh xạ User ID và User Name
                if (entity.getUser() != null) {
                    response.setUserId(entity.getUser().getId());
                    response.setUserName(entity.getUser().getUsername());
                } else {
                    response.setUserId(null);
                    response.setUserName("Anonymous");
                }

                // Ánh xạ Parent ID
                response.setParentCommentId(entity.getComment() != null ? entity.getComment().getId() : null);

                responsecomment.add(response);
            }

            sendJson(resp, HttpServletResponse.SC_OK, responsecomment);

        } catch (NumberFormatException e) {
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, Map.of("error", "Invalid videoid format"));
        } catch (Exception e) {
            e.printStackTrace();
            sendJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, Map.of("error", "An error occurred while fetching comments."));
        }
    }

    // Xử lý POST: Thêm comment mới
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");
        Gson gson = new Gson();

        try {
            // Đọc dữ liệu JSON (content, video_id, user_id) từ body
            Comment newComment = gson.fromJson(req.getReader(), Comment.class);

            // Kiểm tra các trường bắt buộc
            if (newComment == null || newComment.getContent() == null || newComment.getVideo() == null || newComment.getUser() == null) {
                sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, Map.of("error", "Missing required fields (content, videoId, userId)"));
                return;
            }

            // Thực hiện lưu comment
            Comment savedComment = CommentServices.insertComment(newComment);

            if (savedComment != null) {
                sendJson(resp, HttpServletResponse.SC_CREATED, savedComment);
            } else {
                sendJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, Map.of("error", "Failed to save comment."));
            }

        } catch (Exception e) {
            e.printStackTrace();
            sendJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, Map.of("error", "Error adding comment: " + e.getMessage()));
        }
    }

    // ✅ PHƯƠNG THỨC MỚI: Xử lý DELETE comment
    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        Integer currentUserId = getUserIdFromCookie(req);
        if (currentUserId == null) {
            sendJson(resp, HttpServletResponse.SC_UNAUTHORIZED, Map.of("error", "Vui lòng đăng nhập để thực hiện chức năng này."));
            return;
        }

        String commentIdParam = req.getParameter("id"); // Lấy tham số 'id' từ query (theo JS trong watch.jsp)

        if (commentIdParam == null || commentIdParam.isEmpty()) {
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, Map.of("error", "Thiếu tham số ID bình luận."));
            return;
        }

        try {
            int commentId = Integer.parseInt(commentIdParam);

            // Gọi Service để xóa (Service kiểm tra quyền sở hữu)
            String errorMsg = CommentServices.deleteCommentIfOwned(commentId, currentUserId);

            if (errorMsg == null) {
                // Xóa thành công, trả về 200 OK với thông báo
                sendJson(resp, HttpServletResponse.SC_OK, Map.of("message", "Bình luận đã được xóa."));
            } else if (errorMsg.contains("quyền")) {
                sendJson(resp, HttpServletResponse.SC_FORBIDDEN, Map.of("error", errorMsg)); // 403 Forbidden
            } else {
                sendJson(resp, HttpServletResponse.SC_NOT_FOUND, Map.of("error", errorMsg)); // 404 Not Found
            }

        } catch (NumberFormatException e) {
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, Map.of("error", "ID bình luận không hợp lệ."));
        } catch (Exception e) {
            e.printStackTrace();
            sendJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, Map.of("error", "Lỗi server khi xóa bình luận: " + e.getMessage()));
        }
    }
}