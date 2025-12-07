package com.poly.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.poly.entities.Category;
import com.poly.entities.Video;
import com.poly.reponse.CategoryReponse;
import com.poly.reponse.VideoReponse;
import com.poly.services.CategoryServices;
import com.poly.services.VideoServices;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = "/api/videobycat")
public class VideoByCatApi extends HttpServlet {
    @Override
    @Operation(
            summary = "Lấy danh sách video (Tổng hợp)", // Tiêu đề chung cho chức năng GET
            description = "Phương thức này xử lý hai đường dẫn GET khác nhau:\n" +
                    "1. **GET /api/videobycat**: Lấy toàn lấy video dựa trên id của danh mục ",
            responses = {
                    @ApiResponse(responseCode = "200", description = "Thành công",
                            content = @Content(mediaType = "application/json",
                                    schema = @Schema(implementation = VideoReponse.class))),
                    @ApiResponse(responseCode = "500", description = "Lỗi Server")
            }
    )
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        List<VideoReponse> responseVideos = new ArrayList<>();
        //chán vch
        int url = Integer.parseInt(req.getParameter("catId"));
        try {
            resp.setContentType("application/json; charset=UTF-8");
            List<Video> videos = VideoServices.getVideobyCat(url); // lấy enity
            for (Video entity : videos) {
                VideoReponse response = new VideoReponse();
                response.setId(entity.getId());
                response.setTitle(entity.getTitle());
                response.setDesc(entity.getDesc());
                response.setPoster(entity.getPoster());
                response.setUrl(entity.getUrl());
                response.setCreateAt(entity.getCreateAt());
                response.setStatus(entity.getStatus());
                responseVideos.add(response);
            }
            Gson gson = new GsonBuilder().serializeNulls().create();
            resp.getWriter().println(gson.toJson(responseVideos));

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
