CREATE VIEW `vw_user_accounts` AS select u.user_id,u.full_name,u.email,a.account_number,a.account_type,a.balance,a.status from User u join
Accounts a on u.user_id=a.user_id;