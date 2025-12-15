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
/* -------------------- LAYOUT & STYLES (Cần thiết cho giao diện Admin) -------------------- */
:root {
    --sidebar-width: 240px;
    --sidebar-bg: #2a3f54; /* Màu nền sidebar */
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
                    <form class="row g-3" id="videoForm">

                        <%-- TRƯỜNG ẨN DÙNG ĐỂ NHẬN DIỆN ĐANG SỬA VIDEO NÀO --%>
                        <input type="hidden" id="videoId" name="videoId" value="">

                        <div class="col-md-6">
                            <label for="title" class="form-label">Tiêu đề</label>
                            <input type="text" class="form-control"
                                   id="title" name="title"
                                   placeholder="Tiêu đề video">
                            <div class="invalid-feedback" id="titleError"></div>
                        </div>
                        <div class="col-md-6">
                            <label for="url" class="form-label">URL Video</label>
                            <input type="url" class="form-control"
                                   id="url" name="url"
                                   placeholder="https://youtube.com/...">
                            <div class="invalid-feedback" id="urlError"></div>
                        </div>

                        <%-- CẬP NHẬT: Tích hợp Cloudinary Upload Widget --%>
                        <div class="col-md-6">
                            <label for="poster" class="form-label">Ảnh Poster (Thumbnail)</label>
                            <div class="input-group">
                                <input type="text" class="form-control"
                                       id="poster" name="poster" readonly
                                       placeholder="URL ảnh poster sẽ xuất hiện ở đây">
                                <button type="button" class="btn btn-outline-secondary" id="upload_widget">
                                     <i class="fa-solid fa-cloud-arrow-up me-2"></i> Tải lên
                                </button>
                            </div>
                            <div class="invalid-feedback" id="posterError"></div>

                            <%-- Hiển thị ảnh xem trước (tùy chọn) --%>
                            <div class="mt-2" id="poster-preview-container">
                                <img id="poster-preview" src="" alt="Poster Preview" style="max-width: 100%; max-height: 150px; display: none; border: 1px solid #ddd;">
                            </div>
                        </div>
                        <%-- HẾT CẬP NHẬT CLOUDINARY --%>

                        <div class="col-md-6">
                            <label for="category" class="form-label">Danh mục</label>
                            <%-- Dữ liệu danh mục sẽ được load bằng JavaScript --%>
                            <select id="category" name="category" class="form-select">
                                <option value="">Chọn danh mục</option>
                            </select>
                            <div class="invalid-feedback" id="categoryError"></div>
                        </div>
                        <div class="col-12">
                            <label for="description" class="form-label">Mô tả</label>
                            <textarea class="form-control"
                                      id="description" name="description" rows="3"
                                      placeholder="Nhập mô tả chi tiết về video"></textarea>
                            <div class="invalid-feedback" id="descriptionError"></div>
                        </div>

                        <div class="col-12">
                            <button type="submit" class="btn btn-primary" id="saveBtn"
                                    style="background-color: var(--sidebar-bg); border-color: var(--sidebar-bg);">
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
    let allVideos = []; //
    let allCategories = []; //
    const bodyTable = document.getElementById("bodyTableVideo"); //
    const contextPath = bodyTable.getAttribute("data-context-path"); //
    const formTitle = document.getElementById("form-title"); //
    const saveBtn = document.getElementById("saveBtn"); // [cite: 40]
    const videoIdInput = document.getElementById("videoId"); // [cite: 40]
    const categorySelect = document.getElementById("category"); // [cite: 40]
    const videoForm = document.getElementById("videoForm"); // [cite: 40]
    // -------------------- CÁC BIẾN VÀ ELEMENT CHO CLOUDINARY --------------------
    const cloudinaryCloudName = "dhdke5ku8"; // [cite: 41]
    // ⚠️ THAY THẾ BẰNG CLOUD NAME CỦA BẠN!
    const cloudinaryUploadPreset = "unsigned_upload"; // [cite: 42]
    // ⚠️ THAY THẾ BẰNG UNSIGNED UPLOAD PRESET CỦA BẠN!
    const posterInput = document.getElementById('poster'); // [cite: 43]
    const uploadWidgetBtn = document.getElementById('upload_widget'); // [cite: 43]
    const posterPreview = document.getElementById('poster-preview'); // [cite: 44]
    // -------------------- KẾT THÚC CLOUDINARY VARIABLES --------------------

    document.addEventListener('DOMContentLoaded', function() {
        // Khởi tạo: Lấy danh mục trước, sau đó lấy dữ liệu video
        fetchCategories().then(getData); // [cite: 47]

        // Setup form submit handler
        setupFormSubmit(); // [cite: 44]

        // Setup Cloudinary Widget
        setupCloudinaryWidget(); // [cite: 44]

        // Nếu có lỗi validation từ Controller, hãy hiển thị lại form title
        if (videoIdInput.value) { // [cite: 45]
            formTitle.textContent = 'Cập nhật Video ID: ' + videoIdInput.value; // [cite: 45]
            saveBtn.innerHTML = '<i class="fa-solid fa-pen-to-square me-2"></i> Cập nhật video'; // [cite: 45]
        }
    }); // [cite: 46]
    // -------------------- CÁC HÀM XỬ LÝ DANH MỤC --------------------
    async function fetchCategories() {
        try {
            const res = await axios.get(contextPath + "/api/category"); // [cite: 47]
            allCategories = res.data; // [cite: 47]
            renderCategories(); // [cite: 47]
        } catch (error) {
            console.error("Lỗi khi tải danh mục:", error); // [cite: 48]
            categorySelect.innerHTML = '<option value="">Lỗi tải danh mục</option>'; // [cite: 48]
        }
    }

    function renderCategories() {
        categorySelect.innerHTML = '<option value="">Chọn danh mục</option>'; // [cite: 49]
        allCategories.forEach(function(cat) { // [cite: 49]
            const option = document.createElement('option');
            option.value = cat.name;
            option.textContent = cat.name;
            categorySelect.appendChild(option);
        }); // [cite: 49]
        // Nếu có bean.category từ server (sau post/validation), chọn lại danh mục đó
        const preSelectedCategory = "${bean.category}"; // [cite: 50]
        if(preSelectedCategory) { // [cite: 51]
            categorySelect.value = preSelectedCategory; // [cite: 52]
        }
    }

    // -------------------- SETUP CLOUDINARY WIDGET --------------------
    function setupCloudinaryWidget() {
        if (!cloudinaryCloudName || !cloudinaryUploadPreset || cloudinaryCloudName === 'YOUR_CLOUDINARY_CLOUD_NAME') {
             console.error("LỖI CẤU HÌNH CLOUDINARY: Vui lòng cập nhật Cloud Name và Upload Preset."); // [cite: 53]
             uploadWidgetBtn.disabled = true; // [cite: 53]
             uploadWidgetBtn.textContent = 'Lỗi cấu hình Cloudinary'; // [cite: 53]
             return; // [cite: 54]
        }

        const myWidget = cloudinary.createUploadWidget(
            {
                cloudName: cloudinaryCloudName,
                uploadPreset: cloudinaryUploadPreset,
                // Cấu hình thêm (tùy chọn):
                sources: [ 'local', 'url' ], // [cite: 55]
                folder: 'video_posters', // [cite: 55]
                clientAllowedFormats: ["png", "gif", "jpeg", "jpg"], // [cite: 55]
                maxFileSize: 5000000 // Tối đa 5MB // [cite: 55]
            },
            (error, result) => {
                if (!error && result && result.event === "success") { // [cite: 56]
                    console.log('Done uploading! Here is the image info: ', result.info);

                    // Gán URL ảnh vào trường Poster và hiển thị xem trước
                    const imageUrl = result.info.secure_url; // [cite: 57]
                    posterInput.value = imageUrl; // [cite: 57]
                    posterPreview.src = imageUrl; // [cite: 57]
                    posterPreview.style.display = 'block'; // [cite: 57]

                    showAlert('success', 'Tải ảnh lên Cloudinary thành công!'); // [cite: 58]
                } else if (error) { // [cite: 58]
                    console.error("Cloudinary upload error:", error); // [cite: 59]
                    showAlert('danger', 'Lỗi khi tải ảnh lên Cloudinary.'); // [cite: 59]
                }
            }
        ); // [cite: 59]
        // Gán sự kiện cho nút bấm
        uploadWidgetBtn.addEventListener("click", function(){ // [cite: 60]
            myWidget.open(); // [cite: 60]
        }, false); // [cite: 61]
    }

    // -------------------- CÁC HÀM VALIDATION (MỚI) --------------------
    function validateForm(title, url, poster, category) {
        let isValid = true;

        // 1. Reset lỗi trước
        document.getElementById('title').classList.remove('is-invalid');
        document.getElementById('url').classList.remove('is-invalid');
        document.getElementById('category').classList.remove('is-invalid');
        document.getElementById('titleError').textContent = '';
        document.getElementById('urlError').textContent = '';
        document.getElementById('categoryError').textContent = '';

        // 2. Kiểm tra Tiêu đề (Bắt buộc)
        if (!title) {
            document.getElementById('title').classList.add('is-invalid');
            document.getElementById('titleError').textContent = 'Vui lòng nhập tiêu đề video.';
            isValid = false;
        }

        // 3. Kiểm tra URL (Bắt buộc)
        if (!url) {
            document.getElementById('url').classList.add('is-invalid');
            document.getElementById('urlError').textContent = 'Vui lòng nhập URL video.';
            isValid = false;
        } else {
            // 4. Kiểm tra định dạng URL là YouTube
            // Regex cơ bản: chấp nhận các URL của youtube.com (kể cả youtu.be)
            const youtubeRegex = /^(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)([a-zA-Z0-9_-]{11})/;
            if (!youtubeRegex.test(url)) {
                document.getElementById('url').classList.add('is-invalid');
                document.getElementById('urlError').textContent = 'URL không hợp lệ. Vui lòng nhập URL từ YouTube (youtube.com/watch?v=... hoặc youtu.be/...).';
                isValid = false;
            }
        }

        // 5. Kiểm tra Danh mục (Bắt buộc)
        if (!category) {
            document.getElementById('category').classList.add('is-invalid');
            document.getElementById('categoryError').textContent = 'Vui lòng chọn danh mục.';
            isValid = false;
        }

        // 6. Kiểm tra Poster (Đã được kiểm tra trong setupFormSubmit, nhưng thêm lại để đồng bộ)
        if (!poster) {
            // Lỗi này được xử lý bằng showAlert ở hàm submit
            isValid = false;
        }

        return isValid;
    }

    // -------------------- SETUP FORM SUBMIT (CẬP NHẬT ĐỂ TÍCH HỢP VALIDATION) --------------------
    function setupFormSubmit() {
        videoForm.addEventListener('submit', async function(e) {
            e.preventDefault();

            const videoId = videoIdInput.value;
            const title = document.getElementById('title').value.trim(); // [cite: 62]
            const url = document.getElementById('url').value.trim();
            const poster = posterInput.value.trim(); // Lấy giá trị từ trường poster [cite: 62]
            const category = categorySelect.value;
            const description = document.getElementById('description').value.trim();

            // 1. Kiểm tra Poster (Thumbnail) trước
            if (!poster) {
                showAlert('danger', 'Vui lòng tải lên ảnh Poster (Thumbnail) trước khi lưu.'); // [cite: 63]
                return; // [cite: 63]
            }

            // 2. Kiểm tra Validation cho các trường còn lại
            if (!validateForm(title, url, poster, category)) {
                return;
            }

            try {
                const params = new URLSearchParams();
                params.append('title', title); // [cite: 64]
                params.append('url', url); // [cite: 64]
                params.append('poster', poster); // [cite: 64]
                params.append('category', category); // [cite: 64]
                params.append('description', description); // [cite: 64]
                if (videoId) { // [cite: 65]
                    params.append('videoId', videoId); // [cite: 65]
                }

                const response = await axios.post(
                    contextPath + '/api/admin/videos', // [cite: 65]
                    params.toString(), // [cite: 65]
                    {
                        headers: { // [cite: 66]
                            'Content-Type': 'application/x-www-form-urlencoded' // [cite: 66]
                        }
                    }
                ); // [cite: 67]
                if (response.data.status === 'success') { // [cite: 67]
                    showAlert('success', response.data.message); // [cite: 67]
                    resetForm(); // [cite: 68]
                    getData(); // [cite: 68]
                } else {
                    showAlert('danger', response.data.message); // [cite: 69]
                }
            } catch (error) {
                console.error('Error submitting form:', error); // [cite: 70]
                const errorMessage = error.response && error.response.data && error.response.data.message
                    ? error.response.data.message // [cite: 71]
                    : 'Có lỗi xảy ra khi xử lý yêu cầu'; // [cite: 72]
                showAlert('danger', errorMessage); // [cite: 72]
            }
        }); // [cite: 73]
    }

    // -------------------- CÁC HÀM XỬ LÝ VIDEO --------------------

    function getData() {
        axios.get(contextPath + "/api/admin/videos") // [cite: 74]
        .then(function(res) {
            allVideos = res.data; // [cite: 74]
            const arrayHtml = allVideos.map(function(element) { // [cite: 74]
                const posterImg = element.poster ? element.poster : 'placeholder.jpg'; // [cite: 74]

                return "<tr>" + // [cite: 74]
                    "<td>" + element.id + "</td>" + // [cite: 74]
                    "<td>" + escapeHtml(element.title) + "</td>" + // [cite: 74]
                    "<td>" + escapeHtml(element.authName) + "</td>" + // [cite: 74, 75]
                    "<td><a href='" + escapeHtml(element.url) + "' target='_blank'>Link</a></td>" + // [cite: 75]
                    "<td><span class='badge bg-info'>" + escapeHtml(element.catName) + "</span></td>" + // [cite: 75]
                    "<td>" + element.createAt + "</td>" + // [cite: 75]
                    "<td>" + element.viewCount + "</td>" + // [cite: 75]
                    "<td><span class='badge bg-success'>" + (element.status === 1 ? // [cite: 76]
                    'Active' : 'Inactive') + "</span></td>" + // [cite: 77]
                    "<td>" +
                        "<button type='button' class='btn btn-sm btn-warning me-1' onclick='editVideo(" + element.id + ")' title='Sửa'>" + // [cite: 77]
                            "<i class='fa-solid fa-pen-to-square'></i>" + // [cite: 77]
                        "</button>" + // [cite: 78]
                        "<button type='button' class='btn btn-sm btn-danger' onclick='deleteVideo(" + element.id + ")' title='Xoá video'>" + // [cite: 78]
                            "<i class='fa-solid fa-trash'></i>" + // [cite: 79]
                        "</button>" + // [cite: 79]
                    "</td>" + // [cite: 79]
                "</tr>"; // [cite: 80]
            });
            bodyTable.innerHTML = arrayHtml.join(""); // [cite: 80]
        })
        .catch(function(error) {
            console.error("Lỗi khi tải dữ liệu:", error);
            bodyTable.innerHTML = "<tr><td colspan='9' class='text-center text-danger'>Không thể tải danh sách video. Vui lòng kiểm tra API.</td></tr>";
        }); // [cite: 81]
    }

    // Hàm điền dữ liệu vào form để chỉnh sửa
    function editVideo(id) {
        const video = allVideos.find(function(v) { return v.id === id; }); // [cite: 82]
        if (!video) return; // [cite: 82]

        // 1. Điền dữ liệu vào form
        videoIdInput.value = video.id; // [cite: 83]
        document.getElementById("title").value = video.title; // [cite: 83]
        document.getElementById("url").value = video.url; // [cite: 83]
        posterInput.value = video.poster; // Điền URL poster đã có [cite: 83]
        document.getElementById("description").value = video.desc; // [cite: 83]
        // HIỂN THỊ ẢNH XEM TRƯỚC
        if (video.poster) { // [cite: 84]
            posterPreview.src = video.poster; // [cite: 85]
            posterPreview.style.display = 'block'; // [cite: 85]
        } else {
            posterPreview.src = ''; // [cite: 86]
            posterPreview.style.display = 'none'; // [cite: 86]
        }

        // 2. Chọn lại danh mục
        categorySelect.value = video.catName; // [cite: 87]
        // 3. Cập nhật tiêu đề form và nút bấm
        formTitle.textContent = 'Cập nhật Video ID: ' + video.id; // [cite: 88]
        saveBtn.innerHTML = '<i class="fa-solid fa-pen-to-square me-2"></i> Cập nhật video'; // [cite: 88]

        // 4. Scroll lên đầu form
        window.scrollTo({ top: 0, behavior: 'smooth' }); // [cite: 89]
    }

    // Hàm xóa dữ liệu form và chuyển về chế độ Thêm mới (CẬP NHẬT ĐỂ XÓA LỖI)
    function resetForm() {
        videoForm.reset(); // [cite: 90]
        videoIdInput.value = ""; // [cite: 90]
        formTitle.textContent = "Thêm Video Mới"; // [cite: 90]
        saveBtn.innerHTML = '<i class="fa-solid fa-cloud-arrow-up me-2"></i> Lưu video'; // [cite: 90]
        // Ẩn ảnh xem trước khi reset form
        posterPreview.src = ''; // [cite: 91]
        posterPreview.style.display = 'none'; // [cite: 92]

        // Xóa các class is-invalid và nội dung lỗi
        document.querySelectorAll('.is-invalid').forEach(function(el) { // [cite: 92]
            el.classList.remove('is-invalid'); // [cite: 93]
        });
        document.getElementById('titleError').textContent = '';
        document.getElementById('urlError').textContent = '';
        document.getElementById('categoryError').textContent = '';
    }

    // ==================== HÀM XÓA VIDEO ĐÃ ĐƯỢC SỬA CẤU TRÚC ====================
    async function deleteVideo(id) {
        if (confirm("Bạn có chắc chắn muốn xóa video này không?")) {
            try {
                const params = new URLSearchParams();
                params.append("videoId", id); // [cite: 94]
                params.append("action", "delete"); // <-- THÊM THAM SỐ action MỚI [cite: 94]

                const response = await axios.post(
                    contextPath + "/api/admin/videos", // <-- SỬA ENDPOINT CHUNG [cite: 95]
                    params.toString(), // [cite: 95]
                    {
                        headers: { // [cite: 95]
                            "Content-Type": "application/x-www-form-urlencoded" // [cite: 95]
                        }
                    }
                ); // [cite: 96]

                const res = response.data; // [cite: 97]
                if (res.status === true) { // [cite: 97]
                    showAlert('success', res.message); // [cite: 97]
                    getData(); // Tải lại dữ liệu sau khi xóa thành công [cite: 98]
                } else {
                    showAlert('danger', 'Lỗi xóa video: ' + res.message); // [cite: 99]
                }

            } catch (e) {
                console.error("Lỗi hệ thống khi xóa:", e); // [cite: 99]
                showAlert('danger', 'Lỗi hệ thống: Không thể kết nối hoặc xử lý yêu cầu xóa.'); // [cite: 100]
            } // [cite: 101]
        }
    }

    // ==================== ALERT HELPER ====================
    function showAlert(type, message) {
        const alertDiv = document.createElement('div'); // [cite: 102]
        alertDiv.className = 'alert alert-' + type + ' alert-dismissible fade show'; // [cite: 102]
        alertDiv.role = 'alert'; // [cite: 103]
        alertDiv.innerHTML = escapeHtml(message) + // [cite: 103]
            '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>'; // [cite: 104]
        const container = document.querySelector('.container-fluid'); // [cite: 104]
        // Tìm div cha của form để chèn thông báo ngay sau main-header
        const targetElement = document.querySelector('.main-header').nextElementSibling; // [cite: 104, 105]
        if (targetElement) { // [cite: 105]
             targetElement.insertAdjacentElement('afterbegin', alertDiv); // [cite: 106]
        } else {
             container.insertBefore(alertDiv, container.firstChild); // [cite: 107]
        }

        // Auto dismiss after 5 seconds
        setTimeout(function() {
            // Kiểm tra xem alertDiv còn tồn tại trước khi xóa
            if (alertDiv.parentElement) {
                alertDiv.remove();
            }
        }, 5000); // [cite: 108]
    }

    // ==================== HTML ESCAPE ====================
    function escapeHtml(text) {
        if (!text) return ''; // [cite: 109]
        const map = { // [cite: 109]
            '&': '&amp;', //
            '<': '&lt;', //
            '>': '&gt;', //
            '"': '&quot;', //
            "'": '&#039;' //
        };
        return String(text).replace(/[&<>"']/g, function(m) { return map[m]; }); //
    }
</script>
</body>
</html>