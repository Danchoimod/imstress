package com.poly.beans;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.HashMap;
import java.util.Map;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class CategoryBean {
    private String categoryname;

    /**
     * Phương thức kiểm tra và trả về Map các lỗi validation.
     * @return Map<String, String> chứa tên trường và thông báo lỗi tương ứng.
     */
    public Map<String, String> getErrors() {
        Map<String, String> errors = new HashMap<>();

        // 1. Kiểm tra Tiêu đề (Bắt buộc)
        if (categoryname == null || categoryname.isBlank()) {
            errors.put("errTitle", "Tiêu đề không được để trống.");
        } else if (categoryname.trim().length() > 255) {
            errors.put("errTitle", "Tiêu đề quá dài (tối đa 255 ký tự).");
        }

        return errors;
    }
}