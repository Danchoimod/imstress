<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Swagger API Documentation</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/webjars/swagger-ui/5.30.3/swagger-ui.css">
<style>
  html { box-sizing: border-box; overflow: -moz-scrollbars-vertical; overflow-y: scroll; }
  *, *:before, *:after { box-sizing: inherit; }
  body { margin: 0; background: #fafafa; }
</style>
</head>
<body>
    <div id="swagger-ui"></div>

    <script src="${pageContext.request.contextPath}/webjars/swagger-ui/5.30.3/swagger-ui-bundle.js"></script>
    <script src="${pageContext.request.contextPath}/webjars/swagger-ui/5.30.3/swagger-ui-standalone-preset.js"></script>

    <script>
        // Lấy Context Path của ứng dụng (ví dụ: /Java4)
        const contextPath = "${pageContext.request.contextPath}";

        // URL của file JSON đặc tả API (đã được tạo bởi OpenApiJsonServlet)
        const apiSpecUrl = contextPath + "/v3/api-docs";

        console.log("Context Path:", contextPath);
        console.log("API Spec URL:", apiSpecUrl);

        window.onload = function() {
            try {
                // Khởi tạo Swagger UI
                window.ui = SwaggerUIBundle({
                    url: apiSpecUrl, // Đặt URL JSON API ở đây
                    dom_id: '#swagger-ui',
                    deepLinking: true,
                    presets: [
                        SwaggerUIBundle.presets.apis,
                        SwaggerUIStandalonePreset
                    ],
                    plugins: [
                        SwaggerUIBundle.plugins.DownloadUrl
                    ],
                    layout: "StandaloneLayout",
                    onComplete: function() {
                        console.log("Swagger UI loaded successfully!");
                    },
                    onFailure: function(error) {
                        console.error("Failed to load Swagger UI:", error);
                    }
                });
            } catch (error) {
                console.error("Error initializing Swagger UI:", error);
                document.getElementById('swagger-ui').innerHTML =
                    '<div style="padding: 20px; color: red;">' +
                    '<h2>Error Loading API Documentation</h2>' +
                    '<p>' + error.message + '</p>' +
                    '<p>Check browser console for details.</p>' +
                    '</div>';
            }
        };
    </script>
</body>
</html>