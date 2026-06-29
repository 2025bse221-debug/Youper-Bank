CREATE VIEW `vw_transaction_details` AS
    SELECT 
        t.transaction_id,
        u.full_name,
        a.account_number,
        t.transaction_type,
        t.amount,
        t.status,
        t.reference_number,
        t.created_at
    FROM
        transactions t
            JOIN
        Accounts a ON t.account_id = a.account_id
            JOIN
        User u ON a.user_id = u.user_id;