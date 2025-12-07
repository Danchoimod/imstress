package com.poly.config;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.servers.Server;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@OpenAPIDefinition(
        info = @Info(
                title = "Video API Java Servlet Documentation",
                version = "1.0.0",
                description = "Tài liệu API cho các dịch vụ Video."
        ),
        servers = {
                @Server(url = "/Java4", description = "Local Development Server") // Thay 'Java4' nếu tên project khác
        }
)
@WebListener
public class SwaggerConfig implements ServletContextListener {
    // Chỉ dùng @Annotation để cấu hình, không cần logic trong body
}