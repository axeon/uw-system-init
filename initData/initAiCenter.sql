/*!50503 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS `uw_ai` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `uw_ai`;

-- uw_ai.ai_model_config definition

CREATE TABLE `ai_model_config` (
                                   `id` bigint NOT NULL COMMENT 'ID',
                                   `saas_id` bigint NOT NULL DEFAULT '0' COMMENT 'SAAS ID',
                                   `mch_id` bigint NOT NULL DEFAULT '0' COMMENT '商户ID',
                                   `vendor_class` varchar(200) NOT NULL COMMENT '服务商类',
                                   `config_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '服务商代码',
                                   `config_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '服务商名称',
                                   `config_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '服务商描述',
                                   `api_url` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'api地址',
                                   `api_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'api key',
                                   `model_main` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '主模型',
                                   `model_embed` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '嵌入模型',
                                   `vendor_data` json DEFAULT NULL COMMENT '服务商配置',
                                   `model_data` json DEFAULT NULL COMMENT '模型配置',
                                   `embed_data` json DEFAULT NULL COMMENT '嵌入配置',
                                   `create_date` datetime(3) DEFAULT NULL COMMENT '创建时间',
                                   `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                   `state` int DEFAULT NULL COMMENT '状态',
                                   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='AI服务模型';


-- uw_ai.ai_rag_doc definition

CREATE TABLE `ai_rag_doc` (
                              `id` bigint NOT NULL COMMENT 'ID',
                              `saas_id` bigint NOT NULL COMMENT 'saasId',
                              `lib_id` bigint NOT NULL COMMENT 'libId',
                              `doc_type` varchar(20) DEFAULT NULL COMMENT '文档类型',
                              `doc_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '文档名称',
                              `doc_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '文档描述',
                              `doc_body` longblob COMMENT '文档主体',
                              `doc_content` json DEFAULT NULL COMMENT '文档内容',
                              `doc_body_size` bigint DEFAULT NULL COMMENT '文档主体大小',
                              `doc_content_size` bigint DEFAULT NULL COMMENT '文档内容大小',
                              `create_date` datetime(3) DEFAULT NULL COMMENT '创建时间',
                              `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                              `state` int DEFAULT NULL COMMENT '状态',
                              PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='rag文档信息';


-- uw_ai.ai_rag_lib definition

CREATE TABLE `ai_rag_lib` (
                              `id` bigint NOT NULL COMMENT 'ID',
                              `saas_id` bigint NOT NULL COMMENT 'saasId',
                              `lib_type` int DEFAULT NULL COMMENT '文档库类型',
                              `lib_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '文档库名称',
                              `lib_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '文档库描述',
                              `embed_config_id` bigint DEFAULT NULL COMMENT 'embed配置ID',
                              `embed_model_name` varchar(100) DEFAULT NULL COMMENT 'embed模型名',
                              `lib_config` json DEFAULT NULL COMMENT '文档库配置',
                              `create_date` datetime(3) DEFAULT NULL COMMENT '创建时间',
                              `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                              `state` int DEFAULT NULL COMMENT '状态',
                              PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='rag文档库';


-- uw_ai.ai_session_info definition

CREATE TABLE `ai_session_info` (
                                   `id` bigint NOT NULL COMMENT 'ID',
                                   `saas_id` bigint NOT NULL COMMENT 'saasId',
                                   `user_id` bigint NOT NULL COMMENT '用户id',
                                   `user_type` int DEFAULT NULL COMMENT '用户类型',
                                   `user_info` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户名',
                                   `config_id` bigint DEFAULT NULL COMMENT '配置ID',
                                   `session_type` int DEFAULT NULL COMMENT 'session类型',
                                   `session_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'session名称',
                                   `msg_num` int DEFAULT NULL COMMENT 'session大小',
                                   `window_size` int DEFAULT NULL COMMENT '历史长度',
                                   `request_tokens` bigint DEFAULT NULL COMMENT '请求token数',
                                   `response_tokens` bigint DEFAULT NULL COMMENT '响应token数',
                                   `system_prompt` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '系统信息',
                                   `tool_config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '工具信息',
                                   `rag_config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT 'rag信息',
                                   `create_date` datetime(3) DEFAULT NULL COMMENT '创建时间',
                                   `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                   `last_update` datetime(3) DEFAULT NULL COMMENT '最后更新时间',
                                   `state` int DEFAULT NULL COMMENT '状态',
                                   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='session会话';


-- uw_ai.ai_session_msg definition

CREATE TABLE `ai_session_msg` (
                                  `id` bigint NOT NULL COMMENT 'ID',
                                  `saas_id` bigint NOT NULL COMMENT 'saasId',
                                  `user_id` bigint NOT NULL COMMENT '用户id',
                                  `user_type` int DEFAULT NULL COMMENT '用户类型',
                                  `user_info` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户名',
                                  `config_id` bigint DEFAULT NULL COMMENT '配置ID',
                                  `session_id` bigint NOT NULL COMMENT 'sessionId',
                                  `system_prompt` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '系统提问',
                                  `user_prompt` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '用户提问',
                                  `context_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '上下文数据',
                                  `tool_config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '工具信息',
                                  `file_config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '文件信息',
                                  `rag_config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT 'rag信息',
                                  `response_info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '返回信息',
                                  `request_tokens` bigint DEFAULT NULL COMMENT '请求token数',
                                  `response_tokens` bigint DEFAULT NULL COMMENT '响应token数',
                                  `request_date` datetime(3) DEFAULT NULL COMMENT '创建时间',
                                  `response_start_date` datetime(3) DEFAULT NULL COMMENT '回应开始时间',
                                  `response_end_date` datetime(3) DEFAULT NULL COMMENT '回应结束时间',
                                  `state` int DEFAULT NULL COMMENT '状态',
                                  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='session消息';


-- uw_ai.ai_tool_info definition

CREATE TABLE `ai_tool_info` (
                                `id` bigint NOT NULL COMMENT 'ID',
                                `app_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '应用名',
                                `tool_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '工具类',
                                `tool_version` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '工具版本',
                                `tool_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '工具名称',
                                `tool_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '工具描述',
                                `tool_input` json DEFAULT NULL COMMENT '工具参数配置',
                                `tool_output` json DEFAULT NULL COMMENT '工具返回配置',
                                `create_date` datetime(3) DEFAULT NULL COMMENT '创建时间',
                                `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                `state` int DEFAULT NULL COMMENT '状态',
                                PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='AI工具信息';


-- uw_ai.sys_crit_log definition

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


-- uw_ai.sys_data_history definition

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


-- uw_ai.sys_seq definition

CREATE TABLE `sys_seq` (
                           `seq_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '序列名',
                           `seq_id` bigint DEFAULT NULL COMMENT '当前序列id',
                           `seq_desc` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '序列描述',
                           `increment_num` int DEFAULT NULL COMMENT '每次递增大小',
                           `create_date` datetime(3) DEFAULT NULL COMMENT '建立日期',
                           `last_update` datetime(3) DEFAULT NULL COMMENT '最后更新日期',
                           PRIMARY KEY (`seq_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='SYS序列';