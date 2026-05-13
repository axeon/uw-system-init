/*!50503 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS `uw_task` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `uw_task`;


-- uw_task.sys_crit_log definition

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


-- uw_task.sys_data_history definition

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


-- uw_task.sys_seq definition

CREATE TABLE `sys_seq` (
                           `seq_name` varchar(200) NOT NULL COMMENT '序列名',
                           `seq_id` bigint DEFAULT NULL COMMENT '当前序列id',
                           `seq_desc` varchar(200) DEFAULT NULL COMMENT '序列描述',
                           `increment_num` int DEFAULT NULL COMMENT '每次递增大小',
                           `create_date` datetime(3) DEFAULT NULL COMMENT '建立日期',
                           `last_update` datetime(3) DEFAULT NULL COMMENT '最后更新日期',
                           PRIMARY KEY (`seq_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='SYS序列';


-- uw_task.task_alert_contact definition

CREATE TABLE `task_alert_contact` (
                                      `id` bigint NOT NULL COMMENT 'id',
                                      `contact_type` int DEFAULT NULL COMMENT '联系人类型',
                                      `contact_name` varchar(100) DEFAULT NULL COMMENT '联系人',
                                      `mobile` varchar(100) DEFAULT NULL COMMENT '联系电话',
                                      `email` varchar(100) DEFAULT NULL COMMENT '联系email',
                                      `wechat` varchar(100) DEFAULT NULL COMMENT '联系微信',
                                      `im` varchar(100) DEFAULT NULL COMMENT '备用im',
                                      `notify_url` varchar(500) DEFAULT NULL COMMENT '通知链接，如钉钉，微信等',
                                      `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                                      `create_date` datetime(3) DEFAULT NULL COMMENT '创建日期',
                                      `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                                      `state` int DEFAULT NULL COMMENT '状态',
                                      PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='报警联系信息';


-- uw_task.task_alert_info definition

CREATE TABLE `task_alert_info` (
                                   `id` bigint NOT NULL COMMENT 'id',
                                   `task_type` varchar(20) DEFAULT NULL COMMENT '任务类型。1croner2runner',
                                   `task_id` bigint DEFAULT NULL COMMENT '任务配置ID',
                                   `alert_title` varchar(200) DEFAULT NULL COMMENT '报警标题',
                                   `alert_body` longtext DEFAULT NULL COMMENT '报警信息',
                                   `create_date` datetime(3) DEFAULT NULL COMMENT '创建时间',
                                   `state` int DEFAULT NULL COMMENT '状态',
                                   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='报警信息';


-- uw_task.task_alert_notify definition

CREATE TABLE `task_alert_notify` (
                                     `id` bigint NOT NULL,
                                     `info_id` bigint DEFAULT NULL COMMENT '报警信息ID',
                                     `contact_man` varchar(100) DEFAULT NULL COMMENT '联系人',
                                     `contact_type` varchar(10) DEFAULT NULL COMMENT '联系人信息类型,mobile,qq,wx,email',
                                     `contact_info` varchar(100) DEFAULT NULL COMMENT '联系人信息',
                                     `create_date` datetime(3) DEFAULT NULL COMMENT '创建时间',
                                     `sent_date` datetime(3) DEFAULT NULL COMMENT '发送时间',
                                     `sent_times` int DEFAULT NULL COMMENT '发送次数',
                                     `state` int DEFAULT NULL COMMENT '状态',
                                     PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='报警信息通知';


-- uw_task.task_croner_info definition

CREATE TABLE `task_croner_info` (
                                    `id` bigint NOT NULL COMMENT 'id',
                                    `task_name` varchar(200) DEFAULT NULL COMMENT '任务名称',
                                    `task_desc` varchar(1000) DEFAULT NULL COMMENT '任务描述',
                                    `task_class` varchar(200) DEFAULT NULL COMMENT '执行类信息',
                                    `task_param` varchar(100) DEFAULT NULL COMMENT '任务参数',
                                    `task_owner` varchar(500) DEFAULT NULL COMMENT '任务所有人',
                                    `task_cron` varchar(100) DEFAULT NULL COMMENT 'cron表达式',
                                    `run_type` int DEFAULT '0' COMMENT '运行类型',
                                    `run_target` varchar(100) DEFAULT NULL COMMENT '运行目标',
                                    `log_level` int DEFAULT '0' COMMENT '日志类型',
                                    `log_limit_size` int DEFAULT NULL COMMENT '日志长度限制',
                                    `next_run_date` datetime DEFAULT NULL COMMENT '下次执行时间',
                                    `stats_date` datetime DEFAULT NULL COMMENT '最后统计时间',
                                    `stats_run_num` int DEFAULT NULL COMMENT '统计运行次数',
                                    `stats_fail_num` int DEFAULT NULL COMMENT '统计运行失败次数',
                                    `stats_run_time` bigint DEFAULT NULL COMMENT '统计总时间毫秒数',
                                    `alert_fail_rate` int DEFAULT NULL COMMENT '失败率',
                                    `alert_fail_partner_rate` int DEFAULT NULL COMMENT '接口失败率',
                                    `alert_fail_data_rate` int DEFAULT NULL COMMENT '数据失败率',
                                    `alert_fail_program_rate` int DEFAULT NULL COMMENT '程序失败率',
                                    `alert_wait_timeout` int DEFAULT NULL COMMENT '等待超时',
                                    `alert_run_timeout` int DEFAULT NULL COMMENT '运行超时',
                                    `task_link_our` varchar(500) DEFAULT NULL COMMENT '我方联系信息',
                                    `task_link_mch` varchar(500) DEFAULT NULL COMMENT '商户联系信息',
                                    `create_date` datetime(3) DEFAULT NULL COMMENT '创建时间',
                                    `modify_date` datetime(3) DEFAULT NULL COMMENT '最后修改时间',
                                    `state` int DEFAULT NULL COMMENT '状态1正常，0暂停，-1标记删除',
                                    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='定时任务配置';


-- uw_task.task_croner_stats definition

CREATE TABLE `task_croner_stats` (
                                     `id` bigint NOT NULL COMMENT 'id',
                                     `task_id` bigint DEFAULT NULL COMMENT '任务配置id',
                                     `num_all` int DEFAULT NULL COMMENT '全部执行计数',
                                     `num_fail_program` int DEFAULT NULL COMMENT '程序失败计数',
                                     `num_fail_config` int DEFAULT NULL COMMENT '配置失败计数',
                                     `num_fail_data` int DEFAULT NULL COMMENT '数据失败计数',
                                     `num_fail_partner` int DEFAULT NULL COMMENT '对方失败计数',
                                     `time_wait` int DEFAULT NULL COMMENT '超时等待',
                                     `time_run` int DEFAULT NULL COMMENT '运行时间',
                                     `create_date` datetime(3) DEFAULT NULL COMMENT '创建时间',
                                     PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='定时任务统计信息';


-- uw_task.task_host_info definition

CREATE TABLE `task_host_info` (
                                  `id` bigint NOT NULL COMMENT 'id',
                                  `host_ip` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '主机注册IP',
                                  `app_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '应用名称',
                                  `app_version` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '应用版本',
                                  `app_host` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'app主机',
                                  `app_port` int DEFAULT NULL COMMENT 'app端口',
                                  `task_project` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '任务项目',
                                  `run_target` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '运行目标',
                                  `croner_num` int DEFAULT NULL COMMENT '定时任务数量',
                                  `croner_run_num` int DEFAULT NULL COMMENT '统计运行次数',
                                  `croner_fail_num` int DEFAULT NULL COMMENT '统计运行失败次数',
                                  `croner_run_time` bigint DEFAULT NULL COMMENT '统计总时间毫秒数',
                                  `runner_num` int DEFAULT NULL COMMENT '队列任务数量',
                                  `runner_run_num` int DEFAULT NULL COMMENT '统计运行次数',
                                  `runner_fail_num` int DEFAULT NULL COMMENT '统计运行失败次数',
                                  `runner_run_time` bigint DEFAULT NULL COMMENT '统计总时间毫秒数',
                                  `jvm_mem_max` bigint DEFAULT NULL COMMENT 'jvm内存总数',
                                  `jvm_mem_total` bigint DEFAULT NULL COMMENT 'jvm内存总数',
                                  `jvm_mem_free` bigint DEFAULT NULL COMMENT 'jvm空闲内存',
                                  `thread_active` int DEFAULT NULL COMMENT '活跃线程',
                                  `thread_peak` int DEFAULT NULL COMMENT '峰值线程',
                                  `thread_daemon` int DEFAULT NULL COMMENT '守护线程',
                                  `thread_started` bigint DEFAULT NULL COMMENT '累计启动线程',
                                  `create_date` datetime(3) DEFAULT NULL COMMENT '建立日期',
                                  `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                  `last_update` datetime(3) DEFAULT NULL COMMENT '最后更新',
                                  `state` int DEFAULT NULL COMMENT '状态',
                                  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='task主机信息';


-- uw_task.task_runner_info definition

CREATE TABLE `task_runner_info` (
                                    `id` bigint NOT NULL COMMENT 'id',
                                    `task_name` varchar(200) DEFAULT NULL COMMENT '任务名称',
                                    `task_desc` varchar(1000) DEFAULT NULL COMMENT '任务描述',
                                    `task_class` varchar(200) DEFAULT NULL COMMENT '执行类信息',
                                    `task_owner` varchar(200) DEFAULT NULL COMMENT '任务所有人',
                                    `task_tag` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '运行标签',
                                    `queue_type` int DEFAULT NULL COMMENT '队列类型',
                                    `delay_type` int DEFAULT NULL COMMENT '延迟类型',
                                    `log_level` int DEFAULT NULL COMMENT '日志类型',
                                    `log_limit_size` int DEFAULT NULL COMMENT '日志长度限制',
                                    `run_type` int DEFAULT NULL COMMENT '运行类型',
                                    `run_target` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '运行目标',
                                    `consumer_num` int DEFAULT '1' COMMENT '消费者的数量',
                                    `prefetch_num` int DEFAULT '1' COMMENT '队列预取数量',
                                    `rate_limit_type` int DEFAULT '0' COMMENT '限速类型',
                                    `rate_limit_value` int DEFAULT '0' COMMENT '流量限定数值，默认为60次',
                                    `rate_limit_time` int DEFAULT '0' COMMENT '流量限定时间(S)，默认为60秒',
                                    `rate_limit_wait` int DEFAULT '60' COMMENT '当发生流量限制时，等待的秒数',
                                    `retry_times_by_overrated` int DEFAULT '3' COMMENT '超过流量限制重试次数',
                                    `retry_times_by_partner` int DEFAULT '3' COMMENT '对方接口错误重试次数',
                                    `stats_date` datetime DEFAULT NULL COMMENT '最后统计时间',
                                    `stats_run_num` int DEFAULT NULL COMMENT '统计运行次数',
                                    `stats_fail_num` int DEFAULT NULL COMMENT '统计运行失败次数',
                                    `stats_run_time` bigint DEFAULT NULL COMMENT '统计总时间毫秒数',
                                    `alert_fail_rate` int DEFAULT NULL COMMENT '失败率',
                                    `alert_fail_partner_rate` int DEFAULT NULL COMMENT '接口失败率',
                                    `alert_fail_program_rate` int DEFAULT NULL COMMENT '程序失败率',
                                    `alert_fail_config_rate` int DEFAULT NULL COMMENT '配置失败率',
                                    `alert_fail_data_rate` int DEFAULT NULL COMMENT '数据失败率',
                                    `alert_queue_oversize` int DEFAULT NULL COMMENT '队列长度限制',
                                    `alert_queue_timeout` int DEFAULT NULL COMMENT '队列等待超时',
                                    `alert_wait_timeout` int DEFAULT NULL COMMENT '等待超时',
                                    `alert_run_timeout` int DEFAULT NULL COMMENT '运行超时',
                                    `task_link_our` varchar(500) DEFAULT NULL COMMENT '我方联系信息',
                                    `task_link_mch` varchar(500) DEFAULT NULL COMMENT '商户联系信息',
                                    `create_date` datetime(3) DEFAULT NULL COMMENT '创建日期',
                                    `modify_date` datetime(3) DEFAULT NULL COMMENT '最后修改日期',
                                    `state` int DEFAULT NULL COMMENT '状态1正常，0暂停，-1标记删除',
                                    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='队列任务配置';


-- uw_task.task_runner_stats definition

CREATE TABLE `task_runner_stats` (
                                     `id` bigint NOT NULL COMMENT 'id',
                                     `task_id` bigint DEFAULT NULL COMMENT '任务配置id',
                                     `num_all` int DEFAULT NULL COMMENT '全部执行计数',
                                     `num_fail_program` int DEFAULT NULL COMMENT '程序错误计数',
                                     `num_fail_config` int DEFAULT NULL COMMENT '配置错误计数',
                                     `num_fail_data` int DEFAULT NULL COMMENT '数据错误计数',
                                     `num_fail_partner` int DEFAULT NULL COMMENT '对方错误计数',
                                     `time_wait_queue` int DEFAULT NULL COMMENT '队列等待时间',
                                     `time_wait_delay` int DEFAULT NULL COMMENT '超时等待时间',
                                     `time_run` int DEFAULT NULL COMMENT '运行时间',
                                     `queue_size` int DEFAULT NULL COMMENT '队列长度',
                                     `consumer_num` int DEFAULT NULL COMMENT '消费者数量',
                                     `create_date` datetime(3) DEFAULT NULL COMMENT '创建时间',
                                     PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='队列任务统计信息';