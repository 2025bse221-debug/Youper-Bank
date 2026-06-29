CREATE VIEW `vw_failed_transactions` AS
    SELECT 
        transaction_id,
        account_id,
        amount,
        transaction_type,
        status,
        created_at
    FROM
        transactions
    WHERE
        status = 'failed';