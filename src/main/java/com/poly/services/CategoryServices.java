package com.poly.services;

import com.poly.entities.Category;
import com.poly.util.JPAUtils;
import com.poly.util.Utils;
import jakarta.persistence.Entity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import java.util.ArrayList;
import java.util.List;

public class CategoryServices{

    public static List<Category> getAll(){
        List<Category> categories = new ArrayList<>();
        EntityManager manager = JPAUtils.getEntityManager();
        try {
            String sql = "Select *from categories";
            manager.createNativeQuery(sql, Category.class);// ánh xạ class
            Query query = manager.createNativeQuery(sql, Category.class);
            categories = query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        }
        manager.close();

        return categories;
    }
    public static String addCategory(Category category){ //giá trị trả về dạng chuỗi
        EntityManager manager = JPAUtils.getEntityManager();
        try{
        String sql = "SELECT *FROM category where Lower(name)=?1";

        Query query =  manager.createNativeQuery(sql, Category.class);// ánh xạ
            //truyền giá trị vào câu truy vấn (1)
            query.setParameter(1,category.getName().trim().toLowerCase());

            Category categoryCheck = (Category) query.getSingleResult(); //ép kiểu trả về 1 object duy nhất

            if(categoryCheck != null){
                return "tên danh mục đã tồn tại ";
            }
// 1. Bắt đầu giao dịch (nếu chưa có)
            if(!manager.getTransaction().isActive()){
                manager.getTransaction().begin();
            }
            category.setName(Utils.capitalizeString(category.getName())); // chuẩn hóa tên
            manager.persist(category); //Đánh dấu đối tượng cần được lưu
            manager.getTransaction().commit(); //Hibernate tự động sinh và chạy lệnh SQL INSERT

        } catch (Exception e) {
            e.printStackTrace();
            manager.getTransaction().rollback();
            return "Có lỗi khi thêm danh mục";
        }
        manager.close();
        return null;
    }
    public static String UpdateCategory(Category category){ //trả về dạng chuỗi
        EntityManager manager = JPAUtils.getEntityManager();
        try {
            String sql = "select *from category where LOWER(name) = ?1 AND id =?2";
            Query query = manager.createNativeQuery(sql, Category.class);
            query.setParameter(1,category.getName());
            query.setParameter(2,category.getId());

            //lấy kết quả
            Category categoryCheck = (Category) query.getSingleResult();
            if(categoryCheck != null){
                return "danh mục đã tồn tại";
            }
            if(!manager.getTransaction().isActive()){
                manager.getTransaction().begin();
            }
            category.setName(Utils.capitalizeString(category.getName())); // chuẩn hóa tên
            manager.persist(category);
            manager.getTransaction().commit();
        } catch (Exception e) {
            manager.getTransaction().rollback();
            e.printStackTrace();
            return "Lỗi trong quá trình cập nhật";
        }
    manager.close();
        return null;
    }

    public static Category getInfoById(int id) {
        EntityManager manager = JPAUtils.getEntityManager();

        try {
            Category category = manager.find(Category.class, id);

            manager.close();
            return category;
        } catch (Exception e) {
            e.printStackTrace();
        }

        manager.close();
        return null;
    }
}

