package com.poly.beans;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class ProfileBean {
    private String displayName;      // Tên hiển thị
    private String phone;            // Số điện thoại

    // Thuộc tính tùy chọn, nếu bạn muốn lưu trữ đường dẫn ảnh upload tạm thời
    // private String avatarFile;

    public Map<String, String> getErrors() {
        Map<String, String> map = new HashMap<String, String>();

        // 1. Kiểm tra Tên hiển thị (displayName)
        if (displayName == null || displayName.isBlank()) {
            map.put("errDisplayName", "Tên hiển thị không được rỗng.");
        } else if (displayName.length() > 50) {
            map.put("errDisplayName", "Tên hiển thị không được quá 50 ký tự.");
        }

        if (phone != null || phone.isBlank()) {
            // Biểu thức chính quy cơ bản cho SĐT Việt Nam (0xxxxxxxxx, 10-11 số)
            String phoneRegex = "^(0|\\+84)\\d{9,10}$";
            Pattern pattern = Pattern.compile(phoneRegex);
            Matcher matcher = pattern.matcher(phone.trim());

            if (!matcher.matches()) {
                map.put("errPhone", "Số điện thoại không hợp lệ (phải là 10 hoặc 11 số, bắt đầu bằng 0).");
            }
        }

        return map;
    }

}