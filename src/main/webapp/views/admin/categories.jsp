<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý danh mục</title>
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
            <h3 class="mb-0">Quản lý danh mục</h3>
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
                    <h6 class="m-0 fw-bold text-primary">Thêm/Cập nhật Danh mục</h6>
                </div>
                <div class="card-body">
                    <form class="row g-3" method="POST" action="${pageContext.request.contextPath}/admin/categories">
                        <div class="col-md-6">
                            <label for="categoryName" class="form-label">Tên danh mục</label>
                            <input type="text"
                                   class="form-control ${not empty bean.errors.errTitle ? 'is-invalid' : ''}"
                                   id="categoryName"
                                   name="categoryname"
                                   value="${bean.categoryname}"
                                   placeholder="Ví dụ: Hành động, Tình cảm..."
                                   >
                            <c:if test="${not empty bean.errors.errTitle}">
                                <div class="invalid-feedback">${bean.errors.errTitle}</div>
                            </c:if>
                        </div>
                        <div class="col-12">
                            <button type="submit" class="btn btn-primary" style="background-color: var(--sidebar-bg); border-color: var(--sidebar-bg);">
                                <i class="fa-solid fa-floppy-disk me-2"></i> Lưu danh mục
                            </button>
                            <button type="reset" class="btn btn-outline-secondary ms-2">
                                <i class="fa-solid fa-xmark me-2"></i> Hủy
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card shadow mb-4">
                 <div class="card-header py-3">
                    <h6 class="m-0 fw-bold text-primary">Danh sách Danh mục</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-striped table-hover" width="100%" cellspacing="0">
                            <thead>
                                <tr class="table-dark">
                                    <th style="width: 10%;">ID</th>
                                    <th>Tên danh mục</th>
                                    <th style="width: 15%;">Số lượng video</th>
                                    <th style="width: 15%;">Trạng thái</th>
                                    <th style="width: 15%;">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>1</td>
                                    <td>Hành động</td>
                                    <td><span class="badge bg-primary">50</span></td>
                                    <td><span class="badge bg-success">Active</span></td>
                                    <td>
                                        <button class="btn btn-sm btn-warning me-1" title="Sửa"><i class="fa-solid fa-pen-to-square"></i></button>
                                        <button class="btn btn-sm btn-danger" title="Tắt kích hoạt (Disabled)"><i class="fa-solid fa-toggle-on"></i></button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>2</td>
                                    <td>Khoa học viễn tưởng</td>
                                    <td><span class="badge bg-secondary">35</span></td>
                                    <td><span class="badge bg-secondary">Inactive</span></td>
                                    <td>
                                        <button class="btn btn-sm btn-warning me-1" title="Sửa"><i class="fa-solid fa-pen-to-square"></i></button>
                                        <button class="btn btn-sm btn-success" title="Bật kích hoạt (Active)"><i class="fa-solid fa-toggle-off"></i></button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>3</td>
                                    <td>Tình cảm</td>
                                    <td><span class="badge bg-primary">80</span></td>
                                    <td><span class="badge bg-success">Active</span></td>
                                    <td>
                                        <button class="btn btn-sm btn-warning me-1" title="Sửa"><i class="fa-solid fa-pen-to-square"></i></button>
                                        <button class="btn btn-sm btn-danger" title="Tắt kích hoạt (Disabled)"><i class="fa-solid fa-toggle-on"></i></button>
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