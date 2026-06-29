CREATE VIEW `vw_transaction_audit` AS
    SELECT 
        t.transaction_id,
        t.transaction_type,
        ta.action,
        ta.performed_by,
        ta.timestamp
    FROM
        transactions t
            JOIN
        transaction_audit ta ON t.transaction_id = ta.transaction_id;