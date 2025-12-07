// File: com.poly.services.CommentServices
package com.poly.services;

import com.poly.entities.Comment;
import com.poly.util.JPAUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Query;

import java.util.ArrayList;
import java.util.List;

public class CommentServices {

    /**
     * Lấy danh sách Comment theo ID của Video.
     * @param id ID của Video.
     * @return Danh sách Comment.
     */
    public static List<Comment> getCommentbyID(Integer id){
        List<Comment> Comment = new ArrayList<>();
        EntityManager manager = JPAUtils.getEntityManager();
        try {
            String sql =  "Select *from comments\n" +
                    "where video_id = ?1 and status = 1 ORDER BY id DESC;";
            // Sử dụng Native Query để truy vấn cơ sở dữ liệu
            Query query = manager.createNativeQuery(sql,Comment.class);
            query.setParameter(1,id);
            Comment = query.getResultList();
        } catch (Exception e) {
            manager.close();
            e.printStackTrace();
        }
        manager.close();
        return Comment;
    }

    /**
     * Lưu một Comment Entity mới vào cơ sở dữ liệu.
     * @param comment Comment Entity cần lưu.
     * @return Comment đã được lưu (hoặc null nếu thất bại).
     */
    public static Comment insertComment(Comment comment) {
        EntityManager manager = JPAUtils.getEntityManager();
        EntityTransaction transaction = manager.getTransaction();
        try {
            transaction.begin();

            // Thiết lập giá trị mặc định cho status trước khi lưu
            if (comment.isStatus() == false) { // Dù đã được thiết lập mặc định, vẫn nên kiểm tra
                comment.setStatus(true);
            }

            manager.persist(comment); // Lưu entity vào database
            transaction.commit();
            return comment;
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            return null;
        } finally {
            manager.close();
        }
    }
    public static List<Comment> getAllComments() {
        EntityManager manager = JPAUtils.getEntityManager();
        try {
            // Lấy tất cả comment, bao gồm cả comment bị ẩn (status=false)
            String sql = "SELECT * FROM comments ORDER BY id DESC";
            Query query = manager.createNativeQuery(sql, Comment.class);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            if (manager != null) {
                manager.close();
            }
        }
    }

    /**
     * Cập nhật trạng thái (ẩn/hiện) của một bình luận.
     * @param commentId ID của bình luận cần cập nhật.
     * @param newStatus Trạng thái mới (true: Hiện, false: Ẩn).
     * @return true nếu thành công, false nếu thất bại.
     */
    public static boolean updateCommentStatus(int commentId, boolean newStatus) {
        EntityManager manager = JPAUtils.getEntityManager();
        EntityTransaction transaction = manager.getTransaction();
        try {
            Comment comment = manager.find(Comment.class, commentId);
            if (comment == null) return false;

            if (!transaction.isActive()) {
                transaction.begin();
            }
            comment.setStatus(newStatus); // Cập nhật trạng thái
            manager.merge(comment);       // Cập nhật Entity
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            if (manager != null) {
                manager.close();
            }
        }
    }
}