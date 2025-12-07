package com.poly.services;

import com.poly.entities.User;
import com.poly.util.JPAUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.Query;


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
                if (item.getUsername().equals(user.getUsername())){
                    errorMap.put("errUsername","người dùng đã tồn tại");
                }
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
            String sql = "SELECT * FROM users WHERE username=?1 OR email=?2";
        Query query = manager.createNativeQuery(sql,User.class);
        query.setParameter(1,usernameOrEmail);
        query.setParameter(2,usernameOrEmail);

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
}
