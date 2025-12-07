<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Đăng nhập tài khoản</title>
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
/* Style mới cho nút Quay lại */
.btn-back {
    background: transparent;
    color: #b0b8d1;
    font-weight: 600;
    border: 1px solid #2c3557; /* Thêm viền để dễ nhìn */
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
                <h4 class="mb-2">Đăng nhập</h4>
                <div class="mb-3" style="font-size: 0.95rem; color: #b0b8d1;">
                    Nếu bạn chưa có tài khoản, <a href="${pageContext.request.contextPath}/auth/register" class="text-link">đăng ký</a>
                </div>
                <form method="POST" action="${pageContext.request.contextPath}/auth/login">
                    <div class="mb-3">
                        <label class="form-label">Tên tài khoản hoặc Email</label>
                        <input value="${bean.usernameOrEmail}" name="usernameOrEmail" type="text" class="form-control" placeholder="Tên tài khoản hoặc Email">
                        <small class="text-danger">${bean.errors.errUsernameOrEmail}</small>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mật khẩu</label>
                        <input value="${bean.password}" name="password" type="password" class="form-control" placeholder="Mật khẩu">
                        <small class="text-danger">${bean.errors.errPassword}</small>
                    </div>
                    <button type="submit" class="btn btn-custom w-100 mt-2">Đăng nhập</button>
                </form>

                <a href="${pageContext.request.contextPath}/index" class="btn-back w-100 mt-3">Quay lại</a>
                </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
</body>
</html>