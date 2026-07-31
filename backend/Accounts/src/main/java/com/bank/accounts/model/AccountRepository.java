package com.bank.accounts.model;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AccountRepository extends JpaRepository<Account, AccountId> {

    List<Account> findByUserId(Integer userId);

}