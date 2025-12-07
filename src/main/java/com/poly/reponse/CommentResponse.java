// File: com.poly.reponse.CommentResponse
package com.poly.reponse;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class CommentResponse {
    private int id;
    private String content;
    private boolean status;
    private String userName; // Tên người dùng bình luận
    private Integer parentCommentId; // ID của comment cha nếu là reply

    private Date createAt; // Giữ lại theo file bạn cung cấp
}