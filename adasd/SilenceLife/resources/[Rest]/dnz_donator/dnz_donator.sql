-- Exportiere Struktur von Tabelle fivembro.dnz_donator_codes
CREATE TABLE IF NOT EXISTS `dnz_donator_codes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) DEFAULT NULL,
  `item` varchar(255) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `used` int(11) DEFAULT NULL,
  `createdby` varchar(50) DEFAULT NULL,
  `usedby` varchar(50) DEFAULT NULL,
  `createdbyname` varchar(50) DEFAULT NULL,
  `usedbyname` varchar(50) DEFAULT NULL,
  UNIQUE KEY `code` (`code`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=601 DEFAULT CHARSET=utf8mb4;