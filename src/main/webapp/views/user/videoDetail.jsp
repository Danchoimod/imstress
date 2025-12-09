<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết phim - RoPhim</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-color: #e50914;
            --dark-color: #141414;
            --light-color: #f4f4f4;
            --secondary-color: #2c2c2c;
        }

        body {
            background-color: #191b24;
            color: var(--light-color);
            font-family: 'Helvetica Neue', Arial, sans-serif;
            /* Đảm bảo header không che nội dung nếu header fixed */
            padding-top: 80px;
        }

        .detail-container {
            max-width: 1200px;
            margin: 4rem auto;
            padding: 0 15px;
        }

        .detail-content {
            background-color: var(--secondary-color);
            border-radius: 10px;
            padding: 2rem;
        }

        .section-title {
            border-left: 4px solid var(--primary-color);
            padding-left: 10px;
            margin-bottom: 1.5rem;
            font-weight: bold;
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            font-weight: bold;
        }

        .btn-primary:hover {
            background-color: #b8070f;
            border-color: #b8070f;
        }

        .divider {
            border-top: 1px solid #444;
            margin: 2rem 0;
        }

        .movie-poster {
            width: 100%;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            /* Thêm chiều cao tối thiểu để tránh layout shift */
            min-height: 450px;
            object-fit: cover;
            background-color: #333;
        }

        .info-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 1.5rem;
        }

        .info-table td {
            padding: 8px 0;
            border-bottom: 1px solid #444;
        }

        .info-table td:first-child {
            color: #aaa;
            width: 30%;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 1.5rem;
            flex-wrap: wrap;
        }

        .btn-outline-light {
            border-color: #aaa;
            color: #aaa;
        }

        .btn-outline-light:hover {
            background-color: #aaa;
            color: var(--secondary-color);
        }

        .movie-title {
            font-size: 2rem;
            margin-bottom: 1rem;
            color: var(--light-color);
        }

        .movie-subtitle {
            color: #aaa;
            margin-bottom: 1.5rem;
        }

        .movie-description {
            line-height: 1.6;
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body>
    <%@ include file="../component/common/Header.jsp"%>

    <div class="detail-container">
        <div id="loading-spinner" class="text-center my-5">
            <div class="spinner-border text-danger" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="mt-2">Đang tải thông tin phim...</p>
        </div>

        <div class="detail-content" id="main-content" style="display: none;">
            <div class="row">
                <div class="col-md-4">
                    <img id="movie-poster" src="" class="movie-poster" alt="Movie Poster">
                </div>
                <div class="col-md-8">
                    <h1 class="movie-title" id="movie-title">Loading...</h1>
                    <p class="movie-subtitle" id="movie-subtitle"></p>

                    <table class="info-table">
                        <tr>
                            <td>Trạng thái</td>
                            <td id="movie-status">Đang cập nhật</td>
                        </tr>
                        <tr>
                            <td>Ngày cập nhật</td>
                            <td id="movie-date">...</td>
                        </tr>
                    </table>

                    <div class="action-buttons">
                        <a id="btn-watch" href="#" class="btn btn-primary">
                            <i class="bi bi-play-fill me-2"></i>Xem ngay
                        </a>
                        <button class="btn btn-outline-light">
                            <i class="bi bi-heart me-2"></i>Yêu thích
                        </button>
                        <button class="btn btn-outline-light">
                            <i class="bi bi-share me-2"></i>Chia sẻ
                        </button>
                    </div>
                </div>
            </div>

            <div class="divider"></div>

            <div class="row">
                <div class="col-12">
                    <h3 class="section-title">Nội dung</h3>
                    <p class="movie-description" id="movie-description">
                        Đang tải nội dung mô tả...
                    </p>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 🚨 KHẮC PHỤC LỖI: Sử dụng tên biến độc lập và định nghĩa lại URL API
    // Biến contextPath đã được Header.jsp định nghĩa, không cần khai báo lại.
    // Đã sửa lỗi chính tả: /api/vieos -> /api/videos
    const VIDEO_DETAIL_API_URL = "${pageContext.request.contextPath}/api/videos";

    // Hàm lấy tham số từ URL
    function getQueryParam(param) {
        const urlParams = new URLSearchParams(window.location.search);
        return urlParams.get(param);
    }

    // Hàm fetch chi tiết phim (ĐÃ SỬA LOGIC)
    async function fetchVideoDetail() {
        const videoId = getQueryParam('id');
        const spinner = document.getElementById('loading-spinner');
        const content = document.getElementById('main-content');

        // Kiểm tra nếu không có ID
        if (!videoId) {
            alert("Không tìm thấy ID phim! Quay lại trang chủ.");
            // window.location.href = 'index.jsp'; // Bỏ comment nếu muốn tự động quay về
            return;
        }

        try {
            console.log(`Đang tìm phim có ID: ${videoId}`);

            // 🚨 CẬP NHẬT: Gọi API đã sửa URL
            const response = await fetch(VIDEO_DETAIL_API_URL);

            if (!response.ok) {
                throw new Error(`Lỗi kết nối API: ${response.status}`);
            }

            // Lấy danh sách phim về
            const videos = await response.json();

            // Dùng hàm find của Javascript để lọc ra phim có id trùng khớp
            // Lưu ý: videoId từ URL là string, v.id có thể là number, nên dùng == thay vì ===
            const movie = videos.find(v => v.id == videoId);

            if (!movie) {
                throw new Error("Không tìm thấy phim này trong cơ sở dữ liệu.");
            }

            console.log('Thông tin phim tìm được:', movie);

            // Cập nhật giao diện
            updateUI(movie);

            // Ẩn spinner, hiện nội dung
            spinner.style.display = 'none';
            content.style.display = 'block';

        } catch (error) {
            console.error("Error fetching detail:", error);
            spinner.innerHTML = `<p class="text-danger text-center">Lỗi: ${error.message}</p>`;
        }
    }

    // Hàm cập nhật UI
    function updateUI(movie) {
        // Cập nhật tiêu đề trang
        document.title = movie.title + " - RoPhim";

        const posterImg = document.getElementById('movie-poster');
        posterImg.src = movie.poster || 'https://via.placeholder.com/300x450/333/666?text=No+Image';
        posterImg.alt = movie.title;

        document.getElementById('movie-title').textContent = movie.title;
        document.getElementById('movie-subtitle').textContent = movie.title;

        // Kiểm tra mô tả và thay thế description
        document.getElementById('movie-description').textContent = movie.desc || "Chưa có mô tả cho nội dung này."; // Sử dụng movie.desc (từ Entity Video.java)

        document.getElementById('movie-date').textContent = movie.createAt || 'N/A';

        // Cập nhật trạng thái
        let statusDisplay = 'Đang cập nhật';
        if (movie.status === 1) {
            statusDisplay = "Đang hoạt động";
        } else if (movie.status === 2) {
            statusDisplay = "Ẩn";
        } else if (movie.status === 3) {
            statusDisplay = "Từ chối";
        } else if (movie.status === 4) {
            statusDisplay = "Đã duyệt";
        }
        document.getElementById('movie-status').textContent = statusDisplay;

        // Cập nhật nút Xem ngay
        const watchBtn = document.getElementById('btn-watch');
        watchBtn.href = 'watch?id=' + movie.id;
    }

    // Khởi chạy khi trang load
    document.addEventListener('DOMContentLoaded', fetchVideoDetail);

    // Giữ lại xử lý sự kiện cho các nút hành động phụ
    document.querySelectorAll('.btn-outline-light').forEach(button => {
        button.addEventListener('click', function() {
            const buttonText = this.textContent.trim();
            alert(`Chức năng ${buttonText} đang phát triển!`);
        });
    });
</script>
</body>
</html>