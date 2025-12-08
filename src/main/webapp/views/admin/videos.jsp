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
                    <h6 class="m-0 fw-bold text-primary" id="form-title">Thêm Video Mới</h6>
                </div>

                <div class="card-body">
                    <form class="row g-3" method="POST" id="videoForm">

                        <%-- TRƯỜNG ẨN DÙNG ĐỂ NHẬN DIỆN ĐANG SỬA VIDEO NÀO --%>
                        <input type="hidden" id="videoId" name="videoId" value="${param.id}">

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
                            <%-- Dữ liệu danh mục sẽ được load bằng JavaScript --%>
                            <select id="category" name="category"
                                    class="form-select ${not empty bean.errors.errCategory ? 'is-invalid' : ''}">
                                <option value="">Chọn danh mục</option>
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
                            <button type="submit" class="btn btn-primary" id="saveBtn"
                                    style="background-color: var(--sidebar-bg); border-color: var(--sidebar-bg);">
                                <i class="fa-solid fa-cloud-arrow-up me-2"></i> Lưu video
                            </button>
                            <button type="button" onclick="resetForm()" class="btn btn-outline-secondary ms-2">
                               <i class="fa-solid fa-xmark me-2"></i> Hủy / Thêm mới
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
    // Biến toàn cục để lưu trữ danh sách video và danh mục
    let allVideos = [];
    let allCategories = [];
    const bodyTable = document.getElementById("bodyTableVideo");
    const contextPath = bodyTable.getAttribute("data-context-path");
    const formTitle = document.getElementById("form-title");
    const saveBtn = document.getElementById("saveBtn");
    const videoIdInput = document.getElementById("videoId");
    const categorySelect = document.getElementById("category");
    const videoForm = document.getElementById("videoForm");

    document.addEventListener('DOMContentLoaded', function() {
        // Khởi tạo: Lấy danh mục trước, sau đó lấy dữ liệu video
        fetchCategories().then(getData);

        // Setup form submit handler
        setupFormSubmit();

        // Nếu có lỗi validation từ Controller, hãy hiển thị lại form title
        if (videoIdInput.value) {
            formTitle.textContent = 'Cập nhật Video ID: ' + videoIdInput.value;
            saveBtn.innerHTML = '<i class="fa-solid fa-pen-to-square me-2"></i> Cập nhật video';
        }
    });

    // -------------------- CÁC HÀM XỬ LÝ DANH MỤC --------------------
    async function fetchCategories() {
        try {
            const res = await axios.get(contextPath + "/api/category");
            allCategories = res.data;
            renderCategories();
        } catch (error) {
            console.error("Lỗi khi tải danh mục:", error);
            categorySelect.innerHTML = '<option value="">Lỗi tải danh mục</option>';
        }
    }

    function renderCategories() {
        categorySelect.innerHTML = '<option value="">Chọn danh mục</option>';
        allCategories.forEach(function(cat) {
            const option = document.createElement('option');
            option.value = cat.name;
            option.textContent = cat.name;
            categorySelect.appendChild(option);
        });

        // Nếu có bean.category từ server (sau post/validation), chọn lại danh mục đó
        const preSelectedCategory = "${bean.category}";
        if(preSelectedCategory) {
            categorySelect.value = preSelectedCategory;
        }
    }

    // -------------------- SETUP FORM SUBMIT --------------------
    function setupFormSubmit() {
        videoForm.addEventListener('submit', async function(e) {
            e.preventDefault();

            const videoId = videoIdInput.value;
            const title = document.getElementById('title').value.trim();
            const url = document.getElementById('url').value.trim();
            const poster = document.getElementById('poster').value.trim();
            const category = categorySelect.value;
            const description = document.getElementById('description').value.trim();

            // Basic client-side validation
            if (!title || !url || !poster || !category || !description) {
                showAlert('danger', 'Vui lòng điền đầy đủ tất cả các trường!');
                return;
            }

            try {
                const params = new URLSearchParams();
                params.append('title', title);
                params.append('url', url);
                params.append('poster', poster);
                params.append('category', category);
                params.append('description', description);
                if (videoId) {
                    params.append('videoId', videoId);
                }

                const response = await axios.post(
                    contextPath + '/api/admin/videos',
                    params.toString(),
                    {
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        }
                    }
                );

                if (response.data.status === 'success') {
                    showAlert('success', response.data.message);
                    resetForm();
                    getData(); // Reload data
                } else {
                    showAlert('danger', response.data.message);
                }
            } catch (error) {
                console.error('Error submitting form:', error);
                const errorMessage = error.response && error.response.data && error.response.data.message
                    ? error.response.data.message
                    : 'Có lỗi xảy ra khi xử lý yêu cầu';
                showAlert('danger', errorMessage);
            }
        });
    }

    // -------------------- CÁC HÀM XỬ LÝ VIDEO --------------------

    function getData() {
        axios.get(contextPath + "/api/admin/videos")
        .then(function(res) {
            allVideos = res.data;
            const arrayHtml = allVideos.map(function(element) {
                const posterImg = element.poster ? element.poster : 'placeholder.jpg';

                return "<tr>" +
                    "<td>" + element.id + "</td>" +
                    "<td>" + escapeHtml(element.title) + "</td>" +
                    "<td>" + escapeHtml(element.authName) + "</td>" +
                    "<td><a href='" + escapeHtml(element.url) + "' target='_blank'>Link</a></td>" +
                    "<td><span class='badge bg-info'>" + escapeHtml(element.catName) + "</span></td>" +
                    "<td>" + element.createAt + "</td>" +
                    "<td>" + element.viewCount + "</td>" +
                    "<td><span class='badge bg-success'>" + (element.status === 1 ? 'Active' : 'Inactive') + "</span></td>" +
                    "<td>" +
                        "<button type='button' class='btn btn-sm btn-warning me-1' onclick='editVideo(" + element.id + ")' title='Sửa'>" +
                            "<i class='fa-solid fa-pen-to-square'></i>" +
                        "</button>" +
                        "<button type='button' class='btn btn-sm btn-danger' onclick='deleteVideo(" + element.id + ")' title='Xoá video'>" +
                            "<i class='fa-solid fa-trash'></i>" +
                        "</button>" +
                    "</td>" +
                "</tr>";
            });
            bodyTable.innerHTML = arrayHtml.join("");
        })
        .catch(function(error) {
            console.error("Lỗi khi tải dữ liệu:", error);
            bodyTable.innerHTML = "<tr><td colspan='9' class='text-center text-danger'>Không thể tải danh sách video. Vui lòng kiểm tra API.</td></tr>";
        });
    }

    // Hàm điền dữ liệu vào form để chỉnh sửa
    function editVideo(id) {
        const video = allVideos.find(function(v) { return v.id === id; });
        if (!video) return;

        // 1. Điền dữ liệu vào form
        videoIdInput.value = video.id;
        document.getElementById("title").value = video.title;
        document.getElementById("url").value = video.url;
        document.getElementById("poster").value = video.poster;
        document.getElementById("description").value = video.desc;

        // 2. Chọn lại danh mục
        categorySelect.value = video.catName;

        // 3. Cập nhật tiêu đề form và nút bấm
        formTitle.textContent = 'Cập nhật Video ID: ' + video.id;
        saveBtn.innerHTML = '<i class="fa-solid fa-pen-to-square me-2"></i> Cập nhật video';

        // 4. Scroll lên đầu form
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    // Hàm xóa dữ liệu form và chuyển về chế độ Thêm mới
    function resetForm() {
        videoForm.reset();
        videoIdInput.value = "";
        formTitle.textContent = "Thêm Video Mới";
        saveBtn.innerHTML = '<i class="fa-solid fa-cloud-arrow-up me-2"></i> Lưu video';

        // Xóa các class is-invalid
        document.querySelectorAll('.is-invalid').forEach(function(el) {
            el.classList.remove('is-invalid');
        });
    }

    async function deleteVideo(id) {
        if (confirm("Bạn có chắc chắn muốn xóa video này không?")) {
            try {
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
                    showAlert('success', res.message);
                    getData(); // Tải lại dữ liệu sau khi xóa thành công
                } else {
                    showAlert('danger', 'Lỗi xóa video: ' + res.message);
                }

            } catch (e) {
                console.error("Lỗi hệ thống khi xóa:", e);
                showAlert('danger', 'Lỗi hệ thống: Không thể kết nối hoặc xử lý yêu cầu xóa.');
            }
        }
    }

    // ==================== ALERT HELPER ====================
    function showAlert(type, message) {
        const alertDiv = document.createElement('div');
        alertDiv.className = 'alert alert-' + type + ' alert-dismissible fade show';
        alertDiv.role = 'alert';
        alertDiv.innerHTML = escapeHtml(message) +
            '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';

        const container = document.querySelector('.container-fluid');
        container.insertBefore(alertDiv, container.firstChild);

        // Auto dismiss after 5 seconds
        setTimeout(function() {
            alertDiv.remove();
        }, 5000);
    }

    // ==================== HTML ESCAPE ====================
    function escapeHtml(text) {
        if (!text) return '';
        const map = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        };
        return String(text).replace(/[&<>"']/g, function(m) { return map[m]; });
    }
</script>
</body>
</html>