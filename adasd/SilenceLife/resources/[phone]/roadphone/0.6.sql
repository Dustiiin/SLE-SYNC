ALTER TABLE `roadphone_information` ADD crypto LONGTEXT NOT NULL;

DELETE FROM roadphone_messages;
ALTER TABLE `roadphone_messages` MODIFY `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP();
ALTER TABLE `roadphone_messages` ADD isRead int(11) NOT NULL DEFAULT 0;
ALTER TABLE `roadphone_contacts` ADD favourite int(2) NOT NULL DEFAULT 0;

DELETE FROM roadphone_yellowapp;
DELETE FROM roadphone_calls;
DELETE FROM roadphone_jobs;

ALTER TABLE `roadphone_calls` MODIFY `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP();
ALTER TABLE `roadphone_jobs` MODIFY `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP();
ALTER TABLE `roadphone_yellowapp` MODIFY `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP();

CREATE TABLE IF NOT EXISTS `roadphone_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender` varchar(30) NOT NULL DEFAULT '0',
  `receiver` varchar(30) NOT NULL DEFAULT '0',
  `text` varchar(80) DEFAULT NULL,
  `amount` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb4;

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