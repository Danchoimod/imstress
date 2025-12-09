<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xem phim - RoPhim</title>
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
        }

        .watch-container {
            max-width: 1200px;
            margin: 4rem auto;
            padding: 0 15px;
        }

        .video-section {
            background-color: var(--secondary-color);
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .video-player {
            /* Giữ nguyên chiều rộng và chiều cao để iframe lấp đầy */
            width: 100%;
            height: 500px;
            background-color: #000;
            border-radius: 8px;
            margin-bottom: 1rem;
            position: relative;
            overflow: hidden;
        }

        /* Đảm bảo iframe lấp đầy hoàn toàn div chứa nó */
        .video-player iframe {
            width: 100%;
            height: 100%;
            border: none;
        }

        /* Loại bỏ CSS cho placeholder vì ta chèn iframe tĩnh */
        .video-placeholder {
            display: none; /* Ẩn placeholder */
        }

        .video-info {
            background-color: var(--secondary-color);
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .video-title {
            font-size: 1.5rem;
            margin-bottom: 1rem;
            color: var(--light-color);
        }

        .video-meta {
            display: flex;
            gap: 20px;
            margin-bottom: 1rem;
            color: #aaa;
            font-size: 0.9rem;
        }

        .video-description {
            line-height: 1.6;
            color: #ccc;
            margin-top: 1rem;
        }

        .section-title {
            border-left: 4px solid var(--primary-color);
            padding-left: 10px;
            margin-bottom: 1.5rem;
            font-weight: bold;
        }

        .comment-section {
            background-color: var(--secondary-color);
            border-radius: 10px;
            padding: 1.5rem;
        }

        /* Style cho Form Gửi Comment */
        .comment-form .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            transition: background-color 0.3s;
        }
        .comment-form .btn-primary:hover {
            background-color: #ff3333;
            border-color: #ff3333;
        }

        .comment-item {
            background-color: #333;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
        }

        .comment-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
        }

        .comment-author {
            color: var(--primary-color);
            font-weight: bold;
        }

        .comment-time {
            color: #aaa;
            font-size: 0.9rem;
        }

        .comment-content {
            line-height: 1.5;
        }

        .load-more {
            text-align: center;
            margin-top: 1rem;
        }

        .btn-load-more {
            background-color: #333;
            color: var(--light-color);
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            transition: all 0.3s;
        }

        .btn-load-more:hover {
            background-color: var(--primary-color);
        }

        .login-prompt {
            text-align: center;
            padding: 2rem;
            color: #aaa;
        }

        .login-prompt a {
            color: var(--primary-color);
            text-decoration: none;
        }

        .login-prompt a:hover {
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .video-player {
                height: 300px;
            }
            .video-controls {
                flex-direction: column;
                gap: 10px;
            }
        }
    </style>
</head>
<body style="margin-top:100px;">
    <%@ include file="../component/common/Header.jsp"%>

    <div class="watch-container">
        <div class="video-section">
<div class="video-player" id="video-container">
    <iframe id="video-frame"
        width="100%"
        height="100%"
        src=""
        title="Video player"
        frameborder="0"
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
        allowfullscreen>
    </iframe>
</div>
        <div class="video-info">
            <h1 class="video-title" id="video-title">title</h1>
            <div class="video-meta">
                <span id="video-date">loading...</span>
            </div>
            <div class="video-description" id="video-description">
                description
            </div>
        </div>

        <div class="comment-section">
            <h3 class="section-title">Bình luận (<span id="comment-count">0</span>)</h3>

            <!-- ✅ THAY ĐỔI: Xóa logic hardcode user ID -->
            <div class="comment-form mb-4" id="comment-form-section" style="display: none;">
                <textarea class="form-control" id="comment-input" rows="3" placeholder="Nhập bình luận của bạn..." style="background-color: #444; color: #fff; border: 1px solid #555;" required></textarea>
                <div class="d-flex justify-content-end mt-2">
                    <button class="btn btn-primary" id="post-comment-btn">Gửi bình luận</button>
                </div>
            </div>

            <div class="login-prompt" id="login-prompt-section" style="display: none;">
                <a href="#">Đăng nhập để bình luận</a>
            </div>

            <div id="comments-list">
            </div>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    const VIDEO_API_URL = "${pageContext.request.contextPath}/api/videos";
    const COMMENT_API_URL = "${pageContext.request.contextPath}/api/comment";
    const USER_API_URL = "${pageContext.request.contextPath}/api/userinfo";

    console.log(VIDEO_API_URL);
    console.log(COMMENT_API_URL);
    console.log(USER_API_URL);

    const iframe = document.getElementById("video-frame");

    // ✅ THAY ĐỔI: Khởi tạo biến user ID là null, sẽ load từ API
    let LOGGED_IN_USER_ID = null;
    let LOGGED_IN_USER_DISPLAY_NAME = 'Anonymous';

    // ✅ CẬP NHẬT: Hàm tải thông tin người dùng và hiển thị form comment
    async function fetchUserInfo() {
        try {
            const response = await fetch(USER_API_URL);
            if (!response.ok) {
                console.log("User chưa đăng nhập hoặc API lỗi");
                // Hiển thị prompt đăng nhập
                document.getElementById('login-prompt-section').style.display = 'block';
                return;
            }

            const user = await response.json();

            // ✅ LƯU ID USER THỰC TẾ
            if (user.id) {
                LOGGED_IN_USER_ID = user.id;
                console.log("✅ Logged in user ID:", LOGGED_IN_USER_ID);
            }

            if (user.username) {
                LOGGED_IN_USER_DISPLAY_NAME = user.username;
            }
            console.log("Logged in user display name:", LOGGED_IN_USER_DISPLAY_NAME);

            // Hiển thị form comment
            document.getElementById('comment-form-section').style.display = 'block';

            const commentInput = document.getElementById('comment-input');
            if (commentInput) {
                commentInput.placeholder = `Bình luận với tên ${LOGGED_IN_USER_DISPLAY_NAME}...`;
            }

        } catch (error) {
            console.error("Lỗi khi tải dữ liệu người dùng:", error);
            document.getElementById('login-prompt-section').style.display = 'block';
        }
    }

    //lấy id của video
    function getYouTubeId(url) {
        if (!url) return null;

        // Làm sạch URL: loại bỏ khoảng trắng và dấu nháy kép (nếu dính từ DB)
        url = url.trim().replace(/"/g, '');

        // Regex hỗ trợ nhiều định dạng URL của Youtube
        const patterns = [
            /(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)([a-zA-Z0-9_-]{11})/,
            /youtube\.com\/watch\?.*v=([a-zA-Z0-9_-]{11})/,
            /youtu\.be\/([a-zA-Z0-9_-]{11})/,
            /youtube\.com\/embed\/([a-zA-Z0-9_-]{11})/,
            /youtube\.com\/v\/([a-zA-Z0-9_-]{11})/
        ];

        for (let pattern of patterns) {
            const match = url.match(pattern);
            if (match && match[1]) {
                return match[1];
            }
        }
        return null;
    }

    // ✅ CẬP NHẬT: Hàm render một comment (Đã xóa author-level)
    function renderComment(comment) {
        // Xử lý giá trị null/undefined bằng cách gán giá trị mặc định (||)
        const userName = comment.userName || 'Anonymous';
        const content = comment.content || 'Không có nội dung.';
        const timeAgo = "Vừa xong"; // Giữ nguyên, cần logic tính thời gian thực

        let html = '';
        html += '<div class="comment-item">';
        html += '    <div class="comment-header">';
        html += '        <div>';
        html += '            <span class="comment-author">' + userName + '</span>';
        html += '        </div>';
        html += '        <span class="comment-time">' + timeAgo + '</span>';
        html += '    </div>';
        html += '    <div class="comment-content">';
        html += '        ' + content;
        html += '    </div>';
        html += '</div>';
        return html;
    }

    // THÊM: Hàm tải danh sách comment (Dùng nối chuỗi thuần)
    async function fetchComments(videoId) {
        if (!videoId) return;

        try {
            const response = await fetch(COMMENT_API_URL + "?videoid=" + videoId);
            const contentType = response.headers.get("content-type") || "";
            if (!response.ok) throw new Error("HTTP " + response.status);

            if (!contentType.includes("application/json")) {
                const preview = (await response.text()).slice(0, 200);
                throw new Error("Server không trả JSON: " + preview);
            }

            const comments = await response.json();

            const listContainer = document.getElementById('comments-list');
            listContainer.innerHTML = '';

            if (comments.length === 0) {
                listContainer.innerHTML = '<p class="text-center text-muted">Chưa có bình luận nào.</p>';
            } else {
                // watch.jsp (Logic trong fetchComments)
                comments.forEach(comment => {
                    // Chỉ hiển thị comment cấp 1 (parent_id = null)
                    if (comment.parentCommentId == null) {
                        listContainer.innerHTML += renderComment(comment);
                    }
                });
            }
            document.getElementById('comment-count').textContent = comments.length;

        } catch (error) {
            console.error("Lỗi khi tải bình luận:", error);
            document.getElementById('comments-list').innerHTML =
                '<p class="text-center text-danger">Không thể tải bình luận. Vui lòng thử lại sau.</p>';
        }
    }

    // ✅ CẬP NHẬT: Hàm xử lý việc gửi comment mới
    async function postComment() {
        if (!LOGGED_IN_USER_ID) {
            alert("Vui lòng đăng nhập để bình luận.");
            return;
        }

        const commentInput = document.getElementById('comment-input');
        const content = commentInput.value.trim();
        const videoUrlID = (new URLSearchParams(window.location.search)).get('id');

        if (!content) {
            alert("Vui lòng nhập nội dung bình luận.");
            return;
        }

        const postButton = document.getElementById('post-comment-btn');
        postButton.disabled = true;

        // ✅ SỬ DỤNG ID USER THỰC TẾ TỪ API
        const commentDataJson = JSON.stringify({
            content: content,
            video: { id: parseInt(videoUrlID) },
            user: { id: LOGGED_IN_USER_ID }  // ✅ Dùng ID từ API
        });

        console.log("📤 Sending comment with user ID:", LOGGED_IN_USER_ID);

        try {
            const response = await fetch(COMMENT_API_URL, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: commentDataJson
            });

            if (!response.ok) {
                const errorText = await response.text();
                throw new Error(errorText || "Lỗi khi gửi bình luận.");
            }

            alert("Bình luận đã được gửi thành công!");
            commentInput.value = '';

            await fetchComments(videoUrlID);

        } catch (error) {
            console.error("Lỗi gửi bình luận:", error);
            alert("Gửi bình luận thất bại: " + error.message);
        } finally {
            postButton.disabled = false;
        }
    }


    async function fetchAndPlayVideo() {
        try {
           const videoUrlID = (new URLSearchParams(window.location.search)).get('id');
           console.log(videoUrlID) //in ra url cua video hien tai

            // 🚨 CẬP NHẬT: Sử dụng nối chuỗi thuần
            const response = await fetch(VIDEO_API_URL);

            if (!response.ok) throw new Error("Lỗi kết nối API");
            const videos = await response.json();
            console.log("2. Fetch danh sách video thành công. Tổng số:", videos.length);
            const targetVideo = videos.find(video => video.id == videoUrlID);

            if (!targetVideo) {
                console.error("Không tìm thấy video với ID:", videoUrlID);
                return;
            }

            console.log(targetVideo);
            console.log("ID:", targetVideo.id);
            console.log("Tiêu đề (title):", targetVideo.title);
            document.getElementById('video-title').textContent = targetVideo.title;
            document.getElementById('video-date').textContent = targetVideo.createAt;
            document.getElementById('video-description').textContent = targetVideo.desc;
            console.log("Mô tả (desc):", targetVideo.desc);
            console.log("Poster:", targetVideo.poster);
            console.log("URL Video:", targetVideo.url);
            console.log("URL Video:", getYouTubeId(targetVideo.url));
            console.log("Ngày tạo (createAt):", targetVideo.createAt);
            console.log("Trạng thái (status):", targetVideo.status);

            // Cập nhật iframe src
            iframe.src = "https://www.youtube.com/embed/" + getYouTubeId(targetVideo.url);

            // THÊM: Gọi hàm tải bình luận sau khi có video ID
            await fetchComments(videoUrlID);


        } catch (error) {
            console.error("Lỗi khi tải dữ liệu video:", error);
        }
    }

    // ✅ CẬP NHẬT: Thay thế listener cũ để gọi cả hai hàm
    document.addEventListener('DOMContentLoaded', async () => {
        // Tải thông tin người dùng trước để có tên hiển thị cho comment input
        await fetchUserInfo();
        // Sau đó tải video và bình luận
        await fetchAndPlayVideo();
    });

    // Lắng nghe sự kiện Gửi bình luận
    const postButton = document.getElementById('post-comment-btn');
    if (postButton) {
        postButton.addEventListener('click', postComment);
    }

    </script>
</body>
</html>

