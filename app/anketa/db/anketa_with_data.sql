-- MySQL dump 10.13  Distrib 8.0.26, for macos11 (x86_64)
--
-- Host: localhost    Database: anketa
-- ------------------------------------------------------
-- Server version	8.0.30

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
  `name_of_anketa` longtext NOT NULL,
  `category` longtext NOT NULL,
  PRIMARY KEY (`anketa_id`)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `anketa`
--

LOCK TABLES `anketa` WRITE;
/*!40000 ALTER TABLE `anketa` DISABLE KEYS */;
INSERT INTO `anketa` VALUES (112,'Фізіологічне здоровʼя вашої дитини','Анкета'),(113,'Психологічне здоровʼя вашої дитини','Анкета'),(114,'Чи готова ваша дитина до вступу в ДНЗ?','Анкета');
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
  `name` longtext NOT NULL,
  `surname` longtext NOT NULL,
  `birthday` date NOT NULL,
  `weight` int NOT NULL,
  `height` int NOT NULL,
  `parents_id` int NOT NULL,
  PRIMARY KEY (`children_id`),
  KEY `parents_idx` (`parents_id`),
  CONSTRAINT `parents` FOREIGN KEY (`parents_id`) REFERENCES `parents` (`parents_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `children`
--

LOCK TABLES `children` WRITE;
/*!40000 ALTER TABLE `children` DISABLE KEYS */;
INSERT INTO `children` VALUES (81,'Вʼячеслав','Стельмах','2016-08-03',30,120,41),(82,'Dima','Havrulchyk','2019-09-05',20,90,61),(83,'Oleh','Saniuk','2017-07-20',30,100,61);
/*!40000 ALTER TABLE `children` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `children_answer`
--

DROP TABLE IF EXISTS `children_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `children_answer` (
  `children_answer_id` int NOT NULL AUTO_INCREMENT,
  `children_id` int NOT NULL,
  `list_of_answer_id` int NOT NULL,
  `question_id` int NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`children_answer_id`),
  KEY `children_idx` (`children_id`),
  KEY `list_of_answer_idx` (`list_of_answer_id`),
  KEY `question_id_to_answer_idx` (`question_id`),
  CONSTRAINT `answer_id_list` FOREIGN KEY (`list_of_answer_id`) REFERENCES `list_of_answers` (`list_of_answers_id`) ON UPDATE CASCADE,
  CONSTRAINT `children_and_answer` FOREIGN KEY (`children_id`) REFERENCES `children` (`children_id`) ON UPDATE CASCADE,
  CONSTRAINT `to_question_from_answer` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=636 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `children_answer`
--

LOCK TABLES `children_answer` WRITE;
/*!40000 ALTER TABLE `children_answer` DISABLE KEYS */;
INSERT INTO `children_answer` VALUES (621,83,1749,617,'2022-10-09 10:31:19'),(622,83,1752,618,'2022-10-09 10:31:19'),(623,83,1757,619,'2022-10-09 10:31:19'),(624,83,1760,620,'2022-10-09 10:31:19'),(625,83,1763,621,'2022-10-09 10:31:19'),(626,83,1764,622,'2022-10-09 10:31:19'),(627,83,1768,623,'2022-10-09 10:31:19'),(628,83,1771,624,'2022-10-09 10:31:19'),(629,83,1750,617,'2022-10-09 10:37:22'),(630,83,1752,618,'2022-10-09 10:37:22'),(631,83,1759,620,'2022-10-09 10:37:22'),(632,83,1763,621,'2022-10-09 10:37:22'),(633,83,1764,622,'2022-10-09 10:37:22'),(634,83,1769,623,'2022-10-09 10:37:22'),(635,83,1771,624,'2022-10-09 10:37:22');
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
  `name_of_answer` longtext NOT NULL,
  `question_id` int NOT NULL,
  PRIMARY KEY (`list_of_answers_id`),
  KEY `to_question_id_from_list_of_answer_idx` (`question_id`),
  CONSTRAINT `to_question_id_from_list_of_answer` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1840 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `list_of_answers`
--

LOCK TABLES `list_of_answers` WRITE;
/*!40000 ALTER TABLE `list_of_answers` DISABLE KEYS */;
INSERT INTO `list_of_answers` VALUES (1749,'Так',617),(1750,'Ні',617),(1751,'Частково',617),(1752,'Так',618),(1753,'Ні',618),(1754,'Частково',618),(1755,'Так',619),(1756,'Ні',619),(1757,'Частково',619),(1758,'Так',620),(1759,'Ні',620),(1760,'Інколи',620),(1761,'Так',621),(1762,'Ні',621),(1763,'Інколи',621),(1764,'Так',622),(1765,'Ні',622),(1766,'Частково',622),(1767,'До 21:00',623),(1768,'До 22:00',623),(1769,'Після 22:00',623),(1770,'До 7 годин',624),(1771,'До 8 годин',624),(1772,'Більше 9 годин',624),(1773,'Ніколи',625),(1774,'В окремі дні',625),(1775,'У більш як половину днів',625),(1776,'Майже кожен день',625),(1777,'Ніколи',626),(1778,'В окремі дні',626),(1779,'У більш як половину днів',626),(1780,'Майже кожен день',626),(1781,'Ніколи',627),(1782,'В окремі дні',627),(1783,'У більш як половину днів',627),(1784,'Майже кожен день',627),(1785,'Ніколи',628),(1786,'В окремі дні',628),(1787,'У більш як половину днів',628),(1788,'Майже кожен день',628),(1789,'Ніколи',629),(1790,'В окремі дні',629),(1791,'У більш як половину днів',629),(1792,'Майже кожен день',629),(1793,'Ніколи',630),(1794,'В окремі дні',630),(1795,'У більш як половину днів',630),(1796,'Майже кожен день',630),(1797,'Ніколи',631),(1798,'В окремі дні',631),(1799,'У більш як половину днів',631),(1800,'Майже кожен день',631),(1801,'Бадьорий, урівноважений ',632),(1802,'Нестійкий',632),(1803,'Пригнічений',632),(1804,'Швидко, спокійно (до 10 хв)',633),(1805,'Довго не засинає',633),(1806,'Неспокійно',633),(1807,'Так',634),(1808,'Немає',634),(1809,'2 години',635),(1810,'1 години',635),(1811,'Добрий',636),(1812,'Вибірковий',636),(1813,'Нестійкий',636),(1814,'Поганий',636),(1815,'Позитивно',637),(1816,'Негативно',637),(1817,'Так',638),(1818,'Ні, але ходить суха',638),(1819,'Ні та ходить мокра',638),(1820,'Смокче пустушку або смокче палець, розгойдується',639),(1821,'Немає',639),(1822,'Так',640),(1823,'Іноді',640),(1824,'Ні',640),(1825,'Так',641),(1826,'Іноді',641),(1827,'Ні',641),(1828,'Уміє гратися самостійно',642),(1829,'Не завжди',642),(1830,'Не грається сама',642),(1831,'Легко йде на контакт',643),(1832,'Вибірково',643),(1833,'Важко',643),(1834,'Так',644),(1835,'Не завжди',644),(1836,'Ні',644),(1837,'Є',645),(1838,'Не завжди',645),(1839,'Немає',645);
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
  `first_name` longtext NOT NULL,
  `last_name` longtext NOT NULL,
  `username` longtext NOT NULL,
  `password` longtext NOT NULL,
  `phone` longtext,
  `role` longtext NOT NULL,
  `token` longtext,
  PRIMARY KEY (`parents_id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parents`
--

LOCK TABLES `parents` WRITE;
/*!40000 ALTER TABLE `parents` DISABLE KEYS */;
INSERT INTO `parents` VALUES (41,'Bohdan','Krasko','bohdan','$2a$10$fYjfGZmBT16RkZluwcjBSeTGQs330UUHk8vZKAcAtTEFPFgko5Mja',NULL,'admin','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImJvaGRhbiIsImZpcnN0X25hbWUiOiJCb2hkYW4iLCJsYXN0X25hbWUiOiJLcmFza28iLCJwaG9uZSI6bnVsbCwicm9sZSI6InVzZXIiLCJpYXQiOjE2NjUzMTE0OTQsImV4cCI6MTY2NTM0MDI5NH0.nhL75pvFuQBAwp-kxWr8eM3NUGvdtLZ56d1iaM9ZUCw'),(51,'test','test','test','$2a$10$/9G90pL0bfFPF9OPmR9kHO6mSqQV2SfIb.1950NZ8xKVHUC0DRiwy','+3800000000000','user','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3QiLCJmaXJzdF9uYW1lIjoidGVzdCIsImxhc3RfbmFtZSI6InRlc3QiLCJwaG9uZSI6IiszODAwMDAwMDAwMDAwIiwicm9sZSI6InVzZXIiLCJpYXQiOjE2NDY4MjY0NDksImV4cCI6MTY0Njg1NTI0OX0.zmLiWShGfuI8uynmhwMhmXGgndt8cci4A-xY_mxGuXU'),(61,'Влад','Фурсович','vlad','$2a$10$eZTTf8ErhOnL8WSoJ1NUWubvazVpViSOiVmlKwVKed1/xqIs6DYp6','+380987979479','user','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InZsYWQiLCJmaXJzdF9uYW1lIjoi0JLQu9Cw0LQiLCJsYXN0X25hbWUiOiLQpNGD0YDRgdC-0LLQuNGHIiwicGhvbmUiOiIrMzgwOTg3OTc5NDc5Iiwicm9sZSI6InVzZXIiLCJpYXQiOjE2NjUzMDk0NTIsImV4cCI6MTY2NTMzODI1Mn0.c8t4Edim0Qg92oP21htEVMB37PQZuwREeuuDdDpCHeM'),(62,'Bohdan','Krasko','bohdan_krasko','$2a$10$HL3ApzE/7foMveGE/py33e9Azb6xdGVGFglNwbiQZSG2UeY9rAwQO','+380987979479','user','eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImJvaGRhbl9rcmFza28iLCJmaXJzdF9uYW1lIjoiS3Jhc2tvIiwicGhvbmUiOiIrMzgwOTg3OTc5NDc5Iiwicm9sZSI6InVzZXIiLCJpYXQiOjE2NjUzMTAzOTgsImV4cCI6MTY2NTMzOTE5OH0.5tK2yEoIGvWHoPK4xkS8p0anm02ocJot0WlvNypezpY');
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
  `question` longtext NOT NULL,
  `section_id` int NOT NULL,
  PRIMARY KEY (`question_id`),
  KEY `to_section_id_idx` (`section_id`),
  CONSTRAINT `to_section_id_from_question` FOREIGN KEY (`section_id`) REFERENCES `section` (`section_id`)
) ENGINE=InnoDB AUTO_INCREMENT=646 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question`
--

LOCK TABLES `question` WRITE;
/*!40000 ALTER TABLE `question` DISABLE KEYS */;
INSERT INTO `question` VALUES (617,'Дитина має збалансоване харчування?',262),(618,'Дитині подобається їсти фрукти та овощі?',262),(619,'Дитина має повноційний сніданок?',262),(620,'Чи подобається дитині займатись спортом?',263),(621,'Дитина виконує ранкову зарядку?',263),(622,'Дитина має необхідний спортивний інвентар?',263),(623,'В скільки годин дитина лягає спати?',264),(624,'Скільки часи спить дитина?',264),(625,'Дитина почувається знервовано, тривожно?',265),(626,'Дитина не може позбавитись або контролювати хвилювання?',265),(627,'Дитина хвилювалися надто сильно про різні речі?',265),(628,'Дитині складно розслабитись?',265),(629,'Дитина неспокійна настільки, що не може всидіти на місці?',265),(630,'Дитина легко дратується чи нервується?',265),(631,'Дитина відчуває страх, що може статися щось жахливе?',265),(632,'Який настрій переважає у дитини останнім часом?',266),(633,'Як Ваша дитина засинає?',266),(634,'Чи використовуєте ви додаткову дію, щоб покласти дитину спати (заколисування, колискові і ін.)?',266),(635,'Яка тривалість денного сну дитини?',266),(636,'Який апетит у Вашої дитини?',266),(637,'Як відноситься Ваша дитина до горщика?',266),(638,'Чи проситься Ваша дитина на горщик?',266),(639,'Чи Є у Вашої дитини такі звички?',266),(640,'Чи цікавиться дитина іграшками, речами у новому приміщенні?',266),(641,'Чи виявляє дитина цікавість до дій дорослих?',266),(642,'Як Ваша дитина грається?',266),(643,'Які взаємовідносини з дорослими?',266),(644,'Як відноситься до занять: уважний, активний?',266),(645,'Чи Є у дитини впевненість в собі?',266);
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
  `name_of_section` longtext NOT NULL,
  `anketa_id` int NOT NULL,
  PRIMARY KEY (`section_id`),
  KEY `to_section_idx` (`anketa_id`),
  CONSTRAINT `to_anketa_from_section` FOREIGN KEY (`anketa_id`) REFERENCES `anketa` (`anketa_id`)
) ENGINE=InnoDB AUTO_INCREMENT=267 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `section`
--

LOCK TABLES `section` WRITE;
/*!40000 ALTER TABLE `section` DISABLE KEYS */;
INSERT INTO `section` VALUES (262,'Харчування',112),(263,'Спорт',112),(264,'Сон',112),(265,'Протягом останніх двох тижнів, як часто дитина мала наступні симптоми:',113),(266,'Основні питання',114);
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

-- Dump completed on 2022-10-09 15:21:21
