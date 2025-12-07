<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý bình luận</title>
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
            <h3 class="mb-0">Quản lý bình luận</h3>
        </div>

        <div class="container-fluid">

            <div class="card shadow mb-4">
                 <div class="card-header py-3">
                    <h6 class="m-0 fw-bold text-primary">Danh sách Bình luận</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-striped table-hover" width="100%" cellspacing="0">
                            <thead>
                                <tr class="table-dark">
                                    <th>ID</th>
                                    <th>Nội dung</th>
                                    <th>Người dùng</th>
                                    <th>Video</th>
                                    <th>Ngày tạo</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>1</td>
                                    <td style="max-width: 300px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                        Bình luận mẫu về video này. Thật tuyệt vời!
                                    </td>
                                    <td><span class="badge bg-secondary">Nguyễn Văn A</span></td>
                                    <td><a href="#" class="text-primary">Video 1</a></td>
                                    <td>2025-11-23</td>
                                    <td>
                                        <button class="btn btn-sm btn-success" title="Ẩn/Bỏ kiểm duyệt"><i class="fa-solid fa-eye"></i></button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>2</td>
                                    <td style="max-width: 300px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                        Tôi không thích nội dung này, cần cải thiện hơn nữa.
                                    </td>
                                    <td><span class="badge bg-secondary">Trần Thị B</span></td>
                                    <td><a href="#" class="text-primary">Video XYZ</a></td>
                                    <td>2025-11-23</td>
                                    <td>
                                        <button class="btn btn-sm btn-secondary" title="Hiện/Kiểm duyệt"><i class="fa-solid fa-eye-slash"></i></button>
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