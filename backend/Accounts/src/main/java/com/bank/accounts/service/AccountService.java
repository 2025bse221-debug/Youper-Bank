package com.bank.accounts.service;

import com.bank.accounts.model.Account;
import com.bank.accounts.model.AccountId;
import com.bank.accounts.model.AccountRepository;
import com.bank.accounts.model.User;
import com.bank.accounts.security.CurrentUserService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Service
public class AccountService {

    private final AccountRepository accountRepository;
    private final CurrentUserService currentUserService;

    public AccountService(AccountRepository accountRepository, CurrentUserService currentUserService) {
        this.accountRepository = accountRepository;
        this.currentUserService = currentUserService;
    }

    public List<Account> findAll() {
    User currentUser = currentUserService.getCurrentUser();

    boolean isStaff = currentUser.getRole().equalsIgnoreCase("Teller")
            || currentUser.getRole().equalsIgnoreCase("admin")
            || currentUser.getRole().equalsIgnoreCase("manager");

    if (isStaff) {
        return accountRepository.findAll();
    }

    return accountRepository.findByUserId(currentUser.getUserId());
}

    public Optional<Account> findById(Integer accountId, Integer userId) {
        return accountRepository.findById(new AccountId(accountId, userId));
    }

    public Account save(Account account) {
        return accountRepository.save(account);
    }

    public void deleteById(Integer accountId, Integer userId) {
        accountRepository.deleteById(new AccountId(accountId, userId));

        
    }
    @Transactional
public Account getAccountForUpdate(Integer accountId, Integer userId) {

    return accountRepository.findAccountForUpdate(accountId, userId)
            .orElseThrow(() -> new RuntimeException("Account not found"));
}
    @Transactional
public Account updateBalance(
        Integer accountId,
        Integer userId,
        BigDecimal newBalance) {

    Account account = accountRepository
            .findAccountForUpdate(accountId, userId)
            .orElseThrow(() -> new RuntimeException("Account not found"));

    account.setBalance(newBalance);

    return accountRepository.save(account);
}

}
