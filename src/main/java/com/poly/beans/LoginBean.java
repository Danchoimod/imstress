package com.poly.beans;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.HashMap;
import java.util.Map;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class LoginBean {
    private String usernameOrEmail;
    private String password;

    public Map<String, String> getErrors() {
        Map<String, String> map = new HashMap<String, String>();

        if (usernameOrEmail.isBlank()) {
            map.put("errUsernameOrEmail", "Tên tài khoản hoặc email không rỗng");
        }

        if (password.isBlank()) {
            map.put("errPassword", "Mật khẩu không rỗng");
        }

        return map;
    }
}