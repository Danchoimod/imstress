package com.poly.services;

import com.poly.entities.Favourites;
import com.poly.entities.User;
import com.poly.entities.Video;
import com.poly.util.JPAUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import jakarta.persistence.Query;
import java.util.Collections;
import java.util.List;

public class FavServices {

    // 1. Kiểm tra xem video đã được yêu thích chưa
    public static Favourites findFavorite(int userId, int videoId) {
        EntityManager manager = JPAUtils.getEntityManager();
        try {
            // Sử dụng JPQL để truy vấn Favourites theo user ID và video ID
            String sql = "SELECT f FROM Favourites f WHERE f.user.id = :userId AND f.video.id = :videoId";
            return manager.createQuery(sql, Favourites.class)
                    .setParameter("userId", userId)
                    .setParameter("videoId", videoId)
                    .getSingleResult();
        } catch (NoResultException e) {
            // Trả về null nếu không tìm thấy (chưa yêu thích)
            return null;
        } finally {
            if (manager != null) manager.close();
        }
    }

    // 2. Thêm hoặc xóa yêu thích (Toggle)
    public static boolean toggleFavorite(int userId, int videoId) {
        Favourites existingFav = findFavorite(userId, videoId);
        EntityManager manager = JPAUtils.getEntityManager();
        EntityTransaction transaction = manager.getTransaction();

        try {
            if (!transaction.isActive()) {
                transaction.begin();
            }

            if (existingFav != null) {
                // Xóa (Unfavorite): Xóa bản ghi Favourites hiện tại
                manager.remove(manager.contains(existingFav) ? existingFav : manager.merge(existingFav));
                transaction.commit();
                return false; // Đã xóa/Hủy thích
            } else {
                // Thêm (Favorite): Tạo bản ghi Favourites mới
                User user = manager.find(User.class, userId);
                Video video = manager.find(Video.class, videoId);

                if (user == null || video == null) {
                    transaction.rollback();
                    return false;
                }

                Favourites newFav = new Favourites();
                newFav.setUser(user);
                newFav.setVideo(video);
                manager.persist(newFav);
                transaction.commit();
                return true; // Đã thêm/Yêu thích
            }
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            return existingFav == null; // Trả về trạng thái trước đó nếu lỗi
        } finally {
            if (manager != null) manager.close();
        }
    }

    // 3. Lấy danh sách video yêu thích theo User ID
    public static List<Video> getFavoritesByUserId(int userId) {
        EntityManager manager = JPAUtils.getEntityManager();
        try {
            // Truy vấn để lấy trực tiếp các Video Entity thông qua mối quan hệ Favourites
            String sql = "SELECT f.video FROM Favourites f WHERE f.user.id = :userId ORDER BY f.id DESC";
            return manager.createQuery(sql, Video.class)
                    .setParameter("userId", userId)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        } finally {
            if (manager != null) manager.close();
        }
    }
}