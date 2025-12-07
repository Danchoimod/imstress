package com.poly.api;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.v3.core.util.Json;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.PathItem;
import io.swagger.v3.oas.models.Paths;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.responses.ApiResponse;
import io.swagger.v3.oas.models.responses.ApiResponses;
import io.swagger.v3.oas.models.servers.Server;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Servlet phục vụ file JSON OpenAPI specification tại endpoint /v3/api-docs
 */
@WebServlet(urlPatterns = "/v3/api-docs", loadOnStartup = 1)
public class OpenApiJsonServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OpenAPI openAPI;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

        try {
            // 1. Định nghĩa danh sách các API cần quét
            List<Class<? extends HttpServlet>> apiClasses = new ArrayList<>();
            apiClasses.add(VideoApi.class);
            apiClasses.add(CategoryApi.class);
            apiClasses.add(VideoByCatApi.class);
            // THÊM CÁC API KHÁC CỦA BẠN VÀO ĐÂY:
            // apiClasses.add(UserApi.class); // Ví dụ cho một UserApi
            // apiClasses.add(CategoryApi.class); // Ví dụ cho một CategoryApi

            // 2. Tạo OpenAPI object và thông tin cơ bản
            openAPI = new OpenAPI();

            Info info = new Info()
                    .title("Video Management API")
                    .version("1.0.0")
                    .description("REST API documentation cho ứng dụng quản lý video Java4");

            openAPI.info(info);

            // Thêm server URL
            Server server = new Server();
            server.setUrl(config.getServletContext().getContextPath());
            server.setDescription("Development Server");
            openAPI.servers(Collections.singletonList(server));

            // 3. Quét tất cả các API trong danh sách
            openAPI.paths(scanServletPaths(apiClasses));

            System.out.println("OpenAPI initialized successfully!");

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Failed to initialize OpenAPI context", e);
        }
    }

    // Cập nhật: Hàm nhận một List các Class để quét
    private Paths scanServletPaths(List<Class<? extends HttpServlet>> apiClasses) {
        Paths paths = new Paths();

        for (Class<?> apiClass : apiClasses) {
            try {
                WebServlet webServlet = apiClass.getAnnotation(WebServlet.class);

                if (webServlet != null) {
                    // Lấy URL pattern đầu tiên làm Base Path
                    String[] urlPatterns = webServlet.urlPatterns();
                    String basePath = urlPatterns.length > 0 ? urlPatterns[0] : "/" + apiClass.getSimpleName();

                    PathItem pathItem = new PathItem();

                    // Quét các methods có @Operation annotation
                    for (Method method : apiClass.getDeclaredMethods()) {
                        Operation operation = method.getAnnotation(Operation.class);
                        if (operation != null) {
                            io.swagger.v3.oas.models.Operation op = new io.swagger.v3.oas.models.Operation();
                            op.setSummary(operation.summary());
                            op.setDescription(operation.description());

                            // (Giữ nguyên logic thêm responses)
                            ApiResponses responses = new ApiResponses();
                            for (io.swagger.v3.oas.annotations.responses.ApiResponse respAnnotation : operation.responses()) {
                                ApiResponse response = new ApiResponse();
                                response.setDescription(respAnnotation.description());
                                responses.addApiResponse(respAnnotation.responseCode(), response);
                            }
                            op.setResponses(responses);

                            // Map method name to HTTP method
                            if (method.getName().equals("doGet")) {
                                pathItem.setGet(op);
                            } else if (method.getName().equals("doPost")) {
                                pathItem.setPost(op);
                            } else if (method.getName().equals("doPut")) {
                                pathItem.setPut(op);
                            } else if (method.getName().equals("doDelete")) {
                                pathItem.setDelete(op);
                            }
                        }
                    }

                    // Chỉ thêm PathItem nếu có ít nhất một Operation
                    if (pathItem.readOperationsMap().size() > 0) {
                        paths.addPathItem(basePath, pathItem);
                    }
                }
            } catch (Exception e) {
                // In lỗi nếu không thể quét một class nào đó
                System.err.println("Error scanning API class: " + apiClass.getName());
                e.printStackTrace();
            }
        }
        return paths;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        // Quan trọng: Cho phép Swagger UI ở máy khác hoặc domain khác truy cập (CORS)
        resp.setHeader("Access-Control-Allow-Origin", "*");

        try {
            // Convert OpenAPI object sang JSON string
            ObjectMapper mapper = Json.mapper();
            String json = mapper.writerWithDefaultPrettyPrinter()
                    .writeValueAsString(openAPI);

            resp.getWriter().write(json);

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\": \"Failed to generate OpenAPI JSON: " + e.getMessage() + "\"}");
        }
    }
}