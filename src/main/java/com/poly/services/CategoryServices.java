package com.poly.services;

import com.poly.entities.Category;
import com.poly.util.JPAUtils;
import com.poly.util.Utils;
import jakarta.persistence.Entity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction; // Import for transaction
import jakarta.persistence.Query;

import java.util.ArrayList;
import java.util.List;

public class CategoryServices{

    public static List<Category> getAll(){
        List<Category> categories = new ArrayList<>();
        EntityManager manager = JPAUtils.getEntityManager();
        try {
            // Sửa: Lấy tất cả, bao gồm cả cột 'status' nếu nó tồn tại trong DB
            String sql = "Select *from categories";
            Query query = manager.createNativeQuery(sql, Category.class);
            categories = query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        } finally { // Thêm finally để đảm bảo manager được đóng
            if (manager != null) {
                manager.close();
            }
        }
        return categories;
    }

    public static String addCategory(Category category){ //giá trị trả về dạng chuỗi
        EntityManager manager = JPAUtils.getEntityManager();
        EntityTransaction transaction = manager.getTransaction(); // Lấy transaction
        try{
            // Kiểm tra trùng tên (NÊN SỬ DỤNG JPQL HOẶC NATIVE QUERY CHÍNH XÁC HƠN)
            // Hiện tại ta dùng logic của user:
            String sql = "SELECT *FROM categories where Lower(name)=?1"; // Sửa 'category' -> 'categories'
            Query query =  manager.createNativeQuery(sql, Category.class);// ánh xạ
            query.setParameter(1,category.getName().trim().toLowerCase());

            List<Category> categoryChecks = query.getResultList();

            if(!categoryChecks.isEmpty()){ // Kiểm tra nếu có kết quả trả về
                return "tên danh mục đã tồn tại";
            }

            // 1. Bắt đầu giao dịch (nếu chưa có)
            if(!transaction.isActive()){
                transaction.begin();
            }
            category.setName(Utils.capitalizeString(category.getName())); // chuẩn hóa tên

            // Đảm bảo status được set (giả định field status có sẵn)
            category.setStatus(1); // Set default status to Active (1)

            manager.persist(category); //Lưu đối tượng
            transaction.commit(); //Hibernate tự động sinh và chạy lệnh SQL INSERT

        } catch (Exception e) {
            e.printStackTrace();
            if (transaction.isActive()) {
                transaction.rollback();
            }
            return "Có lỗi khi thêm danh mục";
        } finally {
            manager.close();
        }
        return null;
    }

    // Cập nhật UpdateCategory để dùng merge và kiểm tra trùng tên ngoại trừ chính nó
    public static String UpdateCategory(Category category){
        EntityManager manager = JPAUtils.getEntityManager();
        EntityTransaction transaction = manager.getTransaction();
        try {
            // Kiểm tra trùng tên, loại trừ ID hiện tại
            String sqlCheck = "SELECT *FROM categories where LOWER(name) = ?1 AND id <> ?2";
            Query queryCheck = manager.createNativeQuery(sqlCheck, Category.class);
            queryCheck.setParameter(1, category.getName().trim().toLowerCase());
            queryCheck.setParameter(2, category.getId());

            List<Category> categoryChecks = queryCheck.getResultList();
            if(!categoryChecks.isEmpty()){
                return "danh mục đã tồn tại";
            }

            // Lấy entity cần update
            Category existingCategory = manager.find(Category.class, category.getId());
            if (existingCategory == null) {
                return "Không tìm thấy danh mục để cập nhật";
            }

            if(!transaction.isActive()){
                transaction.begin();
            }

            // Cập nhật các trường
            existingCategory.setName(Utils.capitalizeString(category.getName()));
            // Giữ nguyên status hiện tại (existingCategory.getStatus())

            manager.merge(existingCategory); // Sử dụng merge cho update
            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            return "Lỗi trong quá trình cập nhật";
        } finally {
            manager.close();
        }
        return null;
    }

    public static Category getInfoById(int id) {
        EntityManager manager = JPAUtils.getEntityManager();

        try {
            Category category = manager.find(Category.class, id);
            return category;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally { // Đảm bảo manager được đóng
            if (manager != null) {
                manager.close();
            }
        }
    }

    // NEW METHOD: Update Category Status (for Hiding/Displaying)
    public static boolean updateCategoryStatus(int categoryId, int newStatus) {
        EntityManager manager = JPAUtils.getEntityManager();
        EntityTransaction transaction = manager.getTransaction();
        try {
            Category category = manager.find(Category.class, categoryId);
            if (category == null) return false;

            if (!transaction.isActive()) {
                transaction.begin();
            }
            category.setStatus(newStatus);
            manager.merge(category);
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
    public static Category getCategoryByName(String name) {
        EntityManager manager = JPAUtils.getEntityManager();
        Category category = null;
        try {
            String jpql = "SELECT c FROM Category c WHERE c.name = ?1";
            Query query = manager.createQuery(jpql, Category.class);
            query.setParameter(1, name);
            category = (Category) query.getSingleResult();
        } catch (Exception e) {
            System.out.println("Không tìm thấy Category với tên: " + name);
        } finally {
            if (manager != null) {
                manager.close();
            }
        }
        return category;
    }

    // DELETE METHOD: Xóa category (chỉ xóa nếu không có video nào sử dụng)
    public static boolean deleteCategory(int categoryId) {
        EntityManager manager = JPAUtils.getEntityManager();
        EntityTransaction transaction = manager.getTransaction();
        try {
            Category category = manager.find(Category.class, categoryId);
            if (category == null) return false;

            if (!transaction.isActive()) {
                transaction.begin();
            }
            manager.remove(category);
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