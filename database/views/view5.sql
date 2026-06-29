CREATE VIEW `vw_account_balance` AS
    SELECT 
        a.account_number,
        a.account_type,
        a.balance,
        a.status,
        a.user_id
    FROM
        Accounts a;