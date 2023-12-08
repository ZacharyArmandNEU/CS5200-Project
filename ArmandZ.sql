CREATE DATABASE  IF NOT EXISTS `new_england_ice_cream` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `new_england_ice_cream`;
-- MySQL dump 10.13  Distrib 8.0.34, for macos13 (arm64)
--
-- Host: localhost    Database: new_england_ice_cream
-- ------------------------------------------------------
-- Server version	8.0.34

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
-- Table structure for table `base`
--

DROP TABLE IF EXISTS `base`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `base` (
  `base_name` varchar(64) NOT NULL,
  `base_description` text,
  PRIMARY KEY (`base_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `base`
--

LOCK TABLES `base` WRITE;
/*!40000 ALTER TABLE `base` DISABLE KEYS */;
INSERT INTO `base` VALUES ('Cherry',NULL),('Chocolate',NULL),('French Vanilla','Uses egg yolks, making it distinct fron Vanilla Bean'),('Maple',NULL),('Mint',NULL),('Pistachio',NULL),('Strawberry',NULL),('Vanilla','Standard vanilla, no egg yolk');
/*!40000 ALTER TABLE `base` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chains`
--

DROP TABLE IF EXISTS `chains`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chains` (
  `chain_ID` int NOT NULL AUTO_INCREMENT,
  `brand_name` varchar(64) NOT NULL,
  PRIMARY KEY (`chain_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chains`
--

LOCK TABLES `chains` WRITE;
/*!40000 ALTER TABLE `chains` DISABLE KEYS */;
INSERT INTO `chains` VALUES (1,'J.P. Licks'),(2,'Ben and Jerry\'s'),(3,'Cherry Farm'),(4,'Tipping Cow'),(5,'FoMu');
/*!40000 ALTER TABLE `chains` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flavor_base`
--

DROP TABLE IF EXISTS `flavor_base`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flavor_base` (
  `flavor_ID` int NOT NULL,
  `base_name` varchar(64) NOT NULL,
  UNIQUE KEY `flavor_ID` (`flavor_ID`,`base_name`),
  KEY `base_to_flavor_fk` (`base_name`),
  CONSTRAINT `base_to_flavor_fk` FOREIGN KEY (`base_name`) REFERENCES `base` (`base_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `flavor_to_base_fk` FOREIGN KEY (`flavor_ID`) REFERENCES `flavors` (`flavor_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flavor_base`
--

LOCK TABLES `flavor_base` WRITE;
/*!40000 ALTER TABLE `flavor_base` DISABLE KEYS */;
INSERT INTO `flavor_base` VALUES (6,'Cherry'),(2,'Chocolate'),(7,'Chocolate'),(8,'Chocolate'),(16,'Chocolate'),(13,'French Vanilla'),(5,'Maple'),(15,'Mint'),(12,'Pistachio'),(14,'Strawberry'),(1,'Vanilla'),(3,'Vanilla'),(4,'Vanilla'),(7,'Vanilla'),(9,'Vanilla'),(10,'Vanilla'),(11,'Vanilla');
/*!40000 ALTER TABLE `flavor_base` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flavor_mixin`
--

DROP TABLE IF EXISTS `flavor_mixin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flavor_mixin` (
  `flavor_ID` int NOT NULL,
  `mixin_name` varchar(64) NOT NULL,
  UNIQUE KEY `flavor_ID` (`flavor_ID`,`mixin_name`),
  KEY `mixin_to_flavor_fk` (`mixin_name`),
  CONSTRAINT `flavor_to_mixin_fk` FOREIGN KEY (`flavor_ID`) REFERENCES `flavors` (`flavor_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `mixin_to_flavor_fk` FOREIGN KEY (`mixin_name`) REFERENCES `mixin` (`mixin_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flavor_mixin`
--

LOCK TABLES `flavor_mixin` WRITE;
/*!40000 ALTER TABLE `flavor_mixin` DISABLE KEYS */;
INSERT INTO `flavor_mixin` VALUES (16,'Caramel'),(6,'Cherries'),(3,'Chocolate Chip'),(6,'Chocolate Chip'),(15,'Chocolate Chip'),(16,'Chocolate Chip'),(15,'Chocolate Chip Cookie'),(16,'Fluff'),(5,'Walnuts');
/*!40000 ALTER TABLE `flavor_mixin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flavors`
--

DROP TABLE IF EXISTS `flavors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flavors` (
  `flavor_ID` int NOT NULL AUTO_INCREMENT,
  `flavor_name` varchar(64) NOT NULL,
  `ice_cream_type` enum('Hard Serve','Gelato','Sherbet','Sorbet','Frozen Yogurt','Soft Serve','Other') NOT NULL,
  `chain_ID` int NOT NULL,
  PRIMARY KEY (`flavor_ID`),
  UNIQUE KEY `flavor_name` (`flavor_name`,`ice_cream_type`,`chain_ID`),
  KEY `flavor_chain_fk` (`chain_ID`),
  CONSTRAINT `flavor_chain_fk` FOREIGN KEY (`chain_ID`) REFERENCES `chains` (`chain_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flavors`
--

LOCK TABLES `flavors` WRITE;
/*!40000 ALTER TABLE `flavors` DISABLE KEYS */;
INSERT INTO `flavors` VALUES (6,'Cherry Garcia','Hard Serve',2),(2,'Chocolate','Hard Serve',1),(8,'Chocolate','Soft Serve',3),(3,'Chocolate Chip','Hard Serve',1),(15,'Grasshopper','Hard Serve',5),(5,'Maple Walnut','Hard Serve',2),(16,'Phish Food','Hard Serve',2),(12,'Pistachio','Gelato',4),(13,'Rich Vanilla','Hard Serve',4),(14,'Strawberry','Hard Serve',5),(7,'Swirl','Soft Serve',3),(1,'Vanilla','Hard Serve',1),(9,'Vanilla','Hard Serve',3),(11,'Vanilla','Hard Serve',4),(4,'Vanilla','Soft Serve',1),(10,'Vanilla','Soft Serve',3);
/*!40000 ALTER TABLE `flavors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mixin`
--

DROP TABLE IF EXISTS `mixin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mixin` (
  `mixin_name` varchar(64) NOT NULL,
  `mixin_description` text,
  PRIMARY KEY (`mixin_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mixin`
--

LOCK TABLES `mixin` WRITE;
/*!40000 ALTER TABLE `mixin` DISABLE KEYS */;
INSERT INTO `mixin` VALUES ('Caramel','Caramel swirl'),('Cherries','Chunks of cherry pieces'),('Chocolate Chip',NULL),('Chocolate Chip Cookie',NULL),('Cookie Dough','Chunks of cookie dough'),('Fluff','A fluffy marshmellow swirl'),('Walnuts','Chopped walnuts');
/*!40000 ALTER TABLE `mixin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ratings`
--

DROP TABLE IF EXISTS `ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ratings` (
  `rating_ID` int NOT NULL AUTO_INCREMENT,
  `rating_date` date NOT NULL,
  `stars` enum('1','2','3','4','5') NOT NULL,
  `remarks` text,
  `flavor_ID` int NOT NULL,
  `brand` int NOT NULL,
  `user_ID` int DEFAULT NULL,
  PRIMARY KEY (`rating_ID`),
  UNIQUE KEY `user_ID` (`user_ID`,`flavor_ID`),
  KEY `ratings_flavor_fk` (`flavor_ID`),
  KEY `ratings_chains_fk` (`brand`),
  CONSTRAINT `ratings_chains_fk` FOREIGN KEY (`brand`) REFERENCES `chains` (`chain_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `ratings_flavor_fk` FOREIGN KEY (`flavor_ID`) REFERENCES `flavors` (`flavor_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `ratings_user_fk` FOREIGN KEY (`user_ID`) REFERENCES `users` (`user_ID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ratings`
--

LOCK TABLES `ratings` WRITE;
/*!40000 ALTER TABLE `ratings` DISABLE KEYS */;
INSERT INTO `ratings` VALUES (1,'2023-03-23','4',NULL,4,1,1),(2,'2023-11-30','1','Not great',1,1,1),(3,'2023-11-22','3',NULL,6,2,1),(4,'2023-12-04','4',NULL,1,1,2),(5,'2023-12-01','5','Really Delicious!',10,3,2),(6,'2023-11-12','2','Fairly average',2,1,3);
/*!40000 ALTER TABLE `ratings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_ID` int NOT NULL AUTO_INCREMENT,
  `user_name` varchar(32) NOT NULL,
  `email` varchar(32) NOT NULL,
  `first_name` varchar(32) DEFAULT NULL,
  `last_name` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`user_ID`),
  UNIQUE KEY `user_name` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'ZacharyArmand','armand.z@northeastern.edu','Zachary','Armand'),(2,'Bob123','bob.testing@northeastern.edu','Bob','Testing'),(3,'IceCreamFan123','anonymousicecream@gmail.com','Jim','Smith'),(4,'Steve111','sjg12s@testing.com','Steve','Gustafson'),(5,'JuliannaH','Horiuchi.j@northeastern.edu','Julianna','Horiuchi');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'new_england_ice_cream'
--

--
-- Dumping routines for database 'new_england_ice_cream'
--
/*!50003 DROP FUNCTION IF EXISTS `brand_names_from_chain` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `brand_names_from_chain`(input_chain_id INT) RETURNS varchar(64) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
	DECLARE return_brand_name VARCHAR(64);
	IF NOT EXISTS(SELECT chain_ID FROM chains WHERE chain_ID = input_chain_id) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Chain ID does not exist';
	ELSE
		SELECT brand_name INTO return_brand_name FROM chains WHERE chain_ID = input_chain_id;
        RETURN return_brand_name;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `checker_user_taken` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `checker_user_taken`(user_name_input VARCHAR(32)) RETURNS int
    DETERMINISTIC
BEGIN
	DECLARE return_user_exist INT;
	IF EXISTS(SELECT user_ID FROM users where user_name = user_name_input) THEN
		SELECT 1 INTO return_user_exist;
	ELSE
		SELECT -1 INTO return_user_exist;
	END IF;
    RETURN return_user_exist;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `check_user_exist` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `check_user_exist`(user_name_input VARCHAR(32), email_input VARCHAR(32)) RETURNS int
    DETERMINISTIC
BEGIN
	DECLARE return_user_ID INT;
	IF EXISTS(SELECT user_ID FROM users where user_name = user_name_input AND email = email_input) THEN
		BEGIN
			SELECT user_ID 
            INTO return_user_ID 
            FROM users 
            WHERE user_name = user_name_input AND email = email_input;
			RETURN return_user_ID;
        END;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_user`( 
    IN user_name_input VARCHAR(32),
    IN email_input VARCHAR(32),
    IN first_name_input VARCHAR(32),
    IN last_name_input VARCHAR(32)	
)
BEGIN
	-- Hold results of existence test
    DECLARE user_exists INT;
    -- Check if username already exists
    SELECT COUNT(*) INTO user_exists FROM users WHERE user_name = user_name_input;
    IF user_exists = 0 THEN
        -- If not already existing, insert new user into table
        INSERT INTO users (user_name, email, first_name, last_name)
        VALUES (user_name_input, email_input, first_name_input, last_name_input);
	ELSE
		-- If user already exists, raise error
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Passed username already exists.';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_rating` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_rating`(IN rating_id_input INT)
BEGIN

	IF NOT EXISTS(SELECT rating_ID FROM ratings WHERE rating_ID = rating_id_input) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Rating does not exist';
	ELSE
		DELETE FROM ratings WHERE rating_ID = rating_id_input;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `filter_from_flavors` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `filter_from_flavors`( IN filter_keyword TEXT)
BEGIN
    SET @query = CONCAT('SELECT DISTINCT ', filter_keyword, ' FROM flavors JOIN chains ON flavors.chain_ID = chains.chain_ID');
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `flavors_by_base` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `flavors_by_base`(IN in_base_name VARCHAR(64))
BEGIN
    
    IF NOT EXISTS(SELECT base_name FROM base WHERE base_name = in_base_name) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Base not found';
    ELSE
		SELECT flavors.flavor_name,
			chains.brand_name,
			GROUP_CONCAT(IFNULL(flavor_mixin.mixin_name, "None") SEPARATOR ', ') AS mixins
		FROM flavor_base
		JOIN base ON flavor_base.base_name = base.base_name
		JOIN flavors ON flavor_base.flavor_ID = flavors.flavor_ID
		JOIN chains ON flavors.chain_ID = chains.chain_ID
		LEFT JOIN flavor_mixin ON flavor_base.flavor_ID = flavor_mixin.flavor_ID
		WHERE flavor_base.base_name = in_base_name -- input here
		GROUP BY flavor_name, chains.brand_name
		ORDER BY chains.brand_name;    
	END IF;    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `flavors_by_mixin` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `flavors_by_mixin`(in_mixin_name VARCHAR(64))
BEGIN
	IF (in_mixin_name = 'None') OR (in_mixin_name IS NULL) THEN 
		SELECT 
			flavors.flavor_name,
			chains.brand_name,
			GROUP_CONCAT(flavor_base.base_name SEPARATOR ', ') AS base
		FROM flavor_mixin
		RIGHT JOIN flavors ON flavor_mixin.flavor_ID = flavors.flavor_ID
		LEFT JOIN flavor_base ON flavors.flavor_ID = flavor_base.flavor_ID
		JOIN chains ON flavors.chain_ID = chains.chain_ID
		WHERE flavor_mixin.mixin_name IS NULL
		GROUP BY flavors.flavor_ID, chains.brand_name;
    ELSEIF NOT EXISTS(SELECT mixin_name FROM mixin WHERE mixin_name = in_mixin_name) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Mixin not found';
    ELSE
		SELECT flavors.flavor_name,
			chains.brand_name,
			GROUP_CONCAT(flavor_base.base_name SEPARATOR ', ') AS base
		FROM flavor_mixin
		JOIN mixin ON flavor_mixin.mixin_name = mixin.mixin_name
		JOIN flavors ON flavor_mixin.flavor_ID = flavors.flavor_ID
		JOIN chains ON flavors.chain_ID = chains.chain_ID
		LEFT JOIN flavor_base ON flavor_mixin.flavor_ID = flavor_base.flavor_ID
		WHERE flavor_mixin.mixin_name = in_mixin_name -- input here
		GROUP BY flavor_name, chains.brand_name
		ORDER BY chains.brand_name;  
	END IF;    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `flavor_search_procedure` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `flavor_search_procedure`(IN search_criteria TEXT, IN search_term TEXT)
BEGIN
    -- Check if the search_criteria is a valid field in the flavors table
    IF NOT EXISTS (
        SELECT COLUMN_NAME
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'flavors' AND COLUMN_NAME = search_criteria
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid search criteria. The specified field does not exist in the flavors table.';
    ELSE
        -- If the search_criteria is valid, proceed with the dynamic SQL query
        SET @query = CONCAT('SELECT flavor_name, ice_cream_type FROM flavors WHERE ', search_criteria, ' = ?');
        PREPARE stmt FROM @query;
        SET @search_term = search_term;
        EXECUTE stmt USING @search_term;
        DEALLOCATE PREPARE stmt;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_rating` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_rating`( 
    IN input_user_id INT,
    IN rating_flav_ID INT,
    IN rating_date TEXT,  -- will format in procedure
    IN rating_stars INT,
    IN rating_remarks TEXT
)
BEGIN
	
    DECLARE new_brand_ID INT;
    DECLARE formatted_date DATE;
    
    -- Attempt to convert the input string to a date
    set formatted_date = STR_TO_DATE(rating_date, '%Y-%m-%d');

    IF (formatted_date IS NULL) THEN
        -- Handle the case where the date format is invalid
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid date format. Please use YYYY-MM-DD.',
        MYSQL_ERRNO = '1411';
    ELSE
		-- validate that combination of userID, flavorID doesn't already exist
		IF EXISTS(SELECT user_ID, flavor_ID FROM ratings where user_ID = input_user_id AND flavor_ID = rating_flav_ID) THEN
			SIGNAL SQLSTATE '23000'
			SET MESSAGE_TEXT = 'Rating for this combination of userID and flavorID already exist.',
            MYSQL_ERRNO = '1644';
		ELSE
			
			SELECT chain_ID INTO new_brand_ID
			FROM flavors
			WHERE flavor_ID = rating_flav_ID; 

			INSERT INTO ratings 
			VALUES (NULL, rating_date, rating_stars, rating_remarks, rating_flav_ID, new_brand_ID, input_user_id);
		END IF;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ratings_by_chain` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ratings_by_chain`()
BEGIN
	SELECT 
		brand_name, 
		AVG(CAST(stars AS float)) AS avg_stars
	FROM ratings
	JOIN chains ON ratings.brand = chains.chain_ID
	GROUP BY brand_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ratings_by_flavor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ratings_by_flavor`()
BEGIN
	SELECT 
		flavor_name, 
		AVG(CAST(stars AS float)) AS avg_stars
	FROM ratings
	JOIN flavors ON flavors.flavor_ID = ratings.flavor_ID
	GROUP BY flavor_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ratings_by_table` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ratings_by_table`(IN in_table_name TEXT, IN search_criteria TEXT, IN search_term TEXT)
BEGIN
	set @query = CONCAT(
		'SELECT rating_ID, rating_date, stars, remarks, flavor_name, brand_name
		FROM ratings
		JOIN chains ON chains.chain_ID = ratings.brand
		JOIN flavors ON flavors.flavor_ID = ratings.flavor_ID 
		WHERE ',  in_table_name, '.', search_criteria, ' = ?');
	PREPARE stmt FROM @query;
	SET @search_term = search_term;
EXECUTE stmt USING @search_term;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `rating_id_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `rating_id_user`(IN user_id_input INT)
BEGIN
	IF NOT EXISTS(SELECT user_name FROM users WHERE user_ID = user_id_input) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'User does not exist';
	ELSE
		SELECT rating_ID FROM ratings WHERE user_ID = user_id_input;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `show_brands` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `show_brands`(IN filter_keyword TEXT, filter_criteria TEXT)
BEGIN
    SET @query = CONCAT('SELECT DISTINCT brand_name FROM flavors JOIN chains ON chains.chain_ID = flavors.chain_ID WHERE ', filter_keyword, ' = ?');
    PREPARE stmt FROM @query;
    SET @filter_criteria = filter_criteria;
    EXECUTE stmt USING @filter_criteria;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `show_flavors` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `show_flavors`(IN filter_keyword TEXT, IN filter_criteria TEXT)
BEGIN
    SET @query = CONCAT('SELECT flavor_ID, flavor_name, ice_cream_type, brand_name FROM flavors JOIN chains ON flavors.chain_ID = chains.chain_ID HAVING ', filter_keyword, ' = ?');
    PREPARE stmt FROM @query;
    SET @filter_criteria = filter_criteria;
    EXECUTE stmt USING @filter_criteria;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_ratings` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_ratings`(
	IN input_rating_id INT,
    IN new_stars INT,
    IN new_remarks TEXT
)
BEGIN
    -- Update stars if new_stars is not NULL
    IF new_stars IS NOT NULL THEN
		IF new_stars NOT IN ('1', '2', '3', '4', '5') THEN 
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Stars input not between a number 1 and 5',
            MYSQL_ERRNO = '1644';
		ELSE
			UPDATE ratings SET stars = new_stars WHERE rating_ID = input_rating_id;
		END IF;
    END IF;
    -- Update remarks if new_remarks is not NULL
    IF new_remarks IS NOT NULL THEN
        UPDATE ratings SET remarks = new_remarks WHERE rating_ID = input_rating_id;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_user`(
	IN intput_user_ID INT,
    IN new_email VARCHAR(32),
    IN new_first VARCHAR(32),
    IN new_last VARCHAR(32)
)
BEGIN
    -- Update email if new_email is not NULL
    IF new_email IS NOT NULL THEN
        UPDATE users SET email = new_email WHERE intput_user_ID = user_ID;
    END IF;
    -- Update first name if new_first is not NULL
    IF new_first IS NOT NULL THEN
        UPDATE users SET first_name = new_first WHERE intput_user_ID = user_ID;
    END IF;
    -- Update last name if new_last is not NULL
    IF new_last IS NOT NULL THEN
        UPDATE users SET last_name = new_last WHERE intput_user_ID = user_ID;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_information` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_information`(IN user_name_input INT)
BEGIN

	IF NOT EXISTS(SELECT user_name FROM users WHERE user_ID = user_name_input) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'User does not exist';
	ELSE
		SELECT * FROM users WHERE user_ID = user_name_input;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-12-07 20:38:33
