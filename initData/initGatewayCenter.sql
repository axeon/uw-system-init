/*!50503 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS `uw_gateway` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `uw_gateway`;

-- uw_gateway.access_global_stats definition

CREATE TABLE `access_global_stats` (
                                       `id` bigint NOT NULL COMMENT '主键',
                                       `stats_date` datetime DEFAULT NULL COMMENT '统计时间',
                                       `create_date` datetime DEFAULT NULL COMMENT '建立时间',
                                       `saas_num` bigint DEFAULT NULL COMMENT '系统数',
                                       `user_num` bigint DEFAULT NULL COMMENT '用户数',
                                       `ip_num` bigint DEFAULT NULL COMMENT 'ip数',
                                       `session_num` bigint DEFAULT NULL COMMENT '会话数',
                                       `service_num` bigint DEFAULT NULL COMMENT '服务数',
                                       `api_num` bigint DEFAULT NULL COMMENT 'api数',
                                       `request_num` bigint DEFAULT NULL COMMENT '访问量',
                                       `request_size` bigint DEFAULT NULL COMMENT '请求数据量',
                                       `response_size` bigint DEFAULT NULL COMMENT '响应数据量',
                                       `response_millis` bigint DEFAULT NULL COMMENT '响应总时间',
                                       `response_500` bigint DEFAULT NULL COMMENT '500代码数',
                                       `response_404` bigint DEFAULT NULL COMMENT '404代码数',
                                       `response_401` bigint DEFAULT NULL COMMENT '401代码数',
                                       `response_403` bigint DEFAULT NULL COMMENT '403代码数',
                                       PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='全局访问统计';


-- uw_gateway.access_saas_stats definition

CREATE TABLE `access_saas_stats` (
                                     `id` bigint NOT NULL COMMENT '主键',
                                     `saas_id` bigint DEFAULT NULL COMMENT 'saasId',
                                     `stats_date` datetime DEFAULT NULL COMMENT '统计时间',
                                     `create_date` datetime DEFAULT NULL COMMENT '建立时间',
                                     `user_num` bigint DEFAULT NULL COMMENT '用户数',
                                     `ip_num` bigint DEFAULT NULL COMMENT 'ip数',
                                     `session_num` bigint DEFAULT NULL COMMENT '会话数',
                                     `service_num` bigint DEFAULT NULL COMMENT '服务数',
                                     `api_num` bigint DEFAULT NULL COMMENT 'api数',
                                     `request_num` bigint DEFAULT NULL COMMENT '访问量',
                                     `request_size` bigint DEFAULT NULL COMMENT '请求数据量',
                                     `response_size` bigint DEFAULT NULL COMMENT '响应数据量',
                                     `response_millis` bigint DEFAULT NULL COMMENT '响应总时间',
                                     `response_500` bigint DEFAULT NULL COMMENT '500代码数',
                                     `response_404` bigint DEFAULT NULL COMMENT '404代码数',
                                     `response_401` bigint DEFAULT NULL COMMENT '401代码数',
                                     `response_403` bigint DEFAULT NULL COMMENT '403代码数',
                                     PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='saas访问统计';


-- uw_gateway.msc_acl_filter definition

CREATE TABLE `msc_acl_filter` (
                                  `id` bigint NOT NULL COMMENT 'id',
                                  `saas_id` bigint NOT NULL COMMENT 'saasId',
                                  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
                                  `user_type` int DEFAULT NULL COMMENT '用户类型',
                                  `filter_type` int NOT NULL COMMENT '过滤器类型 -1 黑名单模式 0 不过滤 1 白名单模式',
                                  `filter_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '过滤器名',
                                  `filter_desc` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '过滤器描述',
                                  `apply_user_id` bigint NOT NULL COMMENT '申请人ID',
                                  `apply_user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '申请人IP',
                                  `apply_user_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '申请人用户名',
                                  `apply_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '申请备注',
                                  `apply_date` datetime(3) DEFAULT NULL COMMENT '请求时间',
                                  `audit_user_id` bigint DEFAULT NULL COMMENT '审批人ID',
                                  `audit_user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审批用户IP',
                                  `audit_user_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审批人用户名',
                                  `audit_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审批备注',
                                  `audit_date` datetime(3) DEFAULT NULL COMMENT '审批时间',
                                  `audit_state` int NOT NULL COMMENT '审批状态',
                                  `expire_date` datetime(3) DEFAULT NULL COMMENT '过期时间',
                                  `create_date` datetime(3) NOT NULL COMMENT '创建时间',
                                  `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                  `state` int NOT NULL COMMENT '状态值: -1: 删除 0: 冻结 1: 正常',
                                  PRIMARY KEY (`id`),
                                  KEY `msc_acl_filter_saas_id_IDX` (`saas_id`,`state`,`audit_state`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='IP访问控制';


-- uw_gateway.msc_acl_filter_data definition

CREATE TABLE `msc_acl_filter_data` (
                                       `id` bigint NOT NULL COMMENT 'id',
                                       `saas_id` bigint DEFAULT NULL COMMENT 'saasId',
                                       `filter_id` bigint DEFAULT NULL COMMENT '过滤器id',
                                       `ip_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'ip信息',
                                       `ip_start` varchar(50) DEFAULT NULL COMMENT 'ip开始',
                                       `ip_end` varchar(50) DEFAULT NULL COMMENT 'ip结束',
                                       `apply_user_id` bigint NOT NULL COMMENT '申请人ID',
                                       `apply_user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '申请人IP',
                                       `apply_user_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '申请人用户名',
                                       `apply_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '申请备注',
                                       `apply_date` datetime(3) DEFAULT NULL COMMENT '请求时间',
                                       `audit_user_id` bigint DEFAULT NULL COMMENT '审批人ID',
                                       `audit_user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审批用户IP',
                                       `audit_user_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审批人用户名',
                                       `audit_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审批备注',
                                       `audit_date` datetime(3) DEFAULT NULL COMMENT '审批时间',
                                       `audit_state` int NOT NULL COMMENT '审批状态',
                                       `expire_date` datetime(3) DEFAULT NULL COMMENT '过期时间',
                                       `create_date` datetime(3) NOT NULL COMMENT '创建时间',
                                       `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                       `state` int NOT NULL COMMENT '状态值: -1: 删除 0: 冻结 1: 正常',
                                       PRIMARY KEY (`id`),
                                       KEY `msc_acl_filter_data_saas_id_IDX` (`saas_id`,`state`,`audit_state`) USING BTREE,
                                       KEY `msc_acl_filter_data_filter_id_IDX` (`filter_id`,`state`,`audit_state`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='IP访问控制数据';


-- uw_gateway.msc_acl_rate definition

CREATE TABLE `msc_acl_rate` (
                                `id` bigint NOT NULL COMMENT 'id',
                                `saas_id` bigint DEFAULT NULL COMMENT 'saasId',
                                `saas_level` int DEFAULT NULL COMMENT 'SAAS级别',
                                `user_id` bigint DEFAULT NULL COMMENT '用户ID',
                                `user_type` int DEFAULT NULL COMMENT '用户类型',
                                `limit_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '限速名称',
                                `limit_desc` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '限速描述',
                                `limit_type` int DEFAULT NULL COMMENT '限速类型',
                                `limit_uri` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '限速资源',
                                `limit_seconds` int DEFAULT NULL COMMENT '限速秒数',
                                `limit_requests` int DEFAULT NULL COMMENT '限速请求',
                                `limit_bytes` int DEFAULT NULL COMMENT '限速字节数',
                                `apply_user_id` bigint NOT NULL COMMENT '申请人ID',
                                `apply_user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '申请人IP',
                                `apply_user_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '申请人用户名',
                                `apply_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '申请备注',
                                `apply_date` datetime(3) DEFAULT NULL COMMENT '请求时间',
                                `audit_user_id` bigint DEFAULT NULL COMMENT '审批人ID',
                                `audit_user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审批用户IP',
                                `audit_user_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审批人用户名',
                                `audit_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审批备注',
                                `audit_date` datetime(3) DEFAULT NULL COMMENT '审批时间',
                                `audit_state` int NOT NULL COMMENT '审批状态',
                                `expire_date` datetime(3) DEFAULT NULL COMMENT '过期时间',
                                `create_date` datetime(3) NOT NULL COMMENT '创建时间',
                                `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                `state` int NOT NULL COMMENT '状态值: -1: 删除 0: 冻结 1: 正常',
                                PRIMARY KEY (`id`),
                                KEY `msc_acl_rate_saas_id_IDX` (`saas_id`,`state`,`audit_state`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统流控配置';


-- uw_gateway.msc_acme_account definition

CREATE TABLE `msc_acme_account` (
                                    `id` bigint NOT NULL COMMENT 'id',
                                    `saas_id` bigint DEFAULT NULL COMMENT 'saasId',
                                    `account_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '账号名称',
                                    `account_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '账号描述',
                                    `account_cert_alg` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '账户证书算法',
                                    `account_cert_key` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '账户证书密钥',
                                    `eab_id` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'EAB KID',
                                    `eab_key` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'EAB-KEY',
                                    `create_date` datetime(3) NOT NULL COMMENT '创建时间',
                                    `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                    `state` int NOT NULL COMMENT '状态值: -1: 删除 0: 冻结 1: 正常',
                                    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='acme账号';


-- uw_gateway.msc_acme_cert definition

CREATE TABLE `msc_acme_cert` (
                                 `id` bigint NOT NULL COMMENT 'id',
                                 `saas_id` bigint DEFAULT NULL COMMENT 'saasId',
                                 `account_id` bigint DEFAULT NULL COMMENT '账户ID',
                                 `domain_id` bigint DEFAULT NULL COMMENT '域名id',
                                 `domain_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '域名名称',
                                 `domain_alias` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '别名列表',
                                 `cert_alg` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '证书算法',
                                 `cert_key` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '证书密钥',
                                 `cert_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '证书数据',
                                 `cert_log` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '证书日志',
                                 `active_date` datetime(3) DEFAULT NULL COMMENT '激活日期',
                                 `expire_date` datetime(3) DEFAULT NULL COMMENT '失效时间',
                                 `create_date` datetime(3) NOT NULL COMMENT '创建时间',
                                 `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                 `state` int NOT NULL COMMENT '状态值: -1: 删除 0: 冻结 1: 正常',
                                 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='acme证书';


-- uw_gateway.msc_acme_deploy definition

CREATE TABLE `msc_acme_deploy` (
                                   `id` bigint NOT NULL COMMENT 'id',
                                   `saas_id` bigint DEFAULT NULL COMMENT 'saasId',
                                   `domain_id` bigint DEFAULT NULL COMMENT '域名id',
                                   `deploy_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '部署名称',
                                   `deploy_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '部署描述',
                                   `deploy_vendor` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '部署目标',
                                   `deploy_param` json DEFAULT NULL COMMENT '部署参数',
                                   `last_update` datetime(3) DEFAULT NULL COMMENT '上次更新时间',
                                   `last_active_date` datetime(3) DEFAULT NULL COMMENT '上次更新时间',
                                   `last_expire_date` datetime(3) DEFAULT NULL COMMENT '最近证书过期时间',
                                   `create_date` datetime(3) NOT NULL COMMENT '创建时间',
                                   `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                   `state` int NOT NULL COMMENT '状态值: -1: 删除 0: 冻结 1: 正常',
                                   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='acme部署';


-- uw_gateway.msc_acme_deploy_log definition

CREATE TABLE `msc_acme_deploy_log` (
                                       `id` bigint NOT NULL COMMENT 'id',
                                       `saas_id` bigint DEFAULT NULL COMMENT 'saasId',
                                       `domain_id` bigint DEFAULT NULL COMMENT '域名id',
                                       `cert_id` bigint DEFAULT NULL COMMENT '证书id',
                                       `deploy_id` bigint DEFAULT NULL COMMENT '部署id',
                                       `deploy_info` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '部署信息',
                                       `deploy_log` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '部署日志',
                                       `deploy_date` datetime(3) DEFAULT NULL COMMENT '部署时间',
                                       `state` int NOT NULL COMMENT '状态值: -1: 删除 0: 冻结 1: 正常',
                                       PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='acme部署日志';


-- uw_gateway.msc_acme_domain definition

CREATE TABLE `msc_acme_domain` (
                                   `id` bigint NOT NULL COMMENT 'id',
                                   `saas_id` bigint DEFAULT NULL COMMENT 'saasId',
                                   `account_id` bigint DEFAULT NULL COMMENT '账户ID',
                                   `domain_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '域名名称',
                                   `domain_alias` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '别名列表',
                                   `domain_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '域名描述',
                                   `domain_cert_alg` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '域名证书算法',
                                   `domain_cert_key` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '域名证书密钥',
                                   `acme_vendor` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'acme服务商',
                                   `dns_vendor` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'dns供应商',
                                   `dns_param` json DEFAULT NULL COMMENT 'dns参数',
                                   `last_update` datetime(3) DEFAULT NULL COMMENT '上次更新时间',
                                   `last_active_date` datetime(3) DEFAULT NULL COMMENT '上次更新时间',
                                   `last_expire_date` datetime(3) DEFAULT NULL COMMENT '最近证书过期时间',
                                   `create_date` datetime(3) NOT NULL COMMENT '创建时间',
                                   `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                   `state` int NOT NULL COMMENT '状态值: -1: 删除 0: 冻结 1: 正常',
                                   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='acme域名';


-- uw_gateway.sys_crit_log definition

CREATE TABLE `sys_crit_log` (
                                `id` bigint NOT NULL COMMENT 'ID',
                                `saas_id` bigint NOT NULL COMMENT 'saasId',
                                `mch_id` bigint DEFAULT NULL COMMENT '商户ID',
                                `user_id` bigint NOT NULL COMMENT '用户id',
                                `user_type` int DEFAULT NULL COMMENT '用户类型',
                                `group_id` bigint DEFAULT NULL COMMENT '用户组ID',
                                `user_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户名',
                                `nick_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户昵称',
                                `real_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '真实名称',
                                `user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户ip',
                                `api_uri` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '请求uri',
                                `api_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'API名称',
                                `biz_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '业务类型',
                                `biz_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '业务ID',
                                `biz_log` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '业务日志',
                                `request_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '请求时间',
                                `request_body` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '请求参数',
                                `response_state` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '响应状态',
                                `response_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '响应代码',
                                `response_msg` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '响应消息',
                                `response_body` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '响应日志',
                                `response_millis` bigint DEFAULT NULL COMMENT '请求毫秒数',
                                `status_code` int DEFAULT NULL COMMENT '响应状态码',
                                `app_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '应用信息',
                                `app_host` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '应用主机',
                                PRIMARY KEY (`id`),
                                KEY `sys_crit_log_saas_id_IDX` (`saas_id`,`user_id`) USING BTREE,
                                KEY `sys_crit_log_biz_type_IDX` (`biz_type`,`biz_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统关键日志';


-- uw_gateway.sys_data_history definition

CREATE TABLE `sys_data_history` (
                                    `id` bigint NOT NULL COMMENT 'ID',
                                    `saas_id` bigint NOT NULL COMMENT 'saasId',
                                    `mch_id` bigint DEFAULT NULL COMMENT '商户ID',
                                    `user_id` bigint NOT NULL COMMENT '用户ID',
                                    `user_type` int DEFAULT NULL COMMENT '用户类型',
                                    `group_id` bigint DEFAULT NULL COMMENT '用户的组ID',
                                    `user_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户名称',
                                    `nick_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户昵称',
                                    `real_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '真实名称',
                                    `entity_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '实体类',
                                    `entity_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '实体ID',
                                    `entity_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '实体名',
                                    `entity_data` json DEFAULT NULL COMMENT '实体数据',
                                    `entity_update_info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '实体修改信息',
                                    `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '备注信息',
                                    `user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户IP',
                                    `create_date` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建日期',
                                    PRIMARY KEY (`id`),
                                    KEY `sys_data_history_entity_class_IDX` (`entity_class`,`entity_id`) USING BTREE,
                                    KEY `sys_data_history_saas_id_IDX` (`saas_id`,`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统数据历史';


-- uw_gateway.sys_seq definition

CREATE TABLE `sys_seq` (
                           `seq_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '序列名',
                           `seq_id` bigint DEFAULT NULL COMMENT '当前序列id',
                           `seq_desc` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '序列描述',
                           `increment_num` int DEFAULT NULL COMMENT '每次递增大小',
                           `create_date` datetime(3) DEFAULT NULL COMMENT '建立日期',
                           `last_update` datetime(3) DEFAULT NULL COMMENT '最后更新日期',
                           PRIMARY KEY (`seq_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='SYS序列';