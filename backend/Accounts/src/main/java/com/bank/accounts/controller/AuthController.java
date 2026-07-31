package com.bank.accounts.controller;

import com.bank.accounts.model.SignupRequest;
import com.bank.accounts.model.User;
import com.bank.accounts.model.UserResponse;
import com.bank.accounts.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/signup")
    @ResponseStatus(HttpStatus.CREATED)
    public UserResponse signup(@Valid @RequestBody SignupRequest request) {
        User user = authService.signup(request);
        return UserResponse.fromUser(user);
    }

}