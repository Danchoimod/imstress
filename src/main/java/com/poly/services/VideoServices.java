package com.poly.services;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.poly.entities.Category;
import com.poly.entities.Comment;
import com.poly.entities.Favourites;
import com.poly.entities.User;
import com.poly.entities.Video;

import com.poly.util.JPAUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.Query;

public class VideoServices {

	public static String addVideo(Video video, int userId, int catId) {
		Category category = CategoryServices.getInfoById(catId);
		if (category == null) {
			return "Lỗi";
		}
		User user = UserServices.getUserInfoById(userId);
		EntityManagerFactory managerFactory = Persistence.createEntityManagerFactory("dbConnect");
		EntityManager manager = managerFactory.createEntityManager();

		try {
			if (!manager.getTransaction().isActive()) {
				manager.getTransaction().begin();
			}
			Video videoInsert = video;

			videoInsert.setCategory(category); // ??
			videoInsert.setUser(user); // ??

			manager.persist(videoInsert);
			manager.getTransaction().commit();
		} catch (Exception e) {
			e.printStackTrace();
			manager.getTransaction().rollback();
			manager.close();
			return "Lỗi";
		}
		manager.close();
		return null;
	}

	//	- Sửa (Kiểm tra user id) **
//    - Category có tồn tại không?
//    - Video đang sửa có thuộc sở hữu của user đang login không?
	public static String updateVideo(Video video, int userId, int catId) {
		Category category = CategoryServices.getInfoById(catId);
		if (category == null) {
			return "Lỗi: Danh mục không tồn tại";
		}

		// Không kiểm tra quyền sở hữu nữa - cho phép update bất kỳ video nào
		EntityManagerFactory managerFactory = Persistence.createEntityManagerFactory("dbConnect");
		EntityManager manager = managerFactory.createEntityManager();

		try {
			if (!manager.getTransaction().isActive()) {
				manager.getTransaction().begin();
			}

			// Lấy video hiện có từ database
			Video existingVideo = manager.find(Video.class, video.getId());
			if (existingVideo == null) {
				manager.close();
				return "Lỗi: Không tìm thấy video";
			}

			// Cập nhật các trường
			existingVideo.setTitle(video.getTitle());
			existingVideo.setDesc(video.getDesc());
			existingVideo.setPoster(video.getPoster());
			existingVideo.setUrl(video.getUrl());
			existingVideo.setCategory(category);
			existingVideo.setStatus(video.getStatus());
			// Giữ nguyên: createAt, viewCount, user, favorites, comments

			manager.merge(existingVideo);
			manager.getTransaction().commit();
		} catch (Exception e) {
			e.printStackTrace();
			if (manager.getTransaction().isActive()) {
				manager.getTransaction().rollback();
			}
			manager.close();
			return "Lỗi: " + e.getMessage();
		}
		manager.close();
		return null;
	}

	public static Video getInfoByIdAndUserId(int id, int userId) {
		EntityManagerFactory managerFactory = Persistence.createEntityManagerFactory("dbConnect");
		EntityManager manager = managerFactory.createEntityManager();
		try {
			String sql = "SELECT * FROM videos WHERE id=?1 AND user_id=?2";
			Query query = manager.createNativeQuery(sql, Video.class);
			query.setParameter(1, id);
			query.setParameter(2, userId);

			Video video = (Video) query.getSingleResult();
			manager.close();
			return video;

		} catch (Exception e) {
			e.printStackTrace();
		}
		manager.close();
		return null;
	}

	public static String deleteVideo(int videoId, int userId) {
		EntityManagerFactory managerFactory = Persistence.createEntityManagerFactory("dbConnect");
		EntityManager manager = managerFactory.createEntityManager();
		try {
			// Lấy video từ database (không kiểm tra quyền sở hữu)
			Video videoToDelete = manager.find(Video.class, videoId);
			if (videoToDelete == null) {
				manager.close();
				return "Lỗi: Không tìm thấy video";
			}

			if (!manager.getTransaction().isActive()) {
				manager.getTransaction().begin();
			}

			// Xóa tất cả favourites liên quan
			if (videoToDelete.getFavorites() != null) {
				for (Favourites favourite : videoToDelete.getFavorites()) {
					manager.remove(favourite);
				}
			}

			// Xóa tất cả comments liên quan (đệ quy)
			if (videoToDelete.getComments() != null) {
				deleteComment(videoToDelete.getComments(), manager);
			}

			// Xóa video
			manager.remove(videoToDelete);

			manager.getTransaction().commit();
			manager.close();
			return null;
		} catch (Exception e) {
			e.printStackTrace();
			if (manager.getTransaction().isActive()) {
				manager.getTransaction().rollback();
			}
			manager.close();
			return "Lỗi: " + e.getMessage();
		}
	}

	private static void deleteComment(List<Comment> comments, EntityManager manager) {
		if (comments.size() == 0) {
			return;
		}
		for (Comment comment : comments) {
			deleteComment(comment.getComments(), manager);
			manager.remove(comment);
		}
	}

	public static List<Video> getVideos(String title, int catId) {
		List<Video> videos = new ArrayList<Video>();

		EntityManager manager = JPAUtils.getEntityManager();

		try {
			String sql = "SELECT * FROM videos WHERE (?1 = '' OR title LIKE '%?2%') AND (?3 = 0 OR cat_id = ?4)";

			Query query = manager.createNativeQuery(sql, Video.class);
			query.setParameter(1, title == null ? "" : title);
			query.setParameter(2, title == null ? "%%" : "%" + title + "%");
			query.setParameter(3, catId);
			query.setParameter(4, catId);

			videos = query.getResultList();

		} catch (Exception e) {
			e.printStackTrace();
		}

		return videos;
	}
	public static List<Video> getVideobyCat(Integer id){
		List<Video> video = new ArrayList<>();
		EntityManager manager = JPAUtils.getEntityManager();
		try {
			String sql =  "Select *from Videos where cat_id=?1";
			Query query = manager.createNativeQuery(sql,Video.class);
			query.setParameter(1,id);
			video = query.getResultList();
		} catch (Exception e) {
			manager.close();
			e.printStackTrace();
		}
		manager.close();
		return video;
	}
	public static List<Video> getVideoByUserId(Integer userId) {
		List<Video> videos = new ArrayList<Video>();
		EntityManagerFactory managerFactory = Persistence.createEntityManagerFactory("dbConnect");
		EntityManager manager = managerFactory.createEntityManager();
		try {
			String sql = "SELECT * FROM videos WHERE user_id = ?1";
			Query query = manager.createNativeQuery(sql, Video.class);
			query.setParameter(1, userId);

			videos = query.getResultList();
			return videos;
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			return Collections.emptyList();
		}finally {
			managerFactory.close();
		}
	}
	public static List<Video> getAllVideo() {
		List<Video> videos = new ArrayList<>();
		EntityManager manager = null;

		try {
			String sql = "SELECT * FROM videos";
			manager = JPAUtils.getEntityManager();

			Query query = manager.createNativeQuery(sql, Video.class);
			videos = query.getResultList();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (manager != null) {
				manager.close();
			}
		}
		manager.close();
		return videos;
	}

}