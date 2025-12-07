<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Panel - RoPhim</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" crossorigin="anonymous" />
<style>
/* -------------------- ADMIN LAYOUT & CORE STYLES -------------------- */
:root {
    --sidebar-width: 240px;
    --sidebar-bg: #2a3f54; /* Màu nền sidebar tối xanh đậm */
    --link-color: #ecf0f1;
    --hover-bg: #34495e;
    --active-color: #ffe082; /* Màu vàng RoPhim */
    --danger-color: #e74c3c; /* Màu đỏ cho Đăng xuất */
}

body {
    background: #f4f6f9; /* Nền sáng cho khu vực nội dung chính */
    margin: 0;
    padding: 0;
    /* Đẩy nội dung chính sang phải để tránh bị sidebar che */
    padding-left: var(--sidebar-width);
}

/* -------------------- SIDEBAR STYLES (Nâng cấp) -------------------- */
.admin-sidebar {
    width: var(--sidebar-width);
    min-height: 100vh;
    background: var(--sidebar-bg);
    color: var(--link-color);
    position: fixed;
    top: 0;
    left: 0;
    z-index: 1000;
    box-shadow: 2px 0 5px rgba(0, 0, 0, 0.2);
    /* Thiết lập Flexbox để đẩy nút Đăng xuất xuống cuối */
    display: flex;
    flex-direction: column;
}

.admin-sidebar h2 {
    padding: 20px;
    margin: 0;
    font-size: 1.5rem;
    font-weight: 700;
    text-align: center;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    color: var(--active-color);
}

/* Danh sách menu chính */
.admin-sidebar ul.menu-list {
    list-style: none;
    padding: 10px 0;
    margin: 0;
    flex-grow: 1; /* Cho phép danh sách menu chính chiếm hết không gian còn lại */
}

/* Liên kết menu */
.admin-sidebar a {
    color: var(--link-color);
    text-decoration: none;
    display: flex;
    align-items: center;
    padding: 12px 20px;
    font-size: 1rem;
    transition: background 0.3s, color 0.3s;
    border-left: 5px solid transparent;
}

/* Hiệu ứng di chuột (hover) */
.admin-sidebar a:hover {
    background: var(--hover-bg);
    color: #fff;
    border-left-color: var(--active-color);
}

/* Mục menu đang hoạt động (Active state) */
.admin-sidebar li.active a {
    background: var(--hover-bg);
    color: var(--active-color);
    border-left-color: var(--active-color);
    font-weight: 600;
}

.admin-sidebar .fa-solid {
    width: 25px; /* Giữ icon có chiều rộng cố định */
}

/* -------------------- LOGOUT STYLES -------------------- */
.logout-item {
    margin-top: auto; /* Đẩy mục này xuống dưới cùng */
    border-top: 1px solid rgba(255, 255, 255, 0.1);
    padding: 10px 0;
}

.logout-item a {
    color: var(--danger-color); /* Màu đỏ */
    border-left-color: transparent !important; /* Đảm bảo không có thanh vàng */
}

.logout-item a:hover {
    background: var(--danger-color); /* Đổi màu nền khi hover */
    color: #fff;
}
/* -------------------- END LOGOUT STYLES -------------------- */


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
</style>
</head>
<body>

<div class="admin-sidebar">
    <a href="${pageContext.request.contextPath}/index"><i  class="fa-solid fa-film me-2"></i><h2> RoPhim Admin</h2></a>

    <ul class="menu-list">
        <li class="">
            <a href="<%= request.getContextPath() %>/admin/dashboard">
                <i class="fa-solid fa-house-chimney"></i> Dashboard
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/admin/users">
                <i class="fa-solid fa-users"></i> Quản lý người dùng
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/admin/comments">
                <i class="fa-solid fa-comments"></i> Quản lý bình luận
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/admin/videos">
                <i class="fa-solid fa-video"></i> Quản lý video
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/admin/categories">
                <i class="fa-solid fa-tags"></i> Quản lý danh mục
            </a>
        </li>
    </ul>

    <ul class="list-unstyled p-0 m-0 logout-item">
        <li>
            <a href="<%= request.getContextPath() %>/index">
                <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
            </a>
        </li>
    </ul>
    </div>



</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
</body>
</html>