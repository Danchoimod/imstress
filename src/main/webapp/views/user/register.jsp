<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Đăng ký tài khoản</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
<style>
/* ... (CSS giữ nguyên) ... */
body {
    background: #181f36;
    min-height: 100vh;
}
.bg-overlay {
    background: rgba(24, 31, 54, 0.95);
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
}
.card-custom {
    background: #232b4a;
    border-radius: 24px;
    box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
    color: #fff;
    padding: 40px 32px 32px 32px;
    min-width: 380px;
    max-width: 400px;
}
.btn-custom {
    background: #ffe082;
    color: #232b4a;
    font-weight: 600;
    border: none;
    border-radius: 8px;
    transition: background 0.2s;
}
.btn-custom:hover {
    background: #ffd54f;
}
/* Thêm style cho nút Quay lại */
.btn-back {
    background: transparent;
    color: #b0b8d1;
    font-weight: 600;
    border: 1px solid #2c3557;
    border-radius: 8px;
    transition: all 0.2s;
    text-align: center; /* Đảm bảo chữ căn giữa */
    padding: 10px 12px; /* Đồng bộ padding */
    display: block; /* Đảm bảo nó chiếm toàn bộ chiều rộng */
    text-decoration: none; /* Bỏ gạch chân mặc định của thẻ a */
}
.btn-back:hover {
    background: #2c3557;
    color: #fff;
    border-color: #ffe082;
}
/* Kết thúc style mới */

.logo {
    display: flex;
    align-items: center;
    margin-bottom: 32px;
}
.logo-icon {
    width: 48px;
    height: 48px;
    margin-right: 12px;
}
.logo-text {
    font-size: 1.5rem;
    font-weight: bold;
    color: #ffe082;
}
.logo-desc {
    font-size: 1rem;
    color: #b0b8d1;
}
.form-label {
    color: #b0b8d1;
}
.form-control {
    background: #1a2036;
    color: #fff;
    border: 1px solid #2c3557;
    border-radius: 8px;
}
.form-control:focus {
    background: #232b4a;
    color: #fff;
    border-color: #ffe082;
    box-shadow: none;
}
.text-link {
    color: #ffe082;
    text-decoration: none;
}
.text-link:hover {
    text-decoration: underline;
}
</style>
</head>
<body>
    <div class="bg-overlay">
        <div>
            <div class="logo">
                <svg class="logo-icon" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <circle cx="24" cy="24" r="24" fill="#ffe082"/>
                    <polygon points="18,14 36,24 18,34" fill="#232b4a"/>
                </svg>
                <div>
                    <div class="logo-text">RoPhim</div>
                    <div class="logo-desc">Phim hay cả rổ</div>
                </div>
            </div>
            <div class="card card-custom">
                <h4 class="mb-2">Đăng ký tài khoản</h4>
                <div class="mb-3" style="font-size: 0.95rem; color: #b0b8d1;">
                    Nếu bạn đã có tài khoản, <a href="${pageContext.request.contextPath}/auth/login" class="text-link">đăng nhập</a>
                </div>

                <!-- Hiển thị thông báo lỗi chung -->
                <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert" style="background-color: #ff4444; border: none; color: #fff; border-radius: 8px;">
                        <i class="bi bi-exclamation-circle-fill me-2"></i>
                        <%= request.getAttribute("errorMessage") %>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% } %>

                <!-- Hiển thị thông báo thành công -->
                <% if (request.getAttribute("successMessage") != null) { %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert" style="background-color: #00C851; border: none; color: #fff; border-radius: 8px;">
                        <i class="bi bi-check-circle-fill me-2"></i>
                        <%= request.getAttribute("successMessage") %>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% } %>

                <form method="POST" action="${pageContext.request.contextPath}/auth/register">
                 <div class="mb-3">
                     <label class="form-label">Tên Hiển thị </label>
                     <input value="${bean.username}" name="username" type="text" class="form-control" placeholder="Tên đăng nhập">
                     <small class="text-danger">${bean.errors.errUsername}</small>
                 </div>

                 <div class="mb-3">
                     <label class="form-label">Họ và tên</label>
                     <input value="${bean.name}" name="name" type="text" class="form-control" placeholder="Họ và tên của bạn">
                     <small class="text-danger">${bean.errors.errName}</small>
                 </div>

                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input value="${bean.email}" name="email" type="email" class="form-control" placeholder="Email">
                        <small class="text-danger">${bean.errors.errEmail}</small>
                        <small class="text-danger">${errDB.errEmail}</small>
                    </div>

                    <div class="mb-3">
                     <label class="form-label">Số điện thoại</label>
                     <input value="${bean.phone}" name="phone" type="tel" class="form-control" placeholder="Số điện thoại (0xxxxxxxxx)">
                     <small class="text-danger">${bean.errors.errPhone}</small>
                 </div>

                    <div class="mb-3">
                        <label class="form-label">Mật khẩu</label>
                        <input value="${bean.password}" name="password" type="password" class="form-control" placeholder="Mật khẩu">
                        <small class="text-danger">${bean.errors.errPassword}</small>
                    </div>

                 <div class="mb-3">
                        <label class="form-label">Nhập lại Mật khẩu</label>
                        <input value="${bean.confirmPassword}" name="confirmPassword" type="password" class="form-control" placeholder="Nhập lại Mật khẩu">
                        <small class="text-danger">${bean.errors.errConfirmPassword}</small>
                    </div>

                    <button type="submit" class="btn btn-custom w-100 mt-2">Đăng ký</button>
                </form>

                <a href="${pageContext.request.contextPath}/auth/login" class="btn-back w-100 mt-3">Quay lại</a>
                </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
</body>
</html>