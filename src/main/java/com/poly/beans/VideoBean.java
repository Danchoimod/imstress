package com.poly.beans;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.HashMap;
import java.util.Map;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class VideoBean {
    private String title;
    private String url;
    private String poster;
    private String category;
    private String description;

    // THÊM TRƯỜNG videoId
    private String videoId;

    /**
     * Phương thức kiểm tra và trả về Map các lỗi validation.
     * @return Map<String, String> chứa tên trường và thông báo lỗi tương ứng.
     */
    public Map<String, String> getErrors() {
        Map<String, String> errors = new HashMap<>();

        // 1. Kiểm tra Tiêu đề (Bắt buộc)
        if (title == null || title.isBlank()) {
            errors.put("errTitle", "Tiêu đề không được để trống.");
        } else if (title.trim().length() > 255) {
            errors.put("errTitle", "Tiêu đề quá dài (tối đa 255 ký tự).");
        }

        // 2. Kiểm tra URL (Bắt buộc)
        if (url == null || url.isBlank()) {
            errors.put("errUrl", "URL video không được để trống.");
        } else if (!url.matches("^(http|https)://.*$")) {
            errors.put("errUrl", "URL không đúng định dạng (phải bắt đầu bằng http:// hoặc https://).");
        }

        // 3. KIỂM TRA POSTER (BẮT BUỘC theo yêu cầu)
        if (poster == null || poster.isBlank()) {
            errors.put("errPoster", "Ảnh Poster không được để trống.");
        } else if (!poster.matches("^(http|https)://.*$")) { // SỬA LỖI: Nới lỏng kiểm tra regex
            errors.put("errPoster", "URL ảnh poster không đúng định dạng (phải bắt đầu bằng http:// hoặc https://).");
        }

        // 4. Kiểm tra Danh mục (Bắt buộc)
        if (category == null || category.isBlank() || category.equals("Chọn danh mục") || category.equals("")) {
            errors.put("errCategory", "Vui lòng chọn một danh mục.");
        }

        // 5. KIỂM TRA MÔ TẢ (BẮT BUỘC theo yêu cầu)
        if (description == null || description.isBlank()) {
            errors.put("errDescription", "Mô tả không được để trống.");
        } else if (description.trim().length() > 1000) {
            errors.put("errDescription", "Mô tả quá dài (tối đa 1000 ký tự).");
        }


        return errors;
    }
}