CREATE VIEW `vw_pending_transactions` AS
    SELECT 
        pt.id, pt.transaction_id, pt.status
    FROM
        pending_transaction pt;