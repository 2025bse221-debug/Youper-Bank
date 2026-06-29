CREATE VIEW `vw_account_dashboard` AS
    SELECT 
        u.full_name,
        a.account_number,
        a.account_type,
        a.balance,
        COUNT(t.transaction_id) AS total_transactions
    FROM
        User u
            JOIN
        Accounts a ON u.user_id = a.user_id
            LEFT JOIN
        transactions t ON a.account_id = t.account_id
    GROUP BY a.account_id;