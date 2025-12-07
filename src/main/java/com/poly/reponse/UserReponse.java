package com.poly.reponse;

import com.poly.entities.User;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UserReponse {
    int id;
    String username;
    String fullname;
    String email;
    String phone;

    public UserReponse(User user) {
    }
}
