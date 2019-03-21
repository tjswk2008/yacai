yacai

设计宽度：iphone XR 414pt
默认字体大小 14pt

CREATE TABLE `resumeViewer` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`userId` INT(11) NOT NULL DEFAULT '0',
	`companyId` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	INDEX `FK_resumeViewer_user` (`userId`),
	INDEX `FK_resumeViewer_job` (`companyId`),
	CONSTRAINT `FK_resumeViewer_job` FOREIGN KEY (`companyId`) REFERENCES `company` (`id`),
	CONSTRAINT `FK_resumeViewer_user` FOREIGN KEY (`userId`) REFERENCES `user` (`id`)
)
COMMENT='简历查看记录'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=4
;

CREATE TABLE `favorite` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`favorite` INT(1) NOT NULL DEFAULT '0' COMMENT '1 收藏 0 未收藏',
	`userId` INT(11) NOT NULL DEFAULT '0',
	`jobId` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	INDEX `FK_favorite_user` (`userId`),
	INDEX `FK_favorite_job` (`jobId`),
	CONSTRAINT `FK_favorite_job` FOREIGN KEY (`jobId`) REFERENCES `job` (`id`),
	CONSTRAINT `FK_favorite_user` FOREIGN KEY (`userId`) REFERENCES `user` (`id`)
)
COMMENT='收藏记录'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=5
;

CREATE TABLE `delivery` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`userId` INT(11) NOT NULL DEFAULT '0',
	`jobId` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	INDEX `FK_delivery_user` (`userId`),
	INDEX `FK_delivery_job` (`jobId`),
	CONSTRAINT `FK_delivery_job` FOREIGN KEY (`jobId`) REFERENCES `job` (`id`),
	CONSTRAINT `FK_delivery_user` FOREIGN KEY (`userId`) REFERENCES `user` (`id`)
)
COMMENT='投递记录'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=2
;

