-- MySQL dump 10.13  Distrib 8.0.26, for macos11 (x86_64)
--
-- Host: localhost    Database: anketa
-- ------------------------------------------------------
-- Server version	8.0.26

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
-- Table structure for table `anketa`
--

DROP TABLE IF EXISTS `anketa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `anketa` (
  `anketa_id` int NOT NULL AUTO_INCREMENT,
  `name_of_anketa` varchar(45) NOT NULL,
  `category` varchar(45) NOT NULL,
  PRIMARY KEY (`anketa_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `anketa`
--

LOCK TABLES `anketa` WRITE;
/*!40000 ALTER TABLE `anketa` DISABLE KEYS */;
INSERT INTO `anketa` VALUES (1,'anketa_1','health'),(2,'anketa_2','two'),(3,'anketa_3','three');
/*!40000 ALTER TABLE `anketa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `children`
--

DROP TABLE IF EXISTS `children`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `children` (
  `children_id` int NOT NULL AUTO_INCREMENT,
  `parents_id` int NOT NULL,
  `name` varchar(45) NOT NULL,
  `surname` varchar(45) NOT NULL,
  `age` int NOT NULL,
  `weight` int NOT NULL,
  `height` int NOT NULL,
  PRIMARY KEY (`children_id`),
  KEY `childre_to_parents_idx` (`parents_id`),
  CONSTRAINT `childre_to_parents` FOREIGN KEY (`parents_id`) REFERENCES `parents` (`parents_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `children`
--

LOCK TABLES `children` WRITE;
/*!40000 ALTER TABLE `children` DISABLE KEYS */;
/*!40000 ALTER TABLE `children` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `children_and_anketa`
--

DROP TABLE IF EXISTS `children_and_anketa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `children_and_anketa` (
  `children_and_anketa_id` int NOT NULL AUTO_INCREMENT,
  `children_id` int NOT NULL,
  `anketa_id` int NOT NULL,
  PRIMARY KEY (`children_and_anketa_id`),
  KEY `one_idx` (`children_id`),
  KEY `two_idx` (`anketa_id`),
  CONSTRAINT `one` FOREIGN KEY (`children_id`) REFERENCES `children` (`children_id`) ON UPDATE CASCADE,
  CONSTRAINT `two` FOREIGN KEY (`anketa_id`) REFERENCES `anketa` (`anketa_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `children_and_anketa`
--

LOCK TABLES `children_and_anketa` WRITE;
/*!40000 ALTER TABLE `children_and_anketa` DISABLE KEYS */;
/*!40000 ALTER TABLE `children_and_anketa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `children_answer`
--

DROP TABLE IF EXISTS `children_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `children_answer` (
  `user_answer_id` int NOT NULL AUTO_INCREMENT,
  `children_id` int NOT NULL,
  `list_of_answer_id` int NOT NULL,
  PRIMARY KEY (`user_answer_id`),
  KEY `to_list_of_answer_from_user_answer_idx` (`list_of_answer_id`),
  KEY `to_user_from_user_amswer_idx` (`children_id`),
  CONSTRAINT `to_list_of_answer_from_user_answer` FOREIGN KEY (`list_of_answer_id`) REFERENCES `list_of_answers` (`list_of_answers_id`),
  CONSTRAINT `to_user_from_user_amswer` FOREIGN KEY (`children_id`) REFERENCES `children` (`children_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `children_answer`
--

LOCK TABLES `children_answer` WRITE;
/*!40000 ALTER TABLE `children_answer` DISABLE KEYS */;
/*!40000 ALTER TABLE `children_answer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `list_of_answers`
--

DROP TABLE IF EXISTS `list_of_answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `list_of_answers` (
  `list_of_answers_id` int NOT NULL AUTO_INCREMENT,
  `name_of_answer` varchar(45) NOT NULL,
  `question_id` int NOT NULL,
  PRIMARY KEY (`list_of_answers_id`),
  KEY `to_question_id_from_list_of_answer_idx` (`question_id`),
  CONSTRAINT `to_question_id_from_list_of_answer` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `list_of_answers`
--

LOCK TABLES `list_of_answers` WRITE;
/*!40000 ALTER TABLE `list_of_answers` DISABLE KEYS */;
INSERT INTO `list_of_answers` VALUES (11,'tree chaice 1',10),(12,'tree chaice 2',10),(13,'tree two chaice 1',10),(14,'tree two chaice 2',10),(15,'tree chaice 1',12),(16,'tree chaice 2',12),(17,'tree two chaice 1',12),(18,'tree two chaice 2',12),(19,'tree chaice 1',14),(20,'tree chaice 2',14),(21,'tree two chaice 1',14),(22,'tree two chaice 2',14),(23,'tree chaice 1',26),(24,'tree chaice 2',26),(25,'tree two chaice 1',27),(26,'tree two chaice 2',27),(27,'tree two chaice 1',28),(28,'tree two chaice 2',28),(29,'tree chaice 1',29),(30,'tree chaice 2',29),(31,'tree two chaice 1',30),(32,'tree two chaice 2',30),(33,'four 1',31),(34,'four 2',31),(35,'four 3',32),(36,'four 4',32);
/*!40000 ALTER TABLE `list_of_answers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parents`
--

DROP TABLE IF EXISTS `parents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `parents` (
  `parents_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `username` varchar(45) NOT NULL,
  `password` longtext NOT NULL,
  `token` longtext,
  `phone` varchar(45) NOT NULL,
  PRIMARY KEY (`parents_id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parents`
--

LOCK TABLES `parents` WRITE;
/*!40000 ALTER TABLE `parents` DISABLE KEYS */;
INSERT INTO `parents` VALUES (42,'admin','admin','admin','$2a$10$xYRrFKsPBARfavXdzgAN3OjVGaVn4lMVdpIU9i745n.iEqqy2OB4u','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwiZmlyc3RfbmFtZSI6ImFkbWluIiwibGFzdF9uYW1lIjoiYWRtaW4iLCJwaG9uZSI6IiszODA5ODc5Nzk0NzkiLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE2MzI2NzIwMzAsImV4cCI6MTYzMjcwMDgzMH0.G5wRbT8Fpo8zN1jvkspQL2vECg8Om9STz6VwfQLoQpk','+380987979479'),(48,'asdas','asda','qwe','$2a$10$Xb.IY2W5MPyMuOA7vMsDs.ApaH8M.8Z7wSZP28J4g32gR1qyoI51q','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InF3ZSIsImZpcnN0X25hbWUiOiJhc2RhcyIsImxhc3RfbmFtZSI6ImFzZGEiLCJwaG9uZSI6IiszODA5ODc5Nzk0NzkiLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE2MzI1ODA3MDEsImV4cCI6MTYzMjYwOTUwMX0.qQv9jQ-H2HwR-57Pyr7WAM_NW67YuZyzx3Zoms5xxO0','+380987979479');
/*!40000 ALTER TABLE `parents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question`
--

DROP TABLE IF EXISTS `question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `question` (
  `question_id` int NOT NULL AUTO_INCREMENT,
  `question` varchar(200) NOT NULL,
  `section_id` int NOT NULL,
  PRIMARY KEY (`question_id`),
  KEY `to_section_id_idx` (`section_id`),
  CONSTRAINT `to_section_id_from_question` FOREIGN KEY (`section_id`) REFERENCES `section` (`section_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question`
--

LOCK TABLES `question` WRITE;
/*!40000 ALTER TABLE `question` DISABLE KEYS */;
INSERT INTO `question` VALUES (3,'one q',3),(4,'one q',3),(5,'one q',3),(6,'two q',4),(7,'one q',3),(8,'two q',4),(9,'one q',3),(10,'two q',4),(11,'one q',3),(12,'two q',4),(13,'one q',3),(14,'two q',4),(15,'one q',3),(16,'two q',4),(17,'one q',3),(18,'two q',4),(19,'one q',3),(20,'two q',4),(21,'one q',3),(22,'two q',4),(23,'one q',3),(24,'two q',4),(25,'one q',3),(26,'one q',3),(27,'two q',4),(28,'two q',4),(29,'one q',3),(30,'two q',4),(31,'yes 1',3),(32,'yes 2',4);
/*!40000 ALTER TABLE `question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `section`
--

DROP TABLE IF EXISTS `section`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `section` (
  `section_id` int NOT NULL AUTO_INCREMENT,
  `name_of_section` varchar(45) NOT NULL,
  `anketa_id` int NOT NULL,
  PRIMARY KEY (`section_id`),
  KEY `to_section_idx` (`anketa_id`),
  CONSTRAINT `to_anketa_from_section` FOREIGN KEY (`anketa_id`) REFERENCES `anketa` (`anketa_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `section`
--

LOCK TABLES `section` WRITE;
/*!40000 ALTER TABLE `section` DISABLE KEYS */;
INSERT INTO `section` VALUES (3,'name1',1),(4,'name2',1),(5,'name1',1),(6,'name2',1),(7,'name1',1),(8,'name2',1);
/*!40000 ALTER TABLE `section` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-09-26 19:30:23
