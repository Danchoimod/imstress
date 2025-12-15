package com.poly.services;

import com.poly.entities.User;
import com.poly.util.JPAUtils;
import jakarta.persistence.*;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserServices {
    public static Map<String, String> register(User user) {
        Map<String, String> errorMap = new HashMap<String, String>();

        EntityManager manager = JPAUtils.getEntityManager();
        try {
            String sql = "SELECT * FROM users WHERE username=?1 OR email=?2 OR phone=?3";
            Query query = manager.createNativeQuery(sql, User.class); // thực thi
            query.setParameter(1,user.getUsername());
            query.setParameter(2,user.getEmail());
            query.setParameter(3,user.getPhone());

            List<User> UserDB = query.getResultList();
            for (User item:UserDB){
                if (item.getEmail().equals(user.getEmail())){
                    errorMap.put("errEmail","email đã tồn tại");
                }
                if(item.getPhone().equals(user.getPhone())){
                    errorMap.put("errPhone","số điện thoại đã tồn tại");
                }
            }
            if (errorMap.isEmpty()){// nếu errmap tồn tại thì lỗi vch quả logic ảo ma
                //trả về boolean
                if (!manager.getTransaction().isActive()){// bắt buộc khi thực thi
                    manager.getTransaction().begin(); // bắt đầu thực thi
                    manager.persist(user);
                    manager.getTransaction().commit();
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // in ra lỗi
            manager.getTransaction().rollback(); // nếu đang commit thì servetr sập
        }
        manager.close();// tắt nguồn :v
        return errorMap; //trả giá trị lỗi
    }
    public static User Login(String usernameOrEmail,String password){
        EntityManager manager = JPAUtils.getEntityManager();
        try {
            String sql = "SELECT * FROM users WHERE email=?1";
            Query query = manager.createNativeQuery(sql,User.class);
            query.setParameter(1,usernameOrEmail);

            User user = (User) query.getSingleResult(); //ép kiểu trả về 1 object duy nhất
            /*Vì getSingleResult() chỉ trả về kiểu Object */

            if (password.equals(user.getPassword())){
                manager.close(); //so sánh pass giải phóng bộ nhớ vì logi thành công
                return user; //trả về user
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        manager.close();
        return null;
    }
    public static User getUserInfoById(int id){
        EntityManager manager = JPAUtils.getEntityManager();
        try {
            User user = manager.find(User.class, id);
            manager.close();
            return user;
        } catch (Exception e) {
            e.printStackTrace();
        }
        manager.close();
        return null;
    }
    // NEW METHOD: Get all users
    public static List<User> getAllUsers() {
        EntityManager manager = JPAUtils.getEntityManager();
        try {
            // Lấy tất cả người dùng, sắp xếp theo ID
            String sql = "SELECT * FROM users ORDER BY id ASC";
            Query query = manager.createNativeQuery(sql, User.class);
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

    // NEW METHOD: Update user role
    public static boolean updateUserRole(int userId, int newRole) {
        EntityManager manager = JPAUtils.getEntityManager();
        EntityTransaction transaction = manager.getTransaction();
        try {
            User user = manager.find(User.class, userId);
            if (user == null) return false;

            if (!transaction.isActive()) {
                transaction.begin();
            }
            user.setRole(newRole);
            manager.merge(user); // Sử dụng merge để cập nhật entity
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

    public static boolean updateUserStatus(int userId, int newStatus) {
        EntityManager manager = JPAUtils.getEntityManager();
        EntityTransaction transaction = manager.getTransaction();
        try {
            User user = manager.find(User.class, userId);
            if (user == null) return false;

            if (!transaction.isActive()) {
                transaction.begin();
            }
            user.setStatus(newStatus);
            manager.merge(user); // Sử dụng merge để cập nhật entity
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

    public static boolean updateUserProfile(User updatedUser) {
        EntityManager manager = JPAUtils.getEntityManager();
        EntityTransaction transaction = manager.getTransaction();
        try {
            User existingUser = manager.find(User.class, updatedUser.getId());
            if (existingUser == null) return false;


            if (!transaction.isActive()) {
                transaction.begin();
            }
            existingUser.setUsername(updatedUser.getUsername());
            existingUser.setName(updatedUser.getName());
            existingUser.setPhone(updatedUser.getPhone());
            existingUser.setEmail(updatedUser.getEmail());

            manager.merge(existingUser); // Lưu cập nhật
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