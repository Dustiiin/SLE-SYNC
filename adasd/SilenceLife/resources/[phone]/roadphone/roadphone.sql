CREATE TABLE IF NOT EXISTS `roadphone_camera` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(80) NOT NULL,
  `picture` longtext NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `roadphone_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(80) NOT NULL DEFAULT '0',
  `firstname` varchar(12) NOT NULL DEFAULT '0',
  `lastname` varchar(12) NOT NULL DEFAULT '0',
  `number` varchar(10) NOT NULL DEFAULT '0',
  `picture` longtext DEFAULT NULL,
  `favourite` int(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `roadphone_information` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(80) NOT NULL,
  `profilepicture` LONGTEXT DEFAULT NULL,
  `crypto` LONGTEXT NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `roadphone_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender` varchar(50) NOT NULL,
  `jobreceived` varchar(50) NOT NULL,
  `message` varchar(80) NOT NULL DEFAULT '0',
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `gps` varchar(500) DEFAULT '0',
  `status` int(2) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `roadphone_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `receiver` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `isgps` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `ispicture` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `picture` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isRead` int(11) NOT NULL DEFAULT 0,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `roadphone_yellowapp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `number` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `text` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `picture` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `roadphone_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender` varchar(30) NOT NULL DEFAULT '0',
  `receiver` varchar(30) NOT NULL DEFAULT '0',
  `text` varchar(80) DEFAULT NULL,
  `amount` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `roadphone_calls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `caller` varchar(50) DEFAULT NULL,
  `receiver` varchar(50) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `roadphone_gps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(80) NOT NULL DEFAULT '0',
  `name` varchar(20) NOT NULL DEFAULT '0',
  `position` longtext DEFAULT NULL,
  `fontcolor` varchar(50) NOT NULL DEFAULT '0',
  `backgroundcolor` varchar(50) NOT NULL DEFAULT '0',
  `date` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;


CREATE TABLE IF NOT EXISTS `roadphone_encrochat_groupmessages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupid` int(11) DEFAULT NULL,
  `userid` int(11) NOT NULL DEFAULT 0,
  `message` varchar(250) NOT NULL DEFAULT '0',
  `date` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `roadphone_encrochat_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(46) DEFAULT NULL,
  `groupname` varchar(20) DEFAULT NULL,
  `gimage` longtext DEFAULT NULL,
  `password` longtext DEFAULT NULL,
  `users` longtext DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;


CREATE TABLE IF NOT EXISTS `roadphone_encrochat_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) COLLATE utf8_unicode_ci DEFAULT NULL,
  `username` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `date` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `roadphone_mails` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(255) NOT NULL DEFAULT '0' COLLATE utf8_general_ci,
	`sender` VARCHAR(255) NOT NULL DEFAULT '0' COLLATE utf8_general_ci,
	`subject` VARCHAR(255) NOT NULL DEFAULT '0' COLLATE utf8_general_ci,
	`image` TEXT NULL DEFAULT NULL COLLATE utf8_general_ci,
	`message` TEXT NOT NULL COLLATE utf8_general_ci,
	`button` TEXT NULL DEFAULT NULL COLLATE utf8_general_ci,
	`time` TIMESTAMP NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
	PRIMARY KEY (`id`) USING BTREE
) COLLATE=utf8_general_ci ENGINE=InnoDB AUTO_INCREMENT=0;


ALTER TABLE `jobs` ADD jobsapp INT(2) DEFAULT '0';
ALTER TABLE `users` ADD phone_number VARCHAR(10) NULL;
