package com.poly.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.poly.entities.Comment;
import com.poly.reponse.CommentResponse;
import com.poly.services.CommentServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {"/api/comment", "/api/comment/*"})
public class CommentApi extends HttpServlet {

    // Xử lý GET: Hiển thị danh sách comment theo video ID
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        List<CommentResponse> responsecomment = new ArrayList<>();

        String videoIdParam = req.getParameter("videoid"); // Lấy tham số "videoid"
        if (videoIdParam == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing videoid parameter");
            return;
        }

        try {
            int videoId = Integer.parseInt(videoIdParam);
            resp.setContentType("application/json; charset=UTF-8");

            List<Comment> comments = CommentServices.getCommentbyID(videoId);
            for (Comment entity : comments) {
                CommentResponse response = new CommentResponse();
                response.setId(entity.getId());
                response.setContent(entity.getContent());
                response.setStatus(entity.isStatus());

                // ✅ THAY ĐỔI: Ánh xạ User Name thành USERNAME (Tên hiển thị)
                response.setUserName(entity.getUser() != null ? entity.getUser().getUsername() : "Anonymous");
                response.setUserId(entity.getUser() != null ? entity.getUser().getId() : null);

                // Ánh xạ Parent ID
                response.setParentCommentId(entity.getComment() != null ? entity.getComment().getId() : null);

                // Bỏ qua createAt

                responsecomment.add(response);
            }

            Gson gson = new GsonBuilder().serializeNulls().create(); // Tạo Gson
            resp.getWriter().println(gson.toJson(responsecomment)); // Trả về JSON

        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid videoid format");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while fetching comments.");
        }
    }

    // THÊM: Xử lý POST: Thêm comment mới
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
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required fields (content, videoId, userId)");
                return;
            }

            // Thực hiện lưu comment
            Comment savedComment = CommentServices.insertComment(newComment);

            if (savedComment != null) {
                resp.setStatus(HttpServletResponse.SC_CREATED);
                // Trả về response của comment vừa tạo
                resp.getWriter().println(gson.toJson(savedComment));
            } else {
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to save comment.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error adding comment: " + e.getMessage());
        }
    }

    private Integer extractCommentId(HttpServletRequest req) {
        String idParam = req.getParameter("id");
        if (idParam != null && !idParam.isBlank()) {
            try {
                return Integer.parseInt(idParam);
            } catch (NumberFormatException ignored) {
                return null;
            }
        }
        String pathInfo = req.getPathInfo();
        if (pathInfo != null && pathInfo.length() > 1) {
            String candidate = pathInfo.substring(1);
            try {
                return Integer.parseInt(candidate);
            } catch (NumberFormatException ignored) {
                return null;
            }
        }
        return null;
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Integer commentId = extractCommentId(req);
        if (commentId == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or invalid id");
            return;
        }

        try {
            Integer currentUserId = CommentServices.getCurrentUserId(req);
            if (currentUserId == null) {
                resp.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not authenticated");
                return;
            }

            Comment target = CommentServices.findById(commentId);
            if (target == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Comment not found");
                return;
            }

            if (target.getUser() == null || target.getUser().getId() != currentUserId) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "You cannot delete this comment");
                return;
            }

            boolean deleted = CommentServices.deleteComment(commentId);
            if (deleted) {
                resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
            } else {
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to delete comment");
            }
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid id format");
        }
    }
}