<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết phim - RoPhim</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

    <style>
        /* ... (Phần CSS giữ nguyên) ... */
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
                        <button id="btn-favorite" class="btn btn-outline-light">
                            <i class="bi bi-heart me-2" id="favorite-icon"></i><span id="favorite-text">Yêu thích</span>
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
    <script>
        const VIDEO_DETAIL_API_URL = "${pageContext.request.contextPath}/api/videos";
        const FAV_API_URL = "${pageContext.request.contextPath}/api/fav";
        const USER_INFO_API_URL = "${pageContext.request.contextPath}/api/userinfo"; // API lấy thông tin người dùng

        function getQueryParam(param) {
            const urlParams = new URLSearchParams(window.location.search);
            return urlParams.get(param);
        }

        function updateFavoriteButton(isFavorited) {
            const btn = document.getElementById('btn-favorite');
            const icon = document.getElementById('favorite-icon');
            const text = document.getElementById('favorite-text');

            if (!btn || !icon) return;
            if (isFavorited) {
                btn.classList.remove('btn-outline-light');
                btn.classList.add('btn-primary');
                icon.classList.remove('bi-heart');
                icon.classList.add('bi-heart-fill');
                text.textContent = 'Đã thích';
            } else {
                btn.classList.remove('btn-primary');
                btn.classList.add('btn-outline-light');
                icon.classList.remove('bi-heart-fill');
                icon.classList.add('bi-heart');
                text.textContent = 'Yêu thích';
            }
        }

        // HÀM XỬ LÝ TOGGLE FAVORITE DÙNG AXIOS
        async function toggleFavorite(videoId) {
            const favoriteBtn = document.getElementById('btn-favorite');
            favoriteBtn.disabled = true;

            const params = new URLSearchParams();
            params.append("videoId", videoId);

            try {
                // SỬ DỤNG AXIOS.POST
                const response = await axios.post(FAV_API_URL, params.toString(), {
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    }
                });

                const result = response.data; // Axios tự động parse JSON

                alert(result.message);
                updateFavoriteButton(result.action === 'favorited');

            } catch (error) {
                console.error("Lỗi toggle favorite:", error);

                if (error.response && error.response.status === 401) {
                    alert('Vui lòng đăng nhập để sử dụng chức năng yêu thích.');
                    window.location.href = '${pageContext.request.contextPath}/auth/login';
                } else if (error.response && error.response.data) {
                    // Nếu có lỗi trả về từ server dưới dạng JSON (vd: error.response.data.error)
                    alert(error.response.data.error || error.response.data.message || "Cập nhật yêu thích thất bại.");
                } else {
                    alert("Lỗi kết nối hoặc xử lý server. Vui lòng kiểm tra console.");
                }
            } finally {
                favoriteBtn.disabled = false;
            }
        }

        // Hàm fetch chi tiết phim DÙNG AXIOS
        async function fetchVideoDetail() {
            const videoId = getQueryParam('id');
            const spinner = document.getElementById('loading-spinner');
            const content = document.getElementById('main-content');
            const favoriteBtn = document.getElementById('btn-favorite');

            if (!videoId) {
                alert("Không tìm thấy ID phim! Quay lại trang chủ.");
                spinner.style.display = 'none';
                return;
            }

            let movie = null;

            try {
                // 1. LẤY CHI TIẾT VIDEO
                const videoResponse = await axios.get(VIDEO_DETAIL_API_URL);
                const videos = videoResponse.data;
                movie = videos.find(v => v.id == videoId);

                if (!movie) {
                    throw new Error("Không tìm thấy phim này trong cơ sở dữ liệu.");
                }

                updateUI(movie);

                // 2. LẤY THÔNG TIN USER ĐỂ CHECK LOGIN
                let userId = null;
                let isLoggedIn = false;
                try {
                    const userInfoResponse = await axios.get(USER_INFO_API_URL);
                    const userData = userInfoResponse.data;
                    // Giả sử API trả về đối tượng người dùng có trường 'id' nếu đã đăng nhập
                    if (userData && userData.id) {
                        userId = userData.id;
                        isLoggedIn = true;
                    }
                } catch (e) {
                    // Bất kỳ lỗi nào ở đây (vd: 401, 500) đều được coi là chưa đăng nhập
                    isLoggedIn = false;
                    console.warn("User not logged in or API error:", e.response ? e.response.status : e.message);
                }

                console.log("User ID from API:", userId);

                if (isLoggedIn) {
                    // 3. CHECK TRẠNG THÁI FAVORITE
                    try {
                        const favResponse = await axios.get(`${FAV_API_URL}?videoId=${videoId}`);
                        const favStatus = favResponse.data;
                        updateFavoriteButton(favStatus.isFavorited);
                    } catch (e) {
                        // Nếu API check fav lỗi, giả sử chưa thích
                        updateFavoriteButton(false);
                        console.warn("Lỗi khi check trạng thái yêu thích:", e.response ? e.response.status : e.message);
                    }

                    // Gán sự kiện cho nút Favorite
                    favoriteBtn.addEventListener('click', () => toggleFavorite(videoId));
                } else {
                    updateFavoriteButton(false);
                    favoriteBtn.addEventListener('click', () => {
                        alert('Vui lòng đăng nhập để sử dụng chức năng yêu thích.');
                        window.location.href = '${pageContext.request.contextPath}/auth/login';
                    });
                }

                // Ẩn spinner, hiện nội dung
                spinner.style.display = 'none';
                content.style.display = 'block';

            } catch (error) {
                console.error("Error fetching detail:", error);
                let errorMessage = "Không thể tải thông tin chi tiết phim.";

                if (error.response && error.response.status) {
                    errorMessage += ` Lỗi HTTP: ${error.response.status}`;
                } else if (error.message) {
                    // Lỗi từ fetch (ví dụ: không tìm thấy phim)
                    errorMessage = `Lỗi: ${error.message}`;
                }

                spinner.innerHTML = `<p class="text-danger text-center">Lỗi: ${errorMessage}</p>`;
            }
        }

        // Hàm cập nhật UI
        function updateUI(movie) {
            document.title = movie.title + " - RoPhim";
            const posterImg = document.getElementById('movie-poster');
            posterImg.src = movie.poster || 'https://via.placeholder.com/300x450/333/666?text=No+Image';
            posterImg.alt = movie.title;

            document.getElementById('movie-title').textContent = movie.title;
            document.getElementById('movie-subtitle').textContent = movie.title;
            document.getElementById('movie-description').textContent = movie.desc || "Chưa có mô tả cho nội dung này.";

            document.getElementById('movie-date').textContent = movie.createAt || 'N/A';

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

            const watchBtn = document.getElementById('btn-watch');
            watchBtn.href = 'watch?id=' + movie.id;
        }

        // Khởi chạy khi trang load
        document.addEventListener('DOMContentLoaded', fetchVideoDetail);

        document.querySelectorAll('.btn-outline-light:not(#btn-favorite)').forEach(button => {
            button.addEventListener('click', function() {
                const buttonText = this.textContent.trim();
                alert(`Chức năng ${buttonText} đang phát triển!`);
            });
        });
    </script>
</body>
</html>