# lý do không dùng map trong Lgoin
1 không trả lỗi chi tiết vì bảo mật 
# trans .. gì đó 
manager.getTransaction().isActive())
trước khi thực thi phải xác thực 
# query.getSingleResult()
Giá trị trả về: Nó trả về một đối tượng Object duy nhất.
<br>
Nếu truy vấn trả về chính xác một kết quả, nó trả về đối tượng đó.
<br>
Nếu truy vấn không trả về kết quả nào (không tìm thấy user), nó ném ra lỗi NoResultException.
<br>
Nếu truy vấn trả về nhiều hơn một kết quả (lỗi dữ liệu), nó ném ra lỗi NonUniqueResultException.

## lấy nhanh get parameter
Lệnh này tự động lấy các giá trị như username, password, email, phone, name từ Request và gán vào các thuộc tính tương ứng của RegisterBean.
BeanUtils.populate(bean, req.getParameterMap());

