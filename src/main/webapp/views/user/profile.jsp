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

                .email-display {
                    background-color: #333;
                    padding: 10px 15px;
                    border-radius: 5px;
                    margin-bottom: 1.5rem;
                }

                .email-display p {
                    color: var(--light-color);
                    text-decoration: none;
                    margin: 0;
                    /* Xóa margin mặc định của p */
                }

                /* Xóa style cho Modal vì đã xóa Modal */
            </style>
        </head>

        <body>
            <%@ include file="../component/common/Header.jsp" %>
                <div style="padding-top: 80px;"
                    class="profile-container">
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

                                <form id="profileForm">
                                    <%-- XÓA: UI ĐỔI AVATAR --%>

                                    <div class="mb-4">
                                        <label class="form-label">Email</label>
                                        <div class="email-display">
                                            <p id="emailDisplay">loading...</p>
                                            </div>
                                    </div>

                                    <div class="mb-4">
                                        <label for="displayName" class="form-label">Tên hiển thị (Username)</label>
                                        <div class="user-id">ID:
                                            <span id="userIdSpan">0000</span>
                                            <input type="hidden" name="userId" id="userIdInput" value="0000">
                                        </div>
                                        <input type="text" class="form-control" id="displayName" name="displayName"
                                            value="" readonly title="Tên hiển thị (Username) không thể thay đổi">
                                        <small class="text-muted">Username được dùng cho bình luận và đăng nhập, không thể thay đổi.</small>
                                    </div>
                                    <div class="mb-4">
                                        <label for="fullname" class="form-label">Họ và tên </label>
                                        <input type="text" class="form-control" id="fullname" name="fullname"
                                            value="">
                                    </div>

                                    <div class="mb-4">
                                        <label for="phone" class="form-label">Số điện thoại</label>
                                        <input type="tel" class="form-control" id="phone" name="phone"
                                            value="" placeholder="Nhập số điện thoại">
                                    </div>

                                    <div class="divider"></div>

                                    <%-- XÓA: UI ĐỔI MẬT KHẨU --%>

                                    <div class="d-flex justify-content-end mt-4">
                                        <button type="reset" class="btn btn-outline-light me-2">Hủy</button>
                                        <button type="submit" class="btn btn-primary" id="saveProfileBtn">Lưu thay đổi</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- XÓA: MODAL ĐỔI MẬT KHẨU --%>

                <script
                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    const USER_API_URL = "${pageContext.request.contextPath}/api/userinfo";
                    const PROFILE_UPDATE_API_URL = "${pageContext.request.contextPath}/api/profile/update";

                    // XÓA: Logic liên quan đến đổi avatar (avatarUploadTrigger, avatarFileInput, v.v.)

                    // Hàm tải thông tin người dùng hiện tại
                    async function init() {
                        const emailDisplay = document.getElementById("emailDisplay");
                        const userIdSpan = document.getElementById("userIdSpan");
                        const userIdInput = document.getElementById("userIdInput");
                        const displayNameInput = document.getElementById("displayName");
                        const phoneInput = document.getElementById("phone");
                        const fullNameInput = document.getElementById("fullname");
                        // const currentAvatar = document.getElementById('currentAvatar'); // XÓA: Không cần avatar nữa

                        try {
                            const response = await fetch(USER_API_URL);
                            if (!response.ok) throw new Error("Lỗi kết nối API: " + response.status);

                            const user = await response.json();
                            console.log("Thông tin người dùng:", user);

                            // Cập nhật EMAIL (chỉ hiển thị)
                            if (user.email) {
                                emailDisplay.textContent = user.email;
                            }

                            // Cập nhật ID (hidden)
                            if (user.id) {
                                userIdSpan.textContent = user.id;
                                userIdInput.value = user.id;
                            }

                            // Cập nhật Tên hiển thị (Username - chỉ đọc)
                            if (user.username) {
                                displayNameInput.value = user.username;
                            }

                            // Cập nhật Họ và tên (Name)
                            if (user.name) {
                                fullNameInput.value = user.name;
                            } else if (user.fullname) {
                                // Nếu API trả về fullname (trường hợp cũ), sử dụng nó
                                fullNameInput.value = user.fullname;
                            }

                            // Cập nhật Số điện thoại
                            if (user.phone) {
                                phoneInput.value = user.phone;
                            }

                            // XÓA: Logic cập nhật Ảnh đại diện
                            /*
                            if (user.avatarUrl) {
                                currentAvatar.src = user.avatarUrl;
                                document.querySelector('input[name="currentAvatarUrl"]').value = user.avatarUrl;
                            }
                            */


                        } catch (error) {
                            console.error("Lỗi khi tải dữ liệu người dùng:", error);
                            emailDisplay.textContent = "Không thể tải email";
                        }
                    }

                    // HÀM XỬ LÝ SỰ KIỆN CẬP NHẬT PROFILE
                    async function handleProfileUpdate(event) {
                        event.preventDefault(); // Ngăn chặn form submit mặc định

                        const saveButton = document.getElementById('saveProfileBtn');
                        saveButton.disabled = true;

                        // Lấy dữ liệu từ form
                        const updatedData = {
                            id: parseInt(document.getElementById('userIdInput').value),
                            name: document.getElementById('fullname').value, // Họ và tên (mapped to User.name in Service)
                            // Lấy Email từ thẻ p hiển thị (giả định là giá trị đúng, không cho sửa)
                            email: document.getElementById('emailDisplay').textContent,
                            phone: document.getElementById('phone').value,
                            // Username không được gửi vì nó là chỉ đọc
                        };

                        // Kiểm tra dữ liệu cần thiết
                        if (!updatedData.id || !updatedData.name || !updatedData.email) {
                            alert("Lỗi: Thiếu ID, Họ tên hoặc Email.");
                            saveButton.disabled = false;
                            return;
                        }

                        try {
                            const response = await fetch(PROFILE_UPDATE_API_URL, {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json'
                                },
                                body: JSON.stringify(updatedData)
                            });

                            const result = await response.json();

                            if (response.ok) {
                                alert(result.message || "Cập nhật profile thành công!");
                                await init(); // Tải lại dữ liệu để hiển thị thông tin mới nhất
                            } else {
                                alert(result.error || "Cập nhật profile thất bại. Vui lòng kiểm tra lại dữ liệu.");
                            }

                        } catch (error) {
                            console.error("Lỗi gửi yêu cầu cập nhật:", error);
                            alert("Lỗi kết nối server. Vui lòng thử lại.");
                        } finally {
                            saveButton.disabled = false;
                        }
                    }

                    document.addEventListener('DOMContentLoaded', init);
                    document.getElementById('profileForm').addEventListener('submit', handleProfileUpdate);

                </script>
        </body>

        </html>