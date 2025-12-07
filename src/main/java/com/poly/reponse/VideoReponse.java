package com.poly.reponse;// package com.poly.reponse;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@Data
@NoArgsConstructor
public class VideoReponse {
    private Integer id;
    private String title;
    private String desc;
    private String poster;
    private String url;
    private Date createAt;
    private int status;
}

