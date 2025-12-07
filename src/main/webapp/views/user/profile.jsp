<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Quản lý tài khoản - RoPhim</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
            <style>
                :root {
                    --primary-color: #e50914;
                    --dark-color: #141414;
                    /* Màu nền cũ */
                    --light-color: #f4f4f4;
                    --secondary-color: #2c2c2c;
                }

                body {
                    background-color: #191b24;
                    color: var(--light-color);
                    font-family: 'Helvetica Neue', Arial, sans-serif;
                }

                .profile-container {
                    max-width: 1200px;
                    margin: 4rem auto;
                    padding: 0 15px;
                }


                .profile-sidebar {
                    background-color: var(--secondary-color);
                    border-radius: 10px;
                    padding: 1.5rem;
                    height: fit-content;
                }

                .profile-content {
                    background-color: var(--secondary-color);
                    border-radius: 10px;
                    padding: 2rem;
                }

                .nav-profile {
                    list-style: none;
                    padding: 0;
                }

                .nav-profile li {
                    margin-bottom: 0.5rem;
                }

                .nav-profile a {
                    display: block;
                    padding: 0.8rem 1rem;
                    color: #aaa;
                    text-decoration: none;
                    border-radius: 5px;
                    transition: all 0.3s;
                }

                .nav-profile a:hover,
                .nav-profile a.active {
                    background-color: rgba(229, 9, 20, 0.2);
                    color: var(--light-color);
                }

                .nav-profile a i {
                    margin-right: 10px;
                    width: 20px;
                    text-align: center;
                }

                .section-title {
                    border-left: 4px solid var(--primary-color);
                    padding-left: 10px;
                    margin-bottom: 1.5rem;
                    font-weight: bold;
                }

                .form-label {
                    color: #ddd;
                    font-weight: 500;
                }

                .form-control,
                .form-select {
                    background-color: #333;
                    border: 1px solid #444;
                    color: var(--light-color);
                }

                .form-control:focus,
                .form-select:focus {
                    background-color: #333;
                    border-color: var(--primary-color);
                    color: var(--light-color);
                    box-shadow: 0 0 0 0.25rem rgba(229, 9, 20, 0.25);
                }

                .btn-primary {
                    background-color: var(--primary-color);
                    border-color: var(--primary-color);
                    font-weight: bold;
                }

                .btn-primary:hover {
                    background-color: #b8070f;
                    border-color: #b8070f;
                }

                .avatar-container {
                    text-align: center;
                    margin-bottom: 2rem;
                }

                .avatar {
                    width: 120px;
                    height: 120px;
                    border-radius: 50%;
                    object-fit: cover;
                    border: 3px solid var(--primary-color);
                    margin-bottom: 1rem;
                }

                .avatar-upload {
                    display: inline-block;
                    background-color: var(--primary-color);
                    color: white;
                    padding: 8px 15px;
                    border-radius: 20px;
                    cursor: pointer;
                    font-size: 0.9rem;
                }

                .user-id {
                    background-color: #333;
                    color: #aaa;
                    padding: 5px 10px;
                    border-radius: 5px;
                    font-size: 0.9rem;
                    display: inline-block;
                    margin-top: 5px;
                    margin-bottom: 1rem;
                    /* Thêm margin dưới cho ID */
                }

                .divider {
                    border-top: 1px solid #444;
                    margin: 2rem 0;
                }

                /* Đã xóa style cho .gender-option */

                .email-display {
                    background-color: #333;
                    padding: 10px 15px;
                    border-radius: 5px;
                    margin-bottom: 1.5rem;
                }

                .email-display p {
                    /* Sửa p thành a nếu muốn email là link mailto */
                    color: var(--light-color);
                    text-decoration: none;
                    margin: 0;
                    /* Xóa margin mặc định của p */
                }

                /* Nếu bạn muốn email là link mailto, hãy sử dụng lại .email-display a và thay thẻ p thành a */
                /* .email-display a {
            color: var(--primary-color); 
            text-decoration: none;
        } */


                .update-section {
                    text-align: center;
                    margin-top: 2rem;
                    padding: 2rem;
                    border: 2px dashed #555;
                    border-radius: 10px;
                    cursor: pointer;
                    transition: all 0.3s;
                }

                .update-section:hover {
                    border-color: var(--primary-color);
                    background-color: rgba(229, 9, 20, 0.05);
                }

                .update-icon {
                    font-size: 2rem;
                    color: var(--primary-color);
                    margin-bottom: 1rem;
                }

                /* Style cho Modal */
                .modal-content {
                    background-color: var(--secondary-color);
                    color: var(--light-color);
                    border: none;
                }

                .modal-header,
                .modal-footer {
                    border-color: #444;
                }

                .btn-close {
                    filter: invert(1);
                }
            </style>
        </head>

        <body>
            <%@ include file="../component/common/Header.jsp" %>
                <div style="padding-top: 80px;" class="profile-container">
                    <div class="row">
                        <div class="col-lg-3 mb-4">
                            <div class="profile-sidebar">
                                <h1 class="logo mb-4"
                                    style="color: var(--primary-color); font-weight: bold; font-size: 1.8rem;">RoPhim
                                </h1>
                                <h4 class="mb-3">Cài đặt</h4>
                                <ul class="nav-profile">
                                    <li><a href="${pageContext.request.contextPath}/fav"><i class="bi bi-heart"></i> Yêu
                                            thích </a></li>
                                    <li><a href="${pageContext.request.contextPath}/profile" class="active"><i
                                                class="bi bi-person"></i> Tài khoản</a></li>
                                    <div class="divider"></div>
                                    <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i
                                                class="bi bi-house"></i> Quản trị viên</a></li>
                                    <li><a href="${pageContext.request.contextPath}/auth/logout"><i
                                                class="bi bi-box-arrow-right"></i> Đăng xuất</a></li>
                                </ul>
                            </div>
                        </div>

                        <div class="col-lg-9">
                            <div class="profile-content">
                                <h3 class="section-title">Tài khoản</h3>
                                <p class="text-light mb-4">Cập nhật thông tin tài khoản</p>

                                <form method="POST">

                                    <div class="avatar-container">
                                        <img src="https://cdn-icons-png.flaticon.com/512/9347/9347589.png"
                                            class="avatar" alt="Avatar" id="currentAvatar">
                                        <div class="avatar-upload" id="avatarUploadTrigger">
                                            <i class="bi bi-camera me-1"></i> Đổi ảnh đại diện
                                            <input type="file" id="avatarFileInput" name="avatarFile"
                                                style="display: none;">
                                        </div>
                                        <input type="hidden" name="currentAvatarUrl"
                                            value="https://cdn-icons-png.flaticon.com/512/9347/9347589.png">
                                    </div>

                                    <div class="mb-4">
                                        <label class="form-label">Email</label>
                                        <div class="email-display">
                                            <p id="emailDisplay">loading...</p>
                                            <input type="hidden" name="email" id="emailInput">
                                        </div>
                                    </div>

                                    <div class="mb-4">
                                        <label for="displayName" class="form-label">Tên hiển thị</label>
                                        <div class="user-id">ID:
                                            <span id="userIdSpan">0000</span>
                                            <input type="hidden" name="userId" id="userIdInput" value="0000">
                                        </div>
                                        <input type="text" class="form-control" id="displayName" name="displayName"
                                            value="${bean.displayName}">
                                        <c:if test="${not empty bean.errors.errDisplayName}">
                                            <small class="text-danger">${bean.errors.errDisplayName}</small>
                                        </c:if>
                                    </div>
                                    <div class="mb-4">
                                        <label for="displayName" class="form-label">Họ và tên </label>
                                        <input type="text" class="form-control" id="fullname" name="fullname"
                                            value="${bean.displayName}">
                                        <c:if test="${not empty bean.errors.errDisplayName}">
                                            <small class="text-danger">${bean.errors.errDisplayName}</small>
                                        </c:if>
                                    </div>

                                    <div class="mb-4">
                                        <label for="phone" class="form-label">Số điện thoại</label>
                                        <input type="tel" class="form-control" id="phone" name="phone"
                                            value="${bean.phone}" placeholder="Nhập số điện thoại">
                                        <c:if test="${not empty bean.errors.errPhone}">
                                            <small class="text-danger">${bean.errors.errPhone}</small>
                                        </c:if>
                                    </div>

                                    <%-- Đã xóa khối Giới tính ở đây --%>

                                        <div class="divider"></div>

                                        <div class="update-section" data-bs-toggle="modal"
                                            data-bs-target="#changePasswordModal">
                                            <div class="update-icon">
                                                <i class="bi bi-shield-lock"></i>
                                            </div>
                                            <h5>Đặt mật khẩu</h5>
                                            <p class="text-muted">Nhấn vào đây để thay đổi mật khẩu tài khoản</p>
                                        </div>

                                        <div class="d-flex justify-content-end mt-4">
                                            <button type="reset" class="btn btn-outline-light me-2">Hủy</button>
                                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                                        </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal fade" id="changePasswordModal" tabindex="-1"
                    aria-labelledby="changePasswordModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-sm">
                        <div class="modal-content">
                            <form method="POST" action="${pageContext.request.contextPath}/profile/change-password">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="changePasswordModalLabel">Thay đổi mật khẩu</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="mb-3">
                                        <label for="currentPassword" class="form-label">Mật khẩu hiện tại</label>
                                        <input type="password" class="form-control" id="currentPassword"
                                            name="currentPassword" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="newPassword" class="form-label">Mật khẩu mới</label>
                                        <input type="password" class="form-control" id="newPassword" name="newPassword"
                                            required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="confirmNewPassword" class="form-label">Xác nhận mật khẩu mới</label>
                                        <input type="password" class="form-control" id="confirmNewPassword"
                                            name="confirmNewPassword" required>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-outline-light"
                                        data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit" class="btn btn-primary">Xác nhận</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <script
                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                        const USER_API_URL = "${pageContext.request.contextPath}/api/userinfo";

                    //=================================================================================//

                    document.getElementById('avatarUploadTrigger').addEventListener('click', function () {
                        document.getElementById('avatarFileInput').click();
                    });

                    document.getElementById('avatarFileInput').addEventListener('change', function (event) {
                        const file = event.target.files[0];
                        if (file) {
                            const reader = new FileReader();
                            reader.onload = function (e) {
                                document.getElementById('currentAvatar').src = e.target.result;
                            };
                            reader.readAsDataURL(file);
                        }
                    });

                    async function init() {
                        // Lấy các phần tử cần cập nhật (Đã thay đổi ID/query selector để phù hợp với HTML mới)
                        const emailDisplay = document.getElementById("emailDisplay"); // Thẻ p hiển thị email
                        const emailInput = document.getElementById("emailInput");   // Thẻ input hidden
                        const userIdSpan = document.getElementById("userIdSpan");   // Thẻ span hiển thị ID
                        const userIdInput = document.getElementById("userIdInput"); // Thẻ input hidden ID
                        const displayNameInput = document.getElementById("displayName"); // Input Tên hiển thị
                        const phoneInput = document.getElementById("phone");             // Input Số điện thoại
                        const fullNameInput = document.getElementById("fullname");

                        try {
                            const response = await fetch(USER_API_URL);
                            if (!response.ok) throw new Error("Lỗi kết nối API: " + response.status);

                            const user = await response.json();
                            console.log("Thông tin người dùng:", user);

                            // Cập nhật EMAIL
                            if (user.email) {
                                emailDisplay.textContent = user.email; // Sử dụng textContent để thay đổi nội dung của thẻ <p>
                                emailInput.value = user.email;         // Sử dụng .value để thay đổi giá trị của thẻ <input hidden>
                            }

                            // Cập nhật ID
                            if (user.id) {
                                userIdSpan.textContent = user.id;
                                userIdInput.value = user.id;
                            }

                            // Cập nhật Tên hiển thị
                            if (user.username) {
                                displayNameInput.value = user.username;
                            }


                            // Cập nhật Số điện thoại
                            if (user.phone) {
                                phoneInput.value = user.phone;
                            }
                            if (user.fullname) {
                                fullNameInput.value = user.fullname;
                            }

                            // Cập nhật Ảnh đại diện (nếu API trả về URL ảnh)
                            if (user.avatarUrl) {
                                document.getElementById('currentAvatar').src = user.avatarUrl;
                                document.querySelector('input[name="currentAvatarUrl"]').value = user.avatarUrl;
                            }


                        } catch (error) {
                            console.error("Lỗi khi tải dữ liệu người dùng:", error);
                            emailDisplay.textContent = "Không thể tải email";
                        }
                    }

                    document.addEventListener('DOMContentLoaded', init);
                </script>
        </body>

        </html>