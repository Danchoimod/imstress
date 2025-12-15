package com.poly.entities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@AllArgsConstructor
@Entity
@Data
@NoArgsConstructor
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "username", length = 50,unique = false, nullable = false) //trong trường hợp sql không có
    private String username;

    @Column(name = "password", length = 100, unique = false, nullable = false) //nếu sql server nếu gíá trị không có sẫn
    private String password; // mặc định là varchar

    @Column(name = "name",nullable = false,columnDefinition = "NVARCHAR(100)")
    private String name; // Nvarchar

    @Column(name = "phone",nullable = false)
    private String phone;

    @Column(name = "email",nullable = false,unique = true)
    private String email;

    @Column(name = "status", nullable = false)
    private int status = 1;

    @Column(name = "role",nullable = false)
    private int role = 0;

    @OneToMany(mappedBy = "user")
    private List<Video> video;

    @OneToMany(mappedBy = "user")
    private List<Comment> comments;

    @OneToMany(mappedBy = "user")
    private List<Favourites> favorites;
}
