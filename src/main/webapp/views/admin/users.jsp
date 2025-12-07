<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý người dùng</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" crossorigin="anonymous" />
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
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
    <%-- Lưu ý: Kiểm tra lại đường dẫn include file sidebar --%>
    <%@ include file="/views/component/admin/sidebar.jsp" %>

    <div class="main-content">
        <div class="main-header">
            <h3 class="mb-0">Quản lý người dùng</h3>
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

            <%-- ĐÃ XÓA: Khối Thêm/Cập nhật Video --%>

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
                            <%-- THAY ĐỔI ID: bodyTableVideo -> userTableBody --%>
                            <tbody id="userTableBody" data-context-path="${pageContext.request.contextPath}">
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
    document.addEventListener('DOMContentLoaded', function() {
        fetchUsers();
    });

    const bodyTable = document.getElementById("userTableBody");
    const CONTEXT_PATH = bodyTable.getAttribute("data-context-path");

    // THAY ĐỔI URL API: /api/videos -> /api/admin/users
    const API_URL_GET = CONTEXT_PATH + "/api/admin/users";
    const API_URL_UPDATE = CONTEXT_PATH + "/api/admin/users"; // Giả định POST/UPDATE cùng endpoint

    // --- LOGIC HIỂN THỊ TRẠNG THÁI VÀ VAI TRÒ ---
    function getRoleDisplay(role) {
        if (role === 3) return "<span class='badge bg-danger'>Admin</span>";
        if (role === 2) return "<span class='badge bg-primary'>Editer</span>";
        if (role === 1) return "<span class='badge bg-secondary'>User</span>";
        if (role === 0) return "<span class='badge bg-info'>Guest</span>"; // Xử lý role 0
        return "<span class='badge bg-warning'>Unknown</span>";
    }

    function getStatusDisplay(status) {
        if (status === 1) return "<span class='badge bg-success'>Active</span>";
        return "<span class='badge bg-secondary'>Locked</span>"; // status 0
    }

    // Tạo nút chuyển đổi Role (Admin <-> User)
    function generateRoleButton(user) {
        const currentRole = user.role;
        const userId = user.id;

        if (currentRole === 3) {
            // Đang là Admin -> Đề nghị chuyển về User (Role 1)
            return "<button class='btn btn-sm btn-outline-danger ms-2' onclick='updateUser(" + userId + ", \"role\", 1, \"chuyển thành User\")' title='Chuyển thành User'>" +
                        "<i class='fa-solid fa-arrow-down-long'></i> User" +
                    "</button>";
        } else {
            // Đang là User/Editer/Guest -> Đề nghị chuyển thành Admin (Role 3)
            return "<button class='btn btn-sm btn-outline-success ms-2' onclick='updateUser(" + userId + ", \"role\", 3, \"chuyển thành Admin\")' title='Chuyển thành Admin'>" +
                        "<i class='fa-solid fa-arrow-up-long'></i> Admin" +
                    "</button>";
        }
    }

    // Tạo nút chuyển đổi Status (Active <-> Locked)
    function generateStatusButton(user) {
        const currentStatus = user.status;
        const userId = user.id;

        if (currentStatus === 1) { // Current: Active -> Offer Lock (Status 0)
            return "<button class='btn btn-sm btn-danger' onclick='updateUser(" + userId + ", \"status\", 0, \"Ngừng hoạt động\")' title='Tắt kích hoạt'>" +
                        "<i class='fa-solid fa-user-lock'></i>" +
                    "</button>";
        } else { // Current: Locked (Status 0) -> Offer Activate (Status 1)
            return "<button class='btn btn-sm btn-success' onclick='updateUser(" + userId + ", \"status\", 1, \"Kích hoạt\")' title='Kích hoạt'>" +
                        "<i class='fa-solid fa-user-check'></i>" +
                    "</button>";
        }
    }

    // --- HÀM FETCH DỮ LIỆU ---
    function fetchUsers() {
        bodyTable.innerHTML = "<tr><td colspan='6' class='text-center'><i class='fa-solid fa-spinner fa-spin me-2'></i>Đang tải dữ liệu...</td></tr>";

        axios.get(API_URL_GET)
        .then((res) => {
            console.log("Users fetched:", res.data);
            const users = res.data;

            if (!Array.isArray(users) || users.length === 0) {
                bodyTable.innerHTML = "<tr><td colspan='6' class='text-center text-muted'>Chưa có người dùng nào.</td></tr>";
                return;
            }

            const rows = users.map((user) => {
                // SỬ DỤNG NỐI CHUỖI THUẦN
                return "<tr>" +
                    "<td>" + user.id + "</td>" +
                    "<td>" + (user.fullname || user.username) + "</td>" +
                    "<td>" + user.email + "</td>" +
                    "<td>" +
                        getRoleDisplay(user.role) +
                        generateRoleButton(user) +
                    "</td>" +
                    "<td>" + getStatusDisplay(user.status) + "</td>" +
                    "<td>" +
                        generateStatusButton(user) +
                    "</td>" +
                "</tr>";
            }).join("");

            bodyTable.innerHTML = rows;
        })
        .catch((error) => {
            console.error("Lỗi khi tải danh sách người dùng:", error);
            // THAY ĐỔI: Cập nhật colspan thành 6 (số cột người dùng)
            bodyTable.innerHTML = "<tr><td colspan='6' class='text-center text-danger'>Không thể tải danh sách người dùng. Vui lòng kiểm tra API.</td></tr>";
        });
    }

    async function updateUser(userId, action, value, actionName) {
        // SỬ DỤNG NỐI CHUỖI THUẦN
        if (confirm("Bạn có chắc chắn muốn " + actionName + " người dùng ID: " + userId + " không?")) {
            const params = new URLSearchParams();
            params.append("userId", userId);
            params.append("action", action); // 'role' hoặc 'status'
            params.append("value", value); // Role (1/2/3) hoặc Status (0/1)

            try {
                const response = await axios.post(
                    API_URL_UPDATE,
                    params.toString(),
                    {
                        headers: {
                            "Content-Type": "application/x-www-form-urlencoded"
                        }
                    }
                );

                const res = response.data;

                if (res.status === 'success') {
                    alert(res.message);
                    fetchUsers(); // Tải lại dữ liệu sau khi cập nhật thành công
                } else {
                    alert("Cập nhật thất bại: " + (res.message || "Không rõ lỗi."));
                }

            } catch (e) {
                console.error("Lỗi hệ thống khi cập nhật:", e);
                alert("Lỗi hệ thống: Không thể kết nối hoặc xử lý yêu cầu cập nhật.");
            }
        }
    }
</script>
</body>
</html>