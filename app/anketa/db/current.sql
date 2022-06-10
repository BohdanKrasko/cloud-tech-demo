-- MySQL dump 10.13  Distrib 8.0.26, for macos11 (x86_64)
--
-- Host: eu-cdbr-west-02.cleardb.net    Database: heroku_5ab3ba97eb04520
-- ------------------------------------------------------
-- Server version	5.6.50-log

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
  `anketa_id` int(11) NOT NULL AUTO_INCREMENT,
  `name_of_anketa` longtext NOT NULL,
  `category` longtext NOT NULL,
  PRIMARY KEY (`anketa_id`)
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `anketa`
--

LOCK TABLES `anketa` WRITE;
/*!40000 ALTER TABLE `anketa` DISABLE KEYS */;
/*!40000 ALTER TABLE `anketa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `children`
--

DROP TABLE IF EXISTS `children`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `children` (
  `children_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` longtext NOT NULL,
  `surname` longtext NOT NULL,
  `birthday` date NOT NULL,
  `weight` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  `parents_id` int(11) NOT NULL,
  PRIMARY KEY (`children_id`),
  KEY `parents_idx` (`parents_id`),
  CONSTRAINT `parents` FOREIGN KEY (`parents_id`) REFERENCES `parents` (`parents_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `children`
--

LOCK TABLES `children` WRITE;
/*!40000 ALTER TABLE `children` DISABLE KEYS */;
INSERT INTO `children` VALUES (21,'user','user','2022-03-01',12,123,21);
/*!40000 ALTER TABLE `children` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `children_answer`
--

DROP TABLE IF EXISTS `children_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `children_answer` (
  `children_answer_id` int(11) NOT NULL AUTO_INCREMENT,
  `children_id` int(11) NOT NULL,
  `list_of_answer_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`children_answer_id`),
  KEY `children_idx` (`children_id`),
  KEY `list_of_answer_idx` (`list_of_answer_id`),
  KEY `question_id_to_answer_idx` (`question_id`),
  CONSTRAINT `answer_id_list` FOREIGN KEY (`list_of_answer_id`) REFERENCES `list_of_answers` (`list_of_answers_id`) ON UPDATE CASCADE,
  CONSTRAINT `children_and_answer` FOREIGN KEY (`children_id`) REFERENCES `children` (`children_id`) ON UPDATE CASCADE,
  CONSTRAINT `to_question_from_answer` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=621 DEFAULT CHARSET=utf8mb4;
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
  `list_of_answers_id` int(11) NOT NULL AUTO_INCREMENT,
  `name_of_answer` longtext NOT NULL,
  `question_id` int(11) NOT NULL,
  PRIMARY KEY (`list_of_answers_id`),
  KEY `to_question_id_from_list_of_answer_idx` (`question_id`),
  CONSTRAINT `to_question_id_from_list_of_answer` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1731 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `list_of_answers`
--

LOCK TABLES `list_of_answers` WRITE;
/*!40000 ALTER TABLE `list_of_answers` DISABLE KEYS */;
/*!40000 ALTER TABLE `list_of_answers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parents`
--

DROP TABLE IF EXISTS `parents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `parents` (
  `parents_id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` longtext NOT NULL,
  `last_name` longtext NOT NULL,
  `username` longtext NOT NULL,
  `password` longtext NOT NULL,
  `phone` longtext,
  `role` longtext NOT NULL,
  `token` longtext,
  PRIMARY KEY (`parents_id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parents`
--

LOCK TABLES `parents` WRITE;
/*!40000 ALTER TABLE `parents` DISABLE KEYS */;
INSERT INTO `parents` VALUES (21,'Андрій','Красько','andriy','$2a$10$3H4amMBee4jkf9oKusaiJu83NV959GeI.tMtYoslcS/53Axmvg85G',NULL,'admin','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFuZHJpeSIsImZpcnN0X25hbWUiOiLQkNC90LTRgNGW0LkiLCJsYXN0X25hbWUiOiLQmtGA0LDRgdGM0LrQviIsInBob25lIjpudWxsLCJyb2xlIjoidXNlciIsImlhdCI6MTY1MzczOTUwMCwiZXhwIjoxNjUzNzY4MzAwfQ.SBEQn75QNzrgZmbgAPXxm3u8_HPP3Nf4dzzK_R7lXHc'),(41,'Bohdan','Krasko','bohdan','$2a$10$fYjfGZmBT16RkZluwcjBSeTGQs330UUHk8vZKAcAtTEFPFgko5Mja',NULL,'admin','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImJvaGRhbiIsImZpcnN0X25hbWUiOiJCb2hkYW4iLCJsYXN0X25hbWUiOiJLcmFza28iLCJwaG9uZSI6bnVsbCwicm9sZSI6InVzZXIiLCJpYXQiOjE2NTMxMjYzNDMsImV4cCI6MTY1MzE1NTE0M30.6lWDpj3U4CqZJpjcZVwTd1NE0w1e6RuLhQDxzxCa3M8'),(51,'test','test','test','$2a$10$/9G90pL0bfFPF9OPmR9kHO6mSqQV2SfIb.1950NZ8xKVHUC0DRiwy','+3800000000000','user','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3QiLCJmaXJzdF9uYW1lIjoidGVzdCIsImxhc3RfbmFtZSI6InRlc3QiLCJwaG9uZSI6IiszODAwMDAwMDAwMDAwIiwicm9sZSI6InVzZXIiLCJpYXQiOjE2NDY4MjY0NDksImV4cCI6MTY0Njg1NTI0OX0.zmLiWShGfuI8uynmhwMhmXGgndt8cci4A-xY_mxGuXU');
/*!40000 ALTER TABLE `parents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question`
--

DROP TABLE IF EXISTS `question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `question` (
  `question_id` int(11) NOT NULL AUTO_INCREMENT,
  `question` longtext NOT NULL,
  `section_id` int(11) NOT NULL,
  PRIMARY KEY (`question_id`),
  KEY `to_section_id_idx` (`section_id`),
  CONSTRAINT `to_section_id_from_question` FOREIGN KEY (`section_id`) REFERENCES `section` (`section_id`)
) ENGINE=InnoDB AUTO_INCREMENT=611 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question`
--

LOCK TABLES `question` WRITE;
/*!40000 ALTER TABLE `question` DISABLE KEYS */;
/*!40000 ALTER TABLE `question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `section`
--

DROP TABLE IF EXISTS `section`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `section` (
  `section_id` int(11) NOT NULL AUTO_INCREMENT,
  `name_of_section` longtext NOT NULL,
  `anketa_id` int(11) NOT NULL,
  PRIMARY KEY (`section_id`),
  KEY `to_section_idx` (`anketa_id`),
  CONSTRAINT `to_anketa_from_section` FOREIGN KEY (`anketa_id`) REFERENCES `anketa` (`anketa_id`)
) ENGINE=InnoDB AUTO_INCREMENT=261 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `section`
--

LOCK TABLES `section` WRITE;
/*!40000 ALTER TABLE `section` DISABLE KEYS */;
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

-- Dump completed on 2022-06-06 21:05:10
