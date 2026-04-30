/*!50503 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS `uw_tinyurl` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `uw_tinyurl`;

-- uw_tinyurl.sys_seq definition

CREATE TABLE `sys_seq` (
                           `seq_name` varchar(200) NOT NULL COMMENT '序列名',
                           `seq_id` bigint DEFAULT NULL COMMENT '当前序列id',
                           `seq_desc` varchar(200) DEFAULT NULL COMMENT '序列描述',
                           `increment_num` int DEFAULT NULL COMMENT '每次递增大小',
                           `create_date` datetime(3) DEFAULT NULL COMMENT '建立日期',
                           `last_update` datetime(3) DEFAULT NULL COMMENT '最后更新日期',
                           PRIMARY KEY (`seq_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='SYS序列';


-- uw_tinyurl.tiny_url definition

CREATE TABLE `tiny_url` (
                            `id` bigint NOT NULL COMMENT 'id',
                            `saas_id` bigint DEFAULT NULL COMMENT 'saasId',
                            `object_type` varchar(100) DEFAULT NULL COMMENT '对象类型',
                            `object_id` bigint DEFAULT NULL COMMENT '对象Id',
                            `url` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'url',
                            `secret_tips` varchar(200) DEFAULT NULL COMMENT '密语提示？',
                            `secret_data` varchar(100) DEFAULT NULL COMMENT '密语',
                            `create_date` datetime(3) DEFAULT NULL COMMENT '创建时间',
                            `expire_date` datetime(3) DEFAULT NULL COMMENT '过期时间',
                            `last_update` datetime(3) DEFAULT NULL COMMENT '最后访问时间',
                            `create_ip` varchar(50) DEFAULT NULL COMMENT '创建ip',
                            `state` int DEFAULT NULL COMMENT '1 正常 0禁用 -1删除',
                            PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='短链库';