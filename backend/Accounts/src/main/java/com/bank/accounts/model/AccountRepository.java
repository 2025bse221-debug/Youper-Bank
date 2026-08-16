package com.bank.accounts.model;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import jakarta.persistence.LockModeType;
import java.util.List;
import java.util.Optional;

public interface AccountRepository extends JpaRepository<Account, AccountId> {

    List<Account> findByUserId(Integer userId);

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("""
           SELECT a FROM Account a
           WHERE a.accountId = :accountId
           AND a.userId = :userId
           """)
    Optional<Account> findAccountForUpdate(
            @Param("accountId") Integer accountId,
            @Param("userId") Integer userId
    );
}
