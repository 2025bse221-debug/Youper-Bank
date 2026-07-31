package com.bank.accounts.security;

import com.bank.accounts.model.User;
import com.bank.accounts.model.UserRepository;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Service
public class CurrentUserService {

    private final UserRepository userRepository;

    public CurrentUserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public User getCurrentUser() {
        String identifier = SecurityContextHolder.getContext().getAuthentication().getName();

        return userRepository.findByEmail(identifier)
                .or(() -> userRepository.findByPhoneNumber(identifier))
                .orElseThrow(() -> new RuntimeException("Current authenticated user not found in database"));
    }

}