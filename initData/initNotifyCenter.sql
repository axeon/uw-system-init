/*!50503 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS `uw_notify` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `uw_notify`;

CREATE TABLE `sys_seq` (
    `seq_name` varchar(200) NOT NULL,
    `seq_id` bigint DEFAULT NULL,
    `seq_desc` varchar(200) DEFAULT NULL,
    `increment_num` int DEFAULT NULL,
    `create_date` datetime(3) DEFAULT NULL,
    `last_update` datetime(3) DEFAULT NULL,
    PRIMARY KEY (`seq_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='SYS序列';
