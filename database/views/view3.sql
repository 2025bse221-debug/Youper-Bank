CREATE VIEW `vw_account_transactions` AS
    SELECT 
        a.account_number,
        t.transaction_id,
        t.transaction_type,
        t.amount,
        t.status,
        t.reference_number,
        t.created_at
    FROM
        Accounts a
            JOIN
        transactions t ON a.account_id = t.account_id;