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
                    <form id="categoryForm" class="row g-3">
                        <input type="hidden" id="categoryId" name="id" value="">
                        <div class="col-md-6">
                            <label for="categoryName" class="form-label">Tên danh mục</label>
                            <input type="text"
                                   class="form-control"
                                   id="categoryName"
                                   name="categoryname"
                                   placeholder="Ví dụ: Hành động, Tình cảm..."
                                   required>
                            <div class="invalid-feedback" id="categoryNameError"></div>
                        </div>
                        <div class="col-12">
                            <button type="submit" class="btn btn-primary" style="background-color: var(--sidebar-bg); border-color: var(--sidebar-bg);">
                                <i class="fa-solid fa-floppy-disk me-2"></i> <span id="formButtonText">Lưu danh mục</span>
                            </button>
                            <button type="button" class="btn btn-outline-secondary ms-2" onclick="resetForm()">
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
                            <tbody id="categoryTableBody">
                                <!-- Dữ liệu sẽ được load động qua AJAX -->
                                <tr>
                                    <td colspan="5" class="text-center">
                                        <div class="spinner-border text-primary" role="status">
                                            <span class="visually-hidden">Đang tải...</span>
                                        </div>
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
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script>
    // ==================== GLOBAL VARIABLES ====================
    const API_URL = '${pageContext.request.contextPath}/api/admin/categories';
    let categories = []; // Lưu trữ danh sách categories

    // ==================== DOM READY - LOAD DATA ====================
    document.addEventListener('DOMContentLoaded', function() {
        loadCategories();
        setupFormSubmit();
    });

    // ==================== LOAD CATEGORIES FROM API ====================
    async function loadCategories() {
        try {
            const response = await axios.get(API_URL);
            categories = response.data;
            renderCategoriesTable();
        } catch (error) {
            console.error('Error loading categories:', error);
            showErrorInTable('Không thể tải danh sách danh mục. Vui lòng thử lại sau.');
        }
    }

    // ==================== RENDER TABLE (Optimized String Concatenation) ====================
    function renderCategoriesTable() {
        const tbody = document.getElementById('categoryTableBody');

        if (!categories || categories.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" class="text-center text-muted">Chưa có danh mục nào</td></tr>';
            return;
        }

        // Sử dụng Array.map() và Array.join() để tạo chuỗi HTML, hiệu quả hơn nối chuỗi đơn lẻ
        tbody.innerHTML = categories.map(function(cat) {
            const isActive = cat.status === 1;
            const statusBadge = isActive
                ? '<span class="badge bg-success">Active</span>'
                : '<span class="badge bg-secondary">Inactive</span>';

            // Lỗi: `$` trước cat.id trong onclick. Cần sửa thành dấu nháy đơn `'` hoặc bỏ qua (nếu biến đã có sẵn).
            // Sửa: loại bỏ ký tự `$` dư thừa.
            const toggleButton = isActive
                ? '<button class="btn btn-sm btn-danger" onclick="toggleStatus(' + cat.id + ', 0)" title="Ẩn danh mục">' +
                    '<i class="fa-solid fa-toggle-on"></i>' +
                  '</button>'
                : '<button class="btn btn-sm btn-success" onclick="toggleStatus(' + cat.id + ', 1)" title="Hiển thị danh mục">' +
                    '<i class="fa-solid fa-toggle-off"></i>' +
                  '</button>';

            return '<tr>' +
                '<td>' + cat.id + '</td>' +
                '<td>' + escapeHtml(cat.name) + '</td>' +
                '<td><span class="badge bg-primary">' + (cat.videoCount || 0) + '</span></td>' +
                '<td>' + statusBadge + '</td>' +
                '<td>' +
                    '<button class="btn btn-sm btn-warning me-1" onclick="editCategory(' + cat.id + ')" title="Sửa">' +
                        '<i class="fa-solid fa-pen-to-square"></i>' +
                    '</button>' +
                    toggleButton +
                '</td>' +
            '</tr>';
        }).join('');
    }

    // ==================== SHOW ERROR IN TABLE ====================
    function showErrorInTable(message) {
        const tbody = document.getElementById('categoryTableBody');
        tbody.innerHTML = '<tr><td colspan="5" class="text-center text-danger">' + message + '</td></tr>';
    }

   // ==================== SETUP FORM SUBMIT ====================
   function setupFormSubmit() {
       const form = document.getElementById('categoryForm');
       form.addEventListener('submit', async function(e) {
           e.preventDefault();

           const categoryId = document.getElementById('categoryId').value;
           const categoryName = document.getElementById('categoryName').value.trim();

           if (!categoryName) {
               showValidationError('categoryName', 'Tên danh mục không được để trống');
               return;
           }

           clearValidationError('categoryName');

           try {
               // SỬA LỖI: Chuyển sang dùng URLSearchParams để đảm bảo Content-Type là application/x-www-form-urlencoded
               const params = new URLSearchParams();
               params.append('categoryname', categoryName);
               params.append('id', categoryId); // Luôn gửi ID, nếu rỗng thì là ADD

               const action = categoryId ? 'update' : 'add';
               params.append('action', action);

               // Gửi dữ liệu dưới dạng URL-encoded string và đặt header thủ công
               const response = await axios.post(
                   API_URL,
                   params.toString(), // Chuyển URLSearchParams thành chuỗi POST data
                   {
                       headers: {
                           'Content-Type': 'application/x-www-form-urlencoded'
                       }
                   }
               );

               if (response.data.status === 'success') {
                   showAlert('success', response.data.message);
                   resetForm();
                   loadCategories(); // Reload data
               } else {
                   // Xử lý lỗi trả về từ server (ví dụ: Tên đã tồn tại)
                   showAlert('danger', response.data.message);
               }
           } catch (error) {
               console.error('Error submitting form:', error);
               // Cải thiện hiển thị lỗi từ response nếu có
               const errorMessage = error.response && error.response.data && error.response.data.message
                   ? error.response.data.message
                   : 'Có lỗi xảy ra khi xử lý yêu cầu';
               showAlert('danger', errorMessage);
           }
       });
   }

    // ==================== EDIT CATEGORY ====================
    function editCategory(id) {
        const category = categories.find(function(cat) { return cat.id === id; });
        if (!category) return;

        document.getElementById('categoryId').value = category.id;
        document.getElementById('categoryName').value = category.name;
        document.getElementById('formButtonText').textContent = 'Cập nhật danh mục';

        // Scroll to form
        document.getElementById('categoryForm').scrollIntoView({ behavior: 'smooth' });
    }

// ==================== TOGGLE STATUS ====================
async function toggleStatus(id, newStatus) {
    const confirmation = newStatus === 0 ? 'Bạn có chắc muốn ẩn danh mục này?' : 'Bạn có chắc muốn hiển thị danh mục này?';
    if (!confirm(confirmation)) {
        return;
    }

    try {
        // SỬA LỖI: Dùng URLSearchParams
        const params = new URLSearchParams();
        params.append('action', 'status');
        params.append('id', id);
        params.append('value', newStatus);

        const response = await axios.post(
            API_URL,
            params.toString(), // Chuyển URLSearchParams thành chuỗi POST data
            {
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            }
        );

        if (response.data.status === 'success') {
            showAlert('success', response.data.message);
            loadCategories(); // Reload data
        } else {
            showAlert('danger', response.data.message);
        }
    } catch (error) {
        console.error('Error toggling status:', error);
        showAlert('danger', 'Có lỗi xảy ra khi cập nhật trạng thái');
    }
}

    // ==================== RESET FORM ====================
    function resetForm() {
        document.getElementById('categoryForm').reset();
        document.getElementById('categoryId').value = '';
        document.getElementById('formButtonText').textContent = 'Lưu danh mục';
        clearValidationError('categoryName');
    }

    // ==================== VALIDATION HELPERS ====================
    function showValidationError(fieldId, message) {
        const field = document.getElementById(fieldId);
        const errorDiv = document.getElementById(fieldId + 'Error');
        field.classList.add('is-invalid');
        if (errorDiv) errorDiv.textContent = message;
    }

    function clearValidationError(fieldId) {
        const field = document.getElementById(fieldId);
        const errorDiv = document.getElementById(fieldId + 'Error');
        field.classList.remove('is-invalid');
        if (errorDiv) errorDiv.textContent = '';
    }

    // ==================== ALERT HELPER (Gọn hơn, không dùng backtick) ====================
    function showAlert(type, message) {
        const alertDiv = document.createElement('div');
        // Sửa lỗi cú pháp: $ trước type/message
        alertDiv.className = 'alert alert-' + type + ' alert-dismissible fade show';
        alertDiv.role = 'alert';
        alertDiv.innerHTML = message +
            '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';

        const container = document.querySelector('.container-fluid');
        container.insertBefore(alertDiv, container.firstChild);

        // Auto dismiss after 5 seconds
        setTimeout(function() {
            alertDiv.remove();
        }, 5000);
    }

    // ==================== HTML ESCAPE ====================
    function escapeHtml(text) {
        const map = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        };
        // Sửa lỗi cú pháp: sử dụng `function` thay vì arrow function
        return text.replace(/[&<>"']/g, function(m) { return map[m]; });
    }
</script>
</body>
</html>