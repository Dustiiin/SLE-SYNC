CREATE TABLE IF NOT EXISTS `user_clothes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) COLLATE utf8mb4_bin DEFAULT NULL,
  `name` varchar(60) COLLATE utf8mb4_bin DEFAULT NULL,
  `clothesData` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;