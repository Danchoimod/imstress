<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý bình luận</title>
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
.comment-content-cell {
    max-width: 350px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
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
                    <h6 class="m-0 fw-bold text-primary">Danh sách Bình luận</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-striped table-hover" width="100%" cellspacing="0">
                            <thead>
                                <tr class="table-dark">
                                    <th style="width: 5%;">ID</th>
                                    <th>Nội dung</th>
                                    <th style="width: 15%;">Người dùng</th>
                                    <th style="width: 15%;">Video (ID)</th>
                                    <th style="width: 10%;">Trạng thái</th>
                                    <th style="width: 15%;">Hành động</th>
                                </tr>
                            </thead>
                            <%-- THAY ĐỔI ID: bodyTableVideo -> commentsTableBody --%>
                            <tbody id="commentsTableBody" data-context-path="${pageContext.request.contextPath}">
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
        fetchComments();
    });

    const bodyTable = document.getElementById("commentsTableBody");
    const CONTEXT_PATH = bodyTable.getAttribute("data-context-path");

    // Giả định API Admin Comment là /api/admin/comments
    const API_URL_GET = CONTEXT_PATH + "/api/admin/comments";
    const API_URL_UPDATE = CONTEXT_PATH + "/api/admin/comments";

    // --- LOGIC HIỂN THỊ TRẠNG THÁI VÀ VAI TRÒ ---
    // status là boolean: true (Hiện/Active), false (Ẩn/Locked)
    function getStatusDisplay(status) {
        if (status === true) {
             return "<span class='badge bg-success'>Hiện</span>";
        } else {
             return "<span class='badge bg-secondary'>Ẩn</span>";
        }
    }

    // Tạo nút chuyển đổi Status (true <-> false)
    function generateStatusButton(comment) {
        const currentStatus = comment.status;
        const commentId = comment.id;

        if (currentStatus === true) {
            // Current: Hiện -> Offer Hide (false)
            return "<button class='btn btn-sm btn-danger' onclick='updateComment(" + commentId + ", false, \"Ẩn bình luận\")' title='Ẩn bình luận'>" +
                        "<i class='fa-solid fa-eye-slash'></i> Ẩn" +
                    "</button>";
        } else {
            // Current: Ẩn -> Offer Show (true)
            return "<button class='btn btn-sm btn-success' onclick='updateComment(" + commentId + ", true, \"Hiện bình luận\")' title='Hiện bình luận'>" +
                        "<i class='fa-solid fa-eye'></i> Hiện" +
                    "</button>";
        }
    }

    // --- HÀM FETCH DỮ LIỆU ---
    function fetchComments() {
        bodyTable.innerHTML = "<tr><td colspan='6' class='text-center'><i class='fa-solid fa-spinner fa-spin me-2'></i>Đang tải dữ liệu...</td></tr>";

        axios.get(API_URL_GET)
        .then((res) => {
            console.log("Comments fetched:", res.data);
            const comments = res.data;

            if (!Array.isArray(comments) || comments.length === 0) {
                bodyTable.innerHTML = "<tr><td colspan='6' class='text-center text-muted'>Chưa có bình luận nào.</td></tr>";
                return;
            }

            const rows = comments.map((comment) => {
                // SỬ DỤNG NỐI CHUỖI THUẦN
                const videoLink = CONTEXT_PATH + "/videodetail?id=" + comment.video.id;
                const parentId = comment.parentCommentId ? "(Reply: " + comment.parentCommentId + ")" : "";

                return "<tr>" +
                    "<td>" + comment.id + parentId + "</td>" +
                    "<td class='comment-content-cell' title='" + comment.content + "'>" + comment.content + "</td>" +
                    "<td><span class='badge bg-secondary'>" + (comment.userName || 'N/A') + "</span></td>" +
                    "<td><a href='" + videoLink + "' target='_blank'>Video " + comment.video.id + "</a></td>" +
                    "<td>" + getStatusDisplay(comment.status) + "</td>" +
                    "<td>" +
                        generateStatusButton(comment) +
                    "</td>" +
                "</tr>";
            }).join("");

            bodyTable.innerHTML = rows;
        })
        .catch((error) => {
            console.error("Lỗi khi tải danh sách bình luận:", error);
            // Cập nhật colspan thành 6 (số cột)
            bodyTable.innerHTML = "<tr><td colspan='6' class='text-center text-danger'>Không thể tải danh sách bình luận. Vui lòng kiểm tra API.</td></tr>";
        });
    }

    // --- HÀM UPDATE TRẠNG THÁI ---
    // value là boolean (true/false)
    async function updateComment(commentId, value, actionName) {
        // value là true/false, phải chuyển thành chuỗi 'true' hoặc 'false' khi gửi
        const valueString = value ? "true" : "false";

        // SỬ DỤNG NỐI CHUỖI THUẦN
        if (confirm("Bạn có chắc chắn muốn " + actionName + " bình luận ID: " + commentId + " không?")) {
            const params = new URLSearchParams();
            params.append("commentId", commentId);
            params.append("action", "status"); // action cố định là 'status'
            params.append("value", valueString); // 'true' hoặc 'false'

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
                    fetchComments(); // Tải lại dữ liệu sau khi cập nhật thành công
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