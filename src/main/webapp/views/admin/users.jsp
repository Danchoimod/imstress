<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý người dùng</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" crossorigin="anonymous" />
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
    <%@ include file="/views/component/admin/sidebar.jsp" %>

    <div class="main-content">
        <div class="main-header">
            <h3 class="mb-0">Quản lý người dùng</h3>
        </div>

        <div class="container-fluid">

            <div class="card shadow mb-4">
                 <div class="card-header py-3">
                    <h6 class="m-0 fw-bold text-primary">Danh sách Người dùng</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-striped table-hover" width="100%" cellspacing="0">
                            <thead>
                                <tr class="table-dark">
                                    <th>ID</th>
                                    <th>Tên</th>
                                    <th>Email</th>
                                    <th>Vai trò</th>
                                    <th>Trạng thái</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>1</td>
                                    <td>Nguyễn Văn A</td>
                                    <td>a@email.com</td>
                                    <td>
                                        <span class="badge bg-danger">Admin</span>
                                        <button class="btn btn-sm btn-outline-danger ms-2" title="Chuyển thành User">
                                            <i class="fa-solid fa-arrow-down-long"></i> User
                                        </button>
                                    </td>
                                    <td><span class="badge bg-success">Active</span></td>
                                    <td>
                                        <button class="btn btn-sm btn-danger" title="Tắt kích hoạt"><i class="fa-solid fa-user-lock"></i></button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>2</td>
                                    <td>Trần Thị B</td>
                                    <td>b@email.com</td>
                                    <td>
                                        <span class="badge bg-secondary">User</span>
                                        <button class="btn btn-sm btn-outline-success ms-2" title="Chuyển thành Admin">
                                            <i class="fa-solid fa-arrow-up-long"></i> Admin
                                        </button>
                                    </td>
                                    <td><span class="badge bg-secondary">Inactive</span></td>
                                    <td>
                                        <button class="btn btn-sm btn-success" title="Kích hoạt"><i class="fa-solid fa-user-check"></i></button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
</body>
</html>