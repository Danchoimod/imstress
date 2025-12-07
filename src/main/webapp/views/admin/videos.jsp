<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý video</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" crossorigin="anonymous" />
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<style>
/* -------------------- LAYOUT & STYLES (Cần thiết cho giao diện Admin) -------------------- */
:root {
    --sidebar-width: 240px;
    --sidebar-bg: #2a3f54;
    --active-color: #ffe082; /* Màu vàng RoPhim */
}

body {
    background: #f4f6f9;
    margin: 0;
    padding: 0;
    padding-left: var(--sidebar-width); /* Đẩy nội dung chính sang phải */
}

/* -------------------- MAIN CONTENT STYLES -------------------- */
.main-content {
    padding: 20px;
}
.main-header {
    background: #fff;
    padding: 15px 20px;
    border-bottom: 1px solid #ddd;
    margin-bottom: 20px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}
/* Thêm style cho thẻ include sidebar (dù nó đã có style riêng) */
.admin-sidebar {
    position: fixed;
    width: var(--sidebar-width);
}
</style>
</head>
<body>
    <%-- Lưu ý: Kiểm tra lại đường dẫn include file sidebar --%>
    <%@ include file="/views/component/admin/sidebar.jsp" %>

    <div class="main-content">
        <div class="main-header">
            <h3 class="mb-0">Quản lý video</h3>
        </div>

        <div class="container-fluid">

            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 fw-bold text-primary">Thêm/Cập nhật Video</h6>
                </div>

                <div class="card-body">
                    <form class="row g-3" method="POST">
                        <div class="col-md-6">
                            <label for="title" class="form-label">Tiêu đề</label>
                            <input type="text" class="form-control ${not empty bean.errors.errTitle ? 'is-invalid' : ''}"
                                   id="title" name="title"
                                   value="${bean.title}"
                                   placeholder="Tiêu đề video">
                            <c:if test="${not empty bean.errors.errTitle}">
                                <div class="invalid-feedback">${bean.errors.errTitle}</div>
                            </c:if>
                        </div>
                        <div class="col-md-6">
                            <label for="url" class="form-label">URL Video</label>
                            <input type="url" class="form-control ${not empty bean.errors.errUrl ? 'is-invalid' : ''}"
                                   id="url" name="url"
                                   value="${bean.url}"
                                   placeholder="https://youtube.com/...">
                            <c:if test="${not empty bean.errors.errUrl}">
                                <div class="invalid-feedback">${bean.errors.errUrl}</div>
                            </c:if>
                        </div>
                        <div class="col-md-6">
                            <label for="poster" class="form-label">Ảnh Poster (Thumbnail)</label>
                            <input type="text" class="form-control ${not empty bean.errors.errPoster ? 'is-invalid' : ''}"
                                   id="poster" name="poster"
                                   value="${bean.poster}"
                                   placeholder="URL ảnh poster">
                            <c:if test="${not empty bean.errors.errPoster}">
                                <div class="invalid-feedback">${bean.errors.errPoster}</div>
                            </c:if>
                        </div>
                        <div class="col-md-6">
                            <label for="category" class="form-label">Danh mục</label>
                            <select id="category" name="category"
                                    class="form-select ${not empty bean.errors.errCategory ? 'is-invalid' : ''}">
                                <option value="">Chọn danh mục</option>
                                <option value="Hành động" ${bean.category == 'Hành động' ? 'selected' : ''}>Hành động</option>
                                <option value="Khoa học viễn tưởng" ${bean.category == 'Khoa học viễn tưởng' ? 'selected' : ''}>Khoa học viễn tưởng</option>
                                <option value="Tình cảm" ${bean.category == 'Tình cảm' ? 'selected' : ''}>Tình cảm</option>
                            </select>
                            <c:if test="${not empty bean.errors.errCategory}">
                                <div class="invalid-feedback">${bean.errors.errCategory}</div>
                            </c:if>
                        </div>
                        <div class="col-12">
                            <label for="description" class="form-label">Mô tả</label>
                            <textarea class="form-control ${not empty bean.errors.errDescription ? 'is-invalid' : ''}"
                                      id="description" name="description" rows="3"
                                      placeholder="Nhập mô tả chi tiết về video">${bean.description}</textarea>
                            <c:if test="${not empty bean.errors.errDescription}">
                                <div class="invalid-feedback">${bean.errors.errDescription}</div>
                            </c:if>
                        </div>

                        <div class="col-12">
                            <button type="submit" class="btn btn-primary" style="background-color: var(--sidebar-bg); border-color: var(--sidebar-bg);">
                                <i class="fa-solid fa-cloud-arrow-up me-2"></i> Lưu video
                            </button>
                            <button type="reset" class="btn btn-outline-secondary ms-2">
                                <i class="fa-solid fa-xmark me-2"></i> Hủy
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card shadow mb-4">
                 <div class="card-header py-3">
                    <h6 class="m-0 fw-bold text-primary">Danh sách Video</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-striped table-hover" width="100%" cellspacing="0">
                            <thead>
                                <tr class="table-dark">
                                    <th>ID</th>
                                    <th>Tiêu đề</th>
                                    <th>Tác giả</th>
                                    <th>URL</th>
                                    <th>Danh mục</th>
                                    <th>Ngày tạo</th>
                                    <th>Lượt xem</th>
                                    <th>Trạng thái</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <%-- Thêm id và data-context-path vào tbody để JS có thể render dữ liệu --%>
                            <tbody id="bodyTableVideo" data-context-path="${pageContext.request.contextPath}">
                                <%-- Dữ liệu sẽ được load bằng JavaScript --%>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        getData();
    });

    function getData() {
        const bodyTable = document.getElementById("bodyTableVideo");
        const contextPath = bodyTable.getAttribute("data-context-path");
        console.log("start call api: " + contextPath + "/api/videos");

        axios.get(contextPath + "/api/videos")
        .then((res) => {
            console.log(res.data);
            const arrayHtml = res.data.map((element) => {
                // Kiểm tra element.poster, nếu không có, dùng ảnh placeholder
                const posterImg = element.poster ? element.poster : 'placeholder.jpg';

                return "<tr>" +
                    "<td>" + element.id + "</td>" +
                    "<td>" + element.title + "</td>" +
                    "<td>" + element.authName + "</td>" +
                    "<td><a href='" + element.url + "' target='_blank'>Link</a></td>" + // Thêm cột URL
                    "<td><span class='badge bg-info'>" + element.catName + "</span></td>" +
                    "<td>" + element.createAt + "</td>" + // Thêm Ngày tạo
                    "<td>" + element.viewCount + "</td>" + // Thêm Lượt xem
                    "<td><span class='badge bg-success'>" + element.status + "</span></td>" +
                    "<td>" +
                        // Nút Sửa
                        "<a class='btn btn-sm btn-warning me-1' href='" + contextPath + "/editer/video-form?id=" + element.id + "' title='Sửa'>" +
                            "<i class='fa-solid fa-pen-to-square'></i>" +
                        "</a>" +
                        // Nút Xoá (gọi hàm deleteVideo)
                        "<button class='btn btn-sm btn-danger' onclick='deleteVideo(" + element.id + ")' title='Xoá video'>" +
                            "<i class='fa-solid fa-trash'></i>" +
                        "</button>" +
                    "</td>" +
                "</tr>";
            });
            bodyTable.innerHTML = arrayHtml.join("");
        })
        .catch((error) => {
            console.error("Lỗi khi tải dữ liệu:", error);
            // Hiển thị thông báo lỗi ngay trong bảng
            bodyTable.innerHTML = "<tr><td colspan='9' class='text-center text-danger'>Không thể tải danh sách video. Vui lòng kiểm tra API.</td></tr>";
        });
    }

    async function deleteVideo(id) {
        if (confirm("Bạn có chắc chắn muốn xóa video này không?")) {
            const bodyTable = document.getElementById("bodyTableVideo");
            const contextPath = bodyTable.getAttribute("data-context-path");

            try {
                // Sử dụng URLSearchParams để gửi dữ liệu dạng application/x-www-form-urlencoded
                const params = new URLSearchParams();
                params.append("videoId", id);

                const response = await axios.post(
                    contextPath + "/api/video-delete",
                    params.toString(),
                    {
                        headers: {
                            "Content-Type": "application/x-www-form-urlencoded"
                        }
                    }
                );

                const res = response.data;

                if (res.status === true) {
                    alert(res.message);
                    getData(); // Tải lại dữ liệu sau khi xóa thành công
                } else {
                    alert("Lỗi xóa video: " + res.message);
                }

            } catch (e) {
                console.error("Lỗi hệ thống khi xóa:", e);
                alert("Lỗi hệ thống: Không thể kết nối hoặc xử lý yêu cầu xóa.");
            }
        }
    }
</script>
</body>
</html>