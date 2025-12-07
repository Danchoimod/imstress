package com.poly.util;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class Cookies {
    public static final String COOKIE_KEY_USER_ID = "user_id";
    public static final String COOKIE_KEY_ROLE = "role";

    public static String getCookieValues(String key, HttpServletRequest request){
        Cookie[] cookies = request.getCookies();
        if(cookies == null){
            return null;
        }

        //duyệt mảng
        for (Cookie cookie: cookies){
            if(cookie.getName().equals(key)){}
            return cookie.getValue();
        }
        return null;
    }
    public static void clearCookie(HttpServletRequest request, HttpServletResponse response){
        Cookie[] cookies = request.getCookies();
        if(cookies == null){
            return;
        }
        for (Cookie cookie: cookies){
            cookie.setMaxAge(0); // Set to 0 to delete cookie
            cookie.setPath("/"); // Must set same path as when creating cookie
            cookie.setValue(""); // Clear value
            response.addCookie(cookie);
        }

    }
}