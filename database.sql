USE [master];
GO

-- Xóa database nếu tồn tại
IF DB_ID('java4') IS NOT NULL
BEGIN
    ALTER DATABASE java4 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE java4;
END
GO

-- Tạo database mới
CREATE DATABASE java4;
GO

USE java4;
GO

CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(100) NOT NULL,  -- Entity: length=100, unique=true, nullable=false
    password VARCHAR(255) NOT NULL,         -- Entity: length=255, nullable=false
    name NVARCHAR(100) NOT NULL,            -- Entity: NVARCHAR(100), nullable=false
    email VARCHAR(150) NOT NULL UNIQUE,     -- Entity: length=150, unique=true, nullable=false
    phone VARCHAR(12) NOT NULL UNIQUE,      -- Entity: length=12, unique=true, nullable=false
    role INT NOT NULL,                      -- Entity: nullable=false (Default 1)
    status INT NOT NULL                     -- Entity: nullable=false (Default 1)
);
GO

---
-- Bảng 2: categories (Đã sửa ID thành IDENTITY và xóa cột thừa)
---
CREATE TABLE categories (
    id INT IDENTITY(1,1) PRIMARY KEY,       -- Entity: IDENTITY(1,1)
    name NVARCHAR(100) NOT NULL             -- Entity: length=100, nullable=false. (Đã xóa cột description)
);
ALTER TABLE categories ADD status INT NOT NULL DEFAULT 1;
GO

---
-- Bảng 3: videos (Đã sửa tên cột, độ dài, kiểu dữ liệu và thêm khóa ngoại)
---
CREATE TABLE videos (
    id INT IDENTITY(1,1) PRIMARY KEY,                           -- Entity: IDENTITY(1,1)
    title NVARCHAR(1000) NOT NULL,                              -- Entity: NVARCHAR(1000), nullable=false
    content NTEXT NOT NULL,                                     -- Entity: content (ánh xạ từ desc), NTEXT, nullable=false
    poster VARCHAR(255) NOT NULL,                               -- Entity: length=255, nullable=false
    url VARCHAR(255) NOT NULL,                                  -- Entity: length=255, nullable=false
    create_at DATE NOT NULL,                                    -- Entity: create_at (java.sql.Date), nullable=false
    view_count INT NOT NULL,                                    -- Entity: view_count, nullable=false
    status INT NOT NULL,                                        -- Entity: status, nullable=false
    cat_id INT NOT NULL REFERENCES categories(id),              -- Entity: FK (ManyToOne) đến Category
    user_id INT NOT NULL REFERENCES users(id)                   -- Entity: FK (ManyToOne) đến User
);
GO

---
-- Bảng 4: favourites (Đã sửa tên bảng/cột và thêm ràng buộc NOT NULL)
---
CREATE TABLE favourites (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id),                  -- Entity: user_id, nullable=false
    video_id INT NOT NULL REFERENCES videos(id)                 -- Entity: video_id, nullable=false
);
GO

---
-- Bảng 5: comments (Đã sửa tên cột, thêm cột status và ràng buộc NOT NULL)
---
CREATE TABLE comments (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id),                  -- Entity: user_id, nullable=false
    video_id INT NOT NULL REFERENCES videos(id),                -- Entity: video_id, nullable=false
    parent_id INT NULL REFERENCES comments(id),                 -- Entity: parent_id, cho phép NULL
    content NTEXT NOT NULL,                                     -- Entity: NTEXT, nullable=false
    status BIT NOT NULL                                         -- Entity: status (boolean), nullable=false
    -- Đã xóa cột createdAt
);
-- Chèn dữ liệu mẫu cho bảng users
-- Dữ liệu này sử dụng mật khẩu '123' (nên được mã hóa trong thực tế)
-- Role: 1=User, 2=Editer, 3=Admin (theo AuthConfig.java)
-- Status: 1=Active, 0=Locked (theo User.java và AuthConfig.java)
INSERT INTO users (username, password, name, email, phone, role, status)
VALUES
    ('admin', '123', N'Quản Trị Viên', 'admin@poly.com', '0901112223', 3, 1), -- ID=1: Role Admin
    ('editer1', '123', N'Biên Tập Viên A', 'editer1@poly.com', '0902223334', 2, 1), -- ID=2: Role Editer
    ('user1', '123', N'Người Dùng Thường', 'user1@poly.com', '0903334445', 1, 1); -- ID=3: Role User
GO

-- Chèn dữ liệu mẫu cho bảng categories
INSERT INTO categories (name)
VALUES
    (N'Lập Trình Web'), -- ID=1
    (N'Game Review'),    -- ID=2
    (N'Tin Tức'),
    (N'$kinh dị');
GO

-- Chèn dữ liệu mẫu cho bảng videos
    -- cat_id phải tham chiếu đến ID có trong bảng categories (ví dụ: 1, 2, 3)
-- user_id phải tham chiếu đến ID có trong bảng users (ví dụ: 1, 2, 3)
-- status: 1=Hiển thị (Chờ duyệt), 2=Ẩn, 3=Từ chối, 4=Đã duyệt (theo VideoFormBean.java)
INSERT INTO videos (title, content, poster, url, create_at, view_count, status, cat_id, user_id)
VALUES
    -- Video đã duyệt (Status=4) - Hiển thị trên trang chủ
    (N'Hướng Dẫn Java Web Cơ Bản', N'Nội dung chi tiết về cách xây dựng ứng dụng Java Web với Servlet và JSP.', 'poster_java_web.jpg', 'https://www.youtube.com/watch?v=IpDNg7Xj2R4', '2025-11-20', 12500, 4, 1, 2),

    -- Video chờ duyệt (Status=1) - Chỉ Editer và Admin thấy
    (N'Phân Tích Game Cyberpunk 2077', N'Đánh giá chuyên sâu về cốt truyện, đồ họa và gameplay của Cyberpunk 2077 sau bản cập nhật mới nhất.', 'poster_cybperunk.jpg', 'https://www.youtube.com/watch?v=niPkap1ozUA', '2025-11-25', 450, 1, 2, 2),

    -- Video đang ẩn (Status=2) - Chỉ Editer và Admin thấy
    (N'Tin Tức Công Nghệ Nóng Tuần Này', N'Tổng hợp các tin tức công nghệ mới nhất từ Apple, Google và Microsoft.', 'poster_news.jpg', 'https://youtu.be/psZ1g9fMfeo', '2025-11-28', 800, 2, 3, 1);
GO
USE java4;
GO

INSERT INTO comments (user_id, video_id, parent_id, content, status)
VALUES
    -- Comment trên video Java Web (ID=1)
    (3, 1, NULL, N'Bài giảng dễ hiểu quá anh ơi, mong phần nâng cao!', 1), -- ID=1
    (1, 1, 1,    N'Cảm ơn bạn, mình sẽ làm tiếp phần nâng cao nhé!', 1),   -- ID=2 (reply)
    (2, 1, NULL, N'Video chất lượng, đề nghị thêm ví dụ thực tế.', 1),     -- ID=3
    (3, 1, 3,    N'Đúng rồi, mình cũng muốn thêm phần CRUD!', 1),          -- ID=4

    -- Comment trên video Cyberpunk review (ID=2)
    (1, 2, NULL, N'Phân tích rất chi tiết luôn, chấm 10 điểm.', 1),        -- ID=5
    (3, 2, 5,    N'Thật sự bản update 2.0 cải thiện rất tốt.', 1),          -- ID=6
    (2, 2, NULL, N'Có thể nói rõ hơn về bug không ạ?', 1),                  -- ID=7

    -- Comment trên video Tin tức công nghệ (ID=3)
    (3, 3, NULL, N'Apple dạo này ra sản phẩm hơi chán.', 1),                -- ID=8
    (2, 3, NULL, N'Thấy Google tổ chức sự kiện vào tuần sau.', 1),         -- ID=9
    (1, 3, 8,    N'Đúng rồi, toàn nâng cấp nhẹ.', 0),                      -- ID=10 (comment bị ẩn)

    -- Thread nhiều tầng (video 1)
    (3, 1, NULL, N'Anh ơi cho em xin source code ạ.', 1),                  -- ID=11
    (1, 1, 11,   N'Source code mình để trong mô tả video nhé.', 1),        -- ID=12
    (3, 1, 12,   N'Oki anh, em cảm ơn!', 1);                               -- ID=13
GO

use java4;
Select *from users;
select *from comments;
    select *from categories;
select *from favourites;
select *from videos;

SELECT
    (SELECT COUNT(id) FROM users) AS TotalUsers,
    (SELECT COUNT(id) FROM videos) AS TotalVideos,
    (SELECT COUNT(id) FROM comments) AS TotalComments,
    (SELECT COUNT(id) FROM categories) AS TotalCategories;
SELECT *
FROM videos
WHERE cat_id = 2;

Select *from comments
where video_id = 2 and Status = 1 ORDER BY id DESC;
