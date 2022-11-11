CREATE TABLE IF NOT EXISTS `doorscreator_buildings` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`label` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`default_state` TINYINT(4) NOT NULL DEFAULT '0',
	`allowed_jobs` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`required_item` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`requires_job_and_item` INT(11) NOT NULL DEFAULT '0',
	`required_code` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`auto_closure_seconds` INT(11) NULL DEFAULT NULL,
	`requires_identifier` INT(11) NOT NULL DEFAULT '0',
	`allowed_identifiers` LONGTEXT NOT NULL COLLATE 'utf8mb4_bin',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;