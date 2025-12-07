package com.poly.beans;

import java.util.HashMap;
import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class RegisterBean {
    private String username;
    private String password;
    private String confirmPassword; // Thêm trường này để kiểm tra
    private String name;
    private String email;
    private String phone;

    public Map<String, String> getErrors() {
        Map<String, String> map = new HashMap<String, String>();

        if (username == null || username.isBlank()) {
            map.put("errUsername", "Tên tài khoản không được bỏ trống");
        }

        if (password == null || password.trim().length() < 6) {
            map.put("errPassword", "Mật khẩu có ít nhất 6 ký tự");
        }
        if (confirmPassword == null || !confirmPassword.equals(password)) {
            map.put("errConfirmPassword", "Mật khẩu xác nhận không khớp");
        }

        if (name == null || name.isBlank()) {
            map.put("errName", "Họ và tên không bỏ trống");
        }

        if (email == null || !email.matches("^\\S+@\\S+\\.\\S+$")) {
            map.put("errEmail", "Email không đúng định dạng");
        }

        if (phone == null || !phone.matches("^0\\d{9}$")) {
            map.put("errPhone", "Số điện thoại không đúng định dạng");
        }

        return map;
    }


}