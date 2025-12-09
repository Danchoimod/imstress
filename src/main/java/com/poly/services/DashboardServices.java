package com.poly.services;

import com.poly.util.JPAUtils;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;

import java.util.ArrayList;
import java.util.List;
import java.util.Arrays;

public class DashboardServices {

    public static List<Long> getNumber() {
        EntityManager manager = null;
        List<Long> kpiValues = new ArrayList<>();

        String sql = "SELECT " +
                "    (SELECT COUNT(id) FROM users) AS TotalUsers, " +
                "    (SELECT COUNT(id) FROM videos) AS TotalVideos, " +
                "    (SELECT COUNT(id) FROM comments) AS TotalComments, " +
                "    (SELECT COUNT(id) FROM categories) AS TotalCategories";
        try {
            manager = JPAUtils.getEntityManager();
            Query query = manager.createNativeQuery(sql);

            // 1. Lấy kết quả: Truy vấn chỉ trả về 1 hàng duy nhất
            Object[] result = (Object[]) query.getSingleResult();

            for (Object obj : result) {
                if (obj instanceof Number) {
                    kpiValues.add(((Number) obj).longValue());
                } else {
                    kpiValues.add(0L);
                }
            }

            return kpiValues;

        } catch (Exception e) {
            System.err.println("Lỗi khi thực hiện truy vấn KPI: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>(); // Trả về danh sách rỗng khi có lỗi
        } finally {
            if (manager != null && manager.isOpen()) {
                manager.close();
            }
        }
    }
}