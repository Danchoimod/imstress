<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý tài khoản - RoPhim</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <style>
        :root {
            --primary-color: #e50914;
--dark-color: #141414; /* Màu nền cũ */
            --light-color: #f4f4f4;
--secondary-color: #2c2c2c;
        }

        body {
            /* Dòng đã được thay đổi: Sử dụng màu #191b24 làm background */
            background-color: #191b24;
color: var(--light-color);
            font-family: 'Helvetica Neue', Arial, sans-serif;
        }

        .profile-container {
            max-width: 1200px;
/* Tăng khoảng cách trên cùng do không còn Navbar */
            margin: 4rem auto;
padding: 0 15px;
        }


        .profile-sidebar {
            background-color: var(--secondary-color);
border-radius: 10px;
            padding: 1.5rem;
            height: fit-content;
        }

        .profile-content {
            background-color: var(--secondary-color);
border-radius: 10px;
            padding: 2rem;
        }

        .nav-profile {
            list-style: none;
padding: 0;
        }

        .nav-profile li {
            margin-bottom: 0.5rem;
}

        .nav-profile a {
            display: block;
padding: 0.8rem 1rem;
            color: #aaa;
            text-decoration: none;
            border-radius: 5px;
            transition: all 0.3s;
}

        .nav-profile a:hover, .nav-profile a.active {
            background-color: rgba(229, 9, 20, 0.2);
color: var(--light-color);
        }

        .nav-profile a i {
            margin-right: 10px;
width: 20px;
            text-align: center;
        }

        .section-title {
            border-left: 4px solid var(--primary-color);
padding-left: 10px;
            margin-bottom: 1.5rem;
            font-weight: bold;
        }

        .divider {
            border-top: 1px solid #444;
margin: 2rem 0;
        }

        /* Styles cho danh sách yêu thích */
        .video-card {
            background-color: #333;
border: none;
            border-radius: 8px;
            overflow: hidden;
            height: 100%; /* Đảm bảo chiều cao nhất quán */
        }

        .video-link {
            text-decoration: none; /* Bỏ gạch chân khi là thẻ a */
            color: inherit;
        }

        .video-card img {
            width: 100%;
height: 150px;
            object-fit: cover;
        }
        .video-card-body {
            padding: 1rem;
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }
        .video-card-title {
            font-size: 1rem;
            font-weight: bold;
            color: var(--light-color);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .remove-btn {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 0.4rem 0.8rem;
            border-radius: 5px;
            cursor: pointer;
            font-size: 0.85rem;
            transition: background-color 0.3s;
            width: 100%;
            text-align: center;
        }
        .remove-btn:hover {
            background-color: #b8070f;
        }
        .remove-btn i {
            margin-right: 5px;
        }
        .video-card-body {
            background-color: #2c2c2c; /* màu đen */
            color: #fff; /* chữ màu trắng nếu cần */
            border-radius: 5px; /* nếu muốn bo góc */
            padding: 1rem; /* nếu muốn khoảng cách nội dung */
        }

    </style>
</head>
<body>
    <%@ include file="../component/common/Header.jsp"%>
    <div style="padding-top: 80px;"
class="profile-container">
        <div class="row">
            <div class="col-lg-3 mb-4">
                <div class="profile-sidebar">
                    <h1 class="logo mb-4" style="color: var(--primary-color); font-weight: bold; font-size: 1.8rem;">RoPhim</h1>
                    <h4 class="mb-3">Cài đặt</h4>

          <ul class="nav-profile">
                        <li><a href="${pageContext.request.contextPath}/fav" class="active"><i class="bi bi-heart"></i> Yêu thích </a></li>
                        <li><a href="${pageContext.request.contextPath}/profile"><i class="bi bi-person"></i> Tài khoản</a></li>
                        <div class="divider"></div>

                                            <c:if test="${cookie.role != null && cookie.role.value == '3'}">
                                                <li>
                                                    <a href="${pageContext.request.contextPath}/admin/dashboard">
                                                        <i class="bi bi-house"></i> Quản trị viên
                                                    </a>
                                                </li>
                                            </c:if>
                        <li><a href="${pageContext.request.contextPath}/auth/logout"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a></li>
                    </ul>
                </div>

   </div>

            <div class="col-lg-9">
                <div class="profile-content">

                    <h3 class="section-title">Danh sách Yêu thích</h3>
                    <p class="text-light mb-4">Các bộ phim và chương trình bạn đã thêm vào mục yêu thích.</p>


           <div class="row g-4" id="favorites-list">
                        <div id="loading-message" class="text-center w-100 p-5">
                            <div class="spinner-border text-danger" role="status"></div>

 <p class="mt-2 text-muted">Đang tải danh sách yêu thích...</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

 <script>
    const FAV_API_URL = "${pageContext.request.contextPath}/api/fav";
    const VIDEO_DETAIL_BASE_URL = "${pageContext.request.contextPath}/videodetail?id=";

    // Hàm render một video yêu thích
    function renderFavoriteVideo(video) {
        const posterUrl = video.poster || 'https://via.placeholder.com/300x150/333/666?text=No+Image';
        const videoTitle = video.title || 'Không có tiêu đề';
        const videoId = video.id;
        const detailLink = VIDEO_DETAIL_BASE_URL + videoId; // Đường dẫn chi tiết

        return '<div class="col-6 col-md-4 col-lg-3" id="fav-item-' + videoId + '">' +
            '<div class="card video-card">' +
                '<a href="' + detailLink + '" class="video-link">' +
                    '<img src="' + posterUrl + '" class="card-img-top" alt="Thumbnail ' + videoTitle + '">' +
                '</a>' +
                '<div class="video-card-body">' +
                    '<a href="' + detailLink + '" class="video-link">' +
                        '<div class="video-card-title">' + videoTitle + '</div>' +
                    '</a>' +
                    '<button class="remove-btn" title="Xóa khỏi danh sách yêu thích" data-video-id="' + videoId + '" data-video-title="' + videoTitle + '">' +
                        '<i class="bi bi-heart-fill"></i>Bỏ thích' +
                    '</button>' +
                '</div>' +
            '</div>' +
        '</div>';
    }

    // Hàm fetch và hiển thị danh sách yêu thích
    async function fetchFavorites() {
        const listContainer = document.getElementById('favorites-list');
        listContainer.innerHTML = document.getElementById('loading-message').outerHTML; // Hiển thị spinner lại

        try {
            // GET /api/fav (Không có tham số videoId) để lấy danh sách - DÙNG AXIOS
            const response = await axios.get(FAV_API_URL);
            const videos = response.data; // Axios tự động parse JSON

            if (videos.length === 0) {
                listContainer.innerHTML = '<p class="text-center w-100 p-5 text-muted">Danh sách yêu thích của bạn đang trống.</p>';
            } else {
                listContainer.innerHTML = videos.map(renderFavoriteVideo).join('');
                // Gán lại sự kiện xóa sau khi render
                attachRemoveListeners();
            }

        } catch (error) {
            console.error("Lỗi khi tải danh sách yêu thích:", error);

            if (error.response && error.response.status === 401) {
                listContainer.innerHTML = '<p class="text-center w-100 p-5 text-warning">Vui lòng <a href="' + '${pageContext.request.contextPath}/auth/login' + '">đăng nhập</a> để xem danh sách yêu thích.</p>';
            } else {
                listContainer.innerHTML = '<p class="text-center w-100 p-5 text-danger">Không thể tải danh sách yêu thích. Vui lòng thử lại sau.</p>';
            }
        }
    }

    // Hàm xử lý xóa (unfavorite)
    async function handleRemove(videoId, title) {
        if (!confirm('Bạn có chắc chắn muốn xóa "' + title + '" khỏi danh sách yêu thích?')) {
            return;
        }

        const params = new URLSearchParams();
        params.append("videoId", videoId);

        try {
            // POST /api/fav để xóa (Toggle) - DÙNG AXIOS
            const response = await axios.post(FAV_API_URL, params.toString(), {
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                }
            });

            const result = response.data; // Axios tự động parse JSON

            if (result.action === 'unfavorited') {
                alert('Đã xóa ' + title + ' khỏi danh sách yêu thích!');
                // Xóa phần tử khỏi DOM
                document.getElementById('fav-item-' + videoId).remove();
                // Cập nhật lại thông báo nếu list rỗng
                if (document.getElementById('favorites-list').children.length === 0) {
                    document.getElementById('favorites-list').innerHTML = '<p class="text-center w-100 p-5 text-muted">Danh sách yêu thích của bạn đang trống.</p>';
                }
            } else {
                alert(result.message || 'Xóa ' + title + ' thất bại.');
            }

        } catch (error) {
            console.error("Lỗi xóa yêu thích:", error);

            if (error.response && error.response.status === 401) {
                alert('Vui lòng đăng nhập để sử dụng chức năng yêu thích.');
                window.location.href = '${pageContext.request.contextPath}/auth/login';
            } else if (error.response && error.response.data) {
                alert(error.response.data.error || error.response.data.message || "Cập nhật yêu thích thất bại.");
            } else {
                alert("Lỗi kết nối server khi xóa yêu thích.");
            }
        }
    }

    // Hàm gán listener cho nút xóa
    function attachRemoveListeners() {
        document.querySelectorAll('.remove-btn').forEach(button => {
            // Sử dụng một hàm ẩn danh để tránh vấn đề gán lại listener
            button.addEventListener('click', function(event) {
                const videoId = event.target.dataset.videoId;

            const title = event.target.dataset.videoTitle;
                handleRemove(videoId, title);
            });
        });
}

    // Tải dữ liệu khi trang load
    document.addEventListener('DOMContentLoaded', fetchFavorites);
    </script>
</body>
</html>