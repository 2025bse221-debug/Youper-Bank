package com.bank.accounts.model;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.time.LocalDate;

@Getter
@AllArgsConstructor
public class UserResponse {

    private Integer userId;
    private String fullName;
    private String email;
    private String phoneNumber;
    private String role;
    private String status;
    private LocalDate createdAt;

    public static UserResponse fromUser(User user) {
        return new UserResponse(
                user.getUserId(),
                user.getFullName(),
                user.getEmail(),
                user.getPhoneNumber(),
                user.getRole(),
                user.getStatus(),
                user.getCreatedAt()
        );
    }

}