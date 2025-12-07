package com.poly.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.poly.entities.User;
import com.poly.reponse.UserReponse;
import com.poly.services.UserServices;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import org.apache.commons.beanutils.BeanUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = "/api/admin/users")
public class UserManagementApi extends HttpServlet {
    private final Gson gson = new GsonBuilder().serializeNulls().create();

    private void sendJson(HttpServletResponse resp, int status, Object data) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().println(gson.toJson(data));
    }

    // GET: Lấy danh sách tất cả người dùng
    @Override
    @Operation(
            summary = "Lấy danh sách tất cả người dùng",
            responses = {
                    @ApiResponse(responseCode = "200", description = "Thành công",
                            content = @Content(mediaType = "application/json",
                                    schema = @Schema(implementation = UserReponse.class))),
                    @ApiResponse(responseCode = "500", description = "Lỗi Server")
            }
    )
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            List<User> users = UserServices.getAllUsers();
            List<UserReponse> responses = new ArrayList<>();

            for (User user : users) {
                UserReponse response = new UserReponse();
                // Sao chép các thuộc tính (id, username, email, phone, role, status)
                BeanUtils.copyProperties(response, user);
                // Ánh xạ thủ công cho tên hiển thị
                response.setFullname(user.getName());
                responses.add(response);
            }

            sendJson(resp, HttpServletResponse.SC_OK, responses);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "Lỗi server khi tải danh sách người dùng: " + e.getMessage());
            sendJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, error);
        }
    }

    // POST: Cập nhật Role hoặc Status
    @Override
    @Operation(
            summary = "Cập nhật Role hoặc Status của người dùng",
            description = "Sử dụng tham số 'action' (role/status) và 'value' (0/1/2/3) để cập nhật.",
            responses = {
                    @ApiResponse(responseCode = "200", description = "Cập nhật thành công"),
                    @ApiResponse(responseCode = "400", description = "Sai tham số"),
                    @ApiResponse(responseCode = "500", description = "Lỗi Server")
            }
    )
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String userIdParam = req.getParameter("userId");
        String action = req.getParameter("action");
        String valueParam = req.getParameter("value");

        if (userIdParam == null || action == null || valueParam == null) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Thiếu tham số bắt buộc (userId, action, value)");
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, error);
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);
            int value = Integer.parseInt(valueParam);
            boolean success = false;
            String message = "";

            if (action.equals("role")) {
                success = UserServices.updateUserRole(userId, value);
                message = success ? "Cập nhật Role thành công" : "Lỗi khi cập nhật Role";
            } else if (action.equals("status")) {
                success = UserServices.updateUserStatus(userId, value);
                message = success ? "Cập nhật Trạng thái thành công" : "Lỗi khi cập nhật Trạng thái";
            } else {
                Map<String, String> error = new HashMap<>();
                error.put("error", "Hành động không hợp lệ: " + action);
                sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, error);
                return;
            }

            if (success) {
                Map<String, Object> result = new HashMap<>();
                result.put("status", "success");
                result.put("message", message);
                sendJson(resp, HttpServletResponse.SC_OK, result);
            } else {
                Map<String, Object> result = new HashMap<>();
                result.put("status", "error");
                result.put("message", message);
                sendJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, result);
            }

        } catch (NumberFormatException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "userId hoặc value không phải là số.");
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, error);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "Lỗi server trong quá trình cập nhật: " + e.getMessage());
            sendJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, error);
        }
    }
}