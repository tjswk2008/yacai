## Yacai

* 设计宽度：iphone XR 414pt

* 默认字体大小 14pt

```sql
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
```

```sql
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
```

```sql
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
```

```sql
CREATE TABLE `mark` (
 `id` INT(11) NOT NULL AUTO_INCREMENT,
 `marker` INT(1) NOT NULL DEFAULT '0' COMMENT '1 有意向 2 已电联',
 `userId` INT(11) NOT NULL DEFAULT '0',
 `account` VARCHAR(64) NOT NULL DEFAULT '',
 PRIMARY KEY (`id`),
 INDEX `FK_mark_user` (`userId`),
 CONSTRAINT `FK_mark_user` FOREIGN KEY (`userId`) REFERENCES `user` (`id`)
)
COMMENT='标记记录'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=6
;
```

```sql
CREATE TABLE `block` (
 `id` INT(11) NOT NULL AUTO_INCREMENT,
 `blocked` INT(1) NOT NULL DEFAULT '0' COMMENT '1 已屏蔽 0 开放',
 `companyId` INT(11) NOT NULL DEFAULT '0',
 `account` VARCHAR(64) NOT NULL DEFAULT '',
 PRIMARY KEY (`id`),
 INDEX `FK_block_company` (`companyId`),
 CONSTRAINT `FK_block_company` FOREIGN KEY (`companyId`) REFERENCES `company` (`id`)
)
COMMENT='屏蔽记录'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=13
;
```

```sql
CREATE TABLE `likelist` (
 `id` INT(11) NOT NULL AUTO_INCREMENT,
 `answerId` INT(11) NULL DEFAULT NULL,
 `account` VARCHAR(64) NOT NULL,
 `like` INT(1) NOT NULL DEFAULT '0' COMMENT '1. 已点赞 0. 未点赞',
 `postId` INT(11) NULL DEFAULT NULL,
 PRIMARY KEY (`id`)
)
COMMENT='帖子点赞记录'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=8
;
```

```sql
CREATE TABLE `invitation` (
 `id` INT(11) NOT NULL AUTO_INCREMENT,
 `sendBy` VARCHAR(64) NOT NULL,
 `detail` VARCHAR(1024) NOT NULL,
 `userId` INT(11) NOT NULL,
 `accepted` INT(1) NOT NULL DEFAULT '0' COMMENT '1. 已接受邀请 0. 未接受 2. 已拒绝',
 `jobId` INT(11) NOT NULL,
 PRIMARY KEY (`id`)
)
ENGINE=InnoDB
AUTO_INCREMENT=2
;
```
