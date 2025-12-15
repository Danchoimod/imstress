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

        /* Share Modal Styles */
        .share-btn {
            min-width: 120px;
        }

        .share-btn i {
            font-size: 1.2rem;
        }

        #shareModal .modal-content {
            border: 1px solid #444;
        }

        #shareModal .form-control:focus {
            background-color: #1a1a1a;
            border-color: var(--primary-color);
            color: #f4f4f4;
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
                        <button id="btn-share" class="btn btn-outline-light">
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
        const USER_INFO_API_URL = "${pageContext.request.contextPath}/api/userinfo";

        // Biến lưu thông tin phim hiện tại
        let currentMovie = null;

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
                const response = await axios.post(FAV_API_URL, params.toString(), {
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    }
                });

                const result = response.data;
                alert(result.message);

                // SAU KHI TOGGLE, CHECK LẠI TRẠNG THÁI TỪ SERVER
                try {
                    const favResponse = await axios.get(FAV_API_URL);
                    const favList = favResponse.data;
                    const isFavorited = favList.some(video => video.id == videoId);
                    updateFavoriteButton(isFavorited);
                    console.log("Trạng thái yêu thích sau toggle:", isFavorited);
                } catch (e) {
                    console.warn("Không thể cập nhật trạng thái button:", e);
                }

            } catch (error) {
                console.error("Lỗi toggle favorite:", error);

                if (error.response && error.response.status === 401) {
                    alert('Vui lòng đăng nhập để sử dụng chức năng yêu thích.');
                    window.location.href = '${pageContext.request.contextPath}/auth/login';
                } else if (error.response && error.response.data) {
                    alert(error.response.data.error || error.response.data.message || "Cập nhật yêu thích thất bại.");
                } else {
                    alert("Lỗi kết nối hoặc xử lý server. Vui lòng kiểm tra console.");
                }
            } finally {
                favoriteBtn.disabled = false;
            }
        }

        // Hàm chia sẻ phim
        function shareMovie(movie) {
            const shareUrl = window.location.href;
            const shareTitle = movie.title;
            const shareText = `Xem phim "${movie.title}" trên RoPhim`;

            // Kiểm tra nếu trình duyệt hỗ trợ Web Share API (mobile-friendly)
            if (navigator.share) {
                navigator.share({
                    title: shareTitle,
                    text: shareText,
                    url: shareUrl
                })
                .then(() => {
                    console.log('Chia sẻ thành công!');
                })
                .catch((error) => {
                    console.log('Hủy chia sẻ hoặc lỗi:', error);
                });
            } else {
                // Nếu không hỗ trợ Web Share API, hiện modal tùy chọn
                showShareModal(movie, shareUrl, shareTitle, shareText);
            }
        }

        // Hàm hiển thị modal chia sẻ
        function showShareModal(movie, url, title, text) {
            const modalHtml = `
                <div class="modal fade" id="shareModal" tabindex="-1" aria-labelledby="shareModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content" style="background-color: #2c2c2c; color: #f4f4f4;">
                            <div class="modal-header border-secondary">
                                <h5 class="modal-title" id="shareModalLabel">
                                    <i class="bi bi-share me-2"></i>Chia sẻ phim
                                </h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <h6 class="mb-3">${title}</h6>
                                    <div class="d-flex gap-3 mb-4 justify-content-center flex-wrap">
                                        <button class="btn btn-outline-light share-btn" data-platform="facebook">
                                            <i class="bi bi-facebook"></i> Facebook
                                        </button>
                                        <button class="btn btn-outline-light share-btn" data-platform="twitter">
                                            <i class="bi bi-twitter"></i> Twitter
                                        </button>
                                        <button class="btn btn-outline-light share-btn" data-platform="telegram">
                                            <i class="bi bi-telegram"></i> Telegram
                                        </button>
                                        <button class="btn btn-outline-light share-btn" data-platform="zalo">
                                            <i class="bi bi-chat-dots"></i> Zalo
                                        </button>
                                        <button class="btn btn-outline-light share-btn" data-platform="email">
                                            <i class="bi bi-envelope"></i> Email
                                        </button>
                                    </div>
                                </div>

                                <div class="divider" style="border-top: 1px solid #444; margin: 1.5rem 0;"></div>

                                <div>
                                    <label class="form-label">Hoặc sao chép link:</label>
                                    <div class="input-group">
                                        <input type="text" class="form-control" id="shareUrlInput" value="${url}" readonly style="background-color: #1a1a1a; color: #f4f4f4; border-color: #444;">
                                        <button class="btn btn-primary" id="copyUrlBtn" type="button">
                                            <i class="bi bi-clipboard"></i> Sao chép
                                        </button>
                                    </div>
                                    <small class="text-success d-none" id="copySuccess">
                                        <i class="bi bi-check-circle"></i> Đã sao chép!
                                    </small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `;

            // Xóa modal cũ nếu có
            const oldModal = document.getElementById('shareModal');
            if (oldModal) {
                oldModal.remove();
            }

            // Thêm modal vào body
            document.body.insertAdjacentHTML('beforeend', modalHtml);

            // Khởi tạo modal Bootstrap
            const modal = new bootstrap.Modal(document.getElementById('shareModal'));
            modal.show();

            // Xử lý sự kiện các nút chia sẻ
            document.querySelectorAll('.share-btn').forEach(btn => {
                btn.addEventListener('click', function() {
                    const platform = this.getAttribute('data-platform');
                    shareToSocialMedia(platform, url, title, text);
                });
            });

            // Xử lý nút copy
            document.getElementById('copyUrlBtn').addEventListener('click', function() {
                copyToClipboard(url);
            });

            // Xóa modal khi đóng
            document.getElementById('shareModal').addEventListener('hidden.bs.modal', function() {
                this.remove();
            });
        }

        // Hàm chia sẻ đến các nền tảng mạng xã hội
        function shareToSocialMedia(platform, url, title, text) {
            const encodedUrl = encodeURIComponent(url);
            const encodedTitle = encodeURIComponent(title);
            const encodedText = encodeURIComponent(text);

            let shareLink = '';

            switch(platform) {
                case 'facebook':
                    shareLink = `https://www.facebook.com/sharer/sharer.php?u=${encodedUrl}`;
                    break;
                case 'twitter':
                    shareLink = `https://twitter.com/intent/tweet?url=${encodedUrl}&text=${encodedText}`;
                    break;
                case 'telegram':
                    shareLink = `https://t.me/share/url?url=${encodedUrl}&text=${encodedText}`;
                    break;
                case 'zalo':
                    shareLink = `https://zalo.me/share/url?url=${encodedUrl}`;
                    break;
                case 'email':
                    shareLink = `mailto:?subject=${encodedTitle}&body=${encodedText}%0A%0A${encodedUrl}`;
                    break;
                default:
                    alert('Nền tảng không được hỗ trợ!');
                    return;
            }

            // Mở cửa sổ mới để chia sẻ
            window.open(shareLink, '_blank', 'width=600,height=400');
        }

        // Hàm sao chép link vào clipboard
        function copyToClipboard(text) {
            const input = document.getElementById('shareUrlInput');
            const copyBtn = document.getElementById('copyUrlBtn');
            const successMsg = document.getElementById('copySuccess');

            // Sử dụng Clipboard API
            if (navigator.clipboard && navigator.clipboard.writeText) {
                navigator.clipboard.writeText(text)
                    .then(() => {
                        showCopySuccess(copyBtn, successMsg);
                    })
                    .catch(err => {
                        console.error('Lỗi khi sao chép:', err);
                        fallbackCopyToClipboard(input, copyBtn, successMsg);
                    });
            } else {
                // Fallback cho trình duyệt cũ
                fallbackCopyToClipboard(input, copyBtn, successMsg);
            }
        }

        // Fallback method để copy
        function fallbackCopyToClipboard(input, btn, successMsg) {
            input.select();
            input.setSelectionRange(0, 99999);

            try {
                document.execCommand('copy');
                showCopySuccess(btn, successMsg);
            } catch (err) {
                alert('Không thể sao chép. Vui lòng copy thủ công!');
            }
        }

        // Hiển thị thông báo copy thành công
        function showCopySuccess(btn, successMsg) {
            btn.innerHTML = '<i class="bi bi-check-circle"></i> Đã copy!';
            btn.classList.add('btn-success');
            btn.classList.remove('btn-primary');

            successMsg.classList.remove('d-none');

            setTimeout(() => {
                btn.innerHTML = '<i class="bi bi-clipboard"></i> Sao chép';
                btn.classList.remove('btn-success');
                btn.classList.add('btn-primary');
                successMsg.classList.add('d-none');
            }, 2000);
        }

        // ==================== KẾT THÚC TÍNH NĂNG CHIA SẺ ====================

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

                // Lưu thông tin phim vào biến global
                currentMovie = movie;

                updateUI(movie);

                // 2. LẤY THÔNG TIN USER ĐỂ CHECK LOGIN
                let userId = null;
                let isLoggedIn = false;
                try {
                    const userInfoResponse = await axios.get(USER_INFO_API_URL);
                    const userData = userInfoResponse.data;
                    if (userData && userData.id) {
                        userId = userData.id;
                        isLoggedIn = true;
                    }
                } catch (e) {
                    isLoggedIn = false;
                    console.warn("User not logged in or API error:", e.response ? e.response.status : e.message);
                }

                console.log("User ID from API:", userId);
                console.log("Is Logged In:", isLoggedIn);

                if (isLoggedIn) {
                    // 3. CHECK TRẠNG THÁI FAVORITE
                    try {
                        const favResponse = await axios.get(FAV_API_URL);
                        const favList = favResponse.data; // Mảng các video đã thích

                        console.log("Danh sách yêu thích:", favList);

                        // Kiểm tra xem videoId hiện tại có trong danh sách yêu thích không
                        const isFavorited = favList.some(video => video.id == videoId);

                        console.log("Video ID hiện tại:", videoId);
                        console.log("Trạng thái yêu thích:", isFavorited);

                        updateFavoriteButton(isFavorited);
                    } catch (e) {
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

                // 4. GÁN SỰ KIỆN CHO NÚT CHIA SẺ
                const shareBtn = document.getElementById('btn-share');
                if (shareBtn && currentMovie) {
                    shareBtn.addEventListener('click', function(e) {
                        e.preventDefault();
                        shareMovie(currentMovie);
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
    </script>
</body>
</html>