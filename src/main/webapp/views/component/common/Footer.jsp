<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RoPhim - Footer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-color: #e50914;
--dark-color: #141414;
            --light-color: #f4f4f4;
        }



        .main-content {
            flex: 1;
padding: 2rem 0;
        }

        footer {
            background-color: #111;
padding: 3rem 0 1.5rem;
            margin-top: auto;
        }

        .footer-logo {
            color: var(--primary-color);
font-weight: bold;
            font-size: 1.8rem;
            margin-bottom: 1rem;
            display: block;
        }

        .footer-tagline {
            color: #aaa;
margin-bottom: 1.5rem;
            font-style: italic;
        }

        .footer-links h5 {
            color: var(--light-color);
margin-bottom: 1rem;
            font-size: 1.1rem;
            border-left: 3px solid var(--primary-color);
            padding-left: 10px;
}

        .footer-links ul {
            list-style: none;
padding: 0;
        }

        .footer-links li {
            margin-bottom: 0.7rem;
}

        .footer-links a {
            color: #aaa;
text-decoration: none;
            transition: color 0.3s;
            display: flex;
            align-items: center;
        }

        .footer-links a:hover {
            color: var(--primary-color);
}

        .footer-links a i {
            margin-right: 8px;
font-size: 0.9rem;
        }

        .partner-logos {
            display: flex;
flex-wrap: wrap;
            gap: 15px;
            margin-top: 10px;
        }

        .partner-logo {
            height: 40px;
filter: grayscale(100%);
            opacity: 0.7;
            transition: all 0.3s;
        }

        .partner-logo:hover {
            filter: grayscale(0);
opacity: 1;
        }

        .copyright {
            border-top: 1px solid #333;
padding-top: 1.5rem;
            margin-top: 2rem;
            text-align: center;
            color: #777;
            font-size: 0.9rem;
}

        .social-icons {
            display: flex;
gap: 15px;
            margin-top: 1rem;
        }

        .social-icon {
            display: inline-flex;
align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            background-color: #333;
            border-radius: 50%;
            color: #fff;
            text-decoration: none;
            transition: all 0.3s;
}

        .social-icon:hover {
            background-color: var(--primary-color);
transform: translateY(-3px);
        }

        .description {
            color: #aaa;
line-height: 1.6;
            font-size: 0.9rem;
        }

        @media (max-width: 768px) {
            .footer-links {
                margin-bottom: 2rem;
}
        },
    </style>
</head>
<body>
    <div class="main-content container">
        <div class="text-center">
            <h2 class= "text-light">RoPhim - Phim hay cả rổ</h1>
            <p class="lead">Nội dung trang web sẽ ở đây</p>
        </div>
    </div>

    <footer>

        <div class="container">
            <div class="row">
                <div class="col-lg-4 col-md-6 mb-4">
                    <a href="#" class="footer-logo">RoPhim</a>
                    <p class="footer-tagline">Phim hay cả
rổ</p>
                    <p class="description">
                        RoPhim – Trang xem phim online chất lượng cao miễn phí với phụ đề Vietsub, thuyết minh, lồng tiếng full HD.
Kho phim mới không giới hạn, phim chiếu rạp, phim bộ, phim lẻ từ nhiều quốc gia như Việt Nam, Hàn Quốc,
                        Trung Quốc, Thái Lan, Nhật Bản, Âu Mỹ... đa dạng thể loại.
Khám phá ngay những bộ phim trực tuyến hay nhất 2024 chất lượng 4K.
</p>
                    <div class="social-icons">
                        <a href="#" class="social-icon">
                            <i class="bi bi-facebook"></i>

                        </a>
                        <a href="#" class="social-icon">
                            <i class="bi bi-youtube"></i>
                        </a>

                        <a href="#" class="social-icon">
                            <i class="bi bi-twitter"></i>
                        </a>
                        <a href="#" class="social-icon">

                            <i class="bi bi-instagram"></i>
                        </a>
                    </div>
                </div>

                <div class="col-lg-2 col-md-6 mb-4">
                    <div class="footer-links">
                        <h5>Hội Đập</h5>
                        <ul>

                            <li><a href="#"><i class="bi bi-chevron-right"></i> Chính sách bảo mật</a></li>
                            <li><a href="#"><i class="bi bi-chevron-right"></i> Điều khoản sử dụng</a></li>
                            <li><a href="#"><i class="bi bi-chevron-right"></i> Giới thiệu</a></li>

                            <li><a href="#"><i class="bi bi-chevron-right"></i> Liên hệ</a></li>
                        </ul>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="footer-links">
                        <h5>Thể loại phim</h5>
                        <ul>

                            <li><a href="#"><i class="bi bi-chevron-right"></i> Hành động</a></li>
                            <li><a href="#"><i class="bi bi-chevron-right"></i> Tình cảm</a></li>
                            <li><a href="#"><i class="bi bi-chevron-right"></i> Hài hước</a></li>

                            <li><a href="#"><i class="bi bi-chevron-right"></i> Kinh dị</a></li>
                            <li><a href="#"><i class="bi bi-chevron-right"></i> Viễn tưởng</a></li>
                            <li><a href="#"><i class="bi bi-chevron-right"></i> Hoạt hình</a></li>

                        </ul>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6 mb-4">


                    <div class="footer-links mt-4">
                        <h5>Quốc gia</h5>
                        <ul>

                            <li><a href="#"><i class="bi bi-chevron-right"></i> Việt Nam</a></li>
                            <li><a href="#"><i class="bi bi-chevron-right"></i> Hàn Quốc</a></li>
                            <li><a href="#"><i class="bi bi-chevron-right"></i> Trung Quốc</a></li>

                            <li><a href="#"><i class="bi bi-chevron-right"></i> Âu Mỹ</a></li>
                        </ul>
                    </div>
                </div>

            </div>

            <div class="copyright">
                <p>© 2024 RoPhim.
Tất cả các quyền được bảo lưu.</p>
                <p class="mt-2">Hoàng Sa và Trường Sa là của Việt Nam!</p>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>