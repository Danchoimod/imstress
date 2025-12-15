package com.poly.api;

import com.google.gson.Gson;
import com.poly.entities.User;
import com.poly.reponse.UserReponse;
import com.poly.services.UserServices;
import com.poly.util.Utils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = "/api/userinfo")
public class userApi extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int userID = Integer.parseInt(Utils.getCookieValue(Utils.COOKIE_KEY_USER_ID, req));

        User user = UserServices.getUserInfoById(userID); // lấy thông tin đối tượng
        try {
            resp.setContentType("application/json; charset=UTF-8");
            UserReponse response = new UserReponse(user); // ánh xạ đối tượng cũ nà
            response.setId(user.getId());
            response.setEmail(user.getEmail());
            response.setFullname(user.getName());
            response.setUsername(user.getUsername());
            response.setPhone(user.getPhone());
            response.setRole(user.getRole());

            // 4. Trả về JSON Object (KHÔNG dùng List)
            Gson gson = new Gson();
            resp.getWriter().println(gson.toJson(response));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
