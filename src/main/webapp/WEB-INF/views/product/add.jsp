<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Thêm sản phẩm</title>
    <style>
        body { font-family: system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif; padding: 24px; }
        .container { max-width: 720px; margin: 0 auto; }
        .field { margin-bottom: 14px; }
        label { font-weight: 600; display: block; margin-bottom: 6px; }
        input[type=text], input[type=number], select { width: 100%; padding: 8px 10px; border: 1px solid #ccc; border-radius: 6px; }
        .error { color: #b91c1c; font-size: 13px; margin-top: 4px; }
        .global-error { background: #fee2e2; color: #991b1b; padding: 8px 12px; border-radius: 6px; margin-bottom: 8px; }
        .success { background: #dcfce7; color: #166534; padding: 10px 12px; border-radius: 6px; margin-bottom: 12px; }
        .files { font-size: 12px; color: #334155; }
        .actions { margin-top: 18px; }
        button { background: #0ea5e9; border: none; color: white; padding: 10px 16px; border-radius: 8px; cursor: pointer; }
        button:hover { background: #0284c7; }
    </style>
</head>
<body>
<div class="container">
    <h1>Thêm sản phẩm</h1>

    <c:if test="${not empty success}">
        <div class="success">${success}</div>
    </c:if>

    <c:if test="${not empty globalErrors}">
        <c:forEach var="e" items="${globalErrors}">
            <div class="global-error">${e}</div>
        </c:forEach>
    </c:if>

    <form method="post" enctype="multipart/form-data">
        <div class="field">
            <label for="name">Tên sản phẩm</label>
            <input id="name" name="name" type="text" value="${form.name}" />
            <c:if test="${not empty errors.name}"><div class="error">${errors.name}</div></c:if>
        </div>

        <div class="field">
            <label for="price">Giá sản phẩm (>= 1.000)</label>
            <input id="price" name="price" type="text" value="${form.price}" />
            <c:if test="${not empty errors.price}"><div class="error">${errors.price}</div></c:if>
        </div>

        <div class="field">
            <label for="quantity">Số lượng (> 0)</label>
            <input id="quantity" name="quantity" type="number" min="1" step="1" value="${form.quantity}" />
            <c:if test="${not empty errors.quantity}"><div class="error">${errors.quantity}</div></c:if>
        </div>

        <div class="field">
            <label for="category">Danh mục</label>
            <select id="category" name="category">
                <option value="">-- Chọn danh mục --</option>
                <c:forEach var="c1" items="${categories}">
                    <option value="${c1}" <c:if test='${form.category == c1}'>selected</c:if>>${c1}</option>
                </c:forEach>
            </select>
            <c:if test="${not empty errors.category}"><div class="error">${errors.category}</div></c:if>
        </div>

        <div class="field">
            <label>Hình ảnh sản phẩm (1 đến 5 ảnh; mỗi ảnh <= 20KB)</label>
            <input type="file" name="images" accept="image/*" multiple />
            <c:if test="${not empty errors.images}"><div class="error">${errors.images}</div></c:if>
            <c:if test="${not empty selectedFiles}">
                <div class="files">Đã chọn: <c:forEach var="f" items="${selectedFiles}" varStatus="st">${f}<c:if test="${!st.last}">, </c:if></c:forEach></div>
            </c:if>
        </div>

        <div class="field">
            <label>Trạng thái</label>
            <label><input type="radio" name="status" value="HIDE" <c:if test='${form.status == "HIDE"}'>checked</c:if>/> Ẩn</label>
            <label style="margin-left:12px;"><input type="radio" name="status" value="SHOW" <c:if test='${form.status == "SHOW"}'>checked</c:if>/> Hiển thị</label>
            <c:if test="${not empty errors.status}"><div class="error">${errors.status}</div></c:if>
        </div>

        <div class="actions">
            <button type="submit">Submit</button>
        </div>
    </form>
</div>
</body>
</html>
