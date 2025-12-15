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

<script src="https://upload-widget.cloudinary.com/global/all.js" type="text/javascript"></script>

<style>
/* STYLES (Giữ nguyên) */
:root {
    --sidebar-width: 240px;
    --sidebar-bg: #2a3f54;
    --active-color: #ffe082;
}
body {
    background: #f4f6f9;
    margin: 0;
    padding: 0;
    padding-left: var(--sidebar-width);
}
.main-content { padding: 20px; }
.main-header {
    background: #fff;
    padding: 15px 20px;
    border-bottom: 1px solid #ddd;
    margin-bottom: 20px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}
.admin-sidebar { position: fixed; width: var(--sidebar-width); }
</style>
</head>
<body>
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
                    <form class="row g-3" id="videoForm">
                        <input type="hidden" id="videoId" name="videoId" value="">

                        <div class="col-md-6">
                            <label for="title" class="form-label">Tiêu đề</label>
                            <input type="text" class="form-control" id="title" name="title" placeholder="Tiêu đề video">
                            <div class="invalid-feedback" id="titleError"></div>
                        </div>
                        <div class="col-md-6">
                            <label for="url" class="form-label">URL Video</label>
                            <input type="url" class="form-control" id="url" name="url" placeholder="https://youtube.com/...">
                            <div class="invalid-feedback" id="urlError"></div>
                        </div>

                        <div class="col-md-6">
                            <label for="poster" class="form-label">Ảnh Poster (Thumbnail)</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="poster" name="poster" placeholder="URL ảnh poster">
                                <button type="button" class="btn btn-outline-secondary" id="upload_widget">
                                    <i class="fa-solid fa-cloud-arrow-up me-2"></i> Tải lên
                                </button>
                            </div>
                            <div class="invalid-feedback" id="posterError"></div>
                            <div class="mt-2" id="poster-preview-container">
                                <img id="poster-preview" src="" alt="Poster Preview" style="max-width: 100%; max-height: 150px; display: none; border: 1px solid #ddd;">
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label for="category" class="form-label">Danh mục</label>
                            <select id="category" name="category" class="form-select">
                                <option value="">Chọn danh mục</option>
                            </select>
                            <div class="invalid-feedback" id="categoryError"></div>
                        </div>
                        <div class="col-12">
                            <label for="description" class="form-label">Mô tả</label>
                            <textarea class="form-control" id="description" name="description" rows="3" placeholder="Nhập mô tả"></textarea>
                            <div class="invalid-feedback" id="descriptionError"></div>
                        </div>

                        <div class="col-12">
                            <button type="submit" class="btn btn-primary" id="saveBtn" style="background-color: var(--sidebar-bg); border-color: var(--sidebar-bg);">
                                <i class="fa-solid fa-cloud-arrow-up me-2"></i> <span id="formButtonText">Lưu video</span>
                            </button>
                            <button type="button" onclick="resetForm()" class="btn btn-outline-secondary ms-2">
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
                            <tbody id="bodyTableVideo" data-context-path="${pageContext.request.contextPath}">
                                </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>

<script>
    let allVideos = [];
    let allCategories = [];
    const bodyTable = document.getElementById("bodyTableVideo");
    const contextPath = bodyTable.getAttribute("data-context-path");
    const formTitle = document.getElementById("form-title");
    const saveBtn = document.getElementById("saveBtn");
    const videoIdInput = document.getElementById("videoId");
    const categorySelect = document.getElementById("category");
    const videoForm = document.getElementById("videoForm");

    // CLOUDINARY CONFIG
    const cloudinaryCloudName = "dhdke5ku8";
    const cloudinaryUploadPreset = "unsigned_upload";
    const posterInput = document.getElementById('poster');
    const uploadWidgetBtn = document.getElementById('upload_widget');
    const posterPreview = document.getElementById('poster-preview');

    document.addEventListener('DOMContentLoaded', function() {
        fetchCategories().then(getData);
        setupFormSubmit();
        setupCloudinaryWidget();

        if (videoIdInput.value) {
            formTitle.textContent = 'Cập nhật Video ID: ' + videoIdInput.value;
            saveBtn.innerHTML = '<i class="fa-solid fa-pen-to-square me-2"></i> Cập nhật video';
        }
    });

    // 1. FETCH CATEGORIES
    async function fetchCategories() {
        try {
            const res = await axios.get(contextPath + "/api/category");
            allCategories = res.data;
            renderCategories();
        } catch (error) {
            console.error("Lỗi danh mục:", error);
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
        const preSelectedCategory = "${bean.category}";
        if(preSelectedCategory) categorySelect.value = preSelectedCategory;
    }

    // 2. CLOUDINARY WIDGET
    function setupCloudinaryWidget() {
        if (!cloudinaryCloudName || !cloudinaryUploadPreset) {
             uploadWidgetBtn.disabled = true;
             return;
        }
        const myWidget = cloudinary.createUploadWidget(
            {
                cloudName: cloudinaryCloudName,
                uploadPreset: cloudinaryUploadPreset,
                sources: [ 'local', 'url' ],
                folder: 'video_posters',
                clientAllowedFormats: ["png", "gif", "jpeg", "jpg"],
                maxFileSize: 5000000
            },
            (error, result) => {
                if (!error && result && result.event === "success") {
                    const imageUrl = result.info.secure_url;
                    posterInput.value = imageUrl;
                    posterPreview.src = imageUrl;
                    posterPreview.style.display = 'block';
                    showAlert('success', 'Tải ảnh lên thành công!');
                }
            }
        );
        uploadWidgetBtn.addEventListener("click", function(){ myWidget.open(); }, false);
    }

    // 3. VALIDATION
    function validateForm(title, url, poster, category) {
        let isValid = true;
        document.querySelectorAll('.is-invalid').forEach(el => el.classList.remove('is-invalid'));
        ['title', 'url', 'category', 'poster'].forEach(id => document.getElementById(id + 'Error').textContent = '');

        if (!title) {
            document.getElementById('title').classList.add('is-invalid');
            document.getElementById('titleError').textContent = 'Vui lòng nhập tiêu đề.';
            isValid = false;
        }
        if (!url) {
            document.getElementById('url').classList.add('is-invalid');
            document.getElementById('urlError').textContent = 'Vui lòng nhập URL.';
            isValid = false;
        } else {
            const youtubeRegex = /^(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)([a-zA-Z0-9_-]{11})/;
            if (!youtubeRegex.test(url)) {
                document.getElementById('url').classList.add('is-invalid');
                document.getElementById('urlError').textContent = 'URL YouTube không hợp lệ.';
                isValid = false;
            }
        }
        if (!category) {
            document.getElementById('category').classList.add('is-invalid');
            document.getElementById('categoryError').textContent = 'Vui lòng chọn danh mục.';
            isValid = false;
        }
        return isValid;
    }

    // 4. SUBMIT FORM
    function setupFormSubmit() {
        videoForm.addEventListener('submit', async function(e) {
            e.preventDefault();
            const videoId = videoIdInput.value;
            const title = document.getElementById('title').value.trim();
            const url = document.getElementById('url').value.trim();
            const poster = posterInput.value.trim();
            const category = categorySelect.value;
            const description = document.getElementById('description').value.trim();

            if (!poster) {
                showAlert('danger', 'Vui lòng tải lên ảnh Poster.');
                return;
            }
            if (!validateForm(title, url, poster, category)) return;

            try {
                const params = new URLSearchParams();
                params.append('title', title);
                params.append('url', url);
                params.append('poster', poster);
                params.append('category', category);
                params.append('description', description);
                if (videoId) params.append('videoId', videoId);

                const response = await axios.post(contextPath + '/api/admin/videos', params.toString(), {
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                });

                if (response.data.status === 'success') {
                    showAlert('success', response.data.message);
                    resetForm();
                    getData();
                } else {
                    showAlert('danger', response.data.message);
                }
            } catch (error) {
                const msg = error.response && error.response.data ? error.response.data.message : 'Lỗi hệ thống';
                showAlert('danger', msg);
            }
        });
    }

    // 5. GET DATA (CẬP NHẬT: Thêm nút Ẩn/Hiện)
    function getData() {
        axios.get(contextPath + "/api/admin/videos")
        .then(function(res) {
            allVideos = res.data;
            const arrayHtml = allVideos.map(function(element) {
                // Logic tạo nút Ẩn/Hiện
// Logic tạo nút Ẩn/Hiện
let toggleBtn = '';
if (element.status === 1) { // Đang Active -> Hiện nút Ẩn
    toggleBtn = "<button type='button' class='btn btn-sm btn-secondary me-1' onclick='toggleStatus(" + element.id + ", 0)' title='Ẩn video'><i class='fa-solid fa-eye-slash'></i></button>";
} else { // Đang Inactive -> Hiện nút Hiện
    toggleBtn = "<button type='button' class='btn btn-sm btn-success me-1' onclick='toggleStatus(" + element.id + ", 1)' title='Hiện video'><i class='fa-solid fa-eye'></i></button>";
}

                return "<tr>" +
                    "<td>" + element.id + "</td>" +
                    "<td>" + escapeHtml(element.title) + "</td>" +
                    "<td>" + escapeHtml(element.authName) + "</td>" +
                    "<td><a href='" + escapeHtml(element.url) + "' target='_blank'>Link</a></td>" +
                    "<td><span class='badge bg-info'>" + escapeHtml(element.catName) + "</span></td>" +
                    "<td>" + element.createAt + "</td>" +
                    "<td>" + element.viewCount + "</td>" +
                    "<td><span class='badge " + (element.status === 1 ? 'bg-success' : 'bg-secondary') + "'>" +
                        (element.status === 1 ? 'Active' : 'Hidden') + "</span></td>" +
                    "<td>" +
                        toggleBtn + // Nút Ẩn/Hiện mới thêm
                        "<button type='button' class='btn btn-sm btn-warning me-1' onclick='editVideo(" + element.id + ")' title='Sửa'>" +
                            "<i class='fa-solid fa-pen-to-square'></i>" +
                        "</button>" +
                        "<button type='button' class='btn btn-sm btn-danger' onclick='deleteVideo(" + element.id + ")' title='Xoá'>" +
                            "<i class='fa-solid fa-trash'></i>" +
                        "</button>" +
                    "</td>" +
                "</tr>";
            });
            bodyTable.innerHTML = arrayHtml.join("");
        })
        .catch(function(error) {
            console.error(error);
            bodyTable.innerHTML = "<tr><td colspan='9' class='text-center text-danger'>Lỗi tải dữ liệu.</td></tr>";
        });
    }

    // 6. EDIT VIDEO
    function editVideo(id) {
        const video = allVideos.find(v => v.id === id);
        if (!video) return;

        videoIdInput.value = video.id;
        document.getElementById("title").value = video.title;
        document.getElementById("url").value = video.url;
        posterInput.value = video.poster;
        document.getElementById("description").value = video.desc;

        if (video.poster) {
            posterPreview.src = video.poster;
            posterPreview.style.display = 'block';
        } else {
            posterPreview.style.display = 'none';
        }

        categorySelect.value = video.catName;
        formTitle.textContent = 'Cập nhật Video ID: ' + video.id;
        saveBtn.innerHTML = '<i class="fa-solid fa-pen-to-square me-2"></i> Cập nhật video';
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    // 7. RESET FORM
    function resetForm() {
        videoForm.reset();
        videoIdInput.value = "";
        formTitle.textContent = "Thêm Video Mới";
        saveBtn.innerHTML = '<i class="fa-solid fa-cloud-arrow-up me-2"></i> Lưu video';
        posterPreview.src = '';
        posterPreview.style.display = 'none';
        document.querySelectorAll('.is-invalid').forEach(el => el.classList.remove('is-invalid'));
        ['title', 'url', 'category', 'poster'].forEach(id => document.getElementById(id + 'Error').textContent = '');
    }

    // 8. DELETE VIDEO
    async function deleteVideo(id) {
        if (confirm("Bạn có chắc chắn muốn xóa video này không?")) {
            try {
                const params = new URLSearchParams();
                params.append("videoId", id);
                params.append("action", "delete");

                const response = await axios.post(contextPath + "/api/admin/videos", params.toString(), {
                    headers: { "Content-Type": "application/x-www-form-urlencoded" }
                });

                if (response.data.status === true) {
                    showAlert('success', response.data.message);
                    getData();
                } else {
                    showAlert('danger', response.data.message);
                }
            } catch (e) {
                showAlert('danger', 'Lỗi hệ thống khi xóa.');
            }
        }
    }

    // 9. TOGGLE STATUS (THÊM MỚI)
    async function toggleStatus(id, newStatus) {
        const actionText = newStatus === 1 ? "hiện" : "ẩn";
        try {
            const params = new URLSearchParams();
            params.append('videoId', id);
            params.append('status', newStatus);
            params.append('action', 'toggle'); // Action quan trọng

            const response = await axios.post(contextPath + '/api/admin/videos', params.toString(), {
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
            });

            if (response.data.status === 'success') {
                showAlert('success', response.data.message);
                getData(); // Refresh table
            } else {
                showAlert('danger', response.data.message);
            }
        } catch (error) {
            const msg = error.response && error.response.data ? error.response.data.message : "Lỗi kết nối";
            showAlert('danger', 'Không thể ' + actionText + ' video: ' + msg);
        }
    }

    // ==================== UTILITY FUNCTIONS ====================

    // HELPER: Show Alert
    function showAlert(type, message) {
        const alertDiv = document.createElement('div');
        alertDiv.className = 'alert alert-' + type + ' alert-dismissible fade show';
        alertDiv.role = 'alert';
        alertDiv.innerHTML = escapeHtml(message) +
            '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
        const container = document.querySelector('.container-fluid');
        // Tìm div cha của form để chèn thông báo ngay sau main-header
        const targetElement = document.querySelector('.main-header').nextElementSibling;
        if (targetElement) {
             targetElement.insertAdjacentElement('afterbegin', alertDiv);
        } else {
             container.insertBefore(alertDiv, container.firstChild);
        }

        // Auto dismiss after 5 seconds
        setTimeout(function() {
            // Kiểm tra xem alertDiv còn tồn tại trước khi xóa
            if (alertDiv.parentElement) {
                alertDiv.remove();
            }
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
            "'": '&#039;',
        };
        return text.toString().replace(/[&<>"']/g, (m) => map[m]);
    }
</script>
</body>
</html>