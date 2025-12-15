package com.poly.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.poly.entities.Category;
import com.poly.reponse.CategoryReponse;
import com.poly.services.CategoryServices;
import com.poly.services.VideoServices; // Dùng để lấy số lượng video
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = "/api/admin/categories")
public class CategoryManagementApi extends HttpServlet {
    private final Gson gson = new GsonBuilder().serializeNulls().create();

    private void sendJson(HttpServletResponse resp, int status, Object data) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().println(gson.toJson(data));
    }

    // GET: Lấy danh sách tất cả danh mục (có thể kèm số lượng video)
    @Override
    @Operation(
            summary = "Lấy danh sách tất cả danh mục",
            responses = {
                    @ApiResponse(responseCode = "200", description = "Thành công"),
                    @ApiResponse(responseCode = "500", description = "Lỗi Server")
            }
    )
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
                    req.setCharacterEncoding("UTF-8");
                            resp.setContentType("text/html; charset=UTF-8");
            List<Category> categories = CategoryServices.getAll();
            List<Map<String, Object>> responses = new ArrayList<>();

            for (Category category : categories) {
                Map<String, Object> responseMap = new HashMap<>();
                responseMap.put("id", category.getId());
                responseMap.put("name", category.getName());

                // Giả định: status đã được thêm vào Category Entity
                try {
                    responseMap.put("status", category.getStatus());
                } catch (NoSuchMethodError e) {
                    // Fallback nếu status chưa được thêm vào Entity, mặc định là 1 (Active)
                    responseMap.put("status", 1);
                }

                // Lấy số lượng video (cần phải thêm service này)
                responseMap.put("videoCount", VideoServices.getVideobyCat(category.getId()).size());

                responses.add(responseMap);
            }

            sendJson(resp, HttpServletResponse.SC_OK, responses);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "Lỗi server khi tải danh sách danh mục: " + e.getMessage());
            sendJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, error);
        }
    }

    // POST: Xử lý Thêm mới (action=add) và Cập nhật Status (action=status)
    // Sẽ dùng POST cho cả ADD, UPDATE và STATUS UPDATE để đơn giản hóa việc gửi form/ajax
    @Override
    @Operation(
            summary = "Thêm mới hoặc Cập nhật Status/Tên của danh mục",
            description = "Sử dụng 'categoryname' để thêm mới, hoặc 'id', 'action' ('status'/'update') và 'value' (0/1) để cập nhật.",
            responses = {
                    @ApiResponse(responseCode = "200", description = "Thành công"),
                    @ApiResponse(responseCode = "400", description = "Sai tham số / Dữ liệu trùng lặp"),
                    @ApiResponse(responseCode = "500", description = "Lỗi Server")
            }
    )
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        String action = req.getParameter("action");
        String idParam = req.getParameter("id");

        if ("status".equals(action)) {
            updateCategoryStatus(req, resp);
        } else if ("update".equals(action) && idParam != null && !idParam.isEmpty()) {
            addOrUpdateCategory(req, resp); // Dùng chung logic update tên
        } else if ("add".equals(action) || (action == null && idParam == null)) {
            addOrUpdateCategory(req, resp); // Dùng chung logic thêm mới
        } else {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Hành động hoặc tham số không hợp lệ.");
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, error);
        }
    }

    private void addOrUpdateCategory(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            req.setCharacterEncoding("UTF-8");
            resp.setContentType("text/html; charset=UTF-8");
            com.poly.beans.CategoryBean bean = new com.poly.beans.CategoryBean();
            BeanUtils.populate(bean, req.getParameterMap());

            String idParam = req.getParameter("id");

            if (!bean.getErrors().isEmpty()) {
                Map<String, Object> error = new HashMap<>();
                error.put("status", "error");
                error.put("message", "Lỗi validation");
                error.put("errors", bean.getErrors());
                sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, error);
                return;
            }

                Category category = new Category();
            category.setName(bean.getCategoryname());

            String errorMsg;
            if (idParam != null && !idParam.isEmpty()) {
                // Update Logic
                category.setId(Integer.parseInt(idParam));
                errorMsg = CategoryServices.UpdateCategory(category);
            } else {
                // Add Logic
                errorMsg = CategoryServices.addCategory(category);
            }

            if (errorMsg == null) {
                Map<String, Object> result = new HashMap<>();
                result.put("status", "success");
                result.put("message", (idParam != null && !idParam.isEmpty()) ? "Cập nhật danh mục thành công!" : "Thêm danh mục thành công!");
                sendJson(resp, HttpServletResponse.SC_OK, result);
            } else {
                Map<String, Object> result = new HashMap<>();
                result.put("status", "error");
                result.put("message", errorMsg);
                sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, result);
            }

        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "Lỗi server trong quá trình thêm/sửa: " + e.getMessage());
            sendJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, error);
        }
    }

    private void updateCategoryStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idParam = req.getParameter("id");
        String valueParam = req.getParameter("value");

        if (idParam == null || valueParam == null) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Thiếu tham số bắt buộc (id, value)");
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, error);
            return;
        }

        try {
            int categoryId = Integer.parseInt(idParam);
            int newStatus = Integer.parseInt(valueParam);
            boolean success = CategoryServices.updateCategoryStatus(categoryId, newStatus);
            String message = success ?
                    (newStatus == 1 ? "Kích hoạt danh mục thành công" : "Ẩn danh mục thành công") :
                    "Lỗi khi cập nhật trạng thái danh mục";

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
            error.put("error", "id hoặc value không phải là số.");
            sendJson(resp, HttpServletResponse.SC_BAD_REQUEST, error);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "Lỗi server trong quá trình cập nhật status: " + e.getMessage());
            sendJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, error);
        }
    }
}