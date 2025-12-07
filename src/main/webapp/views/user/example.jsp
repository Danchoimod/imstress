<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Example Page</title>
    <style>
        .container { max-width: 800px; margin: 0 auto; padding: 20px; }
        .form-group { margin-bottom: 15px; }
        input[type="text"] { padding: 8px; width: 300px; }
        button { padding: 8px 16px; background: #007bff; color: white; border: none; cursor: pointer; }
        ul { list-style-type: none; padding: 0; }
        li { padding: 8px; border-bottom: 1px solid #eee; }
    </style>
</head>
<body>
    <%@ include file="../common/Header.jsp"%>
    <div class="container">
        <h1>Đây là trang example</h1>

        <form method="post" action="/Java3Demo/example" class="form-group">
            <input type="text" name="exampleinput" placeholder="Nhập giá trị..." required />
            <button type="submit">ADD</button>
        </form>

        <c:choose>
            <c:when test="${not empty map}">
                <h2>Danh sách giá trị đã nhập:</h2>
                <ul>
                    <c:forEach var="entry" items="${map}">
                        <li>${entry.key} : ${entry.value}</li>
<button
    onclick="window.location.href='${pageContext.request.contextPath}/example/delete?id=${entry.key}'"
    class="btn btn-danger btn-sm">
    <i class="bi bi-pencil me-1"></i> xóa
</button>
                           </c:forEach>
                        </li>
                </ul>
            </c:when>
            <c:otherwise>
                <p>Chưa có giá trị nào.</p>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>