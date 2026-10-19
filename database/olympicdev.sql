-- CSDL Olympic Tin học (Contests-BE) - dữ liệu mẫu
-- Import: mysql -u root < olympicdev.sql

CREATE DATABASE IF NOT EXISTS `olympicdev` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `olympicdev`;

-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: olympicdev
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `_prisma_migrations`
--

DROP TABLE IF EXISTS `_prisma_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `_prisma_migrations` (
  `id` varchar(36) NOT NULL,
  `checksum` varchar(64) NOT NULL,
  `finished_at` datetime(3) DEFAULT NULL,
  `migration_name` varchar(255) NOT NULL,
  `logs` text DEFAULT NULL,
  `rolled_back_at` datetime(3) DEFAULT NULL,
  `started_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `applied_steps_count` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `_prisma_migrations`
--

LOCK TABLES `_prisma_migrations` WRITE;
/*!40000 ALTER TABLE `_prisma_migrations` DISABLE KEYS */;
INSERT INTO `_prisma_migrations` VALUES ('0496c00c-455d-411d-b14e-e69c1bc2e680','01fc395e933f35b983568ccda4cb3620570bf58b2dd5f31994695b74b4383693','2026-10-19 12:14:26.969','20250710153507_award_add_match_id',NULL,NULL,'2026-10-19 12:14:26.859',1),('5a1ccc52-293b-48de-935b-0cc0d4f1e56c','388a9e3a8be862bdf069bf2c9efb20ef12b67c6a721adc01f3f7ccc967f2e4ec','2026-10-19 12:14:26.858','20250709051314_refactor',NULL,NULL,'2026-10-19 12:14:26.815',1),('6cad1710-c18a-4288-8bde-deb079f4ff26','a3dbedd5f9272a74ffe6633d61a894cf049423ee1e0bb8e6e45d717711eda7f1','2026-10-19 12:14:26.813','20250708180319_update_contestan_winner',NULL,NULL,'2026-10-19 12:14:26.769',1),('9e407fb7-0f07-433b-a5f2-46d9ce24b024','ccdd4196d154ebefc57ee44bfd58be60a4f1060b7d6e07bcffb501ac27009e37','2026-10-19 12:14:26.767','20250708141628_add_screen_controls_statistic',NULL,NULL,'2026-10-19 12:14:26.759',1),('a79f3042-1422-4a84-84cc-234b914e56ae','800b3c17a252ad899a0dba861a9bbe6f5efec69ba8e5bd56a169933c63f77501','2026-10-19 12:14:26.757','20250707001004_init',NULL,NULL,'2026-10-19 12:14:25.131',1),('b34a868e-d335-4963-a1ef-f479f82bee1d','19aa4afc6242a30c6a85564f496ddccfc494008349abcee93521be4711d80865','2026-10-19 12:14:26.976','20250710173815_award_add_match_id',NULL,NULL,'2026-10-19 12:14:26.970',1),('cf8c8bcd-055b-4309-aec5-af7f29f1391a','c5ee781036d8272b2f86c65aac620a34b0788499394b96658113c5466f881785','2026-10-19 12:14:26.986','20250714154008_add_custom_colums_in_matchs',NULL,NULL,'2026-10-19 12:14:26.978',1);
/*!40000 ALTER TABLE `_prisma_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `about`
--

DROP TABLE IF EXISTS `about`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `about` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `schoolName` varchar(255) NOT NULL,
  `website` varchar(255) DEFAULT NULL,
  `departmentName` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `fanpage` varchar(255) DEFAULT NULL,
  `mapEmbedCode` text DEFAULT NULL,
  `logo` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`logo`)),
  `banner` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`banner`)),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `about`
--

LOCK TABLES `about` WRITE;
/*!40000 ALTER TABLE `about` DISABLE KEYS */;
INSERT INTO `about` VALUES (1,'Đài Truyền hình Việt Nam','https://vtv.vn','Ban Sản xuất các chương trình Giáo dục','olympia@vtv.vn','https://facebook.com/OlympiaOfficial','<iframe src=\"https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3724.096750570489!2d105.8342404147706!3d21.02827408599568!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3135ab9bd9861ca1%3A0xe7887f7b72ca17a9!2zVFRYVk4gLSBUcnVuZyB0w6JtIFRydeG7gWkgaGnhu4luaCB2w6AgVGjDtG5nIHRpbiBWaeG7h3QgTmFt!5e0!3m2!1svi!2s!4v1625097600000!5m2!1svi!2s\" width=\"600\" height=\"450\" style=\"border:0;\" allowfullscreen=\"\" loading=\"lazy\"></iframe>','[{\"url\":\"/uploads/about/test-1.png\",\"filename\":\"vtv-logo-main.png\",\"originalName\":\"VTV Logo Main\",\"size\":124856,\"mimeType\":\"image/png\",\"type\":\"image\",\"description\":\"Logo chính của VTV\"},{\"url\":\"/uploads/about/test-2.png\",\"filename\":\"olympia-logo.png\",\"originalName\":\"Olympia Logo\",\"size\":89654,\"mimeType\":\"image/png\",\"type\":\"image\",\"description\":\"Logo chương trình Olympia\"}]','[{\"url\":\"/uploads/about/test-1.jpg\",\"filename\":\"vtv-banner-main.jpg\",\"originalName\":\"VTV Main Banner\",\"size\":456789,\"mimeType\":\"image/jpeg\",\"type\":\"image\",\"description\":\"Banner chính của VTV\"},{\"url\":\"/uploads/about/test-2.jpg\",\"filename\":\"olympia-banner-2025.jpg\",\"originalName\":\"Olympia 2025 Banner\",\"size\":567890,\"mimeType\":\"image/jpeg\",\"type\":\"image\",\"description\":\"Banner Olympia năm 2025\"},{\"url\":\"/uploads/about/olympia-intro-video.mp4\",\"filename\":\"olympia-intro-video.mp4\",\"originalName\":\"Olympia Intro Video\",\"size\":12456789,\"mimeType\":\"video/mp4\",\"type\":\"video\",\"description\":\"Video giới thiệu chương trình Olympia\"}]',1,'2026-10-19 12:14:32.982','2026-10-19 12:14:32.982');
/*!40000 ALTER TABLE `about` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `awards`
--

DROP TABLE IF EXISTS `awards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `awards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `contest_id` int(11) NOT NULL,
  `contestant_id` int(11) DEFAULT NULL,
  `type` enum('firstPrize','secondPrize','thirdPrize') NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `match_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `awards_contest_id_fkey` (`contest_id`),
  KEY `awards_contestant_id_fkey` (`contestant_id`),
  KEY `awards_match_id_fkey` (`match_id`),
  CONSTRAINT `awards_contest_id_fkey` FOREIGN KEY (`contest_id`) REFERENCES `contests` (`id`),
  CONSTRAINT `awards_contestant_id_fkey` FOREIGN KEY (`contestant_id`) REFERENCES `contestants` (`id`),
  CONSTRAINT `awards_match_id_fkey` FOREIGN KEY (`match_id`) REFERENCES `matches` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `awards`
--

LOCK TABLES `awards` WRITE;
/*!40000 ALTER TABLE `awards` DISABLE KEYS */;
INSERT INTO `awards` VALUES (1,'Giải Nhất',1,26,'firstPrize','2026-10-19 12:14:46.234','2026-10-19 12:14:46.234',NULL),(2,'Giải Nhì',1,55,'secondPrize','2026-10-19 12:14:46.234','2026-10-19 12:14:46.234',NULL),(3,'Giải Ba',1,13,'thirdPrize','2026-10-19 12:14:46.234','2026-10-19 12:14:46.234',NULL),(4,'Giải Nhất',2,NULL,'firstPrize','2026-10-19 12:14:46.234','2026-10-19 12:14:46.234',NULL),(5,'Giải Nhì',2,NULL,'secondPrize','2026-10-19 12:14:46.234','2026-10-19 12:14:46.234',NULL),(6,'Giải Ba',2,39,'thirdPrize','2026-10-19 12:14:46.234','2026-10-19 12:14:46.234',NULL),(7,'Giải Nhất',3,45,'firstPrize','2026-10-19 12:14:46.234','2026-10-19 12:14:46.234',NULL),(8,'Giải Nhì',3,95,'secondPrize','2026-10-19 12:14:46.234','2026-10-19 12:14:46.234',NULL),(9,'Giải Ba',3,75,'thirdPrize','2026-10-19 12:14:46.234','2026-10-19 12:14:46.234',NULL);
/*!40000 ALTER TABLE `awards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `class_videos`
--

DROP TABLE IF EXISTS `class_videos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `class_videos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slogan` varchar(255) DEFAULT NULL,
  `classId` int(11) NOT NULL,
  `contestId` int(11) DEFAULT NULL,
  `videos` varchar(191) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `class_Videos_classId_fkey` (`classId`),
  KEY `class_Videos_contestId_fkey` (`contestId`),
  CONSTRAINT `class_Videos_classId_fkey` FOREIGN KEY (`classId`) REFERENCES `classes` (`id`),
  CONSTRAINT `class_Videos_contestId_fkey` FOREIGN KEY (`contestId`) REFERENCES `contests` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class_videos`
--

LOCK TABLES `class_videos` WRITE;
/*!40000 ALTER TABLE `class_videos` DISABLE KEYS */;
INSERT INTO `class_videos` VALUES (1,'Video giới thiệu lớp 10A1 - Trường THPT Nguyễn Huệ','\"Đoàn kết - Sáng tạo - Vượt trội\"',21,NULL,'/videos/classes/class_21_intro.mp4','2026-10-19 12:14:46.221','2026-10-19 12:14:46.221'),(2,'Video giới thiệu lớp 12A1 - Trường THPT Bùi Thị Xuân','\"Đoàn kết - Sáng tạo - Vượt trội\"',10,NULL,'/videos/classes/class_10_intro.mp4','2026-10-19 12:14:46.220','2026-10-19 12:14:46.220'),(3,'Video giới thiệu lớp 10A2 - Trường THPT Lý Thường Kiệt','\"Đoàn kết - Sáng tạo - Vượt trội\"',26,NULL,'/videos/classes/class_26_intro.mp4','2026-10-19 12:14:46.221','2026-10-19 12:14:46.221'),(4,'Video giới thiệu lớp 10A1 - Trường THPT Lê Thánh Tông','\"Đoàn kết - Sáng tạo - Vượt trội\"',7,NULL,'/videos/classes/class_7_intro.mp4','2026-10-19 12:14:46.221','2026-10-19 12:14:46.221'),(5,'Video giới thiệu lớp 10A1 - Trường THPT Trần Phú','\"Đoàn kết - Sáng tạo - Vượt trội\"',3,NULL,'/videos/classes/class_3_intro.mp4','2026-10-19 12:14:46.220','2026-10-19 12:14:46.220'),(6,'Video giới thiệu lớp 12A2 - Trường THPT Lý Thường Kiệt','\"Đoàn kết - Sáng tạo - Vượt trội\"',16,NULL,'/videos/classes/class_16_intro.mp4','2026-10-19 12:14:46.220','2026-10-19 12:14:46.220'),(7,'Video giới thiệu lớp 10A2 - Trường THPT Lê Thánh Tông','\"Đoàn kết - Sáng tạo - Vượt trội\"',22,NULL,'/videos/classes/class_22_intro.mp4','2026-10-19 12:14:46.221','2026-10-19 12:14:46.221'),(8,'Video giới thiệu lớp 11A1 - Trường THPT Lê Thánh Tông','\"Đoàn kết - Sáng tạo - Vượt trội\"',8,NULL,'/videos/classes/class_8_intro.mp4','2026-10-19 12:14:46.221','2026-10-19 12:14:46.221'),(9,'Video giới thiệu lớp 10A2 - Trường THPT Nguyễn Huệ','\"Đoàn kết - Sáng tạo - Vượt trội\"',19,NULL,'/videos/classes/class_19_intro.mp4','2026-10-19 12:14:46.220','2026-10-19 12:14:46.220'),(10,'Video giới thiệu lớp 12A1 - Trường THPT Trần Phú','\"Đoàn kết - Sáng tạo - Vượt trội\"',2,NULL,'/videos/classes/class_2_intro.mp4','2026-10-19 12:14:46.221','2026-10-19 12:14:46.221'),(11,'Video giới thiệu lớp 11A2 - Trường THPT Lý Thường Kiệt','\"Đoàn kết - Sáng tạo - Vượt trội\"',29,NULL,'/videos/classes/class_29_intro.mp4','2026-10-19 12:14:46.221','2026-10-19 12:14:46.221'),(12,'Video giới thiệu lớp 11A1 - Trường THPT Trần Phú','\"Đoàn kết - Sáng tạo - Vượt trội\"',1,NULL,'/videos/classes/class_1_intro.mp4','2026-10-19 12:14:46.221','2026-10-19 12:14:46.221'),(13,'Video giới thiệu lớp 12A2 - Trường THPT Lê Thánh Tông','\"Đoàn kết - Sáng tạo - Vượt trội\"',17,NULL,'/videos/classes/class_17_intro.mp4','2026-10-19 12:14:46.221','2026-10-19 12:14:46.221'),(14,'Video giới thiệu lớp 11A1 - Trường THPT Bùi Thị Xuân','\"Đoàn kết - Sáng tạo - Vượt trội\"',11,NULL,'/videos/classes/class_11_intro.mp4','2026-10-19 12:14:46.221','2026-10-19 12:14:46.221'),(15,'Video giới thiệu lớp 10A1 - Trường THPT Bùi Thị Xuân','\"Đoàn kết - Sáng tạo - Vượt trội\"',9,NULL,'/videos/classes/class_9_intro.mp4','2026-10-19 12:14:46.220','2026-10-19 12:14:46.220'),(16,'Video giới thiệu lớp 10A2 - Trường THPT Bùi Thị Xuân','\"Đoàn kết - Sáng tạo - Vượt trội\"',12,NULL,'/videos/classes/class_12_intro.mp4','2026-10-19 12:14:46.221','2026-10-19 12:14:46.221'),(17,'Video giới thiệu lớp 10A1 - Trường THPT Lý Thường Kiệt','\"Đoàn kết - Sáng tạo - Vượt trội\"',25,NULL,'/videos/classes/class_25_intro.mp4','2026-10-19 12:14:46.221','2026-10-19 12:14:46.221'),(18,'Video giới thiệu lớp 11A2 - Trường THPT Lê Thánh Tông','\"Đoàn kết - Sáng tạo - Vượt trội\"',14,NULL,'/videos/classes/class_14_intro.mp4','2026-10-19 12:14:46.221','2026-10-19 12:14:46.221');
/*!40000 ALTER TABLE `class_videos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `classes`
--

DROP TABLE IF EXISTS `classes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `classes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `schoolId` int(11) NOT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `classes_schoolId_fkey` (`schoolId`),
  CONSTRAINT `classes_schoolId_fkey` FOREIGN KEY (`schoolId`) REFERENCES `schools` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classes`
--

LOCK TABLES `classes` WRITE;
/*!40000 ALTER TABLE `classes` DISABLE KEYS */;
INSERT INTO `classes` VALUES (1,'11A1',1,1,'2026-10-19 12:14:33.005','2026-10-19 12:14:33.005'),(2,'12A1',1,1,'2026-10-19 12:14:33.006','2026-10-19 12:14:33.006'),(3,'10A1',1,1,'2026-10-19 12:14:33.005','2026-10-19 12:14:33.005'),(4,'12A2',1,1,'2026-10-19 12:14:33.006','2026-10-19 12:14:33.006'),(5,'11A2',1,1,'2026-10-19 12:14:33.005','2026-10-19 12:14:33.005'),(6,'10A2',1,1,'2026-10-19 12:14:33.005','2026-10-19 12:14:33.005'),(7,'10A1',3,1,'2026-10-19 12:14:33.006','2026-10-19 12:14:33.006'),(8,'11A1',3,1,'2026-10-19 12:14:33.006','2026-10-19 12:14:33.006'),(9,'10A1',2,1,'2026-10-19 12:14:33.006','2026-10-19 12:14:33.006'),(10,'12A1',2,1,'2026-10-19 12:14:33.006','2026-10-19 12:14:33.006'),(11,'11A1',2,1,'2026-10-19 12:14:33.006','2026-10-19 12:14:33.006'),(12,'10A2',2,1,'2026-10-19 12:14:33.006','2026-10-19 12:14:33.006'),(13,'11A1',4,1,'2026-10-19 12:14:33.006','2026-10-19 12:14:33.006'),(14,'11A2',3,1,'2026-10-19 12:14:33.006','2026-10-19 12:14:33.006'),(15,'11A2',2,1,'2026-10-19 12:14:33.006','2026-10-19 12:14:33.006'),(16,'12A2',4,1,'2026-10-19 12:14:33.006','2026-10-19 12:14:33.006'),(17,'12A2',3,1,'2026-10-19 12:14:33.006','2026-10-19 12:14:33.006'),(18,'12A1',5,1,'2026-10-19 12:14:33.006','2026-10-19 12:14:33.006'),(19,'10A2',5,1,'2026-10-19 12:14:33.006','2026-10-19 12:14:33.006'),(20,'11A2',5,1,'2026-10-19 12:14:33.006','2026-10-19 12:14:33.006'),(21,'10A1',5,1,'2026-10-19 12:14:33.006','2026-10-19 12:14:33.006'),(22,'10A2',3,1,'2026-10-19 12:14:33.006','2026-10-19 12:14:33.006'),(23,'12A1',3,1,'2026-10-19 12:14:33.006','2026-10-19 12:14:33.006'),(24,'12A1',4,1,'2026-10-19 12:14:33.006','2026-10-19 12:14:33.006'),(25,'10A1',4,1,'2026-10-19 12:14:33.006','2026-10-19 12:14:33.006'),(26,'10A2',4,1,'2026-10-19 12:14:33.006','2026-10-19 12:14:33.006'),(27,'11A1',5,1,'2026-10-19 12:14:33.007','2026-10-19 12:14:33.007'),(28,'12A2',2,1,'2026-10-19 12:14:33.006','2026-10-19 12:14:33.006'),(29,'11A2',4,1,'2026-10-19 12:14:33.006','2026-10-19 12:14:33.006'),(30,'12A2',5,1,'2026-10-19 12:14:33.007','2026-10-19 12:14:33.007');
/*!40000 ALTER TABLE `classes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contestant_matches`
--

DROP TABLE IF EXISTS `contestant_matches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contestant_matches` (
  `contestantId` int(11) NOT NULL,
  `matchId` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `registrationNumber` int(11) NOT NULL,
  `status` enum('not_started','in_progress','confirmed1','confirmed2','eliminated','rescued','banned','completed') NOT NULL DEFAULT 'not_started',
  `eliminatedAtQuestionOrder` int(11) DEFAULT NULL,
  `rescuedAtQuestionOrder` int(11) DEFAULT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`contestantId`,`matchId`),
  KEY `contestant_Matches_matchId_fkey` (`matchId`),
  KEY `contestant_Matches_groupId_fkey` (`groupId`),
  CONSTRAINT `contestant_Matches_contestantId_fkey` FOREIGN KEY (`contestantId`) REFERENCES `contestants` (`id`),
  CONSTRAINT `contestant_Matches_groupId_fkey` FOREIGN KEY (`groupId`) REFERENCES `groups` (`id`),
  CONSTRAINT `contestant_Matches_matchId_fkey` FOREIGN KEY (`matchId`) REFERENCES `matches` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contestant_matches`
--

LOCK TABLES `contestant_matches` WRITE;
/*!40000 ALTER TABLE `contestant_matches` DISABLE KEYS */;
INSERT INTO `contestant_matches` VALUES (3,8,3,3,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(4,1,11,2,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(5,1,8,1,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(6,8,30,4,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(7,8,18,2,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(8,1,5,2,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(9,8,18,1,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(10,1,8,3,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(12,1,11,4,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(14,1,13,2,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(15,8,3,2,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(16,8,30,2,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(17,1,11,1,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(20,8,47,3,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(21,8,30,1,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(22,8,3,1,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(24,8,47,1,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(25,1,11,3,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(27,15,27,1,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(30,8,30,3,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(31,15,38,1,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(33,3,7,1,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(34,3,16,4,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(35,3,7,3,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(36,15,31,4,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(37,15,38,2,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(38,15,31,1,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(39,3,7,2,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(40,3,16,2,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(41,15,35,3,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(42,15,35,2,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(43,21,61,5,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(44,21,63,2,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(45,21,63,3,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(46,8,18,4,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(47,3,16,1,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(48,15,31,2,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(49,15,27,2,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(50,23,66,2,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(51,23,66,4,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(52,21,67,2,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(53,15,31,5,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(54,1,8,2,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(55,8,47,2,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(56,15,35,1,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(57,1,8,4,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(58,21,61,3,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(59,23,69,1,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(60,1,13,3,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(61,8,3,4,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(62,23,69,5,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(63,3,16,3,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(64,24,70,2,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(65,21,61,4,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(66,23,66,1,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(67,23,69,2,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(68,15,27,3,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(69,24,70,1,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(70,21,62,1,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(71,21,61,1,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(72,21,62,2,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(73,24,70,3,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(74,23,66,3,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(75,23,69,4,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(76,21,62,3,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(77,24,71,2,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(78,1,5,4,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(79,1,13,1,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(80,21,62,5,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(81,21,62,4,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(82,1,5,1,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(83,15,31,3,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(84,8,18,3,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(85,23,69,3,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(86,21,63,4,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(87,21,67,1,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(88,24,71,1,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(89,23,66,5,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(91,1,5,3,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(92,21,63,1,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(93,21,67,3,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(94,21,61,2,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205'),(95,24,70,4,'not_started',NULL,NULL,1,'2026-10-19 12:14:46.205','2026-10-19 12:14:46.205');
/*!40000 ALTER TABLE `contestant_matches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contestants`
--

DROP TABLE IF EXISTS `contestants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contestants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contestId` int(11) NOT NULL,
  `studentId` int(11) NOT NULL,
  `roundId` int(11) NOT NULL,
  `status` enum('compete','eliminate','advanced') NOT NULL DEFAULT 'compete',
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `contestants_contestId_fkey` (`contestId`),
  KEY `contestants_studentId_fkey` (`studentId`),
  KEY `contestants_roundId_fkey` (`roundId`),
  CONSTRAINT `contestants_contestId_fkey` FOREIGN KEY (`contestId`) REFERENCES `contests` (`id`),
  CONSTRAINT `contestants_roundId_fkey` FOREIGN KEY (`roundId`) REFERENCES `rounds` (`id`),
  CONSTRAINT `contestants_studentId_fkey` FOREIGN KEY (`studentId`) REFERENCES `students` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=96 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contestants`
--

LOCK TABLES `contestants` WRITE;
/*!40000 ALTER TABLE `contestants` DISABLE KEYS */;
INSERT INTO `contestants` VALUES (1,1,5,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(2,1,30,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(3,1,60,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(4,1,47,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(5,1,3,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(6,1,31,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(7,1,38,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(8,1,67,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(9,1,56,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(10,1,54,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(11,1,57,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(12,1,21,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(13,1,61,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(14,1,89,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(15,1,97,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(16,1,81,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(17,1,139,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(18,1,6,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(19,1,106,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(20,1,152,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(21,1,145,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(22,1,141,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(23,1,110,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(24,1,154,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(25,1,149,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(26,1,28,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(27,2,116,4,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(28,1,147,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(29,1,190,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(30,1,101,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(31,2,129,4,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(32,1,150,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(33,2,119,4,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(34,2,50,4,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(35,2,24,4,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(36,2,99,4,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(37,2,1,4,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(38,2,63,4,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(39,2,47,4,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(40,2,142,4,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(41,2,163,4,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(42,2,77,4,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(43,3,164,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(44,3,116,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(45,3,148,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(46,1,136,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(47,2,121,4,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(48,2,135,4,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(49,2,110,4,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(50,3,44,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(51,3,3,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(52,3,35,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(53,2,38,4,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(54,1,10,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(55,1,12,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(56,2,16,4,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(57,1,64,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(58,3,201,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(59,3,132,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(60,1,34,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(61,1,103,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(62,3,163,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(63,2,3,4,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(64,3,154,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(65,3,172,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(66,3,48,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(67,3,87,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(68,2,22,4,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(69,3,51,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(70,3,136,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(71,3,112,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(72,3,1,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(73,3,75,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(74,3,135,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(75,3,141,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(76,3,38,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(77,3,10,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(78,1,24,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(79,1,140,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(80,3,52,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(81,3,16,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(82,1,129,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(83,2,76,4,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(84,1,102,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(85,3,42,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(86,3,138,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(87,3,41,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(88,3,134,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(89,3,107,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(90,1,171,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(91,1,39,6,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(92,3,162,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(93,3,168,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(94,3,63,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143'),(95,3,131,9,'compete','2026-10-19 12:14:46.143','2026-10-19 12:14:46.143');
/*!40000 ALTER TABLE `contestants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contests`
--

DROP TABLE IF EXISTS `contests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `rule` text NOT NULL,
  `plainText` text NOT NULL,
  `location` varchar(255) NOT NULL,
  `startTime` datetime(3) NOT NULL,
  `endTime` datetime(3) NOT NULL,
  `slogan` varchar(255) DEFAULT NULL,
  `status` enum('upcoming','ongoing','finished') NOT NULL DEFAULT 'upcoming',
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `contests_slug_key` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contests`
--

LOCK TABLES `contests` WRITE;
/*!40000 ALTER TABLE `contests` DISABLE KEYS */;
INSERT INTO `contests` VALUES (1,'Hội thi Tin học văn phòng 2025','tin-hoc-van-phong-2025','\n                    <h3>QUY ĐỊNH CUỘC THI</h3>\n                    <ol>\n                        <li>Cuộc thi dành cho học sinh lớp 10, 11, 12</li>\n                        <li>Thi cá nhân</li>\n                        <li>Sử dụng Microsoft Office (Word, Excel, PowerPoint)</li>\n                        <li>Thời gian thi: 120 phút</li>\n                        <li>Không được sử dụng Internet</li>\n                    </ol>\n                ','Hội thi Tin học văn phòng nhằm nâng cao kỹ năng sử dụng máy tính của học sinh...','Trung tâm Tin học, TP.HCM','2025-05-20 08:00:00.000','2025-05-22 17:00:00.000',NULL,'upcoming',1,'2026-10-19 12:14:46.093','2026-10-19 12:14:46.093'),(2,'Cuộc thi Đường lên đỉnh Olympia 2025','duong-len-dinh-olympia-2025','\n                    <h3>QUY ĐỊNH CUỘC THI</h3>\n                    <ol>\n                        <li>Cuộc thi dành cho học sinh THPT</li>\n                        <li>Mỗi trường được cử tối đa 5 thí sinh tham gia</li>\n                        <li>Cuộc thi gồm 4 phần: Khởi động, Tăng tốc, Về đích, Câu hỏi phụ</li>\n                        <li>Thí sinh cần tuân thủ quy định về thời gian làm bài</li>\n                        <li>Nghiêm cấm gian lận dưới mọi hình thức</li>\n                    </ol>\n                ','Cuộc thi Đường lên đỉnh Olympia là cuộc thi trí tuệ dành cho học sinh trung học phổ thông...','Đài Truyền hình Việt Nam, Hà Nội','2025-03-01 08:00:00.000','2025-12-31 18:00:00.000',NULL,'upcoming',1,'2026-10-19 12:14:46.093','2026-10-19 12:14:46.093'),(3,'Cuộc thi Tin học trẻ toàn quốc 2025','tin-hoc-tre-toan-quoc-2025','\n                    <h3>QUY ĐỊNH CUỘC THI</h3>\n                    <ol>\n                        <li>Cuộc thi dành cho học sinh THCS và THPT</li>\n                        <li>Thi đấu theo nhóm 3 người</li>\n                        <li>Sử dụng ngôn ngữ lập trình C/C++, Pascal, Python</li>\n                        <li>Thời gian thi: 180 phút</li>\n                        <li>Được sử dụng tài liệu tham khảo</li>\n                    </ol>\n                ','Cuộc thi Tin học trẻ toàn quốc nhằm khuyến khích học sinh yêu thích môn Tin học...','Trường Đại học Bách khoa Hà Nội','2025-04-15 08:00:00.000','2025-04-17 18:00:00.000',NULL,'upcoming',1,'2026-10-19 12:14:46.093','2026-10-19 12:14:46.093');
/*!40000 ALTER TABLE `contests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `userId` int(11) DEFAULT NULL,
  `matchId` int(11) NOT NULL,
  `confirmCurrentQuestion` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `groups_userId_fkey` (`userId`),
  KEY `groups_matchId_fkey` (`matchId`),
  CONSTRAINT `groups_matchId_fkey` FOREIGN KEY (`matchId`) REFERENCES `matches` (`id`),
  CONSTRAINT `groups_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
INSERT INTO `groups` VALUES (1,'Nhóm B - Bán kết - Trận 1',204,5,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(2,'Nhóm D - Vòng Quý - Trận 2',203,4,1,'2026-10-19 12:14:46.176','2026-10-19 12:14:46.176'),(3,'Nhóm A - Vòng sơ loại - Trận 1',204,8,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(4,'Nhóm C - Vòng Quý - Trận 2',204,4,1,'2026-10-19 12:14:46.176','2026-10-19 12:14:46.176'),(5,'Nhóm A - Vòng sơ loại - Trận 2',204,1,1,'2026-10-19 12:14:46.176','2026-10-19 12:14:46.176'),(6,'Nhóm B - Vòng chung kết - Trận 4',204,2,1,'2026-10-19 12:14:46.176','2026-10-19 12:14:46.176'),(7,'Nhóm B - Vòng Tháng - Trận 2',204,3,1,'2026-10-19 12:14:46.176','2026-10-19 12:14:46.176'),(8,'Nhóm C - Vòng sơ loại - Trận 2',203,1,1,'2026-10-19 12:14:46.176','2026-10-19 12:14:46.176'),(9,'Nhóm A - Vòng chung kết - Trận 1',204,6,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(10,'Nhóm A - Vòng chung kết - Trận 4',203,2,1,'2026-10-19 12:14:46.176','2026-10-19 12:14:46.176'),(11,'Nhóm D - Vòng sơ loại - Trận 2',203,1,1,'2026-10-19 12:14:46.176','2026-10-19 12:14:46.176'),(12,'Nhóm A - Chung kết - Trận 2',204,7,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(13,'Nhóm B - Vòng sơ loại - Trận 2',203,1,1,'2026-10-19 12:14:46.176','2026-10-19 12:14:46.176'),(14,'Nhóm B - Vòng Quý - Trận 2',204,4,1,'2026-10-19 12:14:46.176','2026-10-19 12:14:46.176'),(15,'Nhóm A - Vòng Quý - Trận 2',203,4,1,'2026-10-19 12:14:46.176','2026-10-19 12:14:46.176'),(16,'Nhóm A - Vòng Tháng - Trận 2',203,3,1,'2026-10-19 12:14:46.176','2026-10-19 12:14:46.176'),(17,'Nhóm A - Vòng chung kết - Trận 3',204,9,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(18,'Nhóm B - Vòng sơ loại - Trận 1',203,8,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(19,'Nhóm C - Chung kết - Trận 3',203,10,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(20,'Nhóm B - Vòng chung kết - Trận 2',204,11,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(21,'Nhóm B - Vòng chung kết - Trận 3',203,9,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(22,'Nhóm A - Vòng Quý - Trận 3',204,12,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(23,'Nhóm B - Chung kết - Trận 3',204,10,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(24,'Nhóm A - Chung kết - Trận 1',204,13,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(25,'Nhóm B - Vòng Năm - Trận 1',203,14,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(26,'Nhóm A - Bán kết - Trận 1',204,5,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(27,'Nhóm B - Vòng Tháng - Trận 1',204,15,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(28,'Nhóm D - Vòng Năm - Trận 1',203,14,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(29,'Nhóm B - Chung kết - Trận 1',203,13,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(30,'Nhóm C - Vòng sơ loại - Trận 1',204,8,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(31,'Nhóm C - Vòng Tháng - Trận 1',204,15,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(32,'Nhóm A - Vòng Quý - Trận 1',204,16,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(33,'Nhóm A - Vòng chung kết - Trận 2',204,11,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(34,'Nhóm A - Vòng Năm - Trận 1',204,14,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(35,'Nhóm D - Vòng Tháng - Trận 1',204,15,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(36,'Nhóm C - Vòng chung kết - Trận 2',204,11,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(37,'Nhóm B - Vòng Quý - Trận 1',203,16,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(38,'Nhóm A - Vòng Tháng - Trận 1',204,15,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(39,'Nhóm A - Chung kết - Trận 3',204,10,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(40,'Nhóm A - Vòng Quý - Trận 4',203,17,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(41,'Nhóm B - Vòng Quý - Trận 4',203,17,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(42,'Nhóm A - Vòng Năm - Trận 2',204,18,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(43,'Nhóm C - Vòng Quý - Trận 4',203,17,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(44,'Nhóm C - Bán kết - Trận 2',204,19,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(45,'Nhóm B - Bán kết - Trận 2',203,19,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(46,'Nhóm A - Bán kết - Trận 2',204,19,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(47,'Nhóm D - Vòng sơ loại - Trận 1',204,8,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(48,'Nhóm B - Vòng chung kết - Trận 1',204,6,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(49,'Nhóm B - Vòng Quý - Trận 3',203,12,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(50,'Nhóm B - Vòng Năm - Trận 2',203,18,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(51,'Nhóm C - Bán kết - Trận 1',203,5,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(52,'Nhóm D - Bán kết - Trận 1',203,5,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(53,'Nhóm D - Bán kết - Trận 2',204,19,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(54,'Nhóm D - Vòng Quý - Trận 4',204,17,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(55,'Nhóm C - Vòng Năm - Trận 1',204,14,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(56,'Nhóm C - Vòng chung kết - Trận 1',204,6,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(57,'Nhóm C - Chung kết - Trận 2',203,7,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(58,'Nhóm B - Chung kết - Trận 2',203,7,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(59,'Nhóm A - Chung kết - Trận 1',203,20,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(60,'Nhóm B - Chung kết - Trận 1',203,20,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(61,'Nhóm C - Vòng loại - Trận 1',203,21,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(62,'Nhóm B - Vòng loại - Trận 1',204,21,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(63,'Nhóm D - Vòng loại - Trận 1',204,21,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(64,'Nhóm A - Chung kết - Trận 2',204,22,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(65,'Nhóm C - Chung kết - Trận 2',203,22,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(66,'Nhóm B - Vòng loại - Trận 4',204,23,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(67,'Nhóm A - Vòng loại - Trận 1',204,21,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(68,'Nhóm B - Chung kết - Trận 2',204,22,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(69,'Nhóm A - Vòng loại - Trận 4',203,23,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(70,'Nhóm C - Vòng loại - Trận 3',204,24,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(71,'Nhóm A - Vòng loại - Trận 3',204,24,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(72,'Nhóm C - Vòng loại - Trận 4',204,23,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(73,'Nhóm B - Vòng loại - Trận 2',204,25,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(74,'Nhóm B - Vòng loại - Trận 3',204,24,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(75,'Nhóm C - Vòng loại - Trận 2',204,25,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(76,'Nhóm D - Vòng loại - Trận 2',204,25,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177'),(77,'Nhóm A - Vòng loại - Trận 2',204,25,1,'2026-10-19 12:14:46.177','2026-10-19 12:14:46.177');
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `matches`
--

DROP TABLE IF EXISTS `matches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `matches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `startTime` datetime(3) NOT NULL,
  `endTime` datetime(3) NOT NULL,
  `slug` varchar(191) DEFAULT NULL,
  `remainingTime` int(11) DEFAULT NULL,
  `status` enum('upcoming','ongoing','finished') NOT NULL DEFAULT 'upcoming',
  `currentQuestion` int(11) NOT NULL,
  `questionPackageId` int(11) NOT NULL,
  `contestId` int(11) NOT NULL,
  `roundId` int(11) NOT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `studentId` int(11) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `maxContestantColumn` int(11) DEFAULT 10,
  PRIMARY KEY (`id`),
  UNIQUE KEY `matches_slug_key` (`slug`),
  KEY `matches_questionPackageId_fkey` (`questionPackageId`),
  KEY `matches_contestId_fkey` (`contestId`),
  KEY `matches_roundId_fkey` (`roundId`),
  KEY `matches_studentId_fkey` (`studentId`),
  CONSTRAINT `matches_contestId_fkey` FOREIGN KEY (`contestId`) REFERENCES `contests` (`id`),
  CONSTRAINT `matches_questionPackageId_fkey` FOREIGN KEY (`questionPackageId`) REFERENCES `question_packages` (`id`),
  CONSTRAINT `matches_roundId_fkey` FOREIGN KEY (`roundId`) REFERENCES `rounds` (`id`),
  CONSTRAINT `matches_studentId_fkey` FOREIGN KEY (`studentId`) REFERENCES `students` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matches`
--

LOCK TABLES `matches` WRITE;
/*!40000 ALTER TABLE `matches` DISABLE KEYS */;
INSERT INTO `matches` VALUES (1,'Vòng sơ loại - Trận 2','2025-05-20 10:00:00.000','2025-05-20 11:00:00.000',NULL,NULL,'upcoming',1,10,1,6,1,NULL,'2026-10-19 12:14:46.115','2026-10-19 12:14:46.115',10),(2,'Vòng chung kết - Trận 4','2025-05-20 14:00:00.000','2025-05-20 15:00:00.000',NULL,NULL,'upcoming',1,12,1,5,1,NULL,'2026-10-19 12:14:46.115','2026-10-19 12:14:46.115',10),(3,'Vòng Tháng - Trận 2','2025-03-01 10:00:00.000','2025-03-01 11:00:00.000',NULL,NULL,'upcoming',1,8,2,4,1,NULL,'2026-10-19 12:14:46.116','2026-10-19 12:14:46.116',10),(4,'Vòng Quý - Trận 2','2025-03-01 10:00:00.000','2025-03-01 11:00:00.000',NULL,NULL,'upcoming',1,4,2,1,1,NULL,'2026-10-19 12:14:46.115','2026-10-19 12:14:46.115',10),(5,'Bán kết - Trận 1','2025-04-15 08:00:00.000','2025-04-15 09:00:00.000',NULL,NULL,'upcoming',1,14,3,2,1,NULL,'2026-10-19 12:14:46.116','2026-10-19 12:14:46.116',10),(6,'Vòng chung kết - Trận 1','2025-05-20 08:00:00.000','2025-05-20 09:00:00.000',NULL,NULL,'upcoming',1,7,1,5,1,NULL,'2026-10-19 12:14:46.115','2026-10-19 12:14:46.115',10),(7,'Chung kết - Trận 2','2025-03-01 10:00:00.000','2025-03-01 11:00:00.000',NULL,NULL,'upcoming',1,9,2,3,1,NULL,'2026-10-19 12:14:46.116','2026-10-19 12:14:46.116',10),(8,'Vòng sơ loại - Trận 1','2025-05-20 08:00:00.000','2025-05-20 09:00:00.000',NULL,NULL,'upcoming',1,10,1,6,1,NULL,'2026-10-19 12:14:46.115','2026-10-19 12:14:46.115',10),(9,'Vòng chung kết - Trận 3','2025-05-20 12:00:00.000','2025-05-20 13:00:00.000',NULL,NULL,'upcoming',1,7,1,5,1,NULL,'2026-10-19 12:14:46.115','2026-10-19 12:14:46.115',10),(10,'Chung kết - Trận 3','2025-03-01 12:00:00.000','2025-03-01 13:00:00.000',NULL,NULL,'upcoming',1,13,2,3,1,NULL,'2026-10-19 12:14:46.116','2026-10-19 12:14:46.116',10),(11,'Vòng chung kết - Trận 2','2025-05-20 10:00:00.000','2025-05-20 11:00:00.000',NULL,NULL,'upcoming',1,7,1,5,1,NULL,'2026-10-19 12:14:46.115','2026-10-19 12:14:46.115',10),(12,'Vòng Quý - Trận 3','2025-03-01 12:00:00.000','2025-03-01 13:00:00.000',NULL,NULL,'upcoming',1,12,2,1,1,NULL,'2026-10-19 12:14:46.115','2026-10-19 12:14:46.115',10),(13,'Chung kết - Trận 1','2025-03-01 08:00:00.000','2025-03-01 09:00:00.000',NULL,NULL,'upcoming',1,4,2,3,1,NULL,'2026-10-19 12:14:46.115','2026-10-19 12:14:46.115',10),(14,'Vòng Năm - Trận 1','2025-03-01 08:00:00.000','2025-03-01 09:00:00.000',NULL,NULL,'upcoming',1,2,2,8,1,NULL,'2026-10-19 12:14:46.116','2026-10-19 12:14:46.116',10),(15,'Vòng Tháng - Trận 1','2025-03-01 08:00:00.000','2025-03-01 09:00:00.000',NULL,NULL,'upcoming',1,6,2,4,1,NULL,'2026-10-19 12:14:46.116','2026-10-19 12:14:46.116',10),(16,'Vòng Quý - Trận 1','2025-03-01 08:00:00.000','2025-03-01 09:00:00.000',NULL,NULL,'upcoming',1,7,2,1,1,NULL,'2026-10-19 12:14:46.115','2026-10-19 12:14:46.115',10),(17,'Vòng Quý - Trận 4','2025-03-01 14:00:00.000','2025-03-01 15:00:00.000',NULL,NULL,'upcoming',1,8,2,1,1,NULL,'2026-10-19 12:14:46.115','2026-10-19 12:14:46.115',10),(18,'Vòng Năm - Trận 2','2025-03-01 10:00:00.000','2025-03-01 11:00:00.000',NULL,NULL,'upcoming',1,1,2,8,1,NULL,'2026-10-19 12:14:46.116','2026-10-19 12:14:46.116',10),(19,'Bán kết - Trận 2','2025-04-15 10:00:00.000','2025-04-15 11:00:00.000',NULL,NULL,'upcoming',1,14,3,2,1,NULL,'2026-10-19 12:14:46.116','2026-10-19 12:14:46.116',10),(20,'Chung kết - Trận 1','2025-04-15 08:00:00.000','2025-04-15 09:00:00.000',NULL,NULL,'upcoming',1,11,3,7,1,NULL,'2026-10-19 12:14:46.116','2026-10-19 12:14:46.116',10),(21,'Vòng loại - Trận 1','2025-04-15 08:00:00.000','2025-04-15 09:00:00.000',NULL,NULL,'upcoming',1,9,3,9,1,NULL,'2026-10-19 12:14:46.116','2026-10-19 12:14:46.116',10),(22,'Chung kết - Trận 2','2025-04-15 10:00:00.000','2025-04-15 11:00:00.000',NULL,NULL,'upcoming',1,13,3,7,1,NULL,'2026-10-19 12:14:46.116','2026-10-19 12:14:46.116',10),(23,'Vòng loại - Trận 4','2025-04-15 14:00:00.000','2025-04-15 15:00:00.000',NULL,NULL,'upcoming',1,14,3,9,1,NULL,'2026-10-19 12:14:46.116','2026-10-19 12:14:46.116',10),(24,'Vòng loại - Trận 3','2025-04-15 12:00:00.000','2025-04-15 13:00:00.000',NULL,NULL,'upcoming',1,2,3,9,1,NULL,'2026-10-19 12:14:46.116','2026-10-19 12:14:46.116',10),(25,'Vòng loại - Trận 2','2025-04-15 10:00:00.000','2025-04-15 11:00:00.000',NULL,NULL,'upcoming',1,9,3,9,1,NULL,'2026-10-19 12:14:46.116','2026-10-19 12:14:46.116',10);
/*!40000 ALTER TABLE `matches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media`
--

DROP TABLE IF EXISTS `media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(255) NOT NULL,
  `type` enum('logo','background','images') NOT NULL,
  `contestId` int(11) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `media_contestId_fkey` (`contestId`),
  CONSTRAINT `media_contestId_fkey` FOREIGN KEY (`contestId`) REFERENCES `contests` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media`
--

LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;
/*!40000 ALTER TABLE `media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question_details`
--

DROP TABLE IF EXISTS `question_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `question_details` (
  `questionId` int(11) NOT NULL,
  `questionPackageId` int(11) NOT NULL,
  `questionOrder` int(11) NOT NULL,
  `isActive` tinyint(1) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`questionId`,`questionPackageId`),
  KEY `question_Details_questionPackageId_fkey` (`questionPackageId`),
  CONSTRAINT `question_Details_questionId_fkey` FOREIGN KEY (`questionId`) REFERENCES `questions` (`id`),
  CONSTRAINT `question_Details_questionPackageId_fkey` FOREIGN KEY (`questionPackageId`) REFERENCES `question_packages` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question_details`
--

LOCK TABLES `question_details` WRITE;
/*!40000 ALTER TABLE `question_details` DISABLE KEYS */;
INSERT INTO `question_details` VALUES (1,4,2,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(1,5,8,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(1,8,3,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(1,10,2,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(2,2,4,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(2,4,13,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(2,5,15,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(2,6,4,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(2,7,4,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(2,9,9,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(2,11,1,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(2,13,4,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(3,7,11,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(3,12,13,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(4,1,8,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(4,5,9,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(4,8,2,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(4,13,3,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(5,1,7,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(5,6,1,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(5,11,8,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(5,12,7,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(6,1,11,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(6,2,1,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(6,3,7,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(6,4,6,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(6,5,3,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(6,6,6,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(6,12,11,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(7,5,12,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(7,11,12,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(7,15,15,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(8,2,6,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(8,3,9,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(8,4,8,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(8,9,6,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(8,12,8,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(9,1,4,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(9,3,2,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(9,8,5,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(10,6,9,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(10,12,9,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(11,4,10,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(11,10,6,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(11,11,2,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(11,13,1,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(11,14,10,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(12,8,10,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(12,9,2,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(12,11,5,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(12,12,2,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(12,14,1,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(12,15,11,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(13,1,5,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(13,4,12,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(13,13,8,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(14,7,3,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(14,15,7,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(15,1,2,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(15,4,14,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(15,13,12,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(15,14,2,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(15,15,4,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(16,8,4,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(16,11,6,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(16,14,12,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(16,15,10,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(17,10,4,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(17,11,11,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(17,14,9,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(17,15,14,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(18,7,12,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(18,8,9,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(18,12,6,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(18,14,6,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(18,15,5,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(19,1,6,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(19,3,1,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(19,4,1,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(19,7,2,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(19,8,13,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(19,10,3,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(19,14,5,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(20,2,3,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(20,8,6,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(20,10,5,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(20,14,8,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(21,2,7,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(21,3,4,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(21,5,10,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(21,6,5,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(21,10,7,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(21,11,7,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(21,12,3,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(21,13,7,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(22,10,12,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(22,15,13,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(23,1,1,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(23,3,10,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(23,7,7,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(23,12,1,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(24,1,3,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(24,2,10,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(24,3,8,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(24,6,2,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(24,7,5,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(24,10,13,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(24,13,10,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(25,1,9,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(25,5,5,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(25,6,8,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(25,12,12,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(25,13,2,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(25,15,1,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(26,9,3,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(26,12,10,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(27,2,8,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(27,5,14,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(27,14,4,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(28,2,2,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(28,15,3,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(29,1,10,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(29,3,5,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(29,4,7,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(29,9,7,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(29,14,3,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(29,15,12,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(30,4,5,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(30,5,7,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(30,10,11,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(30,11,4,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(30,13,9,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(30,15,8,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(31,5,13,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(31,6,10,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(31,7,8,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(31,9,5,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(32,2,5,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(32,3,3,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(32,5,2,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(32,9,8,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(33,1,13,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(33,5,1,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(33,10,8,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(33,13,11,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(33,15,6,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(34,1,12,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(34,2,9,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(34,4,4,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(34,5,11,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(34,7,6,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(34,8,7,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(34,9,10,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(34,11,10,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(34,12,15,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(34,14,7,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(35,4,3,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(35,5,4,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(35,6,11,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(35,7,9,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(35,10,10,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(35,12,4,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(36,4,9,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(36,5,6,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(36,8,8,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(36,12,14,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(37,3,6,1,'2026-10-19 12:14:46.047','2026-10-19 12:14:46.047'),(37,6,7,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(37,7,1,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(37,8,11,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(37,11,9,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(37,12,5,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(37,13,6,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(37,15,2,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(38,4,11,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(38,8,12,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(38,9,4,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(38,14,13,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(39,6,3,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(39,7,10,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(39,10,9,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(39,14,11,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(39,15,9,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050'),(40,8,1,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(40,9,1,1,'2026-10-19 12:14:46.048','2026-10-19 12:14:46.048'),(40,10,1,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(40,11,3,1,'2026-10-19 12:14:46.049','2026-10-19 12:14:46.049'),(40,13,5,1,'2026-10-19 12:14:46.050','2026-10-19 12:14:46.050');
/*!40000 ALTER TABLE `question_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question_packages`
--

DROP TABLE IF EXISTS `question_packages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `question_packages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question_packages`
--

LOCK TABLES `question_packages` WRITE;
/*!40000 ALTER TABLE `question_packages` DISABLE KEYS */;
INSERT INTO `question_packages` VALUES (1,'Gói câu hỏi Công nghệ',1,'2026-10-19 12:14:46.006','2026-10-19 12:14:46.006'),(2,'Gói câu hỏi Tăng tốc',1,'2026-10-19 12:14:46.006','2026-10-19 12:14:46.006'),(3,'Gói câu hỏi Khởi động',1,'2026-10-19 12:14:46.006','2026-10-19 12:14:46.006'),(4,'Gói câu hỏi Câu hỏi phụ',1,'2026-10-19 12:14:46.006','2026-10-19 12:14:46.006'),(5,'Gói câu hỏi Vòng loại',1,'2026-10-19 12:14:46.006','2026-10-19 12:14:46.006'),(6,'Gói câu hỏi Về đích',1,'2026-10-19 12:14:46.006','2026-10-19 12:14:46.006'),(7,'Gói câu hỏi Toán học cơ bản',1,'2026-10-19 12:14:46.006','2026-10-19 12:14:46.006'),(8,'Gói câu hỏi Bán kết',1,'2026-10-19 12:14:46.006','2026-10-19 12:14:46.006'),(9,'Gói câu hỏi Nghệ thuật',1,'2026-10-19 12:14:46.006','2026-10-19 12:14:46.006'),(10,'Gói câu hỏi Văn hóa Việt Nam',1,'2026-10-19 12:14:46.006','2026-10-19 12:14:46.006'),(11,'Gói câu hỏi Khoa học tự nhiên',1,'2026-10-19 12:14:46.006','2026-10-19 12:14:46.006'),(12,'Gói câu hỏi Thi đấu',1,'2026-10-19 12:14:46.006','2026-10-19 12:14:46.006'),(13,'Gói câu hỏi Khoa học xã hội',1,'2026-10-19 12:14:46.006','2026-10-19 12:14:46.006'),(14,'Gói câu hỏi Thể thao',1,'2026-10-19 12:14:46.006','2026-10-19 12:14:46.006'),(15,'Gói câu hỏi Chung kết',1,'2026-10-19 12:14:46.006','2026-10-19 12:14:46.006');
/*!40000 ALTER TABLE `question_packages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question_topics`
--

DROP TABLE IF EXISTS `question_topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `question_topics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question_topics`
--

LOCK TABLES `question_topics` WRITE;
/*!40000 ALTER TABLE `question_topics` DISABLE KEYS */;
INSERT INTO `question_topics` VALUES (1,'Ngữ văn',1,'2026-10-19 12:14:45.990','2026-10-19 12:14:45.990'),(2,'Tin học',1,'2026-10-19 12:14:45.990','2026-10-19 12:14:45.990'),(3,'Thể dục',1,'2026-10-19 12:14:45.990','2026-10-19 12:14:45.990'),(4,'Địa lý',1,'2026-10-19 12:14:45.990','2026-10-19 12:14:45.990'),(5,'Giáo dục công dân',1,'2026-10-19 12:14:45.990','2026-10-19 12:14:45.990'),(6,'Lịch sử',1,'2026-10-19 12:14:45.990','2026-10-19 12:14:45.990'),(7,'Sinh học',1,'2026-10-19 12:14:45.990','2026-10-19 12:14:45.990'),(8,'Vật lý',1,'2026-10-19 12:14:45.990','2026-10-19 12:14:45.990'),(9,'Kiến thức chung',1,'2026-10-19 12:14:45.990','2026-10-19 12:14:45.990'),(10,'Toán học',1,'2026-10-19 12:14:45.990','2026-10-19 12:14:45.990'),(11,'Hóa học',1,'2026-10-19 12:14:45.990','2026-10-19 12:14:45.990'),(12,'Khoa học tự nhiên',1,'2026-10-19 12:14:45.990','2026-10-19 12:14:45.990'),(13,'Khoa học xã hội',1,'2026-10-19 12:14:45.990','2026-10-19 12:14:45.990'),(14,'Tiếng Anh',1,'2026-10-19 12:14:45.990','2026-10-19 12:14:45.990'),(15,'Văn hóa dân gian',1,'2026-10-19 12:14:45.990','2026-10-19 12:14:45.990');
/*!40000 ALTER TABLE `question_topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `intro` varchar(255) DEFAULT NULL,
  `defaultTime` int(11) NOT NULL,
  `questionType` enum('multiple_choice','essay','image','audio','video') NOT NULL,
  `content` text NOT NULL,
  `questionMedia` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`questionMedia`)),
  `options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`options`)),
  `correctAnswer` text NOT NULL,
  `mediaAnswer` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`mediaAnswer`)),
  `score` int(11) NOT NULL DEFAULT 1,
  `difficulty` enum('Alpha','Beta','Rc','Gold') NOT NULL,
  `explanation` text DEFAULT NULL,
  `questionTopicId` int(11) NOT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `questions_questionTopicId_fkey` (`questionTopicId`),
  CONSTRAINT `questions_questionTopicId_fkey` FOREIGN KEY (`questionTopicId`) REFERENCES `question_topics` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions`
--

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
INSERT INTO `questions` VALUES (1,'Câu hỏi khó',90,'essay','<p>Hãy phân tích tác động của cách mạng công nghiệp 4.0 đến hệ thống giáo dục hiện tại và đưa ra những giải pháp thích ứng.</p>','\"/uploads/questions/test-img.jpg\"','null','Câu trả lời mở, cần phân tích đa chiều về tác động tích cực và tiêu cực, đề xuất giải pháp cụ thể.','\"/uploads/questions/test-img.jpg\"',50,'Gold','Đây là câu hỏi mở, yêu cầu thí sinh phân tích sâu và đưa ra quan điểm cá nhân có cơ sở.',3,1,'2026-10-19 12:14:46.021','2026-10-19 12:14:46.021'),(2,'Câu hỏi Toán học nâng cao',60,'multiple_choice','<p>Đạo hàm của hàm số y = x² là?</p>','\"/uploads/questions/test-img.jpg\"','[\"x\",\"2x\",\"x²\",\"2x²\"]','2x','\"/uploads/questions/test-img.jpg\"',20,'Beta','Đạo hàm của x² là 2x',1,1,'2026-10-19 12:14:46.021','2026-10-19 12:14:46.021'),(3,'Câu hỏi Sinh học',50,'multiple_choice','<p>DNA là viết tắt của từ gì?</p>','\"/uploads/questions/test-img.jpg\"','[\"Deoxyribonucleic Acid\",\"Ribonucleic Acid\",\"Amino Acid\",\"Fatty Acid\"]','Deoxyribonucleic Acid','\"/uploads/questions/test-img.jpg\"',15,'Beta','DNA là viết tắt của Deoxyribonucleic Acid (Axit deoxyribonucleic)',4,1,'2026-10-19 12:14:46.021','2026-10-19 12:14:46.021'),(4,'Câu hỏi Vật lý cơ bản',45,'multiple_choice','<p>Đơn vị của vận tốc trong hệ SI là gì?</p>','\"/uploads/questions/test-img.jpg\"','[\"m\",\"m/s\",\"m/s²\",\"kg\"]','m/s','\"/uploads/questions/test-img.jpg\"',15,'Alpha','Vận tốc có đơn vị là mét trên giây (m/s)',3,1,'2026-10-19 12:14:46.021','2026-10-19 12:14:46.021'),(5,'Câu hỏi Toán học nâng cao',60,'multiple_choice','<p>Đạo hàm của hàm số y = x² là?</p>','\"/uploads/questions/test-img.jpg\"','[\"x\",\"2x\",\"x²\",\"2x²\"]','2x','\"/uploads/questions/test-img.jpg\"',20,'Beta','Đạo hàm của x² là 2x',5,1,'2026-10-19 12:14:46.021','2026-10-19 12:14:46.021'),(6,'Câu hỏi Lịch sử Việt Nam',35,'multiple_choice','<p>Việt Nam tuyên bố độc lập vào ngày nào?</p>','\"/uploads/questions/test-img.jpg\"','[\"2/9/1945\",\"30/4/1975\",\"19/8/1945\",\"1/5/1975\"]','2/9/1945','\"/uploads/questions/test-img.jpg\"',10,'Alpha','Việt Nam tuyên bố độc lập vào ngày 2/9/1945',6,1,'2026-10-19 12:14:46.021','2026-10-19 12:14:46.021'),(7,'Câu hỏi Lịch sử Việt Nam',35,'multiple_choice','<p>Việt Nam tuyên bố độc lập vào ngày nào?</p>','\"/uploads/questions/test-img.jpg\"','[\"2/9/1945\",\"30/4/1975\",\"19/8/1945\",\"1/5/1975\"]','2/9/1945','\"/uploads/questions/test-img.jpg\"',10,'Alpha','Việt Nam tuyên bố độc lập vào ngày 2/9/1945',5,1,'2026-10-19 12:14:46.021','2026-10-19 12:14:46.021'),(8,'Câu hỏi Vật lý cơ bản',45,'multiple_choice','<p>Đơn vị của vận tốc trong hệ SI là gì?</p>','\"/uploads/questions/test-img.jpg\"','[\"m\",\"m/s\",\"m/s²\",\"kg\"]','m/s','\"/uploads/questions/test-img.jpg\"',15,'Alpha','Vận tốc có đơn vị là mét trên giây (m/s)',4,1,'2026-10-19 12:14:46.021','2026-10-19 12:14:46.021'),(9,'Câu hỏi Toán học cơ bản',30,'multiple_choice','<p>Tính: 2 + 3 = ?</p>','\"/uploads/questions/test-img.jpg\"','[\"4\",\"5\",\"6\",\"7\"]','5','\"/uploads/questions/test-img.jpg\"',10,'Alpha','2 + 3 = 5',3,1,'2026-10-19 12:14:46.021','2026-10-19 12:14:46.021'),(10,'Câu hỏi Toán học cơ bản',30,'multiple_choice','<p>Tính: 2 + 3 = ?</p>','\"/uploads/questions/test-img.jpg\"','[\"4\",\"5\",\"6\",\"7\"]','5','\"/uploads/questions/test-img.jpg\"',10,'Alpha','2 + 3 = 5',2,1,'2026-10-19 12:14:46.021','2026-10-19 12:14:46.021'),(11,'Câu hỏi Hóa học',40,'multiple_choice','<p>Công thức hóa học của nước là gì?</p>','\"/uploads/questions/test-img.jpg\"','[\"H₂O\",\"CO₂\",\"NaCl\",\"H₂SO₄\"]','H₂O','\"/uploads/questions/test-img.jpg\"',10,'Alpha','Nước có công thức hóa học là H₂O',2,1,'2026-10-19 12:14:46.021','2026-10-19 12:14:46.021'),(12,'Câu hỏi Hóa học',40,'multiple_choice','<p>Công thức hóa học của nước là gì?</p>','\"/uploads/questions/test-img.jpg\"','[\"H₂O\",\"CO₂\",\"NaCl\",\"H₂SO₄\"]','H₂O','\"/uploads/questions/test-img.jpg\"',10,'Alpha','Nước có công thức hóa học là H₂O',5,1,'2026-10-19 12:14:46.021','2026-10-19 12:14:46.021'),(13,'Câu hỏi Toán học cơ bản',30,'multiple_choice','<p>Tính: 2 + 3 = ?</p>','\"/uploads/questions/test-img.jpg\"','[\"4\",\"5\",\"6\",\"7\"]','5','\"/uploads/questions/test-img.jpg\"',10,'Alpha','2 + 3 = 5',1,1,'2026-10-19 12:14:46.021','2026-10-19 12:14:46.021'),(14,'Câu hỏi Toán học nâng cao',60,'multiple_choice','<p>Đạo hàm của hàm số y = x² là?</p>','\"/uploads/questions/test-img.jpg\"','[\"x\",\"2x\",\"x²\",\"2x²\"]','2x','\"/uploads/questions/test-img.jpg\"',20,'Beta','Đạo hàm của x² là 2x',4,1,'2026-10-19 12:14:46.021','2026-10-19 12:14:46.021'),(15,'Câu hỏi Hóa học',40,'multiple_choice','<p>Công thức hóa học của nước là gì?</p>','\"/uploads/questions/test-img.jpg\"','[\"H₂O\",\"CO₂\",\"NaCl\",\"H₂SO₄\"]','H₂O','\"/uploads/questions/test-img.jpg\"',10,'Alpha','Nước có công thức hóa học là H₂O',8,1,'2026-10-19 12:14:46.022','2026-10-19 12:14:46.022'),(16,'Câu hỏi Vật lý cơ bản',45,'multiple_choice','<p>Đơn vị của vận tốc trong hệ SI là gì?</p>','\"/uploads/questions/test-img.jpg\"','[\"m\",\"m/s\",\"m/s²\",\"kg\"]','m/s','\"/uploads/questions/test-img.jpg\"',15,'Alpha','Vận tốc có đơn vị là mét trên giây (m/s)',6,1,'2026-10-19 12:14:46.021','2026-10-19 12:14:46.021'),(17,'Câu hỏi khó',90,'essay','<p>Hãy phân tích tác động của cách mạng công nghiệp 4.0 đến hệ thống giáo dục hiện tại và đưa ra những giải pháp thích ứng.</p>','\"/uploads/questions/test-img.jpg\"','null','Câu trả lời mở, cần phân tích đa chiều về tác động tích cực và tiêu cực, đề xuất giải pháp cụ thể.','\"/uploads/questions/test-img.jpg\"',50,'Gold','Đây là câu hỏi mở, yêu cầu thí sinh phân tích sâu và đưa ra quan điểm cá nhân có cơ sở.',2,1,'2026-10-19 12:14:46.021','2026-10-19 12:14:46.021'),(18,'Câu hỏi Sinh học',50,'multiple_choice','<p>DNA là viết tắt của từ gì?</p>','\"/uploads/questions/test-img.jpg\"','[\"Deoxyribonucleic Acid\",\"Ribonucleic Acid\",\"Amino Acid\",\"Fatty Acid\"]','Deoxyribonucleic Acid','\"/uploads/questions/test-img.jpg\"',15,'Beta','DNA là viết tắt của Deoxyribonucleic Acid (Axit deoxyribonucleic)',8,1,'2026-10-19 12:14:46.022','2026-10-19 12:14:46.022'),(19,'Câu hỏi Toán học cơ bản',30,'multiple_choice','<p>Tính: 2 + 3 = ?</p>','\"/uploads/questions/test-img.jpg\"','[\"4\",\"5\",\"6\",\"7\"]','5','\"/uploads/questions/test-img.jpg\"',10,'Alpha','2 + 3 = 5',8,1,'2026-10-19 12:14:46.022','2026-10-19 12:14:46.022'),(20,'Câu hỏi Lịch sử Việt Nam',35,'multiple_choice','<p>Việt Nam tuyên bố độc lập vào ngày nào?</p>','\"/uploads/questions/test-img.jpg\"','[\"2/9/1945\",\"30/4/1975\",\"19/8/1945\",\"1/5/1975\"]','2/9/1945','\"/uploads/questions/test-img.jpg\"',10,'Alpha','Việt Nam tuyên bố độc lập vào ngày 2/9/1945',7,1,'2026-10-19 12:14:46.022','2026-10-19 12:14:46.022'),(21,'Câu hỏi Toán học nâng cao',60,'multiple_choice','<p>Đạo hàm của hàm số y = x² là?</p>','\"/uploads/questions/test-img.jpg\"','[\"x\",\"2x\",\"x²\",\"2x²\"]','2x','\"/uploads/questions/test-img.jpg\"',20,'Beta','Đạo hàm của x² là 2x',9,1,'2026-10-19 12:14:46.022','2026-10-19 12:14:46.022'),(22,'Câu hỏi Toán học cơ bản',30,'multiple_choice','<p>Tính: 2 + 3 = ?</p>','\"/uploads/questions/test-img.jpg\"','[\"4\",\"5\",\"6\",\"7\"]','5','\"/uploads/questions/test-img.jpg\"',10,'Alpha','2 + 3 = 5',9,1,'2026-10-19 12:14:46.022','2026-10-19 12:14:46.022'),(23,'Câu hỏi Toán học nâng cao',60,'multiple_choice','<p>Đạo hàm của hàm số y = x² là?</p>','\"/uploads/questions/test-img.jpg\"','[\"x\",\"2x\",\"x²\",\"2x²\"]','2x','\"/uploads/questions/test-img.jpg\"',20,'Beta','Đạo hàm của x² là 2x',10,1,'2026-10-19 12:14:46.022','2026-10-19 12:14:46.022'),(24,'Câu hỏi Toán học cơ bản',30,'multiple_choice','<p>Tính: 2 + 3 = ?</p>','\"/uploads/questions/test-img.jpg\"','[\"4\",\"5\",\"6\",\"7\"]','5','\"/uploads/questions/test-img.jpg\"',10,'Alpha','2 + 3 = 5',10,1,'2026-10-19 12:14:46.022','2026-10-19 12:14:46.022'),(25,'Câu hỏi khó',90,'essay','<p>Hãy phân tích tác động của cách mạng công nghiệp 4.0 đến hệ thống giáo dục hiện tại và đưa ra những giải pháp thích ứng.</p>','\"/uploads/questions/test-img.jpg\"','null','Câu trả lời mở, cần phân tích đa chiều về tác động tích cực và tiêu cực, đề xuất giải pháp cụ thể.','\"/uploads/questions/test-img.jpg\"',50,'Gold','Đây là câu hỏi mở, yêu cầu thí sinh phân tích sâu và đưa ra quan điểm cá nhân có cơ sở.',11,1,'2026-10-19 12:14:46.022','2026-10-19 12:14:46.022'),(26,'Câu hỏi Sinh học',50,'multiple_choice','<p>DNA là viết tắt của từ gì?</p>','\"/uploads/questions/test-img.jpg\"','[\"Deoxyribonucleic Acid\",\"Ribonucleic Acid\",\"Amino Acid\",\"Fatty Acid\"]','Deoxyribonucleic Acid','\"/uploads/questions/test-img.jpg\"',15,'Beta','DNA là viết tắt của Deoxyribonucleic Acid (Axit deoxyribonucleic)',11,1,'2026-10-19 12:14:46.022','2026-10-19 12:14:46.022'),(27,'Câu hỏi Sinh học',50,'multiple_choice','<p>DNA là viết tắt của từ gì?</p>','\"/uploads/questions/test-img.jpg\"','[\"Deoxyribonucleic Acid\",\"Ribonucleic Acid\",\"Amino Acid\",\"Fatty Acid\"]','Deoxyribonucleic Acid','\"/uploads/questions/test-img.jpg\"',15,'Beta','DNA là viết tắt của Deoxyribonucleic Acid (Axit deoxyribonucleic)',10,1,'2026-10-19 12:14:46.022','2026-10-19 12:14:46.022'),(28,'Câu hỏi Toán học nâng cao',60,'multiple_choice','<p>Đạo hàm của hàm số y = x² là?</p>','\"/uploads/questions/test-img.jpg\"','[\"x\",\"2x\",\"x²\",\"2x²\"]','2x','\"/uploads/questions/test-img.jpg\"',20,'Beta','Đạo hàm của x² là 2x',11,1,'2026-10-19 12:14:46.022','2026-10-19 12:14:46.022'),(29,'Câu hỏi Toán học cơ bản',30,'multiple_choice','<p>Tính: 2 + 3 = ?</p>','\"/uploads/questions/test-img.jpg\"','[\"4\",\"5\",\"6\",\"7\"]','5','\"/uploads/questions/test-img.jpg\"',10,'Alpha','2 + 3 = 5',12,1,'2026-10-19 12:14:46.022','2026-10-19 12:14:46.022'),(30,'Câu hỏi khó',90,'essay','<p>Hãy phân tích tác động của cách mạng công nghiệp 4.0 đến hệ thống giáo dục hiện tại và đưa ra những giải pháp thích ứng.</p>','\"/uploads/questions/test-img.jpg\"','null','Câu trả lời mở, cần phân tích đa chiều về tác động tích cực và tiêu cực, đề xuất giải pháp cụ thể.','\"/uploads/questions/test-img.jpg\"',50,'Gold','Đây là câu hỏi mở, yêu cầu thí sinh phân tích sâu và đưa ra quan điểm cá nhân có cơ sở.',7,1,'2026-10-19 12:14:46.022','2026-10-19 12:14:46.022'),(31,'Câu hỏi Hóa học',40,'multiple_choice','<p>Công thức hóa học của nước là gì?</p>','\"/uploads/questions/test-img.jpg\"','[\"H₂O\",\"CO₂\",\"NaCl\",\"H₂SO₄\"]','H₂O','\"/uploads/questions/test-img.jpg\"',10,'Alpha','Nước có công thức hóa học là H₂O',14,1,'2026-10-19 12:14:46.022','2026-10-19 12:14:46.022'),(32,'Câu hỏi Lịch sử Việt Nam',35,'multiple_choice','<p>Việt Nam tuyên bố độc lập vào ngày nào?</p>','\"/uploads/questions/test-img.jpg\"','[\"2/9/1945\",\"30/4/1975\",\"19/8/1945\",\"1/5/1975\"]','2/9/1945','\"/uploads/questions/test-img.jpg\"',10,'Alpha','Việt Nam tuyên bố độc lập vào ngày 2/9/1945',13,1,'2026-10-19 12:14:46.022','2026-10-19 12:14:46.022'),(33,'Câu hỏi khó',90,'essay','<p>Hãy phân tích tác động của cách mạng công nghiệp 4.0 đến hệ thống giáo dục hiện tại và đưa ra những giải pháp thích ứng.</p>','\"/uploads/questions/test-img.jpg\"','null','Câu trả lời mở, cần phân tích đa chiều về tác động tích cực và tiêu cực, đề xuất giải pháp cụ thể.','\"/uploads/questions/test-img.jpg\"',50,'Gold','Đây là câu hỏi mở, yêu cầu thí sinh phân tích sâu và đưa ra quan điểm cá nhân có cơ sở.',13,1,'2026-10-19 12:14:46.022','2026-10-19 12:14:46.022'),(34,'Câu hỏi Vật lý cơ bản',45,'multiple_choice','<p>Đơn vị của vận tốc trong hệ SI là gì?</p>','\"/uploads/questions/test-img.jpg\"','[\"m\",\"m/s\",\"m/s²\",\"kg\"]','m/s','\"/uploads/questions/test-img.jpg\"',15,'Alpha','Vận tốc có đơn vị là mét trên giây (m/s)',12,1,'2026-10-19 12:14:46.022','2026-10-19 12:14:46.022'),(35,'Câu hỏi Hóa học',40,'multiple_choice','<p>Công thức hóa học của nước là gì?</p>','\"/uploads/questions/test-img.jpg\"','[\"H₂O\",\"CO₂\",\"NaCl\",\"H₂SO₄\"]','H₂O','\"/uploads/questions/test-img.jpg\"',10,'Alpha','Nước có công thức hóa học là H₂O',15,1,'2026-10-19 12:14:46.023','2026-10-19 12:14:46.023'),(36,'Câu hỏi khó',90,'essay','<p>Hãy phân tích tác động của cách mạng công nghiệp 4.0 đến hệ thống giáo dục hiện tại và đưa ra những giải pháp thích ứng.</p>','\"/uploads/questions/test-img.jpg\"','null','Câu trả lời mở, cần phân tích đa chiều về tác động tích cực và tiêu cực, đề xuất giải pháp cụ thể.','\"/uploads/questions/test-img.jpg\"',50,'Gold','Đây là câu hỏi mở, yêu cầu thí sinh phân tích sâu và đưa ra quan điểm cá nhân có cơ sở.',14,1,'2026-10-19 12:14:46.023','2026-10-19 12:14:46.023'),(37,'Câu hỏi Vật lý cơ bản',45,'multiple_choice','<p>Đơn vị của vận tốc trong hệ SI là gì?</p>','\"/uploads/questions/test-img.jpg\"','[\"m\",\"m/s\",\"m/s²\",\"kg\"]','m/s','\"/uploads/questions/test-img.jpg\"',15,'Alpha','Vận tốc có đơn vị là mét trên giây (m/s)',13,1,'2026-10-19 12:14:46.022','2026-10-19 12:14:46.022'),(38,'Câu hỏi Toán học cơ bản',30,'multiple_choice','<p>Tính: 2 + 3 = ?</p>','\"/uploads/questions/test-img.jpg\"','[\"4\",\"5\",\"6\",\"7\"]','5','\"/uploads/questions/test-img.jpg\"',10,'Alpha','2 + 3 = 5',15,1,'2026-10-19 12:14:46.023','2026-10-19 12:14:46.023'),(39,'Câu hỏi Lịch sử Việt Nam',35,'multiple_choice','<p>Việt Nam tuyên bố độc lập vào ngày nào?</p>','\"/uploads/questions/test-img.jpg\"','[\"2/9/1945\",\"30/4/1975\",\"19/8/1945\",\"1/5/1975\"]','2/9/1945','\"/uploads/questions/test-img.jpg\"',10,'Alpha','Việt Nam tuyên bố độc lập vào ngày 2/9/1945',12,1,'2026-10-19 12:14:46.023','2026-10-19 12:14:46.023'),(40,'Câu hỏi Vật lý cơ bản',45,'multiple_choice','<p>Đơn vị của vận tốc trong hệ SI là gì?</p>','\"/uploads/questions/test-img.jpg\"','[\"m\",\"m/s\",\"m/s²\",\"kg\"]','m/s','\"/uploads/questions/test-img.jpg\"',15,'Alpha','Vận tốc có đơn vị là mét trên giây (m/s)',15,1,'2026-10-19 12:14:46.023','2026-10-19 12:14:46.023');
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refreshtokens`
--

DROP TABLE IF EXISTS `refreshtokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `refreshtokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `refreshToken` text NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `expiredAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `refreshtokens_userId_fkey` (`userId`),
  CONSTRAINT `refreshtokens_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refreshtokens`
--

LOCK TABLES `refreshtokens` WRITE;
/*!40000 ALTER TABLE `refreshtokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `refreshtokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rescues`
--

DROP TABLE IF EXISTS `rescues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rescues` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `rescueType` enum('resurrected','lifelineUsed') NOT NULL,
  `questionFrom` int(11) NOT NULL,
  `questionTo` int(11) NOT NULL,
  `studentIds` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`studentIds`)),
  `supportAnswers` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`supportAnswers`)),
  `remainingContestants` int(11) NOT NULL,
  `questionOrder` int(11) DEFAULT NULL,
  `index` int(11) DEFAULT NULL,
  `status` enum('notUsed','used','passed','notEligible','proposed') NOT NULL,
  `match_id` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `rescues_match_id_fkey` (`match_id`),
  CONSTRAINT `rescues_match_id_fkey` FOREIGN KEY (`match_id`) REFERENCES `matches` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rescues`
--

LOCK TABLES `rescues` WRITE;
/*!40000 ALTER TABLE `rescues` DISABLE KEYS */;
/*!40000 ALTER TABLE `rescues` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `results`
--

DROP TABLE IF EXISTS `results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contestant_id` int(11) NOT NULL,
  `match_id` int(11) NOT NULL,
  `isCorrect` tinyint(1) NOT NULL DEFAULT 1,
  `questionOrder` int(11) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `results_contestant_id_fkey` (`contestant_id`),
  KEY `results_match_id_fkey` (`match_id`),
  CONSTRAINT `results_contestant_id_fkey` FOREIGN KEY (`contestant_id`) REFERENCES `contestants` (`id`),
  CONSTRAINT `results_match_id_fkey` FOREIGN KEY (`match_id`) REFERENCES `matches` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `results`
--

LOCK TABLES `results` WRITE;
/*!40000 ALTER TABLE `results` DISABLE KEYS */;
/*!40000 ALTER TABLE `results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rounds`
--

DROP TABLE IF EXISTS `rounds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rounds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `index` int(11) NOT NULL,
  `contestId` int(11) NOT NULL,
  `startTime` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `endTime` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `rounds_contestId_fkey` (`contestId`),
  CONSTRAINT `rounds_contestId_fkey` FOREIGN KEY (`contestId`) REFERENCES `contests` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rounds`
--

LOCK TABLES `rounds` WRITE;
/*!40000 ALTER TABLE `rounds` DISABLE KEYS */;
INSERT INTO `rounds` VALUES (1,'Vòng Quý',2,2,'2026-10-19 12:14:46.104','2026-10-19 12:14:46.104',1,'2026-10-19 12:14:46.104','2026-10-19 12:14:46.104'),(2,'Bán kết',2,3,'2026-10-19 12:14:46.104','2026-10-19 12:14:46.104',1,'2026-10-19 12:14:46.104','2026-10-19 12:14:46.104'),(3,'Chung kết',4,2,'2026-10-19 12:14:46.104','2026-10-19 12:14:46.104',1,'2026-10-19 12:14:46.104','2026-10-19 12:14:46.104'),(4,'Vòng Tháng',1,2,'2026-10-19 12:14:46.104','2026-10-19 12:14:46.104',1,'2026-10-19 12:14:46.104','2026-10-19 12:14:46.104'),(5,'Vòng chung kết',2,1,'2026-10-19 12:14:46.104','2026-10-19 12:14:46.104',1,'2026-10-19 12:14:46.104','2026-10-19 12:14:46.104'),(6,'Vòng sơ loại',1,1,'2026-10-19 12:14:46.104','2026-10-19 12:14:46.104',1,'2026-10-19 12:14:46.104','2026-10-19 12:14:46.104'),(7,'Chung kết',3,3,'2026-10-19 12:14:46.104','2026-10-19 12:14:46.104',1,'2026-10-19 12:14:46.104','2026-10-19 12:14:46.104'),(8,'Vòng Năm',3,2,'2026-10-19 12:14:46.104','2026-10-19 12:14:46.104',1,'2026-10-19 12:14:46.104','2026-10-19 12:14:46.104'),(9,'Vòng loại',1,3,'2026-10-19 12:14:46.104','2026-10-19 12:14:46.104',1,'2026-10-19 12:14:46.104','2026-10-19 12:14:46.104');
/*!40000 ALTER TABLE `rounds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schools`
--

DROP TABLE IF EXISTS `schools`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schools` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(10) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `schools_email_key` (`email`),
  UNIQUE KEY `schools_phone_key` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schools`
--

LOCK TABLES `schools` WRITE;
/*!40000 ALTER TABLE `schools` DISABLE KEYS */;
INSERT INTO `schools` VALUES (1,'Trường THPT Trần Phú','tranphu@edu.vn','0123456787','789 Đường Nguyễn Văn Cừ, Quận 5, TP.HCM',1,'2026-10-19 12:14:32.995','2026-10-19 12:14:32.995'),(2,'Trường THPT Bùi Thị Xuân','buithixuan@edu.vn','0123456785','654 Đường Cách Mạng Tháng 8, Quận Tân Bình, TP.HCM',1,'2026-10-19 12:14:32.995','2026-10-19 12:14:32.995'),(3,'Trường THPT Lê Thánh Tông','lethanhtong@edu.vn','0123456788','456 Đường Trần Hưng Đạo, Quận 3, TP.HCM',1,'2026-10-19 12:14:32.995','2026-10-19 12:14:32.995'),(4,'Trường THPT Lý Thường Kiệt','lythuongkiet@edu.vn','0123456786','321 Đường Võ Văn Tần, Quận 10, TP.HCM',1,'2026-10-19 12:14:32.995','2026-10-19 12:14:32.995'),(5,'Trường THPT Nguyễn Huệ','nguyenhue@edu.vn','0123456789','123 Đường Lê Lợi, Quận 1, TP.HCM',1,'2026-10-19 12:14:32.995','2026-10-19 12:14:32.995');
/*!40000 ALTER TABLE `schools` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `screen_controls`
--

DROP TABLE IF EXISTS `screen_controls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `screen_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `controlKey` enum('wingold','qrcode','background','question','questionIntro','questionInfo','answer','matchDiagram','explanation','firstPrize','secondPrize','thirdPrize','fourthPrize','impressiveVideo','excellentVideo','allPrize','topWin','listEliminated','listRescued','video','audio','image','chart','statistic','top20Winner','chartContestant') NOT NULL DEFAULT 'background',
  `controlValue` enum('start','pause','reset','Eliminated','Rescued') DEFAULT NULL,
  `matchId` int(11) NOT NULL,
  `media` varchar(255) DEFAULT NULL,
  `value` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `screen_controls_matchId_key` (`matchId`),
  CONSTRAINT `screen_controls_matchId_fkey` FOREIGN KEY (`matchId`) REFERENCES `matches` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `screen_controls`
--

LOCK TABLES `screen_controls` WRITE;
/*!40000 ALTER TABLE `screen_controls` DISABLE KEYS */;
/*!40000 ALTER TABLE `screen_controls` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sponsors`
--

DROP TABLE IF EXISTS `sponsors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sponsors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `images` varchar(255) DEFAULT NULL,
  `videos` varchar(255) NOT NULL,
  `contestId` int(11) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sponsors_contestId_fkey` (`contestId`),
  CONSTRAINT `sponsors_contestId_fkey` FOREIGN KEY (`contestId`) REFERENCES `contests` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sponsors`
--

LOCK TABLES `sponsors` WRITE;
/*!40000 ALTER TABLE `sponsors` DISABLE KEYS */;
INSERT INTO `sponsors` VALUES (1,'Tập đoàn Vingroup','/uploads/sponsors/logos/vingroup-gallery.jpg','/uploads/sponsors/images/vingroup-gallery.jpg','/uploads/sponsors/videos/vingroup-gallery.jpg',NULL,'2026-10-19 12:14:32.988','2026-10-19 12:14:32.988'),(2,'Công ty Grab Việt Nam','/uploads/sponsors/logos/grab-logo.png','/uploads/sponsors/images/grab-gallery.jpg','/uploads/sponsors/videos/grab-intro.mp4',NULL,'2026-10-19 12:14:32.988','2026-10-19 12:14:32.988'),(3,'Tập đoàn FPT','/uploads/sponsors/logos/fpt-logo.png','/uploads/sponsors/images/fpt-gallery.jpg','/uploads/sponsors/videos/fpt-intro.mp4',NULL,'2026-10-19 12:14:32.988','2026-10-19 12:14:32.988'),(4,'Tập đoàn Masan','/uploads/sponsors/logos/masan-logo.png','/uploads/sponsors/images/masan-gallery.jpg','/uploads/sponsors/videos/masan-intro.mp4',NULL,'2026-10-19 12:14:32.988','2026-10-19 12:14:32.988'),(5,'Ngân hàng Vietcombank','/uploads/sponsors/logos/vietcombank-logo.png','/uploads/sponsors/images/vietcombank-gallery.jpg','/uploads/sponsors/videos/vietcombank-intro.mp4',NULL,'2026-10-19 12:14:32.988','2026-10-19 12:14:32.988'),(6,'Công ty Samsung Việt Nam','/uploads/sponsors/logos/samsung-logo.png','/uploads/sponsors/images/samsung-gallery.jpg','/uploads/sponsors/videos/samsung-intro.mp4',NULL,'2026-10-19 12:14:32.988','2026-10-19 12:14:32.988');
/*!40000 ALTER TABLE `sponsors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `students` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `full_name` varchar(255) NOT NULL,
  `student_code` varchar(12) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `classId` int(11) NOT NULL,
  `userId` int(11) DEFAULT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `students_userId_key` (`userId`),
  KEY `students_classId_fkey` (`classId`),
  CONSTRAINT `students_classId_fkey` FOREIGN KEY (`classId`) REFERENCES `classes` (`id`),
  CONSTRAINT `students_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=202 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (1,'Học sinh 1 lớp 11A1 - Trường THPT Trần Phú','10101',NULL,NULL,1,2,1,'2026-10-19 12:14:33.087','2026-10-19 12:14:33.087'),(2,'Học sinh 2 lớp 11A1 - Trường THPT Trần Phú','10102',NULL,NULL,1,3,1,'2026-10-19 12:14:33.158','2026-10-19 12:14:33.158'),(3,'Học sinh 3 lớp 11A1 - Trường THPT Trần Phú','10103',NULL,NULL,1,4,1,'2026-10-19 12:14:33.223','2026-10-19 12:14:33.223'),(4,'Học sinh 4 lớp 11A1 - Trường THPT Trần Phú','10104',NULL,NULL,1,5,1,'2026-10-19 12:14:33.285','2026-10-19 12:14:33.285'),(5,'Học sinh 5 lớp 11A1 - Trường THPT Trần Phú','10105',NULL,NULL,1,6,1,'2026-10-19 12:14:33.350','2026-10-19 12:14:33.350'),(6,'Học sinh 1 lớp 12A1 - Trường THPT Trần Phú','10201',NULL,NULL,2,7,1,'2026-10-19 12:14:33.420','2026-10-19 12:14:33.420'),(7,'Học sinh 2 lớp 12A1 - Trường THPT Trần Phú','10202',NULL,NULL,2,8,1,'2026-10-19 12:14:33.484','2026-10-19 12:14:33.484'),(8,'Học sinh 3 lớp 12A1 - Trường THPT Trần Phú','10203',NULL,NULL,2,9,1,'2026-10-19 12:14:33.547','2026-10-19 12:14:33.547'),(9,'Học sinh 4 lớp 12A1 - Trường THPT Trần Phú','10204',NULL,NULL,2,10,1,'2026-10-19 12:14:33.610','2026-10-19 12:14:33.610'),(10,'Học sinh 5 lớp 12A1 - Trường THPT Trần Phú','10205',NULL,NULL,2,11,1,'2026-10-19 12:14:33.674','2026-10-19 12:14:33.674'),(11,'Học sinh 6 lớp 12A1 - Trường THPT Trần Phú','10206',NULL,NULL,2,12,1,'2026-10-19 12:14:33.737','2026-10-19 12:14:33.737'),(12,'Học sinh 7 lớp 12A1 - Trường THPT Trần Phú','10207',NULL,NULL,2,13,1,'2026-10-19 12:14:33.799','2026-10-19 12:14:33.799'),(13,'Học sinh 1 lớp 10A1 - Trường THPT Trần Phú','10301',NULL,NULL,3,14,1,'2026-10-19 12:14:33.863','2026-10-19 12:14:33.863'),(14,'Học sinh 2 lớp 10A1 - Trường THPT Trần Phú','10302',NULL,NULL,3,15,1,'2026-10-19 12:14:33.927','2026-10-19 12:14:33.927'),(15,'Học sinh 3 lớp 10A1 - Trường THPT Trần Phú','10303',NULL,NULL,3,16,1,'2026-10-19 12:14:33.990','2026-10-19 12:14:33.990'),(16,'Học sinh 4 lớp 10A1 - Trường THPT Trần Phú','10304',NULL,NULL,3,17,1,'2026-10-19 12:14:34.053','2026-10-19 12:14:34.053'),(17,'Học sinh 5 lớp 10A1 - Trường THPT Trần Phú','10305',NULL,NULL,3,18,1,'2026-10-19 12:14:34.117','2026-10-19 12:14:34.117'),(18,'Học sinh 6 lớp 10A1 - Trường THPT Trần Phú','10306',NULL,NULL,3,19,1,'2026-10-19 12:14:34.180','2026-10-19 12:14:34.180'),(19,'Học sinh 7 lớp 10A1 - Trường THPT Trần Phú','10307',NULL,NULL,3,20,1,'2026-10-19 12:14:34.245','2026-10-19 12:14:34.245'),(20,'Học sinh 1 lớp 12A2 - Trường THPT Trần Phú','10401',NULL,NULL,4,21,1,'2026-10-19 12:14:34.307','2026-10-19 12:14:34.307'),(21,'Học sinh 2 lớp 12A2 - Trường THPT Trần Phú','10402',NULL,NULL,4,22,1,'2026-10-19 12:14:34.373','2026-10-19 12:14:34.373'),(22,'Học sinh 3 lớp 12A2 - Trường THPT Trần Phú','10403',NULL,NULL,4,23,1,'2026-10-19 12:14:34.435','2026-10-19 12:14:34.435'),(23,'Học sinh 4 lớp 12A2 - Trường THPT Trần Phú','10404',NULL,NULL,4,24,1,'2026-10-19 12:14:34.499','2026-10-19 12:14:34.499'),(24,'Học sinh 5 lớp 12A2 - Trường THPT Trần Phú','10405',NULL,NULL,4,25,1,'2026-10-19 12:14:34.561','2026-10-19 12:14:34.561'),(25,'Học sinh 6 lớp 12A2 - Trường THPT Trần Phú','10406',NULL,NULL,4,26,1,'2026-10-19 12:14:34.622','2026-10-19 12:14:34.622'),(26,'Học sinh 7 lớp 12A2 - Trường THPT Trần Phú','10407',NULL,NULL,4,27,1,'2026-10-19 12:14:34.688','2026-10-19 12:14:34.688'),(27,'Học sinh 8 lớp 12A2 - Trường THPT Trần Phú','10408',NULL,NULL,4,28,1,'2026-10-19 12:14:34.750','2026-10-19 12:14:34.750'),(28,'Học sinh 1 lớp 11A2 - Trường THPT Trần Phú','10501',NULL,NULL,5,29,1,'2026-10-19 12:14:34.813','2026-10-19 12:14:34.813'),(29,'Học sinh 2 lớp 11A2 - Trường THPT Trần Phú','10502',NULL,NULL,5,30,1,'2026-10-19 12:14:34.875','2026-10-19 12:14:34.875'),(30,'Học sinh 3 lớp 11A2 - Trường THPT Trần Phú','10503',NULL,NULL,5,31,1,'2026-10-19 12:14:34.937','2026-10-19 12:14:34.937'),(31,'Học sinh 4 lớp 11A2 - Trường THPT Trần Phú','10504',NULL,NULL,5,32,1,'2026-10-19 12:14:35.003','2026-10-19 12:14:35.003'),(32,'Học sinh 5 lớp 11A2 - Trường THPT Trần Phú','10505',NULL,NULL,5,33,1,'2026-10-19 12:14:35.065','2026-10-19 12:14:35.065'),(33,'Học sinh 1 lớp 10A2 - Trường THPT Trần Phú','10601',NULL,NULL,6,34,1,'2026-10-19 12:14:35.128','2026-10-19 12:14:35.128'),(34,'Học sinh 2 lớp 10A2 - Trường THPT Trần Phú','10602',NULL,NULL,6,35,1,'2026-10-19 12:14:35.191','2026-10-19 12:14:35.191'),(35,'Học sinh 3 lớp 10A2 - Trường THPT Trần Phú','10603',NULL,NULL,6,36,1,'2026-10-19 12:14:35.262','2026-10-19 12:14:35.262'),(36,'Học sinh 4 lớp 10A2 - Trường THPT Trần Phú','10604',NULL,NULL,6,37,1,'2026-10-19 12:14:35.325','2026-10-19 12:14:35.325'),(37,'Học sinh 5 lớp 10A2 - Trường THPT Trần Phú','10605',NULL,NULL,6,38,1,'2026-10-19 12:14:35.388','2026-10-19 12:14:35.388'),(38,'Học sinh 6 lớp 10A2 - Trường THPT Trần Phú','10606',NULL,NULL,6,39,1,'2026-10-19 12:14:35.454','2026-10-19 12:14:35.454'),(39,'Học sinh 7 lớp 10A2 - Trường THPT Trần Phú','10607',NULL,NULL,6,40,1,'2026-10-19 12:14:35.516','2026-10-19 12:14:35.516'),(40,'Học sinh 1 lớp 10A1 - Trường THPT Lê Thánh Tông','10701',NULL,NULL,7,41,1,'2026-10-19 12:14:35.586','2026-10-19 12:14:35.586'),(41,'Học sinh 2 lớp 10A1 - Trường THPT Lê Thánh Tông','10702',NULL,NULL,7,42,1,'2026-10-19 12:14:35.648','2026-10-19 12:14:35.648'),(42,'Học sinh 3 lớp 10A1 - Trường THPT Lê Thánh Tông','10703',NULL,NULL,7,43,1,'2026-10-19 12:14:35.711','2026-10-19 12:14:35.711'),(43,'Học sinh 4 lớp 10A1 - Trường THPT Lê Thánh Tông','10704',NULL,NULL,7,44,1,'2026-10-19 12:14:35.775','2026-10-19 12:14:35.775'),(44,'Học sinh 5 lớp 10A1 - Trường THPT Lê Thánh Tông','10705',NULL,NULL,7,45,1,'2026-10-19 12:14:35.837','2026-10-19 12:14:35.837'),(45,'Học sinh 6 lớp 10A1 - Trường THPT Lê Thánh Tông','10706',NULL,NULL,7,46,1,'2026-10-19 12:14:35.900','2026-10-19 12:14:35.900'),(46,'Học sinh 1 lớp 11A1 - Trường THPT Lê Thánh Tông','10801',NULL,NULL,8,47,1,'2026-10-19 12:14:35.962','2026-10-19 12:14:35.962'),(47,'Học sinh 2 lớp 11A1 - Trường THPT Lê Thánh Tông','10802',NULL,NULL,8,48,1,'2026-10-19 12:14:36.029','2026-10-19 12:14:36.029'),(48,'Học sinh 3 lớp 11A1 - Trường THPT Lê Thánh Tông','10803',NULL,NULL,8,49,1,'2026-10-19 12:14:36.090','2026-10-19 12:14:36.090'),(49,'Học sinh 4 lớp 11A1 - Trường THPT Lê Thánh Tông','10804',NULL,NULL,8,50,1,'2026-10-19 12:14:36.158','2026-10-19 12:14:36.158'),(50,'Học sinh 5 lớp 11A1 - Trường THPT Lê Thánh Tông','10805',NULL,NULL,8,51,1,'2026-10-19 12:14:36.227','2026-10-19 12:14:36.227'),(51,'Học sinh 1 lớp 10A1 - Trường THPT Bùi Thị Xuân','10901',NULL,NULL,9,52,1,'2026-10-19 12:14:36.290','2026-10-19 12:14:36.290'),(52,'Học sinh 2 lớp 10A1 - Trường THPT Bùi Thị Xuân','10902',NULL,NULL,9,53,1,'2026-10-19 12:14:36.351','2026-10-19 12:14:36.351'),(53,'Học sinh 3 lớp 10A1 - Trường THPT Bùi Thị Xuân','10903',NULL,NULL,9,54,1,'2026-10-19 12:14:36.415','2026-10-19 12:14:36.415'),(54,'Học sinh 4 lớp 10A1 - Trường THPT Bùi Thị Xuân','10904',NULL,NULL,9,55,1,'2026-10-19 12:14:36.477','2026-10-19 12:14:36.477'),(55,'Học sinh 5 lớp 10A1 - Trường THPT Bùi Thị Xuân','10905',NULL,NULL,9,56,1,'2026-10-19 12:14:36.546','2026-10-19 12:14:36.546'),(56,'Học sinh 6 lớp 10A1 - Trường THPT Bùi Thị Xuân','10906',NULL,NULL,9,57,1,'2026-10-19 12:14:36.613','2026-10-19 12:14:36.613'),(57,'Học sinh 7 lớp 10A1 - Trường THPT Bùi Thị Xuân','10907',NULL,NULL,9,58,1,'2026-10-19 12:14:36.678','2026-10-19 12:14:36.678'),(58,'Học sinh 8 lớp 10A1 - Trường THPT Bùi Thị Xuân','10908',NULL,NULL,9,59,1,'2026-10-19 12:14:36.745','2026-10-19 12:14:36.745'),(59,'Học sinh 1 lớp 12A1 - Trường THPT Bùi Thị Xuân','11001',NULL,NULL,10,60,1,'2026-10-19 12:14:36.808','2026-10-19 12:14:36.808'),(60,'Học sinh 2 lớp 12A1 - Trường THPT Bùi Thị Xuân','11002',NULL,NULL,10,61,1,'2026-10-19 12:14:36.875','2026-10-19 12:14:36.875'),(61,'Học sinh 3 lớp 12A1 - Trường THPT Bùi Thị Xuân','11003',NULL,NULL,10,62,1,'2026-10-19 12:14:36.938','2026-10-19 12:14:36.938'),(62,'Học sinh 4 lớp 12A1 - Trường THPT Bùi Thị Xuân','11004',NULL,NULL,10,63,1,'2026-10-19 12:14:37.000','2026-10-19 12:14:37.000'),(63,'Học sinh 5 lớp 12A1 - Trường THPT Bùi Thị Xuân','11005',NULL,NULL,10,64,1,'2026-10-19 12:14:37.063','2026-10-19 12:14:37.063'),(64,'Học sinh 6 lớp 12A1 - Trường THPT Bùi Thị Xuân','11006',NULL,NULL,10,65,1,'2026-10-19 12:14:37.126','2026-10-19 12:14:37.126'),(65,'Học sinh 7 lớp 12A1 - Trường THPT Bùi Thị Xuân','11007',NULL,NULL,10,66,1,'2026-10-19 12:14:37.193','2026-10-19 12:14:37.193'),(66,'Học sinh 8 lớp 12A1 - Trường THPT Bùi Thị Xuân','11008',NULL,NULL,10,67,1,'2026-10-19 12:14:37.255','2026-10-19 12:14:37.255'),(67,'Học sinh 1 lớp 11A1 - Trường THPT Bùi Thị Xuân','11101',NULL,NULL,11,68,1,'2026-10-19 12:14:37.318','2026-10-19 12:14:37.318'),(68,'Học sinh 2 lớp 11A1 - Trường THPT Bùi Thị Xuân','11102',NULL,NULL,11,69,1,'2026-10-19 12:14:37.382','2026-10-19 12:14:37.382'),(69,'Học sinh 3 lớp 11A1 - Trường THPT Bùi Thị Xuân','11103',NULL,NULL,11,70,1,'2026-10-19 12:14:37.452','2026-10-19 12:14:37.452'),(70,'Học sinh 4 lớp 11A1 - Trường THPT Bùi Thị Xuân','11104',NULL,NULL,11,71,1,'2026-10-19 12:14:37.520','2026-10-19 12:14:37.520'),(71,'Học sinh 5 lớp 11A1 - Trường THPT Bùi Thị Xuân','11105',NULL,NULL,11,72,1,'2026-10-19 12:14:37.589','2026-10-19 12:14:37.589'),(72,'Học sinh 6 lớp 11A1 - Trường THPT Bùi Thị Xuân','11106',NULL,NULL,11,73,1,'2026-10-19 12:14:37.652','2026-10-19 12:14:37.652'),(73,'Học sinh 1 lớp 10A2 - Trường THPT Bùi Thị Xuân','11201',NULL,NULL,12,74,1,'2026-10-19 12:14:37.718','2026-10-19 12:14:37.718'),(74,'Học sinh 2 lớp 10A2 - Trường THPT Bùi Thị Xuân','11202',NULL,NULL,12,75,1,'2026-10-19 12:14:37.787','2026-10-19 12:14:37.787'),(75,'Học sinh 3 lớp 10A2 - Trường THPT Bùi Thị Xuân','11203',NULL,NULL,12,76,1,'2026-10-19 12:14:37.856','2026-10-19 12:14:37.856'),(76,'Học sinh 4 lớp 10A2 - Trường THPT Bùi Thị Xuân','11204',NULL,NULL,12,77,1,'2026-10-19 12:14:37.919','2026-10-19 12:14:37.919'),(77,'Học sinh 5 lớp 10A2 - Trường THPT Bùi Thị Xuân','11205',NULL,NULL,12,78,1,'2026-10-19 12:14:37.983','2026-10-19 12:14:37.983'),(78,'Học sinh 6 lớp 10A2 - Trường THPT Bùi Thị Xuân','11206',NULL,NULL,12,79,1,'2026-10-19 12:14:38.045','2026-10-19 12:14:38.045'),(79,'Học sinh 7 lớp 10A2 - Trường THPT Bùi Thị Xuân','11207',NULL,NULL,12,80,1,'2026-10-19 12:14:38.109','2026-10-19 12:14:38.109'),(80,'Học sinh 1 lớp 11A1 - Trường THPT Lý Thường Kiệt','11301',NULL,NULL,13,81,1,'2026-10-19 12:14:38.173','2026-10-19 12:14:38.173'),(81,'Học sinh 2 lớp 11A1 - Trường THPT Lý Thường Kiệt','11302',NULL,NULL,13,82,1,'2026-10-19 12:14:38.236','2026-10-19 12:14:38.236'),(82,'Học sinh 3 lớp 11A1 - Trường THPT Lý Thường Kiệt','11303',NULL,NULL,13,83,1,'2026-10-19 12:14:38.299','2026-10-19 12:14:38.299'),(83,'Học sinh 4 lớp 11A1 - Trường THPT Lý Thường Kiệt','11304',NULL,NULL,13,84,1,'2026-10-19 12:14:38.363','2026-10-19 12:14:38.363'),(84,'Học sinh 5 lớp 11A1 - Trường THPT Lý Thường Kiệt','11305',NULL,NULL,13,85,1,'2026-10-19 12:14:38.426','2026-10-19 12:14:38.426'),(85,'Học sinh 6 lớp 11A1 - Trường THPT Lý Thường Kiệt','11306',NULL,NULL,13,86,1,'2026-10-19 12:14:38.493','2026-10-19 12:14:38.493'),(86,'Học sinh 7 lớp 11A1 - Trường THPT Lý Thường Kiệt','11307',NULL,NULL,13,87,1,'2026-10-19 12:14:38.560','2026-10-19 12:14:38.560'),(87,'Học sinh 8 lớp 11A1 - Trường THPT Lý Thường Kiệt','11308',NULL,NULL,13,88,1,'2026-10-19 12:14:38.628','2026-10-19 12:14:38.628'),(88,'Học sinh 1 lớp 11A2 - Trường THPT Lê Thánh Tông','11401',NULL,NULL,14,89,1,'2026-10-19 12:14:38.691','2026-10-19 12:14:38.691'),(89,'Học sinh 2 lớp 11A2 - Trường THPT Lê Thánh Tông','11402',NULL,NULL,14,90,1,'2026-10-19 12:14:38.756','2026-10-19 12:14:38.756'),(90,'Học sinh 3 lớp 11A2 - Trường THPT Lê Thánh Tông','11403',NULL,NULL,14,91,1,'2026-10-19 12:14:38.822','2026-10-19 12:14:38.822'),(91,'Học sinh 4 lớp 11A2 - Trường THPT Lê Thánh Tông','11404',NULL,NULL,14,92,1,'2026-10-19 12:14:38.883','2026-10-19 12:14:38.883'),(92,'Học sinh 5 lớp 11A2 - Trường THPT Lê Thánh Tông','11405',NULL,NULL,14,93,1,'2026-10-19 12:14:38.948','2026-10-19 12:14:38.948'),(93,'Học sinh 1 lớp 11A2 - Trường THPT Bùi Thị Xuân','11501',NULL,NULL,15,94,1,'2026-10-19 12:14:39.012','2026-10-19 12:14:39.012'),(94,'Học sinh 2 lớp 11A2 - Trường THPT Bùi Thị Xuân','11502',NULL,NULL,15,95,1,'2026-10-19 12:14:39.074','2026-10-19 12:14:39.074'),(95,'Học sinh 3 lớp 11A2 - Trường THPT Bùi Thị Xuân','11503',NULL,NULL,15,96,1,'2026-10-19 12:14:39.137','2026-10-19 12:14:39.137'),(96,'Học sinh 4 lớp 11A2 - Trường THPT Bùi Thị Xuân','11504',NULL,NULL,15,97,1,'2026-10-19 12:14:39.202','2026-10-19 12:14:39.202'),(97,'Học sinh 5 lớp 11A2 - Trường THPT Bùi Thị Xuân','11505',NULL,NULL,15,98,1,'2026-10-19 12:14:39.263','2026-10-19 12:14:39.263'),(98,'Học sinh 6 lớp 11A2 - Trường THPT Bùi Thị Xuân','11506',NULL,NULL,15,99,1,'2026-10-19 12:14:39.325','2026-10-19 12:14:39.325'),(99,'Học sinh 7 lớp 11A2 - Trường THPT Bùi Thị Xuân','11507',NULL,NULL,15,100,1,'2026-10-19 12:14:39.387','2026-10-19 12:14:39.387'),(100,'Học sinh 1 lớp 12A2 - Trường THPT Lý Thường Kiệt','11601',NULL,NULL,16,101,1,'2026-10-19 12:14:39.448','2026-10-19 12:14:39.448'),(101,'Học sinh 2 lớp 12A2 - Trường THPT Lý Thường Kiệt','11602',NULL,NULL,16,102,1,'2026-10-19 12:14:39.509','2026-10-19 12:14:39.509'),(102,'Học sinh 3 lớp 12A2 - Trường THPT Lý Thường Kiệt','11603',NULL,NULL,16,103,1,'2026-10-19 12:14:39.571','2026-10-19 12:14:39.571'),(103,'Học sinh 4 lớp 12A2 - Trường THPT Lý Thường Kiệt','11604',NULL,NULL,16,104,1,'2026-10-19 12:14:39.636','2026-10-19 12:14:39.636'),(104,'Học sinh 5 lớp 12A2 - Trường THPT Lý Thường Kiệt','11605',NULL,NULL,16,105,1,'2026-10-19 12:14:39.698','2026-10-19 12:14:39.698'),(105,'Học sinh 6 lớp 12A2 - Trường THPT Lý Thường Kiệt','11606',NULL,NULL,16,106,1,'2026-10-19 12:14:39.759','2026-10-19 12:14:39.759'),(106,'Học sinh 1 lớp 12A2 - Trường THPT Lê Thánh Tông','11701',NULL,NULL,17,107,1,'2026-10-19 12:14:39.820','2026-10-19 12:14:39.820'),(107,'Học sinh 2 lớp 12A2 - Trường THPT Lê Thánh Tông','11702',NULL,NULL,17,108,1,'2026-10-19 12:14:39.882','2026-10-19 12:14:39.882'),(108,'Học sinh 3 lớp 12A2 - Trường THPT Lê Thánh Tông','11703',NULL,NULL,17,109,1,'2026-10-19 12:14:39.945','2026-10-19 12:14:39.945'),(109,'Học sinh 4 lớp 12A2 - Trường THPT Lê Thánh Tông','11704',NULL,NULL,17,110,1,'2026-10-19 12:14:40.008','2026-10-19 12:14:40.008'),(110,'Học sinh 5 lớp 12A2 - Trường THPT Lê Thánh Tông','11705',NULL,NULL,17,111,1,'2026-10-19 12:14:40.068','2026-10-19 12:14:40.068'),(111,'Học sinh 1 lớp 12A1 - Trường THPT Nguyễn Huệ','11801',NULL,NULL,18,112,1,'2026-10-19 12:14:40.131','2026-10-19 12:14:40.131'),(112,'Học sinh 2 lớp 12A1 - Trường THPT Nguyễn Huệ','11802',NULL,NULL,18,113,1,'2026-10-19 12:14:40.193','2026-10-19 12:14:40.193'),(113,'Học sinh 3 lớp 12A1 - Trường THPT Nguyễn Huệ','11803',NULL,NULL,18,114,1,'2026-10-19 12:14:40.260','2026-10-19 12:14:40.260'),(114,'Học sinh 4 lớp 12A1 - Trường THPT Nguyễn Huệ','11804',NULL,NULL,18,115,1,'2026-10-19 12:14:40.326','2026-10-19 12:14:40.326'),(115,'Học sinh 5 lớp 12A1 - Trường THPT Nguyễn Huệ','11805',NULL,NULL,18,116,1,'2026-10-19 12:14:40.389','2026-10-19 12:14:40.389'),(116,'Học sinh 6 lớp 12A1 - Trường THPT Nguyễn Huệ','11806',NULL,NULL,18,117,1,'2026-10-19 12:14:40.452','2026-10-19 12:14:40.452'),(117,'Học sinh 7 lớp 12A1 - Trường THPT Nguyễn Huệ','11807',NULL,NULL,18,118,1,'2026-10-19 12:14:40.516','2026-10-19 12:14:40.516'),(118,'Học sinh 1 lớp 10A2 - Trường THPT Nguyễn Huệ','11901',NULL,NULL,19,119,1,'2026-10-19 12:14:40.578','2026-10-19 12:14:40.578'),(119,'Học sinh 2 lớp 10A2 - Trường THPT Nguyễn Huệ','11902',NULL,NULL,19,120,1,'2026-10-19 12:14:40.640','2026-10-19 12:14:40.640'),(120,'Học sinh 3 lớp 10A2 - Trường THPT Nguyễn Huệ','11903',NULL,NULL,19,121,1,'2026-10-19 12:14:40.702','2026-10-19 12:14:40.702'),(121,'Học sinh 4 lớp 10A2 - Trường THPT Nguyễn Huệ','11904',NULL,NULL,19,122,1,'2026-10-19 12:14:40.773','2026-10-19 12:14:40.773'),(122,'Học sinh 5 lớp 10A2 - Trường THPT Nguyễn Huệ','11905',NULL,NULL,19,123,1,'2026-10-19 12:14:40.838','2026-10-19 12:14:40.838'),(123,'Học sinh 6 lớp 10A2 - Trường THPT Nguyễn Huệ','11906',NULL,NULL,19,124,1,'2026-10-19 12:14:40.905','2026-10-19 12:14:40.905'),(124,'Học sinh 1 lớp 11A2 - Trường THPT Nguyễn Huệ','12001',NULL,NULL,20,125,1,'2026-10-19 12:14:40.967','2026-10-19 12:14:40.967'),(125,'Học sinh 2 lớp 11A2 - Trường THPT Nguyễn Huệ','12002',NULL,NULL,20,126,1,'2026-10-19 12:14:41.033','2026-10-19 12:14:41.033'),(126,'Học sinh 3 lớp 11A2 - Trường THPT Nguyễn Huệ','12003',NULL,NULL,20,127,1,'2026-10-19 12:14:41.105','2026-10-19 12:14:41.105'),(127,'Học sinh 4 lớp 11A2 - Trường THPT Nguyễn Huệ','12004',NULL,NULL,20,128,1,'2026-10-19 12:14:41.175','2026-10-19 12:14:41.175'),(128,'Học sinh 5 lớp 11A2 - Trường THPT Nguyễn Huệ','12005',NULL,NULL,20,129,1,'2026-10-19 12:14:41.238','2026-10-19 12:14:41.238'),(129,'Học sinh 6 lớp 11A2 - Trường THPT Nguyễn Huệ','12006',NULL,NULL,20,130,1,'2026-10-19 12:14:41.305','2026-10-19 12:14:41.305'),(130,'Học sinh 7 lớp 11A2 - Trường THPT Nguyễn Huệ','12007',NULL,NULL,20,131,1,'2026-10-19 12:14:41.376','2026-10-19 12:14:41.376'),(131,'Học sinh 1 lớp 10A1 - Trường THPT Nguyễn Huệ','12101',NULL,NULL,21,132,1,'2026-10-19 12:14:41.439','2026-10-19 12:14:41.439'),(132,'Học sinh 2 lớp 10A1 - Trường THPT Nguyễn Huệ','12102',NULL,NULL,21,133,1,'2026-10-19 12:14:41.505','2026-10-19 12:14:41.505'),(133,'Học sinh 3 lớp 10A1 - Trường THPT Nguyễn Huệ','12103',NULL,NULL,21,134,1,'2026-10-19 12:14:41.569','2026-10-19 12:14:41.569'),(134,'Học sinh 4 lớp 10A1 - Trường THPT Nguyễn Huệ','12104',NULL,NULL,21,135,1,'2026-10-19 12:14:41.634','2026-10-19 12:14:41.634'),(135,'Học sinh 5 lớp 10A1 - Trường THPT Nguyễn Huệ','12105',NULL,NULL,21,136,1,'2026-10-19 12:14:41.695','2026-10-19 12:14:41.695'),(136,'Học sinh 6 lớp 10A1 - Trường THPT Nguyễn Huệ','12106',NULL,NULL,21,137,1,'2026-10-19 12:14:41.759','2026-10-19 12:14:41.759'),(137,'Học sinh 7 lớp 10A1 - Trường THPT Nguyễn Huệ','12107',NULL,NULL,21,138,1,'2026-10-19 12:14:41.824','2026-10-19 12:14:41.824'),(138,'Học sinh 8 lớp 10A1 - Trường THPT Nguyễn Huệ','12108',NULL,NULL,21,139,1,'2026-10-19 12:14:41.886','2026-10-19 12:14:41.886'),(139,'Học sinh 1 lớp 10A2 - Trường THPT Lê Thánh Tông','12201',NULL,NULL,22,140,1,'2026-10-19 12:14:41.948','2026-10-19 12:14:41.948'),(140,'Học sinh 2 lớp 10A2 - Trường THPT Lê Thánh Tông','12202',NULL,NULL,22,141,1,'2026-10-19 12:14:42.011','2026-10-19 12:14:42.011'),(141,'Học sinh 3 lớp 10A2 - Trường THPT Lê Thánh Tông','12203',NULL,NULL,22,142,1,'2026-10-19 12:14:42.076','2026-10-19 12:14:42.076'),(142,'Học sinh 4 lớp 10A2 - Trường THPT Lê Thánh Tông','12204',NULL,NULL,22,143,1,'2026-10-19 12:14:42.138','2026-10-19 12:14:42.138'),(143,'Học sinh 5 lớp 10A2 - Trường THPT Lê Thánh Tông','12205',NULL,NULL,22,144,1,'2026-10-19 12:14:42.202','2026-10-19 12:14:42.202'),(144,'Học sinh 6 lớp 10A2 - Trường THPT Lê Thánh Tông','12206',NULL,NULL,22,145,1,'2026-10-19 12:14:42.266','2026-10-19 12:14:42.266'),(145,'Học sinh 1 lớp 12A1 - Trường THPT Lê Thánh Tông','12301',NULL,NULL,23,146,1,'2026-10-19 12:14:42.330','2026-10-19 12:14:42.330'),(146,'Học sinh 2 lớp 12A1 - Trường THPT Lê Thánh Tông','12302',NULL,NULL,23,147,1,'2026-10-19 12:14:42.392','2026-10-19 12:14:42.392'),(147,'Học sinh 3 lớp 12A1 - Trường THPT Lê Thánh Tông','12303',NULL,NULL,23,148,1,'2026-10-19 12:14:42.454','2026-10-19 12:14:42.454'),(148,'Học sinh 4 lớp 12A1 - Trường THPT Lê Thánh Tông','12304',NULL,NULL,23,149,1,'2026-10-19 12:14:42.516','2026-10-19 12:14:42.516'),(149,'Học sinh 5 lớp 12A1 - Trường THPT Lê Thánh Tông','12305',NULL,NULL,23,150,1,'2026-10-19 12:14:42.578','2026-10-19 12:14:42.578'),(150,'Học sinh 6 lớp 12A1 - Trường THPT Lê Thánh Tông','12306',NULL,NULL,23,151,1,'2026-10-19 12:14:42.657','2026-10-19 12:14:42.657'),(151,'Học sinh 7 lớp 12A1 - Trường THPT Lê Thánh Tông','12307',NULL,NULL,23,152,1,'2026-10-19 12:14:42.718','2026-10-19 12:14:42.718'),(152,'Học sinh 1 lớp 12A1 - Trường THPT Lý Thường Kiệt','12401',NULL,NULL,24,153,1,'2026-10-19 12:14:42.780','2026-10-19 12:14:42.780'),(153,'Học sinh 2 lớp 12A1 - Trường THPT Lý Thường Kiệt','12402',NULL,NULL,24,154,1,'2026-10-19 12:14:42.848','2026-10-19 12:14:42.848'),(154,'Học sinh 3 lớp 12A1 - Trường THPT Lý Thường Kiệt','12403',NULL,NULL,24,155,1,'2026-10-19 12:14:42.911','2026-10-19 12:14:42.911'),(155,'Học sinh 4 lớp 12A1 - Trường THPT Lý Thường Kiệt','12404',NULL,NULL,24,156,1,'2026-10-19 12:14:42.977','2026-10-19 12:14:42.977'),(156,'Học sinh 5 lớp 12A1 - Trường THPT Lý Thường Kiệt','12405',NULL,NULL,24,157,1,'2026-10-19 12:14:43.045','2026-10-19 12:14:43.045'),(157,'Học sinh 6 lớp 12A1 - Trường THPT Lý Thường Kiệt','12406',NULL,NULL,24,158,1,'2026-10-19 12:14:43.113','2026-10-19 12:14:43.113'),(158,'Học sinh 7 lớp 12A1 - Trường THPT Lý Thường Kiệt','12407',NULL,NULL,24,159,1,'2026-10-19 12:14:43.187','2026-10-19 12:14:43.187'),(159,'Học sinh 8 lớp 12A1 - Trường THPT Lý Thường Kiệt','12408',NULL,NULL,24,160,1,'2026-10-19 12:14:43.254','2026-10-19 12:14:43.254'),(160,'Học sinh 1 lớp 10A1 - Trường THPT Lý Thường Kiệt','12501',NULL,NULL,25,161,1,'2026-10-19 12:14:43.321','2026-10-19 12:14:43.321'),(161,'Học sinh 2 lớp 10A1 - Trường THPT Lý Thường Kiệt','12502',NULL,NULL,25,162,1,'2026-10-19 12:14:43.393','2026-10-19 12:14:43.393'),(162,'Học sinh 3 lớp 10A1 - Trường THPT Lý Thường Kiệt','12503',NULL,NULL,25,163,1,'2026-10-19 12:14:43.456','2026-10-19 12:14:43.456'),(163,'Học sinh 4 lớp 10A1 - Trường THPT Lý Thường Kiệt','12504',NULL,NULL,25,164,1,'2026-10-19 12:14:43.524','2026-10-19 12:14:43.524'),(164,'Học sinh 5 lớp 10A1 - Trường THPT Lý Thường Kiệt','12505',NULL,NULL,25,165,1,'2026-10-19 12:14:43.591','2026-10-19 12:14:43.591'),(165,'Học sinh 6 lớp 10A1 - Trường THPT Lý Thường Kiệt','12506',NULL,NULL,25,166,1,'2026-10-19 12:14:43.659','2026-10-19 12:14:43.659'),(166,'Học sinh 7 lớp 10A1 - Trường THPT Lý Thường Kiệt','12507',NULL,NULL,25,167,1,'2026-10-19 12:14:43.721','2026-10-19 12:14:43.721'),(167,'Học sinh 1 lớp 10A2 - Trường THPT Lý Thường Kiệt','12601',NULL,NULL,26,168,1,'2026-10-19 12:14:43.793','2026-10-19 12:14:43.793'),(168,'Học sinh 2 lớp 10A2 - Trường THPT Lý Thường Kiệt','12602',NULL,NULL,26,169,1,'2026-10-19 12:14:43.858','2026-10-19 12:14:43.858'),(169,'Học sinh 3 lớp 10A2 - Trường THPT Lý Thường Kiệt','12603',NULL,NULL,26,170,1,'2026-10-19 12:14:43.928','2026-10-19 12:14:43.928'),(170,'Học sinh 4 lớp 10A2 - Trường THPT Lý Thường Kiệt','12604',NULL,NULL,26,171,1,'2026-10-19 12:14:43.990','2026-10-19 12:14:43.990'),(171,'Học sinh 5 lớp 10A2 - Trường THPT Lý Thường Kiệt','12605',NULL,NULL,26,172,1,'2026-10-19 12:14:44.052','2026-10-19 12:14:44.052'),(172,'Học sinh 6 lớp 10A2 - Trường THPT Lý Thường Kiệt','12606',NULL,NULL,26,173,1,'2026-10-19 12:14:44.121','2026-10-19 12:14:44.121'),(173,'Học sinh 7 lớp 10A2 - Trường THPT Lý Thường Kiệt','12607',NULL,NULL,26,174,1,'2026-10-19 12:14:44.183','2026-10-19 12:14:44.183'),(174,'Học sinh 1 lớp 11A1 - Trường THPT Nguyễn Huệ','12701',NULL,NULL,27,175,1,'2026-10-19 12:14:44.254','2026-10-19 12:14:44.254'),(175,'Học sinh 2 lớp 11A1 - Trường THPT Nguyễn Huệ','12702',NULL,NULL,27,176,1,'2026-10-19 12:14:44.317','2026-10-19 12:14:44.317'),(176,'Học sinh 3 lớp 11A1 - Trường THPT Nguyễn Huệ','12703',NULL,NULL,27,177,1,'2026-10-19 12:14:44.380','2026-10-19 12:14:44.380'),(177,'Học sinh 4 lớp 11A1 - Trường THPT Nguyễn Huệ','12704',NULL,NULL,27,178,1,'2026-10-19 12:14:44.442','2026-10-19 12:14:44.442'),(178,'Học sinh 5 lớp 11A1 - Trường THPT Nguyễn Huệ','12705',NULL,NULL,27,179,1,'2026-10-19 12:14:44.505','2026-10-19 12:14:44.505'),(179,'Học sinh 6 lớp 11A1 - Trường THPT Nguyễn Huệ','12706',NULL,NULL,27,180,1,'2026-10-19 12:14:44.568','2026-10-19 12:14:44.568'),(180,'Học sinh 1 lớp 12A2 - Trường THPT Bùi Thị Xuân','12801',NULL,NULL,28,181,1,'2026-10-19 12:14:44.632','2026-10-19 12:14:44.632'),(181,'Học sinh 2 lớp 12A2 - Trường THPT Bùi Thị Xuân','12802',NULL,NULL,28,182,1,'2026-10-19 12:14:44.693','2026-10-19 12:14:44.693'),(182,'Học sinh 3 lớp 12A2 - Trường THPT Bùi Thị Xuân','12803',NULL,NULL,28,183,1,'2026-10-19 12:14:44.762','2026-10-19 12:14:44.762'),(183,'Học sinh 4 lớp 12A2 - Trường THPT Bùi Thị Xuân','12804',NULL,NULL,28,184,1,'2026-10-19 12:14:44.825','2026-10-19 12:14:44.825'),(184,'Học sinh 5 lớp 12A2 - Trường THPT Bùi Thị Xuân','12805',NULL,NULL,28,185,1,'2026-10-19 12:14:44.889','2026-10-19 12:14:44.889'),(185,'Học sinh 6 lớp 12A2 - Trường THPT Bùi Thị Xuân','12806',NULL,NULL,28,186,1,'2026-10-19 12:14:44.952','2026-10-19 12:14:44.952'),(186,'Học sinh 7 lớp 12A2 - Trường THPT Bùi Thị Xuân','12807',NULL,NULL,28,187,1,'2026-10-19 12:14:45.015','2026-10-19 12:14:45.015'),(187,'Học sinh 1 lớp 11A2 - Trường THPT Lý Thường Kiệt','12901',NULL,NULL,29,188,1,'2026-10-19 12:14:45.082','2026-10-19 12:14:45.082'),(188,'Học sinh 2 lớp 11A2 - Trường THPT Lý Thường Kiệt','12902',NULL,NULL,29,189,1,'2026-10-19 12:14:45.146','2026-10-19 12:14:45.146'),(189,'Học sinh 3 lớp 11A2 - Trường THPT Lý Thường Kiệt','12903',NULL,NULL,29,190,1,'2026-10-19 12:14:45.212','2026-10-19 12:14:45.212'),(190,'Học sinh 4 lớp 11A2 - Trường THPT Lý Thường Kiệt','12904',NULL,NULL,29,191,1,'2026-10-19 12:14:45.276','2026-10-19 12:14:45.276'),(191,'Học sinh 5 lớp 11A2 - Trường THPT Lý Thường Kiệt','12905',NULL,NULL,29,192,1,'2026-10-19 12:14:45.347','2026-10-19 12:14:45.347'),(192,'Học sinh 6 lớp 11A2 - Trường THPT Lý Thường Kiệt','12906',NULL,NULL,29,193,1,'2026-10-19 12:14:45.412','2026-10-19 12:14:45.412'),(193,'Học sinh 7 lớp 11A2 - Trường THPT Lý Thường Kiệt','12907',NULL,NULL,29,194,1,'2026-10-19 12:14:45.476','2026-10-19 12:14:45.476'),(194,'Học sinh 8 lớp 11A2 - Trường THPT Lý Thường Kiệt','12908',NULL,NULL,29,195,1,'2026-10-19 12:14:45.539','2026-10-19 12:14:45.539'),(195,'Học sinh 1 lớp 12A2 - Trường THPT Nguyễn Huệ','13001',NULL,NULL,30,196,1,'2026-10-19 12:14:45.604','2026-10-19 12:14:45.604'),(196,'Học sinh 2 lớp 12A2 - Trường THPT Nguyễn Huệ','13002',NULL,NULL,30,197,1,'2026-10-19 12:14:45.669','2026-10-19 12:14:45.669'),(197,'Học sinh 3 lớp 12A2 - Trường THPT Nguyễn Huệ','13003',NULL,NULL,30,198,1,'2026-10-19 12:14:45.731','2026-10-19 12:14:45.731'),(198,'Học sinh 4 lớp 12A2 - Trường THPT Nguyễn Huệ','13004',NULL,NULL,30,199,1,'2026-10-19 12:14:45.794','2026-10-19 12:14:45.794'),(199,'Học sinh 5 lớp 12A2 - Trường THPT Nguyễn Huệ','13005',NULL,NULL,30,200,1,'2026-10-19 12:14:45.859','2026-10-19 12:14:45.859'),(200,'Học sinh 6 lớp 12A2 - Trường THPT Nguyễn Huệ','13006',NULL,NULL,30,201,1,'2026-10-19 12:14:45.921','2026-10-19 12:14:45.921'),(201,'Học sinh 7 lớp 12A2 - Trường THPT Nguyễn Huệ','13007',NULL,NULL,30,202,1,'2026-10-19 12:14:45.984','2026-10-19 12:14:45.984');
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` char(255) NOT NULL,
  `password` char(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `role` enum('Admin','Judge','Student') NOT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `token` text DEFAULT NULL,
  `otpCode` varchar(6) DEFAULT NULL,
  `otpExpiredAt` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_username_key` (`username`),
  UNIQUE KEY `users_email_key` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','$2b$10$BYyanxWlLbQUuOrPmF8a/uCeV/eddQyTfmluMSStmKozps8anWuYe','admin@example.com','Admin',1,NULL,NULL,NULL,'2026-10-19 12:14:32.972','2026-10-19 13:06:16.358'),(2,'student_10101','$2b$10$y9uG6kqp.YIhLCZVhK0wC.s0t2OGnF/QNJBsekkV.JctP3MqLg6Oa','student_10101@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:33.079','2026-10-19 12:32:34.269'),(3,'student_10102','$2b$10$OMmtdi29pPrDmvuXa481L.CTQKHG11VUaxr7WC9yIaUkgWhS87H4C','student_10102@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:33.150','2026-10-19 12:53:31.492'),(4,'student_10103','$2b$10$54Mb/q0jTpLRzBcZx6qQtuEBXgHz2JeGhdHQtbnbMDwZ2fFDEYbpW','student_10103@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:33.219','2026-10-19 12:14:33.219'),(5,'student_10104','$2b$10$fQ.LJ5igqUVbHH167DKFmujlQbDDSVNtMKmP/1Qz17wtMEPJtZiw6','student_10104@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:33.282','2026-10-19 12:14:33.282'),(6,'student_10105','$2b$10$dzlzFX4mlUplsrE8TcSYhuFceI51HRhMUa3euqe25crKF9XYIlB.u','student_10105@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:33.345','2026-10-19 12:14:33.345'),(7,'student_10201','$2b$10$ZJw9AEPmb9eJITOahInzeuXYdfU69rJV1mvi/wOFBQahFadtVPQn2','student_10201@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:33.410','2026-10-19 12:14:33.410'),(8,'student_10202','$2b$10$i5MlvD11VHbgC.E2YvuqHe8K87O97wxlAmDzV6BjxZOPpCXombL4.','student_10202@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:33.480','2026-10-19 12:14:33.480'),(9,'student_10203','$2b$10$eeYDL7b5NQUNkVfe0kymtuBB8R5zMDCvJPx25SGtQ5Tg8ePMYFYAC','student_10203@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:33.542','2026-10-19 12:14:33.542'),(10,'student_10204','$2b$10$WQWbD3gOrKLi1i5/WNQhOebbsSUmK/Qn0IQTHFzIG7p/WUZEX8BTa','student_10204@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:33.606','2026-10-19 12:14:33.606'),(11,'student_10205','$2b$10$mXUX4kZihmCn//.DeCSTU.sWFQ4h3g/neRYZ85saaQSnqWmWqheKC','student_10205@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:33.669','2026-10-19 12:14:33.669'),(12,'student_10206','$2b$10$zgBXKOoHAShjXdlLT5VDGuT29MghJxMiXNMf/Uz59suWK/T5s0.d6','student_10206@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:33.734','2026-10-19 12:14:33.734'),(13,'student_10207','$2b$10$S/PDe38c5R377zCrZm2Iw.V13Nkremffk/ZUJc.uGHIRalvEskyw.','student_10207@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:33.796','2026-10-19 12:14:33.796'),(14,'student_10301','$2b$10$FW7V/mKykFUq2/yzYvV38uK6v34i36LKUchg.0GD7vnpmQBHaLU0.','student_10301@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:33.859','2026-10-19 12:14:33.859'),(15,'student_10302','$2b$10$djGtxUQSU90ObivLIsBoJuUaiyRlj3y8.iAvl9.fCkAwtWX1.E7bW','student_10302@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:33.922','2026-10-19 12:14:33.922'),(16,'student_10303','$2b$10$LKILH93PIENqmOpSOIiXkOkAMx/3fXd8lwWguCmWMod8r/e8e2zZW','student_10303@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:33.987','2026-10-19 12:14:33.987'),(17,'student_10304','$2b$10$HqoAbgyZ.MbsFDmMlqWM8OKsvZkSKtQnbmC4xR3VOD8n9n0ZCcsbC','student_10304@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:34.049','2026-10-19 12:14:34.049'),(18,'student_10305','$2b$10$sk/sTaDnwL9mulOfEqGwsuGtNxelWUKOSu3BhTCeXudBijRJioU9q','student_10305@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:34.112','2026-10-19 12:14:34.112'),(19,'student_10306','$2b$10$7VRSCkAI97arq9eFgI1YNuyJEppNMrFkIVP7VLRCnB.O/lvS8GUQe','student_10306@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:34.177','2026-10-19 12:14:34.177'),(20,'student_10307','$2b$10$c4Jdlx71qYIeKECPqvAApOaQVV1w9G8TlnO6DB1zfGVRu5IxXIOxS','student_10307@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:34.240','2026-10-19 12:14:34.240'),(21,'student_10401','$2b$10$ECW/Hd7BNkwxIKSltoCaG.NgiCaaQQ8S4BOxNj1mufstY90OeIKQW','student_10401@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:34.305','2026-10-19 12:14:34.305'),(22,'student_10402','$2b$10$m0E7QingQbJVgY0q7VvJ0O/eHOgJNHd/8XokijcwITdcNq5WRYyku','student_10402@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:34.367','2026-10-19 12:14:34.367'),(23,'student_10403','$2b$10$lWdH2GP7oveeq.yQ55zujOwgMvpv4wGiFi/mEjFFLJGWcbmbWohNS','student_10403@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:34.432','2026-10-19 12:14:34.432'),(24,'student_10404','$2b$10$EbmFVf03VK992t1bg02B/OKZNjBxJ4V70qQkPLcXsIT6QEbmIFyFi','student_10404@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:34.494','2026-10-19 12:14:34.494'),(25,'student_10405','$2b$10$ofe8Kx6LSAbRCj/PFJQoyurpUB/qYgGhlxoJFfcNCvNsUrasamY2G','student_10405@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:34.558','2026-10-19 12:14:34.558'),(26,'student_10406','$2b$10$0IttzkbUqNEvrW9JmfVEfeU08ghiAxwrB/87cpaCcmKkXV2Zr9vOa','student_10406@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:34.619','2026-10-19 12:14:34.619'),(27,'student_10407','$2b$10$Pj/55gNvL8xHkAdBgGbES.FhJzeEGhqU9XwYiGiZW1XIHtUH4ymIe','student_10407@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:34.683','2026-10-19 12:14:34.683'),(28,'student_10408','$2b$10$ZF372F4TSA3xB3xEmKN17.YO5Ti9KdRbNNdz/wauxV//E1gzWJyMe','student_10408@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:34.747','2026-10-19 12:14:34.747'),(29,'student_10501','$2b$10$Ao/96TLeubrEzwaozvxXz.qrVV8V/J9FhPaPUaa.LR4kqbGrlnJwu','student_10501@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:34.810','2026-10-19 12:14:34.810'),(30,'student_10502','$2b$10$hydOpzcaFjvslqSPABe1UemF/E6eTZ4PtshOMOAL5sRCkQt588SSi','student_10502@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:34.872','2026-10-19 12:14:34.872'),(31,'student_10503','$2b$10$.FOlSzea4as9e4S/jGvcTuWQyO2zAVJYsTQPQEd2pH6fBRB6GEd9y','student_10503@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:34.934','2026-10-19 12:14:34.934'),(32,'student_10504','$2b$10$NknmeLWf5rtQtTLTa5XC.OsGSZakFHEiLUDUPWoweBESYhWQSZAy.','student_10504@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:34.996','2026-10-19 12:14:34.996'),(33,'student_10505','$2b$10$LwjMykk.z/xpWKtQk2z2HuHLUXE4XZkRDk9jIL76PT9kldt7XyWMi','student_10505@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:35.062','2026-10-19 12:14:35.062'),(34,'student_10601','$2b$10$Z6IfFfRRGqb/m50kKGOtUuSaG55djlS.e/UM7aCHw5qjFb/GOs3G6','student_10601@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:35.124','2026-10-19 12:14:35.124'),(35,'student_10602','$2b$10$BhcOdwVOHavpwsJk9VCm.egnMomlHN6PdWrIs4qi2v9cICYlZerv.','student_10602@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:35.187','2026-10-19 12:14:35.187'),(36,'student_10603','$2b$10$ym6FPPlkg/WGmrTxy0GTU.yGQiYZgB/RP8/yd9ixA8sN8P27QxZKu','student_10603@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:35.251','2026-10-19 12:14:35.251'),(37,'student_10604','$2b$10$vdh8YBLlx2UDaNuT7cr3POb1o9tWPtTTZ/CDedesQ1HkoI/29.kyK','student_10604@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:35.322','2026-10-19 12:14:35.322'),(38,'student_10605','$2b$10$U8YvDbYv3bWfb.myDV/t6uJatJd6fCd20XIBZ7FP1PHzbBO.iMKqK','student_10605@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:35.385','2026-10-19 12:14:35.385'),(39,'student_10606','$2b$10$7SbPYi1eW5sUw6p/MKzjOOphP5k.PSoy52NavPQk5cGMYsNcUfrfC','student_10606@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:35.448','2026-10-19 12:14:35.448'),(40,'student_10607','$2b$10$dTw.lhsZB31WL0GgVskM6OrHnGKEqg2Z7WvSABoBJSu3fzAAVG5Cy','student_10607@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:35.513','2026-10-19 12:14:35.513'),(41,'student_10701','$2b$10$mtBYFR8hgH.juX9c.ivZReeylkCKpcucwO9Ku1fcyiEP4Ikao9epe','student_10701@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:35.575','2026-10-19 12:14:35.575'),(42,'student_10702','$2b$10$AthuL9KEIYqDvZPVreghseCrnx4RODn7OK4BrMzzT6LjWBtSqy5g2','student_10702@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:35.645','2026-10-19 12:14:35.645'),(43,'student_10703','$2b$10$ZPxTEgtCUbQTgTe6mdD7iuGYeevYO4E5BKB0YRu3fa8cC6PZ5u6ee','student_10703@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:35.706','2026-10-19 12:14:35.706'),(44,'student_10704','$2b$10$ajNCE3rOeAEYkQQSSHUR4eh9NsAf8sP8DNiGCV2cmPSed4juZL.5.','student_10704@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:35.770','2026-10-19 12:14:35.770'),(45,'student_10705','$2b$10$8mbWAkLKLSO5QRuicYu1N.ee2JhRb5GVsmfz.zTO/fzyxFw3AQ7om','student_10705@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:35.834','2026-10-19 12:14:35.834'),(46,'student_10706','$2b$10$IAeuTkieXcmWNaoBls4UoOpPEKf56yuB0U2ZEnOEvnVvqxiHPs1fe','student_10706@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:35.896','2026-10-19 12:14:35.896'),(47,'student_10801','$2b$10$8vzAjlZOC6diZKVzH./rY.Jr6yL5FZllUlBJ56inPZVzNC4z3smAi','student_10801@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:35.959','2026-10-19 12:14:35.959'),(48,'student_10802','$2b$10$Z7O5kgn1yn9pxTsyLUrXBehMe2Ki9HFQLDjAyxcj9B2I9sOkwXQ0e','student_10802@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:36.021','2026-10-19 12:14:36.021'),(49,'student_10803','$2b$10$aERYxJ5M88HYE2qjPSG4uu7.u01Q9OvyXmAy/7/OaXVMRlTyzrmqG','student_10803@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:36.087','2026-10-19 12:14:36.087'),(50,'student_10804','$2b$10$NlE4E0dGHJi5HbzUQHlFjeGCQs3CdvIQvtMryH6rDISp6Kv7Y/4B.','student_10804@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:36.149','2026-10-19 12:14:36.149'),(51,'student_10805','$2b$10$3QXUyeSh6XdfoGvdsw0R..GvAorMAXV9RNJZWU8f.kuVAAil5RrNq','student_10805@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:36.218','2026-10-19 12:14:36.218'),(52,'student_10901','$2b$10$80FjLcPRJuWhJl07A55AKO2aYeYytv0iu8pAwwvZZzcTbI7zyclwG','student_10901@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:36.287','2026-10-19 12:14:36.287'),(53,'student_10902','$2b$10$FpY3IOJPe59vkH1vyOSbbeMKjc9XvW49HsSjfO1SLxoFHQCM/etIy','student_10902@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:36.349','2026-10-19 12:14:36.349'),(54,'student_10903','$2b$10$OJBHE3lExHdcmK94LVcLAeWtH3iFZ/w7J8DMcAQREL8ja2D4EhCbC','student_10903@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:36.410','2026-10-19 12:14:36.410'),(55,'student_10904','$2b$10$JEWU9DWZFYe5QQLAnjoekeIiPkxKbYp8RXshxqnfg5PNAMMiTIFo.','student_10904@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:36.475','2026-10-19 12:14:36.475'),(56,'student_10905','$2b$10$rEOt47GulkwkubBgobRCuuBXcMPxqNdtovC675aAfHzffVfQswVwW','student_10905@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:36.536','2026-10-19 12:14:36.536'),(57,'student_10906','$2b$10$3jW7oO44L696H8xE/oOPKua73XD.u.GIqIPBwjWsWqk82U6Qczani','student_10906@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:36.604','2026-10-19 12:14:36.604'),(58,'student_10907','$2b$10$KQIbLytN6d6Lt.ZQ/hqYou/wA0ABL2rDiotlyhebgvsMlEB8cUyiK','student_10907@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:36.672','2026-10-19 12:14:36.672'),(59,'student_10908','$2b$10$DbPlSe67eFfFJ/XQ5relJu45wx5nIH0xh4E7baGkHDmD8Co4ZoDzC','student_10908@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:36.737','2026-10-19 12:14:36.737'),(60,'student_11001','$2b$10$/8CrGlfKBnm9w5cCAYd6XOagILLhxbT7QK3nk8qLe6JaZby5RiIri','student_11001@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:36.804','2026-10-19 12:14:36.804'),(61,'student_11002','$2b$10$OdZKHxGA6fPOJ97OXgEMhed781eVX5MIBRuQbKuCkS7oQk2Seg/V2','student_11002@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:36.867','2026-10-19 12:14:36.867'),(62,'student_11003','$2b$10$yq6rYg8IQ2eyHFEmC/JqC.aRcZnx3cGv5CtAVHIrisQZm6fqi/MzK','student_11003@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:36.933','2026-10-19 12:14:36.933'),(63,'student_11004','$2b$10$M43oIvrIAjOIGuiwhwxb6e17906cYnhNhd8foCvl0NnduYU.P.K3q','student_11004@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:36.997','2026-10-19 12:14:36.997'),(64,'student_11005','$2b$10$eMOM/lQM6PG/v5ZVQhAoKeSzwydrzNfa/gUPhhDqtGLkzNrjvw/Jm','student_11005@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:37.060','2026-10-19 12:14:37.060'),(65,'student_11006','$2b$10$3LL8qdCjx05R.YkydJvoReJk1ooNrqYFDkfY9nU3/QoJHRJRL.Fiu','student_11006@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:37.122','2026-10-19 12:14:37.122'),(66,'student_11007','$2b$10$cdt53twdL3x.XyPD3RdLdueRJz8V0U2jnjI1QMNTsksTSjJ14YjF6','student_11007@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:37.185','2026-10-19 12:14:37.185'),(67,'student_11008','$2b$10$5JF74F9p0BURHFr1VDE70eBDTLyFGTGnlCctydUNy6rX/8jkk37Ui','student_11008@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:37.252','2026-10-19 12:14:37.252'),(68,'student_11101','$2b$10$jsoPDfPIpNhi1aL0kXYELOkZS7C/NJocSTtEvbmp7uldPO6z8g4Ua','student_11101@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:37.315','2026-10-19 12:14:37.315'),(69,'student_11102','$2b$10$YD3m6Tr1T0Lij1FBVl6Gle/41a6JF8X/o71H9iU6eQ6Tv7YOyhsK.','student_11102@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:37.378','2026-10-19 12:14:37.378'),(70,'student_11103','$2b$10$huY1fU.4DT2HLQqG5x7Kvu832U55IwBsLUybwXrFOVymEjGU9KzXG','student_11103@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:37.443','2026-10-19 12:14:37.443'),(71,'student_11104','$2b$10$GN2wD68K2oXUQR6qlMlq6uC4gnA7DO6nInvIkwVQftoGHaU.Tt6Ue','student_11104@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:37.512','2026-10-19 12:14:37.512'),(72,'student_11105','$2b$10$YNMTOw83ExNlozwYK5lf9OnUssFzQmb.pc5EIX9oA2jvL8JAfSIBO','student_11105@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:37.579','2026-10-19 12:14:37.579'),(73,'student_11106','$2b$10$eTgAfMtaurcorpjKS7KJpeEpOYlzRmWG2wsCAgWYZFGlNaFE.65Pi','student_11106@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:37.649','2026-10-19 12:14:37.649'),(74,'student_11201','$2b$10$020S14Z/OI9CRU6PYTlgUuu0Bc92IUYHfgBjBJcHsg7N55n5PGTwm','student_11201@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:37.714','2026-10-19 12:14:37.714'),(75,'student_11202','$2b$10$vyVZEk3JD2Sr1kmnMB598uIloPvWKeHGoRva7KRVx0opjiinBFLt.','student_11202@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:37.779','2026-10-19 12:14:37.779'),(76,'student_11203','$2b$10$7BipFUb6zqGuMm2Q2YE1KOKN3QtohZeTyX9IYqsxb2NPqXEkuMciG','student_11203@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:37.847','2026-10-19 12:14:37.847'),(77,'student_11204','$2b$10$3mCicMFccDLcJuiUhb7pWO0b8whJdwxZl7P2nGZsrb/Akn3SXZCgS','student_11204@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:37.915','2026-10-19 12:58:38.673'),(78,'student_11205','$2b$10$Kysapg2.5e4XD0tQAXSCkuMsaaa3DdI2D31S1mxZIb90kZc9Tj4uq','student_11205@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:37.978','2026-10-19 12:14:37.978'),(79,'student_11206','$2b$10$ElnqjllvgFPT4J0EwEffOeF.LerM0xorjp9ZnTTQuJthMcQat6l1e','student_11206@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:38.041','2026-10-19 12:14:38.041'),(80,'student_11207','$2b$10$5tZC/Jh3YZbmaCRCSJbSReGM7W9GmbOTtqmFQWXIBogatm7WjuH/K','student_11207@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:38.104','2026-10-19 12:14:38.104'),(81,'student_11301','$2b$10$WoOz4IUrGIFQXGaAl.J7Z.LfM5VUjZ209o.KxH0qMXAXw9MFHfzma','student_11301@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:38.169','2026-10-19 12:14:38.169'),(82,'student_11302','$2b$10$rCDTutly71fFCgc4QI3Kpu/eSgOB9cMx7VgAq2ue5bF4xEqvofyym','student_11302@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:38.231','2026-10-19 12:14:38.231'),(83,'student_11303','$2b$10$SDRjarU80bmRk6o3tzwnC.wyEM/KJz54NWUpKP5iUzLUqlc8fOYBG','student_11303@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:38.295','2026-10-19 12:14:38.295'),(84,'student_11304','$2b$10$87wxETBa7e6jK2j6oRykjeK6A66IdIdbj56EFc0C0K.IQBMq.k.IS','student_11304@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:38.358','2026-10-19 12:14:38.358'),(85,'student_11305','$2b$10$gfhod4e1jzFMqDqUl97/QOOwte8EX7TTE.s8cu2Zaq1rA77.3s9Ta','student_11305@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:38.422','2026-10-19 12:14:38.422'),(86,'student_11306','$2b$10$1nMW4AHmSKwmbc9xw8PBSeuk7ZQ1DSx58yWDQUgkFdKGsBhcffjEO','student_11306@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:38.484','2026-10-19 12:14:38.484'),(87,'student_11307','$2b$10$X71C0z2XWd0zsSNN4pt2nu7NVjb/l0MK3WtlPQUqra7SVwjVnNGOa','student_11307@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:38.552','2026-10-19 12:14:38.552'),(88,'student_11308','$2b$10$4UuopT.g8yudUWVdInCADejXrAJBYgNDGWdWdTBgtKvNQkkGtiq6K','student_11308@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:38.619','2026-10-19 12:14:38.619'),(89,'student_11401','$2b$10$/m769/Xgz3F9TxRu94zj3uG6EogaSIoDx6e1qUKfRe67RPrcXeYZ6','student_11401@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:38.687','2026-10-19 12:14:38.687'),(90,'student_11402','$2b$10$ukdSn6RWKrOa8.SK4FCZf.v/PITzcNOhD.EP4jusImjuMMhsQsYpC','student_11402@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:38.750','2026-10-19 12:14:38.750'),(91,'student_11403','$2b$10$k2VKvZXIFMYoS7cvxUibIugfW1KTOWfcbFkXt5CFhMGB4sE4G.OPK','student_11403@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:38.816','2026-10-19 12:14:38.816'),(92,'student_11404','$2b$10$mZ01uxB6x3uNDw8k7qwjTOqW.e5NKXtzFisrQVQ1zE2zCZcx3RNa6','student_11404@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:38.879','2026-10-19 12:14:38.879'),(93,'student_11405','$2b$10$BU7glEhZaysyPzsI3CPNOeMOL//2vpHW9age86aGGrlXEnRJJar92','student_11405@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:38.942','2026-10-19 12:14:38.942'),(94,'student_11501','$2b$10$FoZ/.AMpw9tlwDd/kbOWR.ab1IPSgn3jOnYMs3E4Jdy9rOeVbCEr.','student_11501@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:39.006','2026-10-19 12:14:39.006'),(95,'student_11502','$2b$10$eM21QcEMSkurQ4CYoQF80O0QxlEC7eakkPUikV43UBrRT/HKssrSm','student_11502@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:39.069','2026-10-19 12:14:39.069'),(96,'student_11503','$2b$10$hMum6b00jhZdFS9nlouF3.Qstio4y5XLV.Y0BBFcRqo7cQKrEzdnG','student_11503@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:39.132','2026-10-19 12:14:39.132'),(97,'student_11504','$2b$10$FV5zIfecMFEUqegIar3SjuM4gbmXn9j3ZPlZDF3w7ORykOEunWMhC','student_11504@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:39.195','2026-10-19 12:14:39.195'),(98,'student_11505','$2b$10$OpcN9XGi6tp2RzVAjLusrulOz/ecdilxIH/pImev0hd4RaHIBJ4Oa','student_11505@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:39.260','2026-10-19 12:14:39.260'),(99,'student_11506','$2b$10$pjKk7gWRiR3/GjDTK0UsnOLFLBbnE6OVwWilSzt28cun5vJJ0nuwK','student_11506@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:39.321','2026-10-19 12:14:39.321'),(100,'student_11507','$2b$10$ImDtSqrtNrUnx9Sf8fjqDupTM6dyWKCBoE/brsZ65D3mKedCTm4NK','student_11507@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:39.384','2026-10-19 12:14:39.384'),(101,'student_11601','$2b$10$4SZ.ujlsQ0O0Fx86OIfUd.V8c86D/VdppF2609XZb1y8aXCAcdAku','student_11601@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:39.444','2026-10-19 12:14:39.444'),(102,'student_11602','$2b$10$e6tJGeDY9xggYrYAHqGryuAW7s.ZKX5.4absLeEKEXfDxffhJ9Tpy','student_11602@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:39.506','2026-10-19 12:14:39.506'),(103,'student_11603','$2b$10$f1BvKsOIXvntGSuLOFTrl.Fg0qrMJDcv/DEaLr1lCwmXPPGw0.c6i','student_11603@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:39.568','2026-10-19 12:14:39.568'),(104,'student_11604','$2b$10$H5ONAE9yOoKqpKj.kPMgv.YzComxNBeSFS.kZKgbtO6Nl5iBl3G9q','student_11604@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:39.630','2026-10-19 12:14:39.630'),(105,'student_11605','$2b$10$yDdaAw8k/nRH/nnzEaZBFuDMgbDidF.REbVsN2GJhPUIgCX6yEAYG','student_11605@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:39.694','2026-10-19 12:14:39.694'),(106,'student_11606','$2b$10$0Windhh4Uq5OvXvLbXE3P.yEFSNH/8qYXbPxspyf3a6dqL4D7T2Dm','student_11606@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:39.755','2026-10-19 12:14:39.755'),(107,'student_11701','$2b$10$l.yFrsx8k8P/JiN5ui3Zy.QEQr8xFOBo3PMcAr/kPqVFadCPHfKwK','student_11701@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:39.817','2026-10-19 12:14:39.817'),(108,'student_11702','$2b$10$KVya2Ho33nDIcTBiHVUdEeIpQBr0Lqllki53enjFCebOxhx9g9huC','student_11702@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:39.879','2026-10-19 12:14:39.879'),(109,'student_11703','$2b$10$t32yUUPEKEcFFykI4ylLKejYMrxpCCkHN4hY0DTlJha801OT1fAfK','student_11703@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:39.942','2026-10-19 12:14:39.942'),(110,'student_11704','$2b$10$mBmAl5rwJktgczs6IZlfuuzUKqpY4BLNFHgzIijzLVaLYuwEt0W4y','student_11704@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:40.003','2026-10-19 12:14:40.003'),(111,'student_11705','$2b$10$NlQUbxphZ7a/1udVk.MrYurGhB1PL/GvoUFMDmU8g/j5MvAYIy9tK','student_11705@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:40.065','2026-10-19 12:14:40.065'),(112,'student_11801','$2b$10$0OjvrMdNX4FZNOGYKinxe.Hs4La3y3iIC6WMCWUaSGjXc1xiDZuAK','student_11801@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:40.127','2026-10-19 12:14:40.127'),(113,'student_11802','$2b$10$cuRc29t8fViUbpGQYnTcPOsFdjtxvZofABsUz/KG7h0euQ93KFytq','student_11802@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:40.189','2026-10-19 12:14:40.189'),(114,'student_11803','$2b$10$W3H5x8ZY2Dv8.wT.THS/zuhInXLv./3Ign8f0cZhTOkNuRhIrBWSG','student_11803@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:40.254','2026-10-19 12:14:40.254'),(115,'student_11804','$2b$10$K9LFYnwnFdzBV1H2zQ8wVe4z1LBErndrAJ.yyZJssWCSrqb8uC9Yq','student_11804@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:40.320','2026-10-19 12:14:40.320'),(116,'student_11805','$2b$10$EnMGaPU0ZwiMqT46scme9OHzYYizD/Vw.7CvxZ4BUyGGyQVrUlaGu','student_11805@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:40.386','2026-10-19 12:14:40.386'),(117,'student_11806','$2b$10$TclQUHTXoXaBl2x3pTQMQemYmwZ2ZfHl8GVQipFOrITB5n0mDP9.W','student_11806@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:40.449','2026-10-19 12:14:40.449'),(118,'student_11807','$2b$10$cFzOsKERFV1PApg2BjaxfOgUjqo6CCoZcfTf4AcVNdMk7NVotyJS2','student_11807@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:40.511','2026-10-19 12:14:40.511'),(119,'student_11901','$2b$10$gp6wfyn6zExs22a61hKROu/x6OnNUGMfNRxadtEZjwKKN3v84cTB6','student_11901@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:40.574','2026-10-19 12:14:40.574'),(120,'student_11902','$2b$10$FkHLbyAHH3TO5GDWct/rsOjtmOTAIZ5S9m14WOoqJ94VfRWvhWD6G','student_11902@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:40.636','2026-10-19 12:14:40.636'),(121,'student_11903','$2b$10$5MPu0C3iLr0GpF8.4UIq9Oljl4V5g9Zwc2Md/6rrDstlhZrbOPiTe','student_11903@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:40.698','2026-10-19 12:14:40.698'),(122,'student_11904','$2b$10$AKvsiSrO5vb2a4zLXSjF4eygMz24EvqaMbnvK1hpKJe1f9Aa6Y3jy','student_11904@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:40.762','2026-10-19 12:14:40.762'),(123,'student_11905','$2b$10$cTT81UUAKoD0ncLbTpQfgeLpDtdumeSTCdyJnlU.dSLhML8PR1g32','student_11905@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:40.833','2026-10-19 12:14:40.833'),(124,'student_11906','$2b$10$U73n9LYh3y2/CCW9OKqBsO60zyIsg/26UqGYY5MGpoDdCGis9kB.i','student_11906@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:40.898','2026-10-19 12:14:40.898'),(125,'student_12001','$2b$10$o1r99ov9lbvYgnfqSWxax.X3WJlfH.p.Gb8PINHAmS1KgDmJ5IBeO','student_12001@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:40.964','2026-10-19 12:14:40.964'),(126,'student_12002','$2b$10$NPrENNkUiU6MsRbYZDolF.aa/nI2.ItyLy93mgvqMPsPXpV/Ld1IS','student_12002@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:41.027','2026-10-19 12:14:41.027'),(127,'student_12003','$2b$10$a92hUHHpw4/FeQyYjSz8HOZD1s89YloYFM.LLaCcW3fp8ZRtMeo/y','student_12003@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:41.094','2026-10-19 12:14:41.094'),(128,'student_12004','$2b$10$FuVUvaOJ8AdZXL6b3aLcfejpIxM95odGxw8h17ezFKeHJ7u2GU.aO','student_12004@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:41.167','2026-10-19 12:14:41.167'),(129,'student_12005','$2b$10$w8tbvGPD5tnN7rz1gC1KRO.iDFygMwUN6EsR860xptGKOq.KtBf16','student_12005@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:41.234','2026-10-19 12:14:41.234'),(130,'student_12006','$2b$10$IAnwze5PzvNnoEb/E6jRK.WafGNZZX4v/udR1xqBjQZ8X.45HYAk2','student_12006@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:41.297','2026-10-19 12:14:41.297'),(131,'student_12007','$2b$10$9IKmSX08h0.YLqa2wy/UXed7OI5.yOYhg9FZKLWoZGLRoShmu.goa','student_12007@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:41.365','2026-10-19 12:14:41.365'),(132,'student_12101','$2b$10$Sf02KDl8fFVgqHudu0rN6uWJ.GnslBG6TR8QQotMCmONvJeutdGMi','student_12101@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:41.436','2026-10-19 12:14:41.436'),(133,'student_12102','$2b$10$de7bydXxS4MOag/Wa2CFoubs0ChLI7ReNwWGmXLKsKULjHWLMcN/u','student_12102@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:41.500','2026-10-19 12:14:41.500'),(134,'student_12103','$2b$10$xoLjYp275Aaw9xbOSaw4XuJRUDZk/pJevDckXZNkPdu425jYk8ZO6','student_12103@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:41.565','2026-10-19 12:14:41.565'),(135,'student_12104','$2b$10$rBn75e1cjta/vJnvXWrvtOak/80nh9oEUUc3Bd7GYvzMytzdX.JBe','student_12104@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:41.628','2026-10-19 12:14:41.628'),(136,'student_12105','$2b$10$sOAOyrvpfZtmE0VyTotN..QQZmKZto8aOPpHXBk30rLBQMu30Xd9C','student_12105@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:41.693','2026-10-19 12:14:41.693'),(137,'student_12106','$2b$10$oW6wwXWpBQX6ZQU/4dRXw.dwrZLjwRe55VtVnRVF5WserCtK1Kpxm','student_12106@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:41.754','2026-10-19 12:14:41.754'),(138,'student_12107','$2b$10$wKYsgPri1pn./OQhoo56P.BtevNdcjsnI0pJSXPW0rWMhvQ60y.Au','student_12107@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:41.821','2026-10-19 12:14:41.821'),(139,'student_12108','$2b$10$nPcqBqfSgo11s9sk6jX6S.fJsmfcwNqCnNZgItujH/vXzXPac2R4G','student_12108@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:41.883','2026-10-19 12:14:41.883'),(140,'student_12201','$2b$10$QrRUyWLx7b3GG3e1yUv2NufyDnw6Rs16o4XD43IkH4ltewbrSZZGG','student_12201@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:41.945','2026-10-19 12:14:41.945'),(141,'student_12202','$2b$10$0ks.3W3MH1L1HCN.dqohuu85sv5dzw29oczRMjsiNVLNPk.3Lf.rO','student_12202@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:42.007','2026-10-19 12:14:42.007'),(142,'student_12203','$2b$10$eDYSo1SZadSbQYeitwqSdeDX4QVqWtqXl4EeuPGGaHDVm6OCdhDr6','student_12203@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:42.072','2026-10-19 12:14:42.072'),(143,'student_12204','$2b$10$Z16o0RNil1EiQOs1tkY6/.exlnZpZCECu9fW37g3zhPjREPxvLvEe','student_12204@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:42.135','2026-10-19 12:14:42.135'),(144,'student_12205','$2b$10$THnmXm/ADOtzwvyeEF/2UucK8t0aDAU8uDY7gWN8TCFH.2ul0gd.y','student_12205@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:42.198','2026-10-19 12:14:42.198'),(145,'student_12206','$2b$10$zcLq2riRn5QCHaPVvTe10efV5ax/2jtpujzAi4ME0BtRc2MwU3MRC','student_12206@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:42.262','2026-10-19 12:14:42.262'),(146,'student_12301','$2b$10$D6WQ21uzeQYHMPaMwqJUwekix6k9BeFkolSUhIMo5ThrN6RqR6KtC','student_12301@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:42.326','2026-10-19 12:14:42.326'),(147,'student_12302','$2b$10$yyC7eT61TlPLJLg4nmpdIO3ax3O61w6jZoHn66uLMigAtdbFr0TIK','student_12302@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:42.388','2026-10-19 12:14:42.388'),(148,'student_12303','$2b$10$i9cdyLYBFEDVtwB6sjC3o.gw4MD5xAPdHlUzht.5cb3riu3tpR8CW','student_12303@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:42.450','2026-10-19 12:14:42.450'),(149,'student_12304','$2b$10$I7pncG3nTd1Y2wU0J.nmEOfhSB.mWg017VxOXDEbLSIHcf/4kzxXu','student_12304@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:42.512','2026-10-19 12:14:42.512'),(150,'student_12305','$2b$10$ufhhAJHXZ14mCLN.1JpES.Ye00o2d5KexUWZEp7tulQF2DB53eiDy','student_12305@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:42.575','2026-10-19 12:14:42.575'),(151,'student_12306','$2b$10$2xT5015SMje.WQK8krZMUOZGe04ES1wLr2Zufpzfyy5D7eBFwVv6q','student_12306@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:42.637','2026-10-19 12:14:42.637'),(152,'student_12307','$2b$10$1Fs0C8a677xw0VSsxsyxdO95nPP9XLqdyyvFM3A8nwbGuSNSGA7Ue','student_12307@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:42.715','2026-10-19 12:14:42.715'),(153,'student_12401','$2b$10$FEshmXS64SE3sZT1bhaLIuQIFCIOYoyhk9nwch8ebGSontz/EvAfq','student_12401@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:42.777','2026-10-19 12:14:42.777'),(154,'student_12402','$2b$10$fOARGtjQqsTQ2JPOSwpWvu1qLMpH/vtn2IyYMRCWfEf2bHySiDob6','student_12402@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:42.839','2026-10-19 12:14:42.839'),(155,'student_12403','$2b$10$XIIuH5Hdd3juHxVmcU93w.1HryjVCXRGc3quWe09SMRsGmuhQ6hWi','student_12403@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:42.907','2026-10-19 12:14:42.907'),(156,'student_12404','$2b$10$nAEQSDXbj7iaJa0SIqxEBOyuDvozCB43EImIW1rRGDoVjasoe/n3i','student_12404@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:42.970','2026-10-19 12:14:42.970'),(157,'student_12405','$2b$10$jqVWHzzEgsem8Qko5rusg.hd48fiKOD6bIJCJDIOUWAclTgTg/B9C','student_12405@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:43.037','2026-10-19 12:14:43.037'),(158,'student_12406','$2b$10$7DYHJaUCwgJUfUHVh8NRmemLSRhhdG8K.T1c.ntZUi1B00lwGZVpi','student_12406@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:43.106','2026-10-19 12:14:43.106'),(159,'student_12407','$2b$10$WiSmK3Tz7xHmhCRr49BaOeDWVDBC2VAKQvZgXvpsV7iin0neFTt4q','student_12407@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:43.172','2026-10-19 12:14:43.172'),(160,'student_12408','$2b$10$.kjfT4c7NWZVqjqyvsOnRuyxZ4sQ66Rrt2D8MO.nKmglVFnKHSXAS','student_12408@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:43.246','2026-10-19 12:14:43.246'),(161,'student_12501','$2b$10$8Ygkn.SyEItN2aNM2VqkVOP5eleZyoqV31IfZKMsZlBxVey9ZusKC','student_12501@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:43.314','2026-10-19 12:14:43.314'),(162,'student_12502','$2b$10$xh4hcwPXrGtetwOSSYxJm.jEl/H4De8venWJQh/Ul3JdGhnvcBwB2','student_12502@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:43.381','2026-10-19 12:14:43.381'),(163,'student_12503','$2b$10$ax8y5FrsH6OrEbjuy.5YUO3/Kbpl4P8JntE6RazzRA0.3B22vIqjK','student_12503@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:43.453','2026-10-19 12:14:43.453'),(164,'student_12504','$2b$10$qddtgMbbMiLEHux9yg7nNeC7/FnaLie.nHnb98hKgroKYvHo5eExi','student_12504@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:43.516','2026-10-19 12:14:43.516'),(165,'student_12505','$2b$10$Lb4.dw/Fzl9c5s8Q1f4lcOQ6.tNrMST9Z5Q77QKlLR615cy2y0K4m','student_12505@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:43.583','2026-10-19 12:14:43.583'),(166,'student_12506','$2b$10$AjfEh5.KWubyjhw3iLOGN.y1KGHhz6oV6ozpj7DfPq7lIrTUZ/eum','student_12506@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:43.649','2026-10-19 12:14:43.649'),(167,'student_12507','$2b$10$1BHHITO6XHH3fVF4o3wHAOAOSkSpybRl2OR.rxv43liCKVzbxTska','student_12507@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:43.718','2026-10-19 12:14:43.718'),(168,'student_12601','$2b$10$14eGBZ4MfXj01bkPaytLLe0v4V8ZnQjOyXHXhEwzZKyfkhjcGYEZC','student_12601@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:43.789','2026-10-19 12:14:43.789'),(169,'student_12602','$2b$10$lMK85qxdqSlFLEJsT9sW8e.Lg5mwWvZCdbYxtkU2IvWSzCkZ9Vy8K','student_12602@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:43.853','2026-10-19 12:14:43.853'),(170,'student_12603','$2b$10$Isvt04TlDwtLaFJ05PYZXu.Z8tM0GCIZ9JFuRpVjMvMr.Ft5z2JVO','student_12603@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:43.917','2026-10-19 12:14:43.917'),(171,'student_12604','$2b$10$YzbUU8OZR1uhDsKWwlxL9umj9J6l/gcIaQKH.BG/QIODgcFu/A7KC','student_12604@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:43.987','2026-10-19 12:14:43.987'),(172,'student_12605','$2b$10$0Ht5q4LDUCOIoq4r.rVJtOeOYlCZoY4mfxj7hv2Lfk2IYPSPGSB56','student_12605@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:44.049','2026-10-19 12:14:44.049'),(173,'student_12606','$2b$10$Xs/F8k2jfoQQu3zSJCcxuudMqujo2bHvahW8S8e.3bJpy0dLWbGVe','student_12606@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:44.111','2026-10-19 12:14:44.111'),(174,'student_12607','$2b$10$dlmo5pZ.zAlGhO4B5g1F7OREmANfljGdE.t19zZiFfMvZELyCJdFu','student_12607@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:44.180','2026-10-19 12:14:44.180'),(175,'student_12701','$2b$10$0Y8OXLxsLTBC2MFupEWcL.cK5WSS3KZo5cNUlyZRUdv.fNLIYyi06','student_12701@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:44.244','2026-10-19 12:14:44.244'),(176,'student_12702','$2b$10$83inYJUDdgsRs2YrF0uM1uIkKEqmYl4ooNq8kW1j1H77u1eissGIS','student_12702@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:44.314','2026-10-19 12:14:44.314'),(177,'student_12703','$2b$10$YAUvzDxDqSJZ6w5bRGKJ8uzM.bHpXFs5OFmHG6Gb4Mx0jdYR3M4Ze','student_12703@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:44.377','2026-10-19 12:14:44.377'),(178,'student_12704','$2b$10$oWAiurzv2di.K691wANQHukZNpiToT7/P5VXduTKMEJAx/6N73Bme','student_12704@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:44.439','2026-10-19 12:14:44.439'),(179,'student_12705','$2b$10$Oi10BLeb14t.ST64VHBnuuYQvamxFSdt.fs4uOceKa84HvzIaSqW2','student_12705@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:44.502','2026-10-19 12:14:44.502'),(180,'student_12706','$2b$10$.05gNxaNKXjpcNbe.vvWR.VsJ6vR0Bi1w8PeXobSe7NfwmwSca5BO','student_12706@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:44.564','2026-10-19 12:14:44.564'),(181,'student_12801','$2b$10$V06.3HCxdKRIm47etR2d.uY3iKkw4fjCYzLjbOVAfUD5bcuQuKNqq','student_12801@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:44.627','2026-10-19 12:14:44.627'),(182,'student_12802','$2b$10$6T3KmPtGj.OJejDVGxVvJevpXfh4rVQYU/0/YKEGmvHkw7lhj.IVi','student_12802@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:44.690','2026-10-19 12:14:44.690'),(183,'student_12803','$2b$10$Ns/RQIS3drAWHGWu/K9Cj.GUVaGxzyfkwCYEtSLp.4lMpLxv5psOS','student_12803@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:44.752','2026-10-19 12:14:44.752'),(184,'student_12804','$2b$10$zZf2aOrTmzzGnZUW1KudTehQ/aomV4629Ma3gLYhf1vupHMibpUgC','student_12804@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:44.821','2026-10-19 12:14:44.821'),(185,'student_12805','$2b$10$WXEgzquNBOkY01dokq.szOPnUWOeAc.4miBuB25Ls4YYy8hrVtaKe','student_12805@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:44.884','2026-10-19 12:14:44.884'),(186,'student_12806','$2b$10$p/lJy1w9mCfRhCjOz.f3DurDFLWVUC2TT4Ul7lT0YHMJLJ82fiEC6','student_12806@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:44.947','2026-10-19 12:14:44.947'),(187,'student_12807','$2b$10$E.dKfbp44v.1Ilt7F09m6u2d73r8q/za2J61Jfv9GbiGV1pLGyOKW','student_12807@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:45.012','2026-10-19 12:14:45.012'),(188,'student_12901','$2b$10$QbScHXmRlWkZ3ogxY.0Bu.RFGV0ctEniLUkygFto6kAP/OS9rA1uy','student_12901@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:45.076','2026-10-19 12:14:45.076'),(189,'student_12902','$2b$10$eGsM06qetPlOq4Iu5d29V.KtuSDt80lEc5YV6Ph3elvnSeHYsrR5G','student_12902@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:45.142','2026-10-19 12:14:45.142'),(190,'student_12903','$2b$10$NR.mKxEDdCcCZXoa/y2I/.Ru0K3iL6ZBHYM.jHHS.8c8BS8h/wzGS','student_12903@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:45.206','2026-10-19 12:14:45.206'),(191,'student_12904','$2b$10$X7OwrEU7B7eNIrlcZygQ.eZHih1D9yOgmVKR2v5aGd8pDndHDCZ.6','student_12904@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:45.272','2026-10-19 12:14:45.272'),(192,'student_12905','$2b$10$rnTV/qgUBYPAvW8.OM7gX.x2nRiNjraxOTZT77ZyZgLt0pmkz6832','student_12905@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:45.336','2026-10-19 12:14:45.336'),(193,'student_12906','$2b$10$.yRUWkM2xGe4Auo20W1KheSf8w9SP27vQ4QbaAcl3BCU67NYFb2/u','student_12906@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:45.406','2026-10-19 12:14:45.406'),(194,'student_12907','$2b$10$UrWbIV.sG9CxlGf/YWeNEOftVwkqkY69M1jQomkoKOLkls8L7d4dK','student_12907@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:45.472','2026-10-19 12:14:45.472'),(195,'student_12908','$2b$10$Ht0mHS.LAkrPLCKcZYwhTuvTWODjYHMolNWcQ1GKnY93BfjM.BX1y','student_12908@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:45.536','2026-10-19 12:14:45.536'),(196,'student_13001','$2b$10$BxQgtKd6TQiLOH9ULGq2jev8ZT8p6IR4WjNKO.2MS9dWauWa4rBc.','student_13001@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:45.600','2026-10-19 12:14:45.600'),(197,'student_13002','$2b$10$1hWfFrrC2dGNEHTjH9/hW.NL2cti1uPWKl6BP24G.e24IG105fVeG','student_13002@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:45.664','2026-10-19 12:14:45.664'),(198,'student_13003','$2b$10$w5gO23DJHxHBWQ7HfDw/JOtwct1ofusJ4sFvNoL4B5rbnh9xLEFGW','student_13003@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:45.728','2026-10-19 12:14:45.728'),(199,'student_13004','$2b$10$Yg19cGcKO0Jss9CuDACBUO7oR5.A9pL5wvv9Abk.Ol3crX3sk3zWG','student_13004@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:45.790','2026-10-19 12:14:45.790'),(200,'student_13005','$2b$10$U0IDZBJSL1Vrcy.XDzvWyeuO149Z5bpRhfrwEf9Q6DrepdyPOrIBq','student_13005@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:45.853','2026-10-19 12:14:45.853'),(201,'student_13006','$2b$10$9BUMKLu5seg8scTZlGMUv.WWag/kH2rQIW8f9wJYaMeKql949rqh.','student_13006@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:45.918','2026-10-19 12:14:45.918'),(202,'student_13007','$2b$10$G27n8RkytcE4ra93WbcIBOsKr5gyE15b58WPwZZN6PPSjvjX8aviy','student_13007@school.edu.vn','Student',1,NULL,NULL,NULL,'2026-10-19 12:14:45.979','2026-10-19 12:14:45.979'),(203,'judge1','judge123','judge1@contest.com','Judge',1,NULL,NULL,NULL,'2026-10-19 12:14:46.170','2026-10-19 12:14:46.170'),(204,'judge2','judge123','judge2@contest.com','Judge',1,NULL,NULL,NULL,'2026-10-19 12:14:46.170','2026-10-19 12:14:46.170');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'olympicdev'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-19 20:15:56
