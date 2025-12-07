package com.poly.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.poly.entities.Video;
import com.poly.reponse.VideoReponse;
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

@WebServlet(urlPatterns = {"/api/videos"})
public class VideoApi extends HttpServlet {
    private static final long serialVersionUID = 1L;
    @Override
    @Operation(
            summary = "Lấy danh sách video (Tổng hợp)", // Tiêu đề chung cho chức năng GET
            description = "Phương thức này xử lý hai đường dẫn GET khác nhau:\n" +
                    "1. **GET /api/videos**: Lấy toàn bộ danh sách video đang hoạt động (Active Videos).\n" +
                    "2. **GET /api/videosoft/**: Lấy danh sách video đã được đánh dấu xóa mềm (Soft Deleted Videos) hoặc theo logic lọc khác.", // Chi tiết hóa các endpoint
            responses = {
                    @ApiResponse(responseCode = "200", description = "Thành công",
                            content = @Content(mediaType = "application/json",
                                    schema = @Schema(implementation = VideoReponse.class))),
                    @ApiResponse(responseCode = "500", description = "Lỗi Server")
            }
    )
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        List<VideoReponse> responseVideos = new ArrayList<>();
        if(path.equals("/api/videos")){
            try{
                resp.setContentType("application/json; charset=UTF-8");
                List<Video> videos = VideoServices.getAllVideo(); // lấy enity
                //ánh xạ .
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
        }else{
            resp.getWriter().println("fetch thất bại");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.doPost(req, resp);
    }
}
