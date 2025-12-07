<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" crossorigin="anonymous" />
<style>
/* -------------------- ADMIN LAYOUT & CORE STYLES -------------------- */
:root {
    --sidebar-width: 240px;
    --sidebar-bg: #2a3f54; [cite_start]/* Màu nền sidebar tối xanh đậm [cite: 2] */
    --link-color: #ecf0f1;
    --hover-bg: #34495e;
    --active-color: #ffe082; [cite_start]/* Màu vàng RoPhim [cite: 3] */
}

body {
    background: #f4f6f9; [cite_start]/* Nền sáng cho khu vực nội dung chính [cite: 4] */
    margin: 0;
    padding: 0;
    padding-left: var(--sidebar-width); [cite_start]/* Đẩy nội dung chính sang phải để tránh bị sidebar che [cite: 5] */
}

/* -------------------- SIDEBAR STYLES (Giữ nguyên từ trước) -------------------- */
.admin-sidebar {
    width: var(--sidebar-width);
    min-height: 100vh;
    background: var(--sidebar-bg); [cite_start]/* [cite: 6] */
    color: var(--link-color); [cite_start]/* [cite: 7] */
    position: fixed;
    top: 0;
    left: 0;
    z-index: 1000;
    box-shadow: 2px 0 5px rgba(0, 0, 0, 0.2);
}

.admin-sidebar h2 {
    padding: 20px;
    margin: 0;
    font-size: 1.5rem;
    font-weight: 700;
    text-align: center;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1); [cite_start]/* [cite: 9] */
    color: var(--active-color);
}

.admin-sidebar ul {
    list-style: none;
    padding: 10px 0;
    margin: 0; [cite_start]/* [cite: 10] */
}

.admin-sidebar a {
    color: var(--link-color);
    text-decoration: none;
    display: flex;
    align-items: center;
    padding: 12px 20px;
    font-size: 1rem; [cite_start]/* [cite: 11] */
    transition: background 0.3s, color 0.3s;
    border-left: 5px solid transparent;
}

.admin-sidebar a:hover {
    background: var(--hover-bg); [cite_start]/* [cite: 12] */
    color: #fff; [cite_start]/* [cite: 12] */
    border-left-color: var(--active-color);
}

.admin-sidebar li.active a {
    background: var(--hover-bg);
    color: var(--active-color);
    border-left-color: var(--active-color);
    font-weight: 600; [cite_start]/* [cite: 13] */
}

.admin-sidebar .fa-solid {
    width: 25px;
}

/* -------------------- MAIN CONTENT STYLES -------------------- */
.main-content {
    padding: 20px; [cite_start]/* [cite: 14] */
}
.main-header {
    background: #fff;
    padding: 15px 20px;
    border-bottom: 1px solid #ddd;
    margin-bottom: 20px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05); [cite_start]/* [cite: 15] */
}
</style>
</head>
<body>
    <%@ include file="/views/component/admin/sidebar.jsp" %>

    <div class="main-content">
        <div class="main-header">
            <h3 class="mb-0">Dashboard - Tổng quan</h3>
        </div>

        <div class="container-fluid">
            <div class="row">
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card shadow h-100 py-2 border-start border-primary border-4">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col me-2">
                                    <div class="text-xs fw-bold text-primary text-uppercase mb-1">
                                        Tổng Người dùng
                                    </div>
                                    <div class="h5 mb-0 fw-bold text-gray-800" id="kpi-total-users">0</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fa-solid fa-user-group fa-2x text-gray-400"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card shadow h-100 py-2 border-start border-success border-4">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col me-2">
                                    <div class="text-xs fw-bold text-success text-uppercase mb-1">
                                        Tổng Số Video
                                    </div>
                                    <div class="h5 mb-0 fw-bold text-gray-800" id="kpi-total-videos">0</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fa-solid fa-clapperboard fa-2x text-gray-400"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card shadow h-100 py-2 border-start border-info border-4">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col me-2">
                                    <div class="text-xs fw-bold text-info text-uppercase mb-1">
                                        Bình luận mới
                                    </div>
                                    <div class="h5 mb-0 fw-bold text-gray-800" id="kpi-total-comments">0</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fa-solid fa-message fa-2x text-gray-400"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card shadow h-100 py-2 border-start border-warning border-4">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col me-2">
                                    <div class="text-xs fw-bold text-warning text-uppercase mb-1">
                                        Tổng Danh mục
                                    </div>
                                    <div class="h5 mb-0 fw-bold text-gray-800" id="kpi-total-categories">0</div>
                                </div>
                                <div class="col-auto">
                                    <i class="fa-solid fa-tags fa-2x text-gray-400"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 fw-bold text-primary">Các Video được xem nhiều nhất tuần này</h6>
                        </div>
                        <div class="card-body">
                            <p>Sử dụng thư viện Chart.js hoặc thư viện bảng Bootstrap để hiển thị dữ liệu.</p>
                            <ul>
                                <li>Video A (1,200 lượt xem)</li>
                                <li>Video B (950 lượt xem)</li>
                                <li>Video C (800 lượt xem)</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script>
    const VIDEO_API_URL = "${pageContext.request.contextPath}/api/dashboard";

    /**
     * Hàm tiện ích để tìm giá trị KPI theo nhãn (Label)
     * @param {Array<Object>} kpiArray - Mảng KPI từ API
     * @param {string} label - Nhãn KPI cần tìm (ví dụ: 'TotalUsers')
     * @returns {number} Giá trị KPI hoặc 0 nếu không tìm thấy
     */
    function getKpiValue(kpiArray, label) {
        const item = kpiArray.find(item => item.label === label);
        // Chuyển sang số nguyên và trả về 0 nếu không tìm thấy
        return item ? parseInt(item.value) : 0;
    }

    /**
     * Cập nhật các thẻ card KPI trên Dashboard
     * @param {Array<Object>} videos - Dữ liệu KPI đã được fetch từ API
     */
    function updateKpiCards(videos) {
        // 1. Lấy giá trị từ mảng JSON đã fetch
        const totalUsers = getKpiValue(videos, 'TotalUsers');
        const totalVideos = getKpiValue(videos, 'TotalVideos');
        const totalComments = getKpiValue(videos, 'TotalComments');
        const totalCategories = getKpiValue(videos, 'TotalCategories');

        // 2. Cập nhật nội dung (textContent) của các thẻ card dựa trên ID
        // Sử dụng toLocaleString để định dạng số có dấu phẩy nếu cần
        document.getElementById('kpi-total-users').textContent = totalUsers.toLocaleString('vi-VN');
        document.getElementById('kpi-total-videos').textContent = totalVideos.toLocaleString('vi-VN');
        document.getElementById('kpi-total-comments').textContent = totalComments.toLocaleString('vi-VN');
        document.getElementById('kpi-total-categories').textContent = totalCategories.toLocaleString('vi-VN');

        console.log("3. Đã cập nhật các giá trị KPI trên Dashboard.");
    }


    async function init() {
        try {
            const response = await fetch(VIDEO_API_URL);
            if (!response.ok) throw new Error("Lỗi kết nối API: " + response.statusText);

            const videos = await response.json();

            // Log dữ liệu fetch được
            console.log("2. Fetch danh sách video thành công. Tổng số:", videos);

            // Gọi hàm cập nhật các thẻ card
            updateKpiCards(videos);

        } catch (error) {
            console.error("Lỗi khi tải dữ liệu video:", error);
            // Có thể hiển thị thông báo lỗi lên giao diện nếu cần
        }
    }

    document.addEventListener('DOMContentLoaded', init);
</script>
</body>
</html>