<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<style>
.header-logo svg {
    width: 40px;
height: 40px; margin-right: 10px;
}
body {
    background-color: #191b24;
    color: #f4f4f4;
/* Quan trọng: để chữ hiển thị trên nền tối */
}
.header-logo .brand {
    font-size: 1.6rem;
    font-weight: bold;
line-height: 1;
}
.header-logo .subtitle {
    font-size: 0.9rem;
    color: #bdbdbd;
    margin-top: 2px;
}
.menu-badge {
    background: #ffd966;
    color: #222;
    font-size: 0.8rem;
    border-radius: 4px;
    padding: 2px 6px;
    margin-left: 4px;
    font-weight: bold;
}
.header-app svg {
    width: 24px; height: 24px;
}
.header-user svg {
    width: 22px; height: 22px;
}
</style>
<nav class="navbar navbar-expand-lg fixed-top" style="background:#11121a;">

  <div class="container-fluid">
    <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/index">
      <span class="header-logo d-flex align-items-center">
        <svg viewBox="0 0 40 40" fill="none"><circle cx="20" cy="20" r="20" fill="#23232e"/><path d="M13 28c0-4.418 3.582-8 8-8s8 3.582 8 8" stroke="#ffd966" stroke-width="2"/><circle cx="20" cy="16" r="5" fill="#fff" stroke="#ffd966" stroke-width="2"/></svg>
        <span>
          <span class="brand text-white">RoPhim</span><br>
          <span class="subtitle">Phim hay cả rổ</span>
        </span>


    </span>
    </a>
    <button class="navbar-toggler bg-light" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent" aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarContent">
      <form class="d-flex mx-3 flex-grow-1" role="search" style="max-width:420px;">
        <span class="input-group-text bg-dark border-0" style="border-radius:10px 0 0 10px;">
          <svg viewBox="0 0 24 24" fill="none" width="22" height="22"><circle cx="11" cy="11" r="7" stroke="#bdbdbd" stroke-width="2"/><path d="M20 20l-3.5-3.5" stroke="#bdbdbd" stroke-width="2" stroke-linecap="round"/></svg>

</span>
        <input class="form-control
 bg-dark text-white border-0" style="border-radius:0 10px 10px 0;"
type="search" placeholder="Tìm kiếm phim, diễn viên" aria-label="Search">
      </form>
      <ul class="navbar-nav me-auto mb-2 mb-lg-0 align-items-center">
        <%-- ĐÃ XÓA MỤC "PHIM LẺ" VÀ "PHIM BỘ" TẠI ĐÂY --%>

        <%-- Container cho các mục Category/Thể loại (tải bằng JS) --%>
        <div id="categoryNavItems" class="d-flex"></div>


        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle text-white" href="#" id="themDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">Thêm</a>
          <ul class="dropdown-menu" aria-labelledby="themDropdown">
            <li><a class="dropdown-item" href="#">Tin
 tức</a></li>

            <li><a class="dropdown-item" href="#">Liên hệ</a></li>
          </ul>
        </li>
      </ul>
      <div class="d-flex align-items-center gap-2">
        <button class="btn btn-link text-white d-flex align-items-center header-app" style="text-decoration:none;">
          <svg viewBox="0 0 24 24" fill="none"><rect x="4" y="3" width="16" height="18" rx="3" fill="#ffd966"/><rect x="8" y="17" width="8" height="2" rx="1" fill="#fff"/></svg>

 <span class="ms-1">Tải ứng dụng<br><b>RoPhim</b></span>

        </button>
<button onclick="window.location.href='${pageContext.request.contextPath}/profile';"
 class="btn btn-light d-flex align-items-center header-user text-dark">
  <svg viewBox="0 0 24 24" fill="none"><circle cx="12" cy="9" r="4" stroke="#222" stroke-width="2"/><path d="M4 20c0-3.314 3.134-6 7-6s7 2.686 7 6" stroke="#222" stroke-width="2"/></svg>
  <span class="ms-1">Thành viên</span>
</button>
      </div>
    </div>
  </div>
</nav>

<script>
    // Lấy Context Path từ JSP, sử dụng biến JS để nối chuỗi
    const contextPath = '${pageContext.request.contextPath}';
    const API_BASE_URL = contextPath + "/api/category";

    // CHỈ LẤY PHẦN TỬ CONTAINER CỦA CATEGORY
    const categoryNavItems = document.getElementById('categoryNavItems');

    // Hàm fetch và populate navbar
    async function fetchCategories() {
        try {
            const response = await fetch(API_BASE_URL);
            if (!response.ok) {
                // Ném lỗi rõ ràng nếu có lỗi HTTP
                throw new Error("Lỗi kết nối API: " + response.statusText);
            }
            const data = await response.json();

            if (!Array.isArray(data)) {
                console.error("Dữ liệu trả về không phải là mảng:", data);
                return;
            }

            // Xóa nội dung cũ
            categoryNavItems.innerHTML = '';

            data.forEach(item => {
                // Logic kiểm tra $ để loại bỏ các mục Quốc gia
                const isCountry = item.name.startsWith('$');

                // Nếu là Quốc gia (có dấu $), BỎ QUA không render
                if (isCountry) {
                    return; // Bỏ qua mục này
                }

                // Nếu không phải Quốc gia, tiến hành render mục Category
                const listItem = document.createElement('li');
                const link = document.createElement('a');

                listItem.className = 'nav-item';
                link.className = 'nav-link text-white';

                // Tên
                const cleanName = item.name.trim();

                // TẠO URL LỌC:
                link.href = contextPath + "/category?catId=" + item.id;
                link.textContent = cleanName;

                listItem.appendChild(link);
                categoryNavItems.appendChild(listItem);
            });

        } catch (error) {
            console.error('Lỗi khi fetch dữ liệu category:', error);
            // Có thể thêm mục thông báo lỗi trên UI nếu cần
        }
    }

    document.addEventListener('DOMContentLoaded', fetchCategories);

</script>