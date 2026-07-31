package com.bank.accounts.controller;

import com.bank.accounts.model.Account;
import com.bank.accounts.service.AccountService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/accounts")
public class AccountController {

    private final AccountService accountService;

    public AccountController(AccountService accountService) {
        this.accountService = accountService;
    }

    @GetMapping
    public List<Account> getAll() {
        return accountService.findAll();
    }

    @GetMapping("/{accountId}/{userId}")
    public ResponseEntity<Account> getById(@PathVariable Integer accountId, @PathVariable Integer userId) {
        return accountService.findById(accountId, userId)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Account create(@Valid @RequestBody Account account) {
        return accountService.save(account);
    }

    @DeleteMapping("/{accountId}/{userId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable Integer accountId, @PathVariable Integer userId) {
        accountService.deleteById(accountId, userId);
    }

}