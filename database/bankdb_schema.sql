CREATE DATABASE  IF NOT EXISTS `banking_system` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `banking_system`;
-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: banking_system
-- ------------------------------------------------------
-- Server version	8.4.7

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `account_balance`
--

DROP TABLE IF EXISTS `account_balance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_balance` (
  `account_id` int NOT NULL AUTO_INCREMENT,
  `current_balance` decimal(18,2) NOT NULL,
  `last_update` date NOT NULL,
  PRIMARY KEY (`account_id`),
  UNIQUE KEY `account_id_UNIQUE` (`account_id`),
  CONSTRAINT `fk_balance_account` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`account_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_balance`
--

LOCK TABLES `account_balance` WRITE;
/*!40000 ALTER TABLE `account_balance` DISABLE KEYS */;
INSERT INTO `account_balance` VALUES (1,620000.00,'2026-07-21'),(4,435000.00,'2026-07-21');
/*!40000 ALTER TABLE `account_balance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts` (
  `account_id` int NOT NULL AUTO_INCREMENT,
  `account_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `account_type` enum('saving','current','fixed_deposit') COLLATE utf8mb4_unicode_ci NOT NULL,
  `balance` decimal(18,2) NOT NULL,
  `status` enum('active','frozen','closed','dormant') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_at` date DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`account_id`,`user_id`),
  UNIQUE KEY `account_number_UNIQUE` (`account_number`),
  UNIQUE KEY `account_id_UNIQUE` (`account_id`),
  KEY `fk_Accounts_User_idx` (`user_id`),
  CONSTRAINT `fk_Accounts_User` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (1,'ACC001','saving',620000.00,'active','2025-12-31 21:00:00','2026-07-21',1),(4,'ACC002','saving',435000.00,'active','0000-00-00 00:00:00','2026-07-21',3);
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_account_created` AFTER INSERT ON `accounts` FOR EACH ROW begin 
insert into account_balance (account_id, current_balance, last_update)values(NEW.account_id, NEW.balance, CURDATE());
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_balance_update` AFTER UPDATE ON `accounts` FOR EACH ROW begin if OLD.balance <> NEW.balance then update account_balance set current_balance = NEW.balance, last_update = CURDATE() where account_id = NEW.account_id;
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `ledger_entries`
--

DROP TABLE IF EXISTS `ledger_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ledger_entries` (
  `ledger_id` int NOT NULL AUTO_INCREMENT,
  `entry_type` enum('debit','credit') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` decimal(18,2) NOT NULL,
  `balance_after` decimal(18,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `transaction_id` int NOT NULL,
  `account_id` int NOT NULL,
  PRIMARY KEY (`ledger_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ledger_entries`
--

LOCK TABLES `ledger_entries` WRITE;
/*!40000 ALTER TABLE `ledger_entries` DISABLE KEYS */;
INSERT INTO `ledger_entries` VALUES (1,'credit',200000.00,700000.00,'2026-01-09 21:00:00',1,1),(3,'credit',50000.00,550000.00,'2026-07-08 00:46:33',11,1),(4,'credit',100000.00,650000.00,'2026-07-08 01:01:10',12,1),(6,'debit',5000.00,445000.00,'2026-07-09 17:59:18',14,1),(7,'debit',5000.00,440000.00,'2026-07-09 18:03:53',15,1),(8,'debit',5000.00,435000.00,'2026-07-09 18:32:37',16,1),(9,'credit',50000.00,150000.00,'2026-07-11 20:39:20',21,4),(10,'credit',5000.00,155000.00,'2026-07-11 21:16:01',22,4),(11,'credit',500000.00,880000.00,'2026-07-11 21:20:54',23,1),(12,'debit',80000.00,800000.00,'2026-07-11 21:24:10',24,1),(13,'credit',200000.00,355000.00,'2026-07-11 21:45:16',25,4),(14,'credit',100000.00,700000.00,'2026-07-11 21:48:56',26,1),(15,'credit',700000.00,955000.00,'2026-07-15 15:47:30',27,4),(16,'credit',700000.00,700000.00,'2026-07-15 15:49:09',28,1),(17,'credit',10000.00,710000.00,'2026-07-15 15:50:44',29,1),(18,'credit',10000.00,720000.00,'2026-07-15 18:33:33',30,1),(19,'credit',100000.00,820000.00,'2026-07-15 18:36:55',31,1),(20,'debit',100000.00,720000.00,'2026-07-15 18:37:50',32,1),(21,'debit',100000.00,135000.00,'2026-07-15 18:38:31',33,4),(22,'debit',100000.00,35000.00,'2026-07-15 20:10:47',34,4),(23,'credit',100000.00,135000.00,'2026-07-15 20:11:45',35,4),(24,'credit',100000.00,235000.00,'2026-07-16 20:06:21',38,4),(25,'credit',50000.00,285000.00,'2026-07-16 20:09:29',39,4),(26,'credit',50000.00,335000.00,'2026-07-21 19:40:15',40,4),(27,'credit',50000.00,385000.00,'2026-07-21 20:04:30',41,4),(28,'credit',50000.00,435000.00,'2026-07-21 20:16:22',42,4);
/*!40000 ALTER TABLE `ledger_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pending_transaction`
--

DROP TABLE IF EXISTS `pending_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pending_transaction` (
  `id` int NOT NULL AUTO_INCREMENT,
  `status` enum('queued','processing','completed','failed') COLLATE utf8mb4_unicode_ci NOT NULL,
  `scheduled_time` date DEFAULT NULL,
  `transaction_id` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pending_transaction`
--

LOCK TABLES `pending_transaction` WRITE;
/*!40000 ALTER TABLE `pending_transaction` DISABLE KEYS */;
INSERT INTO `pending_transaction` VALUES (1,'queued','2026-01-12',1),(2,'queued','2026-07-15',34);
/*!40000 ALTER TABLE `pending_transaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction_account`
--

DROP TABLE IF EXISTS `transaction_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction_account` (
  `transfer_id` int NOT NULL AUTO_INCREMENT,
  `from_account_id` int DEFAULT NULL,
  `amount` decimal(18,2) NOT NULL,
  `to_account_id` int DEFAULT NULL,
  `transaction_id` int NOT NULL,
  PRIMARY KEY (`transfer_id`,`transaction_id`),
  KEY `fk_transfer_from_account` (`from_account_id`),
  KEY `fk_transfer_to_account` (`to_account_id`),
  CONSTRAINT `fk_transfer_from_account` FOREIGN KEY (`from_account_id`) REFERENCES `accounts` (`account_id`),
  CONSTRAINT `fk_transfer_to_account` FOREIGN KEY (`to_account_id`) REFERENCES `accounts` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction_account`
--

LOCK TABLES `transaction_account` WRITE;
/*!40000 ALTER TABLE `transaction_account` DISABLE KEYS */;
INSERT INTO `transaction_account` VALUES (1,1,50000.00,4,21),(2,1,5000.00,4,22),(3,1,200000.00,4,25),(4,4,100000.00,1,26),(5,1,700000.00,4,27),(6,4,700000.00,1,28),(7,4,10000.00,1,29),(8,4,10000.00,1,30),(9,1,50000.00,4,39),(10,1,50000.00,4,40),(11,1,50000.00,4,41),(12,1,50000.00,4,42);
/*!40000 ALTER TABLE `transaction_account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction_audit`
--

DROP TABLE IF EXISTS `transaction_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction_audit` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `action` enum('created','updated','reversed','failed') COLLATE utf8mb4_unicode_ci NOT NULL,
  `performed_by` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `transaction_id` int NOT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction_audit`
--

LOCK TABLES `transaction_audit` WRITE;
/*!40000 ALTER TABLE `transaction_audit` DISABLE KEYS */;
INSERT INTO `transaction_audit` VALUES (1,'created','admin','2026-01-11 21:00:00',1,NULL),(2,'created','USER:3','2026-07-16 20:06:21',38,'127.0.0.1'),(3,'updated','SYSTEM','2026-07-16 20:06:21',38,'127.0.0.1'),(4,'created','USER:1','2026-07-16 20:09:29',39,'127.0.0.1'),(5,'updated','SYSTEM','2026-07-16 20:09:29',39,'127.0.0.1'),(6,'created','USER:1','2026-07-21 19:40:15',40,'127.0.0.1'),(7,'updated','SYSTEM','2026-07-21 19:40:15',40,'127.0.0.1'),(8,'created','USER:1','2026-07-21 20:04:30',41,'127.0.0.1'),(9,'updated','SYSTEM','2026-07-21 20:04:30',41,'127.0.0.1'),(10,'created','USER:1','2026-07-21 20:16:22',42,'127.0.0.1'),(11,'updated','SYSTEM','2026-07-21 20:16:22',42,'127.0.0.1'),(12,'reversed','SYSTEM','2026-07-21 20:34:28',48,'127.0.0.1'),(13,'reversed','SYSTEM','2026-07-21 20:51:12',50,'127.0.0.1');
/*!40000 ALTER TABLE `transaction_audit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction_reversals`
--

DROP TABLE IF EXISTS `transaction_reversals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction_reversals` (
  `reversal_id` int NOT NULL AUTO_INCREMENT,
  `original_transaction_id` int NOT NULL,
  `reversal_transaction_id` int DEFAULT NULL,
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `processed_by` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`reversal_id`),
  UNIQUE KEY `original_transaction_id_UNIQUE` (`original_transaction_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction_reversals`
--

LOCK TABLES `transaction_reversals` WRITE;
/*!40000 ALTER TABLE `transaction_reversals` DISABLE KEYS */;
INSERT INTO `transaction_reversals` VALUES (1,1,2,'wrong_entry','2026-01-10 21:00:00','admin'),(4,39,48,'wrong transaction','2026-07-21 20:34:28','USER'),(6,42,50,'wrong transaction','2026-07-21 20:51:12','USER');
/*!40000 ALTER TABLE `transaction_reversals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `transaction_id` int NOT NULL AUTO_INCREMENT,
  `transaction_type` enum('deposit','withdraw','transfer','reversal') COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(18,2) NOT NULL,
  `status` enum('pending','completed','failed','reversal') COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `account_id` int NOT NULL,
  `initiated_by` int NOT NULL,
  PRIMARY KEY (`transaction_id`,`account_id`,`initiated_by`),
  UNIQUE KEY `reference_number_UNIQUE` (`reference_number`),
  KEY `fk_transaction_Accounts1_idx` (`account_id`,`initiated_by`),
  CONSTRAINT `fk_transaction_Accounts1` FOREIGN KEY (`account_id`, `initiated_by`) REFERENCES `accounts` (`account_id`, `user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
INSERT INTO `transactions` VALUES (1,'deposit',200000.00,'','REF001','2026-01-09 21:00:00',1,1),(11,'deposit',50000.00,'completed','DEP-934102','2026-07-08 00:46:33',1,1),(12,'deposit',100000.00,'completed','DEP-3755BE','2026-07-08 01:01:10',1,1),(14,'withdraw',5000.00,'pending','DEP-A15F3E','2026-07-09 17:59:18',1,1),(15,'withdraw',5000.00,'pending','DEP-30C87F','2026-07-09 18:03:53',1,1),(16,'withdraw',5000.00,'completed','DEP-879889','2026-07-09 18:32:37',1,1),(21,'transfer',50000.00,'completed','DEP-AF5ED1','2026-07-11 20:39:20',1,1),(22,'transfer',5000.00,'completed','DEP-977943','2026-07-11 21:16:01',1,1),(23,'deposit',500000.00,'completed','DEP-F66889','2026-07-11 21:20:54',1,1),(24,'withdraw',80000.00,'completed','DEP-5754C6','2026-07-11 21:24:10',1,1),(25,'transfer',200000.00,'completed','DEP-F86364','2026-07-11 21:45:16',1,1),(26,'transfer',100000.00,'completed','DEP-C5B8BC','2026-07-11 21:48:56',4,3),(27,'transfer',700000.00,'completed','DEP-6F12E4','2026-07-15 15:47:30',1,1),(28,'transfer',700000.00,'completed','DEP-27EE7F','2026-07-15 15:49:09',4,3),(29,'transfer',10000.00,'completed','DEP-3F0F30','2026-07-15 15:50:44',4,3),(30,'transfer',10000.00,'completed','DEP-090DD3','2026-07-15 18:33:33',4,3),(31,'deposit',100000.00,'completed','DEP-CEB9CD','2026-07-15 18:36:55',1,1),(32,'withdraw',100000.00,'completed','DEP-1A3A3D','2026-07-15 18:37:50',1,1),(33,'withdraw',100000.00,'completed','DEP-CA15E1','2026-07-15 18:38:31',4,3),(34,'withdraw',100000.00,'completed','DEP-84DD8F','2026-07-15 20:10:47',4,3),(35,'deposit',100000.00,'completed','DEP-BE8A1D','2026-07-15 20:11:45',4,3),(38,'deposit',100000.00,'completed','DEP-362817','2026-07-16 20:06:21',4,3),(39,'transfer',50000.00,'reversal','DEP-9D7E6B','2026-07-16 20:09:29',1,1),(40,'transfer',50000.00,'completed','DEP-212841','2026-07-21 19:40:15',1,1),(41,'transfer',50000.00,'completed','DEP-5850EE','2026-07-21 20:04:30',1,1),(42,'transfer',50000.00,'reversal','DEP-29556A','2026-07-21 20:16:22',1,1),(48,'reversal',50000.00,'pending','DEP-B1807B','2026-07-21 20:34:28',1,1),(50,'reversal',50000.00,'completed','DEP-73294F','2026-07-21 20:51:12',1,1);
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone_number` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('customer','Teller','admin','manager') COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('active','suspended','closed') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_login` date DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'John Doe','john@gmail.com','0771234567','hash1','customer','active','2025-12-31 21:00:00','2026-01-10'),(3,'Joels Mwesigwa','joelmwesigwa@gmail,com','0742991252','JoelsK','customer','active','2026-07-09 20:00:23','2026-01-10');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_account_balance`
--

DROP TABLE IF EXISTS `vw_account_balance`;
/*!50001 DROP VIEW IF EXISTS `vw_account_balance`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_account_balance` AS SELECT 
 1 AS `account_number`,
 1 AS `account_type`,
 1 AS `balance`,
 1 AS `status`,
 1 AS `user_id`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_account_dashboard`
--

DROP TABLE IF EXISTS `vw_account_dashboard`;
/*!50001 DROP VIEW IF EXISTS `vw_account_dashboard`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_account_dashboard` AS SELECT 
 1 AS `full_name`,
 1 AS `account_number`,
 1 AS `account_type`,
 1 AS `balance`,
 1 AS `total_transactions`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_account_transactions`
--

DROP TABLE IF EXISTS `vw_account_transactions`;
/*!50001 DROP VIEW IF EXISTS `vw_account_transactions`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_account_transactions` AS SELECT 
 1 AS `account_number`,
 1 AS `transaction_id`,
 1 AS `transaction_type`,
 1 AS `amount`,
 1 AS `status`,
 1 AS `reference_number`,
 1 AS `created_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_failed_transactions`
--

DROP TABLE IF EXISTS `vw_failed_transactions`;
/*!50001 DROP VIEW IF EXISTS `vw_failed_transactions`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_failed_transactions` AS SELECT 
 1 AS `transaction_id`,
 1 AS `account_id`,
 1 AS `amount`,
 1 AS `transaction_type`,
 1 AS `status`,
 1 AS `created_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_high_value_transactions`
--

DROP TABLE IF EXISTS `vw_high_value_transactions`;
/*!50001 DROP VIEW IF EXISTS `vw_high_value_transactions`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_high_value_transactions` AS SELECT 
 1 AS `transaction_id`,
 1 AS `account_id`,
 1 AS `amount`,
 1 AS `transaction_type`,
 1 AS `status`,
 1 AS `created_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_pending_transactions`
--

DROP TABLE IF EXISTS `vw_pending_transactions`;
/*!50001 DROP VIEW IF EXISTS `vw_pending_transactions`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_pending_transactions` AS SELECT 
 1 AS `id`,
 1 AS `transaction_id`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_transaction_audit`
--

DROP TABLE IF EXISTS `vw_transaction_audit`;
/*!50001 DROP VIEW IF EXISTS `vw_transaction_audit`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_transaction_audit` AS SELECT 
 1 AS `transaction_id`,
 1 AS `transaction_type`,
 1 AS `action`,
 1 AS `performed_by`,
 1 AS `timestamp`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_transaction_details`
--

DROP TABLE IF EXISTS `vw_transaction_details`;
/*!50001 DROP VIEW IF EXISTS `vw_transaction_details`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_transaction_details` AS SELECT 
 1 AS `transaction_id`,
 1 AS `full_name`,
 1 AS `account_number`,
 1 AS `transaction_type`,
 1 AS `amount`,
 1 AS `status`,
 1 AS `reference_number`,
 1 AS `created_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_user_accounts`
--

DROP TABLE IF EXISTS `vw_user_accounts`;
/*!50001 DROP VIEW IF EXISTS `vw_user_accounts`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_user_accounts` AS SELECT 
 1 AS `user_id`,
 1 AS `full_name`,
 1 AS `email`,
 1 AS `account_number`,
 1 AS `account_type`,
 1 AS `balance`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'banking_system'
--

--
-- Final view structure for view `vw_account_balance`
--

/*!50001 DROP VIEW IF EXISTS `vw_account_balance`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_account_balance` AS select `a`.`account_number` AS `account_number`,`a`.`account_type` AS `account_type`,`a`.`balance` AS `balance`,`a`.`status` AS `status`,`a`.`user_id` AS `user_id` from `accounts` `a` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_account_dashboard`
--

/*!50001 DROP VIEW IF EXISTS `vw_account_dashboard`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_account_dashboard` AS select `u`.`full_name` AS `full_name`,`a`.`account_number` AS `account_number`,`a`.`account_type` AS `account_type`,`a`.`balance` AS `balance`,count(`t`.`transaction_id`) AS `total_transactions` from ((`user` `u` join `accounts` `a` on((`u`.`user_id` = `a`.`user_id`))) left join `transactions` `t` on((`a`.`account_id` = `t`.`account_id`))) group by `a`.`account_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_account_transactions`
--

/*!50001 DROP VIEW IF EXISTS `vw_account_transactions`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_account_transactions` AS select `a`.`account_number` AS `account_number`,`t`.`transaction_id` AS `transaction_id`,`t`.`transaction_type` AS `transaction_type`,`t`.`amount` AS `amount`,`t`.`status` AS `status`,`t`.`reference_number` AS `reference_number`,`t`.`created_at` AS `created_at` from (`accounts` `a` join `transactions` `t` on((`a`.`account_id` = `t`.`account_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_failed_transactions`
--

/*!50001 DROP VIEW IF EXISTS `vw_failed_transactions`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_failed_transactions` AS select `transactions`.`transaction_id` AS `transaction_id`,`transactions`.`account_id` AS `account_id`,`transactions`.`amount` AS `amount`,`transactions`.`transaction_type` AS `transaction_type`,`transactions`.`status` AS `status`,`transactions`.`created_at` AS `created_at` from `transactions` where (`transactions`.`status` = 'failed') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_high_value_transactions`
--

/*!50001 DROP VIEW IF EXISTS `vw_high_value_transactions`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_high_value_transactions` AS select `transactions`.`transaction_id` AS `transaction_id`,`transactions`.`account_id` AS `account_id`,`transactions`.`amount` AS `amount`,`transactions`.`transaction_type` AS `transaction_type`,`transactions`.`status` AS `status`,`transactions`.`created_at` AS `created_at` from `transactions` where (`transactions`.`amount` >= 100000) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_pending_transactions`
--

/*!50001 DROP VIEW IF EXISTS `vw_pending_transactions`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_pending_transactions` AS select `pt`.`id` AS `id`,`pt`.`transaction_id` AS `transaction_id`,`pt`.`status` AS `status` from `pending_transaction` `pt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_transaction_audit`
--

/*!50001 DROP VIEW IF EXISTS `vw_transaction_audit`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_transaction_audit` AS select `t`.`transaction_id` AS `transaction_id`,`t`.`transaction_type` AS `transaction_type`,`ta`.`action` AS `action`,`ta`.`performed_by` AS `performed_by`,`ta`.`timestamp` AS `timestamp` from (`transactions` `t` join `transaction_audit` `ta` on((`t`.`transaction_id` = `ta`.`transaction_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_transaction_details`
--

/*!50001 DROP VIEW IF EXISTS `vw_transaction_details`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_transaction_details` AS select `t`.`transaction_id` AS `transaction_id`,`u`.`full_name` AS `full_name`,`a`.`account_number` AS `account_number`,`t`.`transaction_type` AS `transaction_type`,`t`.`amount` AS `amount`,`t`.`status` AS `status`,`t`.`reference_number` AS `reference_number`,`t`.`created_at` AS `created_at` from ((`transactions` `t` join `accounts` `a` on((`t`.`account_id` = `a`.`account_id`))) join `user` `u` on((`a`.`user_id` = `u`.`user_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_user_accounts`
--

/*!50001 DROP VIEW IF EXISTS `vw_user_accounts`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_user_accounts` AS select `u`.`user_id` AS `user_id`,`u`.`full_name` AS `full_name`,`u`.`email` AS `email`,`a`.`account_number` AS `account_number`,`a`.`account_type` AS `account_type`,`a`.`balance` AS `balance`,`a`.`status` AS `status` from (`user` `u` join `accounts` `a` on((`u`.`user_id` = `a`.`user_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-30 18:13:01
