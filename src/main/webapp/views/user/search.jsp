<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>RoPhim - Trang chủ</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-color: #e50914;
            --dark-color: #141414;
            --light-color: #f4f4f4;
            --secondary-color: #2c2c2c;
        }

        /* ĐẢM BẢO BACKGROUND LÀ #191b24 */
        body {
            background-color: #191b24 !important;
            color: var(--light-color);
            font-family: 'Helvetica Neue', Arial, sans-serif;
            padding-top: 80px;
            margin: 0;
            min-height: 100vh;
        }

        html {
            background-color: #191b24 !important;
        }

        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 15px;
            background-color: #191b24;
        }

        .section-title {
            border-left: 4px solid var(--primary-color);
            padding-left: 10px;
            margin-bottom: 1.5rem;
            font-weight: bold;
            color: var(--light-color);
        }

        .movie-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 3rem;
        }

        .movie-card {
            background-color: var(--secondary-color);
            border-radius: 10px;
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
            cursor: pointer;
        }

        .movie-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
        }

        .movie-poster {
            width: 100%;
            height: 280px;
            object-fit: cover;
        }

        .movie-info {
            padding: 15px;
        }

        .movie-title {
            font-size: 1rem;
            font-weight: bold;
            margin-bottom: 5px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            color: var(--light-color);
        }

        .movie-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 5px;
        }

        .movie-date {
            color: #aaa;
            font-size: 0.85rem;
        }

        .movie-rating {
            display: flex;
            align-items: center;
            color: gold;
            font-size: 0.85rem;
        }

        .movie-rating i {
            margin-right: 2px;
        }

        .welcome-section {
            text-align: center;
            margin-bottom: 3rem;
            padding: 2rem;
            background-color: var(--secondary-color);
            border-radius: 10px;
            color: var(--light-color);
        }

        .welcome-title {
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        .server-status {
            background-color: #333;
            padding: 10px 15px;
            border-radius: 5px;
            display: inline-block;
            margin-top: 1rem;
            color: var(--light-color);
        }

        /* Đảm bảo tất cả text đều có màu sáng */
        h1, h2, h3, h4, h5, h6, p, span {
            color: var(--light-color);
        }

        @media (max-width: 768px) {
            .movie-grid {
                grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
                gap: 15px;
            }

            .movie-poster {
                height: 220px;
            }
        }
    </style>
</head>
<body>
    <%@ include file="../component/common/Header.jsp"%>

    <div class="main-container">

        <h2 class="section-title">Phim đề xuất</h2>
        <div class="movie-grid" id="recommended-movies-grid">
            <!-- Movies will be loaded here -->
        </div>

    </div>

    <%@ include file="../component/common/Footer.jsp"%>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

    <script>
    const videoUrlID = (new URLSearchParams(window.location.search)).get('q');
    const VIDEO_API_URL = "${pageContext.request.contextPath}/api/search?q=" + videoUrlID;

        // 2. Hàm tạo thẻ phim (Movie Card) từ dữ liệu
        function createMovieCard(movie) {
            // Sửa lỗi: Đảm bảo sử dụng đúng tên thuộc tính từ API
            const displayDate = movie.createAt || 'N/A';
            // Sử dụng template literal với cú pháp đúng
            return `
                <div class="movie-card" data-movie-id="\${movie.id}">
                    <img src="\${movie.poster || 'https://via.placeholder.com/200x280?text=No+Image'}" alt="\${movie.title}" class="movie-poster">
                    <div class="movie-info">
                        <h3 class="movie-title">\${movie.title}</h3>
                        <div class="movie-meta">
                            <span class="movie-date">\${displayDate}</span>
                        </div>
                    </div>
                </div>
            `;
        }

        // 3. Hàm fetch dữ liệu và render lên giao diện
        async function fetchAndRenderMovies(containerId, apiUrl) {
            const container = document.getElementById(containerId);
            if (!container) {
                console.error('Container not found:', containerId);
                return;
            }

            try {
                console.log('Fetching data from:', apiUrl);

                // Fetch API
                const response = await fetch(apiUrl);
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }

                // Parse JSON
                const videos = await response.json();
                console.log('Data received:', videos);

                let htmlContent = '';

                // Kiểm tra nếu videos là mảng
                if (Array.isArray(videos)) {
                    videos.forEach(movie => {
                        htmlContent += createMovieCard(movie);
                    });
                } else {
                    console.error('Expected array but got:', typeof videos);
                    htmlContent = '<p style="color:var(--primary-color);">Dữ liệu không đúng định dạng</p>';
                }

                // Chèn tất cả các thẻ phim vào container
                container.innerHTML = htmlContent;

                // Sau khi chèn, gắn lại sự kiện click cho các thẻ phim mới
                attachMovieCardListeners();

            } catch (error) {
                console.error('Lỗi khi fetch dữ liệu phim:', error);
                container.innerHTML = `<p style="color:var(--primary-color);">Không thể tải phim: \${error.message}. Vui lòng kiểm tra API.</p>`;
            }
        }

        // 4. Hàm gắn sự kiện click
        function attachMovieCardListeners() {
            document.querySelectorAll('.movie-card').forEach(card => {
                card.addEventListener('click', function() {
                    const movieId = this.getAttribute('data-movie-id');
                    let redirectUrl = 'videodetail';
                    if (movieId) {
                        redirectUrl += '?id=' + movieId;
                    }
                    window.location.href = redirectUrl;
                });
            });
        }

        // 5. Chạy hàm chính khi trang tải xong
        document.addEventListener('DOMContentLoaded', () => {
            fetchAndRenderMovies('recommended-movies-grid', VIDEO_API_URL);
        });
    </script>
</body>
</html>