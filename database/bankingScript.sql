-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema banking_system
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema banking_system
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `banking_system` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
USE `banking_system` ;

-- -----------------------------------------------------
-- Table `banking_system`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `banking_system`.`user` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `full_name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NULL DEFAULT NULL,
  `phone_number` VARCHAR(15) NOT NULL,
  `password_hash` VARCHAR(45) NOT NULL,
  `role` ENUM('customer', 'Teller', 'admin', 'manager') NOT NULL,
  `status` ENUM('active', 'suspended', 'closed') NOT NULL,
  `created_at` DATE NOT NULL,
  `last_login` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `banking_system`.`accounts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `banking_system`.`accounts` (
  `account_id` INT NOT NULL AUTO_INCREMENT,
  `account_number` VARCHAR(20) NOT NULL,
  `account_type` ENUM('saving', 'current', 'fixed_deposit') NOT NULL,
  `balance` DECIMAL(18,2) NOT NULL,
  `status` ENUM('active', 'frozen', 'closed', 'dormant') NOT NULL,
  `created_at` DATE NOT NULL,
  `update_at` DATE NULL DEFAULT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`account_id`, `user_id`),
  UNIQUE INDEX `account_number_UNIQUE` (`account_number` ASC) VISIBLE,
  UNIQUE INDEX `account_id_UNIQUE` (`account_id` ASC) VISIBLE,
  INDEX `fk_Accounts_User_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_Accounts_User`
    FOREIGN KEY (`user_id`)
    REFERENCES `banking_system`.`user` (`user_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `banking_system`.`account_balance`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `banking_system`.`account_balance` (
  `account_id` INT NOT NULL AUTO_INCREMENT,
  `current_balance` DECIMAL(18,2) NOT NULL,
  `last_update` DATE NOT NULL,
  PRIMARY KEY (`account_id`),
  UNIQUE INDEX `account_id_UNIQUE` (`account_id` ASC) VISIBLE,
  CONSTRAINT `fk_balance_account`
    FOREIGN KEY (`account_id`)
    REFERENCES `banking_system`.`accounts` (`account_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `banking_system`.`transactions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `banking_system`.`transactions` (
  `transaction_id` INT NOT NULL AUTO_INCREMENT,
  `transaction_type` ENUM('deposit', 'withdraw', 'transfer', 'reversal') NOT NULL,
  `amount` DECIMAL(18,2) NOT NULL,
  `status` ENUM('pending', 'cpmpleted', 'failed', 'reversal') NOT NULL,
  `reference_number` VARCHAR(20) NOT NULL,
  `created_at` DATE NOT NULL,
  `account_id` INT NOT NULL,
  `initiated_by` INT NOT NULL,
  PRIMARY KEY (`transaction_id`, `account_id`, `initiated_by`),
  UNIQUE INDEX `reference_number_UNIQUE` (`reference_number` ASC) VISIBLE,
  INDEX `fk_transaction_Accounts1_idx` (`account_id` ASC, `initiated_by` ASC) VISIBLE,
  CONSTRAINT `fk_transaction_Accounts1`
    FOREIGN KEY (`account_id` , `initiated_by`)
    REFERENCES `banking_system`.`accounts` (`account_id` , `user_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `banking_system`.`ledger_entries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `banking_system`.`ledger_entries` (
  `ledger_id` INT NOT NULL AUTO_INCREMENT,
  `entry_type` ENUM('debit', 'credit') NULL DEFAULT NULL,
  `amount` DECIMAL(18,2) NOT NULL,
  `balance_after` DECIMAL(18,2) NOT NULL,
  `created_at` DATE NOT NULL,
  `transaction_id` INT NOT NULL,
  `account_id` INT NOT NULL,
  PRIMARY KEY (`ledger_id`, `transaction_id`, `account_id`),
  INDEX `fk_ledger_entries_transactions1_idx` (`transaction_id` ASC) VISIBLE,
  INDEX `fk_ledger_entries_accounts1_idx` (`account_id` ASC) VISIBLE,
  CONSTRAINT `fk_ledger_entries_transactions1`
    FOREIGN KEY (`transaction_id`)
    REFERENCES `banking_system`.`transactions` (`transaction_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ledger_entries_accounts1`
    FOREIGN KEY (`account_id`)
    REFERENCES `banking_system`.`accounts` (`account_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `banking_system`.`pending_transaction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `banking_system`.`pending_transaction` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `status` ENUM('queued', 'processing', 'completed', 'failed') NOT NULL,
  `scheduled_time` DATE NULL DEFAULT NULL,
  `transaction_id` INT NOT NULL,
  PRIMARY KEY (`id`, `transaction_id`),
  INDEX `fk_pending_transaction_transactions1_idx` (`transaction_id` ASC) VISIBLE,
  CONSTRAINT `fk_pending_transaction_transactions1`
    FOREIGN KEY (`transaction_id`)
    REFERENCES `banking_system`.`transactions` (`transaction_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `banking_system`.`transaction_account`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `banking_system`.`transaction_account` (
  `transfer_id` INT NOT NULL AUTO_INCREMENT,
  `from_account_id` INT NULL DEFAULT NULL,
  `amount` DECIMAL(18,2) NOT NULL,
  `to_account_id` INT NULL DEFAULT NULL,
  `transaction_id` INT NOT NULL,
  PRIMARY KEY (`transfer_id`, `transaction_id`),
  INDEX `fk_transfer_from_account_idx` (`from_account_id` ASC) VISIBLE,
  INDEX `fk_transfer_to_account_idx` (`to_account_id` ASC) VISIBLE,
  INDEX `fk_transaction_account_transactions1_idx` (`transaction_id` ASC) VISIBLE,
  CONSTRAINT `fk_transfer_from_account`
    FOREIGN KEY (`from_account_id`)
    REFERENCES `banking_system`.`accounts` (`account_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transfer_to_account`
    FOREIGN KEY (`to_account_id`)
    REFERENCES `banking_system`.`accounts` (`account_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transaction_account_transactions1`
    FOREIGN KEY (`transaction_id`)
    REFERENCES `banking_system`.`transactions` (`transaction_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `banking_system`.`transaction_audit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `banking_system`.`transaction_audit` (
  `log_id` INT NOT NULL AUTO_INCREMENT,
  `action` ENUM('created', 'updated', 'reversed', 'failed') NOT NULL,
  `performed_by` VARCHAR(45) NOT NULL,
  `timestamp` DATE NOT NULL,
  `transaction_id` INT NOT NULL,
  PRIMARY KEY (`log_id`, `transaction_id`),
  INDEX `fk_transaction_audit_transactions1_idx` (`transaction_id` ASC) VISIBLE,
  CONSTRAINT `fk_transaction_audit_transactions1`
    FOREIGN KEY (`transaction_id`)
    REFERENCES `banking_system`.`transactions` (`transaction_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `banking_system`.`transaction_reversals`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `banking_system`.`transaction_reversals` (
  `reversal_id` INT NOT NULL AUTO_INCREMENT,
  `original_transaction_id` INT NOT NULL,
  `reversal_transaction_id` INT NULL DEFAULT NULL,
  `reason` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATE NOT NULL,
  `processed_by` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`reversal_id`),
  UNIQUE INDEX `original_transaction_id_UNIQUE` (`original_transaction_id` ASC) VISIBLE,
  INDEX `fk_reversal_new_idx` (`original_transaction_id` ASC, `reversal_transaction_id` ASC) VISIBLE,
  CONSTRAINT `fk_reversal_original`
    FOREIGN KEY (`original_transaction_id`)
    REFERENCES `banking_system`.`transactions` (`transaction_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reversal_new`
    FOREIGN KEY (`original_transaction_id` , `reversal_transaction_id`)
    REFERENCES `banking_system`.`transactions` (`transaction_id` , `transaction_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

USE `banking_system` ;

-- -----------------------------------------------------
-- Placeholder table for view `banking_system`.`vw_user_accounts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `banking_system`.`vw_user_accounts` (`user_id` INT, `full_name` INT, `email` INT, `account_number` INT, `account_type` INT, `balance` INT, `status` INT);

-- -----------------------------------------------------
-- Placeholder table for view `banking_system`.`vw_account_transactions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `banking_system`.`vw_account_transactions` (`account_number` INT, `transaction_id` INT, `transaction_type` INT, `amount` INT, `status` INT, `reference_number` INT, `created_at` INT);

-- -----------------------------------------------------
-- Placeholder table for view `banking_system`.`vw_transaction_audit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `banking_system`.`vw_transaction_audit` (`transaction_id` INT, `transaction_type` INT, `action` INT, `performed_by` INT, `timestamp` INT);

-- -----------------------------------------------------
-- Placeholder table for view `banking_system`.`vw_transaction_details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `banking_system`.`vw_transaction_details` (`transaction_id` INT, `full_name` INT, `account_number` INT, `transaction_type` INT, `amount` INT, `status` INT, `reference_number` INT, `created_at` INT);

-- -----------------------------------------------------
-- Placeholder table for view `banking_system`.`vw_account_balance`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `banking_system`.`vw_account_balance` (`account_number` INT, `account_type` INT, `balance` INT, `status` INT, `user_id` INT);

-- -----------------------------------------------------
-- Placeholder table for view `banking_system`.`vw_high_value_transactions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `banking_system`.`vw_high_value_transactions` (`transaction_id` INT, `account_id` INT, `amount` INT, `transaction_type` INT, `status` INT, `created_at` INT);

-- -----------------------------------------------------
-- Placeholder table for view `banking_system`.`vw_failed_transactions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `banking_system`.`vw_failed_transactions` (`transaction_id` INT, `account_id` INT, `amount` INT, `transaction_type` INT, `status` INT, `created_at` INT);

-- -----------------------------------------------------
-- Placeholder table for view `banking_system`.`vw_pending_transactions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `banking_system`.`vw_pending_transactions` (`id` INT, `transaction_id` INT, `status` INT);

-- -----------------------------------------------------
-- Placeholder table for view `banking_system`.`vw_account_dashboard`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `banking_system`.`vw_account_dashboard` (`full_name` INT, `account_number` INT, `account_type` INT, `balance` INT, `total_transactions` INT);

-- -----------------------------------------------------
-- View `banking_system`.`vw_user_accounts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `banking_system`.`vw_user_accounts`;
USE `banking_system`;
CREATE  OR REPLACE VIEW `vw_user_accounts` AS
    SELECT 
        u.user_id,
        u.full_name,
        u.email,
        a.account_number,
        a.account_type,
        a.balance,
        a.status
    FROM
        User u
            JOIN
        Accounts a ON u.user_id = a.user_id;

-- -----------------------------------------------------
-- View `banking_system`.`vw_account_transactions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `banking_system`.`vw_account_transactions`;
USE `banking_system`;
CREATE  OR REPLACE VIEW `vw_account_transactions` AS
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

-- -----------------------------------------------------
-- View `banking_system`.`vw_transaction_audit`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `banking_system`.`vw_transaction_audit`;
USE `banking_system`;
CREATE  OR REPLACE VIEW `vw_transaction_audit` AS
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

-- -----------------------------------------------------
-- View `banking_system`.`vw_transaction_details`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `banking_system`.`vw_transaction_details`;
USE `banking_system`;
CREATE  OR REPLACE VIEW `vw_transaction_details` AS
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

-- -----------------------------------------------------
-- View `banking_system`.`vw_account_balance`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `banking_system`.`vw_account_balance`;
USE `banking_system`;
CREATE  OR REPLACE VIEW `vw_account_balance` AS
    SELECT 
        a.account_number,
        a.account_type,
        a.balance,
        a.status,
        a.user_id
    FROM
        Accounts a;

-- -----------------------------------------------------
-- View `banking_system`.`vw_high_value_transactions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `banking_system`.`vw_high_value_transactions`;
USE `banking_system`;
CREATE  OR REPLACE VIEW `vw_high_value_transactions` AS
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
        amount >= 100000;

-- -----------------------------------------------------
-- View `banking_system`.`vw_failed_transactions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `banking_system`.`vw_failed_transactions`;
USE `banking_system`;
CREATE  OR REPLACE VIEW `vw_failed_transactions` AS
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

-- -----------------------------------------------------
-- View `banking_system`.`vw_pending_transactions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `banking_system`.`vw_pending_transactions`;
USE `banking_system`;
CREATE  OR REPLACE VIEW `vw_pending_transactions` AS
    SELECT 
        pt.id, pt.transaction_id, pt.status
    FROM
        pending_transaction pt;

-- -----------------------------------------------------
-- View `banking_system`.`vw_account_dashboard`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `banking_system`.`vw_account_dashboard`;
USE `banking_system`;
CREATE  OR REPLACE VIEW `vw_account_dashboard` AS
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

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
