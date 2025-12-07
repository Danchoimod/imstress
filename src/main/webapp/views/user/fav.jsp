<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý tài khoản - RoPhim</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
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

        .form-label {
            color: #ddd;
            font-weight: 500;
        }

        .form-control, .form-select {
            background-color: #333;
            border: 1px solid #444;
            color: var(--light-color);
        }

        .form-control:focus, .form-select:focus {
            background-color: #333;
            border-color: var(--primary-color);
            color: var(--light-color);
            box-shadow: 0 0 0 0.25rem rgba(229, 9, 20, 0.25);
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

        .avatar-container {
            text-align: center;
            margin-bottom: 2rem;
        }

        .avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid var(--primary-color);
            margin-bottom: 1rem;
        }

        .avatar-upload {
            display: inline-block;
            background-color: var(--primary-color);
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            cursor: pointer;
            font-size: 0.9rem;
        }

        .user-id {
            background-color: #333;
            color: #aaa;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 0.9rem;
            display: inline-block;
            margin-top: 5px;
        }

        .divider {
            border-top: 1px solid #444;
            margin: 2rem 0;
        }

        .gender-option {
            display: flex;
            align-items: center;
            margin-bottom: 0.5rem;
            padding: 0.5rem;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .gender-option:hover {
            background-color: rgba(255, 255, 255, 0.05);
        }

        .gender-option input {
            margin-right: 10px;
        }

        .email-display {
            background-color: #333;
            padding: 10px 15px;
            border-radius: 5px;
            margin-bottom: 1.5rem;
        }

        .email-display a {
            color: var(--primary-color);
            text-decoration: none;
        }

        .update-section {
            text-align: center;
            margin-top: 2rem;
            padding: 2rem;
            border: 2px dashed #555;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .update-section:hover {
            border-color: var(--primary-color);
            background-color: rgba(229, 9, 20, 0.05);
        }

        .update-icon {
            font-size: 2rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <%@ include file="../component/common/Header.jsp"%>
    <div style="padding-top: 80px;" class="profile-container">
        <div class="row">
            <div class="col-lg-3 mb-4">
                <div class="profile-sidebar">
                    <h1 class="logo mb-4" style="color: var(--primary-color); font-weight: bold; font-size: 1.8rem;">RoPhim</h1>
                    <h4 class="mb-3">Cài đặt</h4>
                    <ul class="nav-profile">
                        <li><a href="${pageContext.request.contextPath}/fav" class="active"><i class="bi bi-heart"></i> Yêu thích </a></li>
                        <li><a href="${pageContext.request.contextPath}/profile"><i class="bi bi-person"></i> Tài khoản</a></li>
                        <div class="divider"></div>
                        <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-house"></i> Quản trị viên</a></li>
                        <li><a href="${pageContext.request.contextPath}/login"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a></li>
                    </ul>
                </div>
            </div>

            <div class="col-lg-9">
                <div class="profile-content">

                    <h3 class="section-title">Danh sách Yêu thích</h3>
                    <p class="text-light mb-4">Các bộ phim và chương trình bạn đã thêm vào mục yêu thích.</p>

                    <div class="row g-4">
                        <div class="col-6 col-md-4 col-lg-3">
                            <div class="card video-card">
                                <img src="https://picsum.photos/300/150?random=1" class="card-img-top" alt="Thumbnail Video 1">
                                <div class="video-card-body d-flex justify-content-between align-items-center">
                                    <div class="video-card-title">Chiến dịch giải cứu hành tinh</div>
                                    <i class="bi bi-x-circle-fill remove-btn text-danger" title="Xóa khỏi danh sách"></i>
                                </div>
                            </div>
                        </div>

                        <div class="col-6 col-md-4 col-lg-3">
                            <div class="card video-card">
                                <img src="https://picsum.photos/300/150?random=2" class="card-img-top" alt="Thumbnail Video 2">
                                <div class="video-card-body d-flex justify-content-between align-items-center">
                                    <div class="video-card-title">Người thừa kế bí ẩn</div>
                                    <i class="bi bi-x-circle-fill remove-btn text-danger" title="Xóa khỏi danh sách"></i>
                                </div>
                            </div>
                        </div>

                        <style>
                            .video-card { background-color: #333; border: none; border-radius: 8px; overflow: hidden; }
                            .video-card img { width: 100%; height: 150px; object-fit: cover; }
                            .video-card-body { padding: 1rem; }
                            .video-card-title { font-size: 1rem; font-weight: bold; color: var(--light-color); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
                            .remove-btn { color: var(--primary-color); font-size: 1.2rem; cursor: pointer; }
                        </style>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Logic JS cho trang Yêu thích (xóa item)
        document.querySelectorAll('.remove-btn').forEach(button => {
            button.addEventListener('click', function() {
                const title = this.closest('.video-card').querySelector('.video-card-title').textContent;
                if (confirm(`Bạn có chắc chắn muốn xóa "${title}" khỏi danh sách yêu thích?`)) {
                    // Thêm logic xóa bằng AJAX hoặc chuyển hướng tại đây
                    alert(`Đã xóa ${title}`);
                    // Cập nhật lại giao diện sau khi xóa (ví dụ: xóa thẻ cha)
                    this.closest('.col-lg-3').remove();
                }
            });
        });

        // Loại bỏ các đoạn code JS không liên quan đến trang Yêu thích (Đặt mật khẩu, Đổi Avatar)
    </script>
</body>
</html>