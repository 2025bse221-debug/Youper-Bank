package com.bank.accounts.model;

import java.io.Serializable;
import java.util.Objects;

public class AccountId implements Serializable {

    private Integer accountId;
    private Integer userId;

    public AccountId() {
    }

    public AccountId(Integer accountId, Integer userId) {
        this.accountId = accountId;
        this.userId = userId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof AccountId)) return false;
        AccountId that = (AccountId) o;
        return Objects.equals(accountId, that.accountId) && Objects.equals(userId, that.userId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(accountId, userId);
    }

}