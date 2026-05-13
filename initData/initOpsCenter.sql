/*!50503 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS `uw_ops` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `uw_ops`;

-- uw_ops.ops_alert_config_es definition

CREATE TABLE `ops_alert_config_es` (
                                       `id` bigint NOT NULL COMMENT 'ID',
                                       `config_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '配置名',
                                       `es_host` varchar(200) DEFAULT NULL COMMENT 'es主机',
                                       `es_user` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'es用户',
                                       `es_pass` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'es密码',
                                       `es_index` varchar(200) DEFAULT NULL COMMENT 'es索引',
                                       `error_limit` bigint DEFAULT NULL COMMENT '错误限制',
                                       `warn_limit` bigint DEFAULT NULL COMMENT '警告限制',
                                       `all_limit` bigint DEFAULT NULL COMMENT '日志限制',
                                       `check_interval` bigint DEFAULT NULL COMMENT '检测间隔S',
                                       `create_date` datetime(3) DEFAULT NULL COMMENT '创建日期',
                                       `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                                       `last_check_date` datetime(3) DEFAULT NULL COMMENT '最近检测时间',
                                       `state` int DEFAULT NULL COMMENT '状态',
                                       PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='报警ES配置';


-- uw_ops.ops_alert_config_host definition

CREATE TABLE `ops_alert_config_host` (
                                         `id` bigint NOT NULL COMMENT 'ID',
                                         `config_name` varchar(200) DEFAULT NULL COMMENT '配置名',
                                         `mem_rate_limit` double DEFAULT NULL COMMENT '内存使用率限制',
                                         `load_limit` double DEFAULT NULL COMMENT '负载限制',
                                         `cpu_rate_limit` double DEFAULT NULL COMMENT 'cpu使用率限制',
                                         `disk_rate_limit` double DEFAULT NULL COMMENT '磁盘容量限制',
                                         `process_limit` int DEFAULT NULL COMMENT '进程数量限制',
                                         `thread_limit` int DEFAULT NULL COMMENT '线程数量限制',
                                         `conn_limit` int DEFAULT NULL COMMENT '连接数限制',
                                         `net_rx_limit` int DEFAULT NULL COMMENT '网络入口限制',
                                         `net_tx_limit` int DEFAULT NULL COMMENT '网络流程限制',
                                         `create_date` datetime(3) DEFAULT NULL COMMENT '创建日期',
                                         `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                                         `state` int DEFAULT NULL COMMENT '状态',
                                         PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='报警主机配置';


-- uw_ops.ops_alert_config_plan definition

CREATE TABLE `ops_alert_config_plan` (
                                         `id` bigint NOT NULL COMMENT 'id',
                                         `config_name` varchar(200) DEFAULT NULL COMMENT '配置名',
                                         `mem_rate_limit` double DEFAULT NULL COMMENT '内存使用率限制',
                                         `cpu_rate_limit` double DEFAULT NULL COMMENT 'CPU使用率限制',
                                         `process_limit` int DEFAULT NULL COMMENT '进程数量限制',
                                         `create_date` datetime(3) DEFAULT NULL COMMENT '创建日期',
                                         `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                                         `state` int DEFAULT NULL COMMENT '状态',
                                         PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='报警方案配置';


-- uw_ops.ops_alert_info definition

CREATE TABLE `ops_alert_info` (
                                  `id` bigint NOT NULL COMMENT 'id',
                                  `alert_object_type` varchar(20) DEFAULT NULL COMMENT '报警对象类型',
                                  `alert_object_id` bigint DEFAULT NULL COMMENT '报警对象id',
                                  `alert_title` varchar(200) DEFAULT NULL COMMENT '报警标题',
                                  `alert_body` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '报警信息',
                                  `create_date` datetime(3) DEFAULT NULL COMMENT '创建时间',
                                  `state` int DEFAULT NULL COMMENT '状态',
                                  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='报警信息';


-- uw_ops.ops_app_release definition

CREATE TABLE `ops_app_release` (
                                   `id` bigint NOT NULL COMMENT '主键ID',
                                   `app_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '应用名',
                                   `app_platform` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '应用平台',
                                   `app_version` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '应用版本',
                                   `release_file` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '全量安装包地址',
                                   `release_date` datetime(3) DEFAULT NULL COMMENT '发布时间',
                                   `release_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '应用发版信息',
                                   `force_update` int DEFAULT NULL COMMENT '1.强制更新 0普通更新',
                                   `create_date` datetime(3) DEFAULT NULL COMMENT '创建时间',
                                   `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                   `state` int DEFAULT NULL COMMENT '状态',
                                   PRIMARY KEY (`id`),
                                   KEY `ops_app_release_app_name_IDX` (`app_name`,`app_platform`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='app版本发布';


-- uw_ops.ops_app_release_log definition

CREATE TABLE `ops_app_release_log` (
                                       `id` bigint NOT NULL COMMENT '主键ID',
                                       `app_id` bigint DEFAULT NULL COMMENT 'APPID',
                                       `app_name` varchar(100) DEFAULT NULL COMMENT '应用名',
                                       `app_platform` varchar(100) DEFAULT NULL COMMENT '应用平台',
                                       `app_version` varchar(100) DEFAULT NULL COMMENT '应用版本',
                                       `release_file` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '全量安装包地址',
                                       `release_date` datetime(3) DEFAULT NULL COMMENT '发布时间',
                                       `release_info` varchar(100) DEFAULT NULL COMMENT '应用发版信息',
                                       `force_update` int DEFAULT NULL COMMENT '1.强制更新 0普通更新',
                                       `create_date` datetime(3) DEFAULT NULL COMMENT '创建时间',
                                       `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                       `state` int DEFAULT NULL COMMENT '状态',
                                       PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='app发布日志';


-- uw_ops.ops_deploy_plan definition

CREATE TABLE `ops_deploy_plan` (
                                   `id` bigint NOT NULL COMMENT 'ID',
                                   `deploy_profile` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '发布环境',
                                   `plan_name` varchar(200) DEFAULT NULL COMMENT '方案名称',
                                   `plan_desc` varchar(1000) DEFAULT NULL COMMENT '方案描述',
                                   `plan_remark` varchar(1000) DEFAULT NULL COMMENT '方案备注',
                                   `image_name` varchar(200) DEFAULT NULL COMMENT '镜像名',
                                   `image_version` varchar(100) DEFAULT NULL COMMENT '镜像版本',
                                   `cluster_id` bigint DEFAULT NULL COMMENT '集群ID',
                                   `plan_type` int DEFAULT NULL COMMENT '方案类型',
                                   `deploy_type` int DEFAULT NULL COMMENT '部署类型',
                                   `deploy_ports` varchar(500) DEFAULT NULL COMMENT '部署端口',
                                   `start_script` text COMMENT '启动脚本',
                                   `stop_script` text COMMENT '关闭脚本',
                                   `status_script` text COMMENT '状态脚本',
                                   `deploy_interval` int DEFAULT NULL COMMENT '部署间隔(S)',
                                   `check_cron` varchar(20) DEFAULT NULL COMMENT '检查cron',
                                   `container_num_min` int DEFAULT NULL COMMENT '容器初始数量',
                                   `container_num_max` int DEFAULT NULL COMMENT '容器最大数量',
                                   `container_mem` bigint DEFAULT NULL COMMENT '容器内存设置',
                                   `create_date` datetime(3) DEFAULT NULL COMMENT '创建时间',
                                   `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                   `plan_version` bigint DEFAULT NULL COMMENT '部署版本',
                                   `state` int DEFAULT NULL COMMENT '状态',
                                   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='部署方案';


-- uw_ops.ops_deploy_profile definition

CREATE TABLE `ops_deploy_profile` (
                                      `id` bigint NOT NULL COMMENT 'ID',
                                      `profile_code` varchar(100) DEFAULT NULL COMMENT '环境代码',
                                      `profile_name` varchar(200) DEFAULT NULL COMMENT '环境名称',
                                      `profile_env` text COMMENT '环境变量',
                                      `create_date` datetime(3) DEFAULT NULL COMMENT '创建日期',
                                      `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                                      `state` int DEFAULT NULL COMMENT '状态',
                                      PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='部署环境';


-- uw_ops.ops_deploy_script definition

CREATE TABLE `ops_deploy_script` (
                                     `id` bigint NOT NULL COMMENT 'ID',
                                     `script_type` int DEFAULT NULL COMMENT '脚本类型。后端、前端、mysql等',
                                     `script_name` varchar(200) DEFAULT NULL COMMENT '脚本名称',
                                     `script_desc` text COMMENT '脚本描述',
                                     `start_script` text COMMENT '启动脚本',
                                     `stop_script` text COMMENT '关闭脚本',
                                     `status_script` text COMMENT '状态脚本',
                                     `create_date` datetime(3) DEFAULT NULL COMMENT '创建日期',
                                     `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                                     `state` int DEFAULT NULL COMMENT '状态',
                                     PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='部署脚本模版';


-- uw_ops.ops_deploy_task definition

CREATE TABLE `ops_deploy_task` (
                                   `id` bigint NOT NULL COMMENT 'ID',
                                   `deploy_profile` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '发布环境',
                                   `plan_id` bigint DEFAULT NULL COMMENT '方案ID',
                                   `plan_version` bigint DEFAULT NULL COMMENT '部署版本',
                                   `instance_id` bigint DEFAULT NULL COMMENT '实例ID',
                                   `cluster_id` bigint DEFAULT NULL COMMENT '集群ID',
                                   `host_id` bigint DEFAULT NULL COMMENT '主机ID',
                                   `host_ip` varchar(100) DEFAULT NULL COMMENT '主机IP',
                                   `host_hash` varchar(100) DEFAULT NULL COMMENT '主机HASH',
                                   `task_type` int DEFAULT NULL COMMENT '任务类型',
                                   `task_ports` varchar(500) DEFAULT NULL COMMENT '任务端口',
                                   `task_remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '任务备注',
                                   `task_info` varchar(500) DEFAULT NULL COMMENT '任务信息',
                                   `task_script` text COMMENT '任务脚本',
                                   `task_result` text COMMENT '执行结果',
                                   `task_error` text COMMENT '错误信息',
                                   `create_date` datetime(3) DEFAULT NULL COMMENT '下发时间',
                                   `schedule_date` datetime(3) DEFAULT NULL COMMENT '计划时间',
                                   `execute_date` datetime(3) DEFAULT NULL COMMENT '执行时间',
                                   `finish_date` datetime(3) DEFAULT NULL COMMENT '结束时间',
                                   `state` int DEFAULT NULL COMMENT '状态',
                                   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='部署任务';


-- uw_ops.ops_deploy_task_history definition

CREATE TABLE `ops_deploy_task_history` (
                                           `id` bigint NOT NULL COMMENT 'ID',
                                           `deploy_profile` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '发布环境',
                                           `plan_id` bigint DEFAULT NULL COMMENT '方案ID',
                                           `plan_version` bigint DEFAULT NULL COMMENT '部署版本',
                                           `instance_id` bigint DEFAULT NULL COMMENT '实例ID',
                                           `cluster_id` bigint DEFAULT NULL COMMENT '集群ID',
                                           `host_id` bigint DEFAULT NULL COMMENT '主机ID',
                                           `host_ip` varchar(100) DEFAULT NULL COMMENT '主机IP',
                                           `host_hash` varchar(100) DEFAULT NULL COMMENT '主机HASH',
                                           `task_type` int DEFAULT NULL COMMENT '任务类型',
                                           `task_ports` varchar(500) DEFAULT NULL COMMENT '任务端口',
                                           `task_remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '任务备注',
                                           `task_info` varchar(500) DEFAULT NULL COMMENT '任务信息',
                                           `task_script` text COMMENT '任务脚本',
                                           `task_result` text COMMENT '执行结果',
                                           `task_error` text COMMENT '错误信息',
                                           `create_date` datetime(3) DEFAULT NULL COMMENT '下发时间',
                                           `schedule_date` datetime(3) DEFAULT NULL COMMENT '计划时间',
                                           `execute_date` datetime(3) DEFAULT NULL COMMENT '执行时间',
                                           `finish_date` datetime(3) DEFAULT NULL COMMENT '结束时间',
                                           `state` int DEFAULT NULL COMMENT '状态',
                                           PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='部署任务历史';


-- uw_ops.ops_host_cluster definition

CREATE TABLE `ops_host_cluster` (
                                    `id` bigint NOT NULL COMMENT 'id',
                                    `cluster_type` int DEFAULT NULL COMMENT '主机类型',
                                    `cluster_name` varchar(200) DEFAULT NULL COMMENT '集群名',
                                    `cluster_desc` text COMMENT '集群描述',
                                    `host_ids` text COMMENT '主机id列表',
                                    `create_date` datetime(3) DEFAULT NULL COMMENT '创建日期',
                                    `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                                    `state` int DEFAULT NULL,
                                    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='主机集群';


-- uw_ops.ops_host_info definition

CREATE TABLE `ops_host_info` (
                                 `id` bigint NOT NULL COMMENT 'ID',
                                 `host_type` int DEFAULT NULL COMMENT '主机类型',
                                 `host_hash` varchar(100) DEFAULT NULL COMMENT '主机HASH',
                                 `host_name` varchar(100) DEFAULT NULL COMMENT '主机名称',
                                 `host_label` varchar(100) DEFAULT NULL COMMENT '主机标识',
                                 `host_ip` varchar(50) DEFAULT NULL COMMENT '主机IP',
                                 `manufacturer` varchar(100) DEFAULT NULL COMMENT '设备制造商',
                                 `machine_model` varchar(100) DEFAULT NULL COMMENT '设备型号',
                                 `serial_number` varchar(100) DEFAULT NULL COMMENT '设备序列号',
                                 `agent_info` varchar(100) DEFAULT NULL COMMENT 'Agent信息',
                                 `os_info` varchar(100) DEFAULT NULL COMMENT '操作系统信息',
                                 `cpu_info` varchar(100) DEFAULT NULL COMMENT 'CPU信息',
                                 `mem_info` varchar(100) DEFAULT NULL COMMENT '内存信息',
                                 `disk_info` json DEFAULT NULL COMMENT '硬盘信息',
                                 `fs_info` json DEFAULT NULL COMMENT '文件系统信息',
                                 `network_info` json DEFAULT NULL COMMENT '网络信息',
                                 `report_interval` int DEFAULT NULL COMMENT '报告间隔(S)',
                                 `create_date` datetime(3) DEFAULT NULL COMMENT '注册时间',
                                 `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                 `audit_date` datetime(3) DEFAULT NULL COMMENT '验证时间',
                                 `last_update` datetime(3) DEFAULT NULL COMMENT '最后更新时间',
                                 `state` int DEFAULT NULL COMMENT '状态',
                                 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='主机信息';


-- uw_ops.ops_host_stats definition

CREATE TABLE `ops_host_stats` (
                                  `id` bigint NOT NULL COMMENT 'id',
                                  `host_id` bigint DEFAULT NULL COMMENT '主机id',
                                  `create_date` datetime(3) DEFAULT NULL COMMENT '创建日期',
                                  `cpu_cs` bigint DEFAULT NULL COMMENT 'cpu上下文切换数',
                                  `cpu_int` bigint DEFAULT NULL COMMENT 'cpu中断数',
                                  `cpu_user` double DEFAULT NULL COMMENT 'cpu用户使用率',
                                  `cpu_nice` double DEFAULT NULL COMMENT 'cpu优先使用率',
                                  `cpu_sys` double DEFAULT NULL COMMENT 'cpu系统使用率',
                                  `cpu_idle` double DEFAULT NULL COMMENT 'cpu空闲使用率',
                                  `cpu_iowait` double DEFAULT NULL COMMENT 'cpu io使用率',
                                  `cpu_hirq` double DEFAULT NULL COMMENT 'cpu硬irq使用率',
                                  `cpu_sirq` double DEFAULT NULL COMMENT 'cpu软irq使用率',
                                  `cpu_steal` double DEFAULT NULL COMMENT 'cpu等待使用率',
                                  `host_uptime` bigint DEFAULT NULL COMMENT '启动时间',
                                  `load_1m` double DEFAULT NULL COMMENT 'load1m',
                                  `load_5m` double DEFAULT NULL COMMENT 'load5m',
                                  `load_15m` double DEFAULT NULL COMMENT 'load15m',
                                  `host_power` bigint DEFAULT NULL COMMENT '主机功率',
                                  `process_count` int DEFAULT NULL COMMENT '进程数',
                                  `thread_count` int DEFAULT NULL COMMENT '线程数',
                                  `mem_total` bigint DEFAULT NULL COMMENT '内存总数',
                                  `mem_usable` bigint DEFAULT NULL COMMENT '内存可用',
                                  `swap_total` bigint DEFAULT NULL COMMENT 'swap总数',
                                  `swap_used` bigint DEFAULT NULL COMMENT 'swap已用',
                                  `memv_max` bigint DEFAULT NULL COMMENT '虚拟内存总数',
                                  `memv_used` bigint DEFAULT NULL COMMENT '虚拟内存已用',
                                  `disk_reads` bigint DEFAULT NULL COMMENT '磁盘读次数',
                                  `disk_read_bytes` bigint DEFAULT NULL COMMENT '磁盘读字节数',
                                  `disk_writes` bigint DEFAULT NULL COMMENT '磁盘写次数',
                                  `disk_write_bytes` bigint DEFAULT NULL COMMENT '磁盘写字节数',
                                  `disk_io_millis` bigint DEFAULT NULL COMMENT '磁盘io毫秒数',
                                  `disk_io_queue` bigint DEFAULT NULL COMMENT '磁盘io队列数',
                                  `net_established` int DEFAULT NULL COMMENT '已连接数',
                                  `net_time_wait` int DEFAULT NULL COMMENT '我方关闭连接数',
                                  `net_close_wait` int DEFAULT NULL COMMENT '对方关闭连接数',
                                  `net_syn_recv` int DEFAULT NULL COMMENT '收到请求连接数',
                                  `net_syn_sent` int DEFAULT NULL COMMENT '发出请求连接数',
                                  `net1_tx_rate` bigint DEFAULT NULL COMMENT '网络1发送速率',
                                  `net1_rx_rate` bigint DEFAULT NULL COMMENT '网络1接收速率',
                                  `net2_tx_rate` bigint DEFAULT NULL COMMENT '网络2发送速率',
                                  `net2_rx_rate` bigint DEFAULT NULL COMMENT '网络2接收速率',
                                  `fs1_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'fs1名称',
                                  `fs1_total` bigint DEFAULT NULL COMMENT 'fs1容量',
                                  `fs1_usable` bigint DEFAULT NULL COMMENT 'fs1可用',
                                  `fs2_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'fs2名称',
                                  `fs2_total` bigint DEFAULT NULL COMMENT 'fs2容量',
                                  `fs2_usable` bigint DEFAULT NULL COMMENT 'fs2可用',
                                  `fs3_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'fs3名称',
                                  `fs3_total` bigint DEFAULT NULL COMMENT 'fs3容量',
                                  `fs3_usable` bigint DEFAULT NULL COMMENT 'fs3可用',
                                  `fs4_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'fs4名称',
                                  `fs4_total` bigint DEFAULT NULL COMMENT 'fs4容量',
                                  `fs4_usable` bigint DEFAULT NULL COMMENT 'fs4可用',
                                  `fs5_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'fs5名称',
                                  `fs5_total` bigint DEFAULT NULL COMMENT 'fs5容量',
                                  `fs5_usable` bigint DEFAULT NULL COMMENT 'fs5可用',
                                  `fs6_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'fs6名称',
                                  `fs6_total` bigint DEFAULT NULL COMMENT 'fs6容量',
                                  `fs6_usable` bigint DEFAULT NULL COMMENT 'fs6可用',
                                  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='主机性能统计';


-- uw_ops.ops_instance_info definition

CREATE TABLE `ops_instance_info` (
                                     `id` bigint NOT NULL COMMENT 'ID',
                                     `deploy_profile` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '发布环境',
                                     `plan_id` bigint DEFAULT NULL COMMENT '计划ID',
                                     `cluster_id` bigint DEFAULT NULL COMMENT '集群ID',
                                     `host_id` bigint DEFAULT NULL COMMENT '主机ID',
                                     `host_ip` varchar(100) DEFAULT NULL COMMENT '应用主机',
                                     `container_hash` varchar(200) DEFAULT NULL COMMENT '容器HASH',
                                     `image_name` varchar(100) DEFAULT NULL COMMENT '镜像名',
                                     `image_version` varchar(100) DEFAULT NULL COMMENT '镜像版本',
                                     `start_script` text COMMENT '启动脚本',
                                     `stop_script` text COMMENT '关闭脚本',
                                     `status_script` text COMMENT '状态脚本',
                                     `container_mem` bigint DEFAULT NULL COMMENT '应用内存',
                                     `container_image` varchar(200) DEFAULT NULL COMMENT '容器镜像',
                                     `container_name` varchar(100) DEFAULT NULL COMMENT '容器名',
                                     `container_command` varchar(200) DEFAULT NULL COMMENT '进程指令',
                                     `container_network` varchar(100) DEFAULT NULL COMMENT '容器网络',
                                     `container_ports` varchar(500) DEFAULT NULL COMMENT '容器端口',
                                     `container_state` varchar(100) DEFAULT NULL COMMENT '容器状态',
                                     `container_status` varchar(100) DEFAULT NULL COMMENT '运行状态',
                                     `create_date` datetime(3) DEFAULT NULL COMMENT '创建时间',
                                     `start_version` bigint DEFAULT NULL COMMENT 'start部署版本',
                                     `start_remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '启动备注',
                                     `start_date` datetime(3) DEFAULT NULL COMMENT '启动时间',
                                     `stop_version` bigint DEFAULT NULL COMMENT 'stop部署版本',
                                     `stop_remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '关闭备注',
                                     `stop_date` datetime(3) DEFAULT NULL COMMENT '关闭时间',
                                     `last_update` datetime(3) DEFAULT NULL COMMENT '最后更新时间',
                                     `state` int DEFAULT NULL COMMENT '状态',
                                     PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='实例信息';


-- uw_ops.ops_instance_stats definition

CREATE TABLE `ops_instance_stats` (
                                      `id` bigint NOT NULL COMMENT 'id',
                                      `plan_id` bigint DEFAULT NULL COMMENT '计划id',
                                      `container_id` bigint DEFAULT NULL COMMENT '容器id',
                                      `container_hash` varchar(100) DEFAULT NULL COMMENT '容器hash',
                                      `cpu_load` double DEFAULT NULL COMMENT 'cpu负载',
                                      `mem_load` double DEFAULT NULL COMMENT '内存使用率',
                                      `mem_limit` bigint DEFAULT NULL COMMENT '内存限制',
                                      `net_rx` bigint DEFAULT NULL COMMENT '网络流入速率',
                                      `net_tx` bigint DEFAULT NULL COMMENT '网络发送速率',
                                      `disk_write` bigint DEFAULT NULL COMMENT '磁盘写信息',
                                      `disk_read` bigint DEFAULT NULL COMMENT '磁盘读信息',
                                      `pid_count` int DEFAULT NULL COMMENT '线程数',
                                      `create_date` datetime(3) DEFAULT NULL COMMENT '建立日期',
                                      PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='容器运行统计';


-- uw_ops.ops_nft_auth definition

CREATE TABLE `ops_nft_auth` (
                                `id` bigint NOT NULL COMMENT 'id',
                                `host_type` int DEFAULT NULL COMMENT '主机类型',
                                `host_id` bigint NOT NULL COMMENT '主机ID',
                                `host_info` varchar(1000) DEFAULT NULL COMMENT '主机信息',
                                `apply_ports` varchar(500) DEFAULT NULL COMMENT '申请的端口号',
                                `valid_seconds` int NOT NULL COMMENT '有效期(秒)',
                                `apply_user_id` bigint NOT NULL COMMENT '申请人ID',
                                `apply_user_ip` varchar(50) DEFAULT NULL COMMENT '申请人IP',
                                `apply_user_name` varchar(255) DEFAULT NULL COMMENT '申请人用户名',
                                `apply_remark` varchar(255) DEFAULT NULL COMMENT '申请备注',
                                `apply_date` datetime(3) DEFAULT NULL COMMENT '请求时间',
                                `audit_user_id` bigint DEFAULT NULL COMMENT '审批人ID',
                                `audit_user_ip` varchar(50) DEFAULT NULL COMMENT '审批用户IP',
                                `audit_user_name` varchar(255) DEFAULT NULL COMMENT '审批人用户名',
                                `audit_remark` varchar(255) DEFAULT NULL COMMENT '审批备注',
                                `audit_date` datetime(3) DEFAULT NULL COMMENT '审批时间',
                                `expire_date` datetime(3) DEFAULT NULL COMMENT '过期时间',
                                `open_task_id` bigint DEFAULT NULL COMMENT '授权开启任务ID',
                                `open_task_date` datetime(3) DEFAULT NULL COMMENT '授权开启任务时间',
                                `close_task_id` bigint DEFAULT NULL COMMENT '授权关闭任务ID',
                                `close_task_date` datetime(3) DEFAULT NULL COMMENT '任务结束时间',
                                `state` int NOT NULL COMMENT '状态',
                                PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='NFT授权';


-- uw_ops.sys_crit_log definition

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


-- uw_ops.sys_data_history definition

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


-- uw_ops.sys_seq definition

CREATE TABLE `sys_seq` (
                           `seq_name` varchar(200) NOT NULL COMMENT '序列名',
                           `seq_id` bigint DEFAULT NULL COMMENT '当前序列id',
                           `seq_desc` varchar(200) DEFAULT NULL COMMENT '序列描述',
                           `increment_num` int DEFAULT NULL COMMENT '每次递增大小',
                           `create_date` datetime(3) DEFAULT NULL COMMENT '建立日期',
                           `last_update` datetime(3) DEFAULT NULL COMMENT '最后更新日期',
                           PRIMARY KEY (`seq_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='SYS序列';

--
-- Dumping data
--
INSERT INTO `ops_deploy_profile` VALUES (1,'dev','开发环境','NACOS_SERVER=#{NACOS_SERVER}\nNACOS_USERNAME=#{NACOS_USERNAME}\nNACOS_PASSWORD=#{NACOS_PASSWORD}\nNACOS_NAMESPACE=dev\nLOG_ES_SERVER=#{LOG_ES_SERVER}\nLOG_ES_USERNAME=#{LOG_ES_USERNAME}\nLOG_ES_PASSWORD=#{LOG_ES_PASSWORD}\nREGISTRY_SERVER=#{REGISTRY_SERVER}','2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',1),
(2,'debug','调试环境','NACOS_SERVER=#{NACOS_SERVER}\nNACOS_USERNAME=#{NACOS_USERNAME}\nNACOS_PASSWORD=#{NACOS_PASSWORD}\nNACOS_NAMESPACE=debug\nLOG_ES_SERVER=#{LOG_ES_SERVER}\nLOG_ES_USERNAME=#{LOG_ES_USERNAME}\nLOG_ES_PASSWORD=#{LOG_ES_PASSWORD}\nREGISTRY_SERVER=#{REGISTRY_SERVER}','2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',1),
(3,'test','测试环境','NACOS_SERVER=#{NACOS_SERVER}\nNACOS_USERNAME=#{NACOS_USERNAME}\nNACOS_PASSWORD=#{NACOS_PASSWORD}\nNACOS_NAMESPACE=test\nLOG_ES_SERVER=#{LOG_ES_SERVER}\nLOG_ES_USERNAME=#{LOG_ES_USERNAME}\nLOG_ES_PASSWORD=#{LOG_ES_PASSWORD}\nREGISTRY_SERVER=#{REGISTRY_SERVER}','2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',1),
(5,'stag','预上线环境','NACOS_SERVER=#{NACOS_SERVER}\nNACOS_USERNAME=#{NACOS_USERNAME}\nNACOS_PASSWORD=#{NACOS_PASSWORD}\nNACOS_NAMESPACE=stag\nLOG_ES_SERVER=#{LOG_ES_SERVER}\nLOG_ES_USERNAME=#{LOG_ES_USERNAME}\nLOG_ES_PASSWORD=#{LOG_ES_PASSWORD}\nREGISTRY_SERVER=#{REGISTRY_SERVER}','2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',1),
(6,'prod','生产环境','NACOS_SERVER=#{NACOS_SERVER}\nNACOS_USERNAME=#{NACOS_USERNAME}\nNACOS_PASSWORD=#{NACOS_PASSWORD}\nNACOS_NAMESPACE=prod\nLOG_ES_SERVER=#{LOG_ES_SERVER}\nLOG_ES_USERNAME=#{LOG_ES_USERNAME}\nLOG_ES_PASSWORD=#{LOG_ES_PASSWORD}\nREGISTRY_SERVER=#{REGISTRY_SERVER}','2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',1),
(8,'stab','稳定环境','NACOS_SERVER=#{NACOS_SERVER}\nNACOS_USERNAME=#{NACOS_USERNAME}\nNACOS_PASSWORD=#{NACOS_PASSWORD}\nNACOS_NAMESPACE=stab\nLOG_ES_SERVER=#{LOG_ES_SERVER}\nLOG_ES_USERNAME=#{LOG_ES_USERNAME}\nLOG_ES_PASSWORD=#{LOG_ES_PASSWORD}\nREGISTRY_SERVER=#{REGISTRY_SERVER}','2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',1);

INSERT INTO `ops_deploy_script` VALUES (1,3,'UI启动脚本','UI启动脚本','#!/bin/bash\ndocker stop ${APP_NAME}-${APP_PORT}\ndocker rm ${APP_NAME}-${APP_PORT}\ndocker run -d \\\n-m ${APP_MEM}m \\\n-e APP_NAME=${APP_NAME} \\\n-e APP_HOST=${APP_HOST} \\\n-e APP_PORT=${APP_PORT} \\\n-e NACOS_SERVER=${NACOS_SERVER} \\\n-e NACOS_USERNAME=${NACOS_USERNAME} \\\n-e NACOS_PASSWORD=${NACOS_PASSWORD} \\\n-e NACOS_NAMESPACE=${NACOS_NAMESPACE} \\\n-e TZ=$(cat /etc/timezone) \\\n-v /etc/localtime:/etc/localtime:ro \\\n-v /etc/timezone:/etc/timezone:ro \\\n--net=host \\\n--restart=unless-stopped \\\n--name=${APP_NAME}-${APP_PORT} \\\n${REGISTRY_SERVER}/${APP_NAME}:${APP_VERSION}','docker stop ${CONTAINER_HASH}',NULL,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',1),
(2,3,'APP启动脚本','APP启动脚本','#!/bin/bash\ndocker stop ${APP_NAME}-${APP_PORT}\ndocker rm ${APP_NAME}-${APP_PORT}\ndocker run -d \\\n-m ${APP_MEM}m \\\n-e JAVA_OPTS=\"-XX:+UseShenandoahGC -XX:+UseContainerSupport -XX:MaxRAMPercentage=80.0\" \\\n-e SPRING_OPTS=\"--app.info=${APP_NAME}:${APP_VERSION} --spring.profiles.active=${NACOS_NAMESPACE} --server.port=${APP_PORT}\" \\\n-e APP_HOST=${APP_HOST} \\\n-e APP_PORT=${APP_PORT} \\\n-e NACOS_SERVER=${NACOS_SERVER} \\\n-e NACOS_USERNAME=${NACOS_USERNAME} \\\n-e NACOS_PASSWORD=${NACOS_PASSWORD} \\\n-e NACOS_NAMESPACE=${NACOS_NAMESPACE} \\\n-e LOG_ES_SERVER=${LOG_ES_SERVER} \\\n-e LOG_ES_USERNAME=${LOG_ES_USERNAME} \\\n-e LOG_ES_PASSWORD=${LOG_ES_PASSWORD} \\\n-e TZ=$(cat /etc/timezone) \\\n-v /etc/localtime:/etc/localtime:ro \\\n-v /etc/timezone:/etc/timezone:ro \\\n--net=host \\\n--restart=unless-stopped \\\n--name=${APP_NAME}-${APP_PORT} \\\n${REGISTRY_SERVER}/${APP_NAME}:${APP_VERSION}','docker stop ${CONTAINER_HASH}','','2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',1);

INSERT INTO `ops_deploy_plan` VALUES (-1,'#{NACOS_NAMESPACE}','docker镜像定期清理','docker镜像定期清理，每天凌晨3点执行。','','','',0,1,102,'',' docker system prune -f',NULL,NULL,0,'0 0 3 * * ?',0,0,0,'2023-11-17 11:57:01.290',NULL,1710702000108,1),
(0,'#{NACOS_NAMESPACE}','升级OPS-AGENT','升级OPS-AGENT，建议手动执行。','',NULL,NULL,0,1,102,'','curl -s #{GATEWAY_SERVER}/uw-ops-center/agent/installer/install|bash',NULL,NULL,0,NULL,0,0,0,'2023-11-17 11:13:36.697','2024-01-30 21:45:39.691',1706622456182,1),
(1,'#{NACOS_NAMESPACE}','uw-auth-center部署方案','uw-auth-center部署方案','','uw-auth-center','6.1.0',0,3,103,'APP_PORT=10000','#!/bin/bash\ndocker stop ${APP_NAME}-${APP_PORT}\ndocker rm ${APP_NAME}-${APP_PORT}\ndocker run -d \\\n-m ${APP_MEM}m \\\n-e JAVA_OPTS=\"-XX:+UseShenandoahGC -XX:+UseContainerSupport -XX:MaxRAMPercentage=80.0\" \\\n-e SPRING_OPTS=\"--app.info=${APP_NAME}:${APP_VERSION} --spring.profiles.active=${NACOS_NAMESPACE} --server.port=${APP_PORT}\" \\\n-e APP_HOST=${APP_HOST} \\\n-e APP_PORT=${APP_PORT} \\\n-e NACOS_SERVER=${NACOS_SERVER} \\\n-e NACOS_USERNAME=${NACOS_USERNAME} \\\n-e NACOS_PASSWORD=${NACOS_PASSWORD} \\\n-e NACOS_NAMESPACE=${NACOS_NAMESPACE} \\\n-e LOG_ES_SERVER=${LOG_ES_SERVER} \\\n-e LOG_ES_USERNAME=${LOG_ES_USERNAME} \\\n-e LOG_ES_PASSWORD=${LOG_ES_PASSWORD} \\\n-e TZ=$(cat /etc/timezone) \\\n-v /etc/localtime:/etc/localtime:ro \\\n-v /etc/timezone:/etc/timezone:ro \\\n--net=host \\\n--restart=unless-stopped \\\n--name=${APP_NAME}-${APP_PORT} \\\n${REGISTRY_SERVER}/${APP_NAME}:${APP_VERSION}','docker stop ${CONTAINER_HASH}',NULL,30,NULL,2,2,1000,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',0,1),
(2,'#{NACOS_NAMESPACE}','uw-task-center部署方案','uw-task-center部署方案','','uw-task-center','5.1.0',0,3,103,'APP_PORT=10010','#!/bin/bash\ndocker stop ${APP_NAME}-${APP_PORT}\ndocker rm ${APP_NAME}-${APP_PORT}\ndocker run -d \\\n-m ${APP_MEM}m \\\n-e JAVA_OPTS=\"-XX:+UseShenandoahGC -XX:+UseContainerSupport -XX:MaxRAMPercentage=80.0\" \\\n-e SPRING_OPTS=\"--app.info=${APP_NAME}:${APP_VERSION} --spring.profiles.active=${NACOS_NAMESPACE} --server.port=${APP_PORT}\" \\\n-e APP_HOST=${APP_HOST} \\\n-e APP_PORT=${APP_PORT} \\\n-e NACOS_SERVER=${NACOS_SERVER} \\\n-e NACOS_USERNAME=${NACOS_USERNAME} \\\n-e NACOS_PASSWORD=${NACOS_PASSWORD} \\\n-e NACOS_NAMESPACE=${NACOS_NAMESPACE} \\\n-e LOG_ES_SERVER=${LOG_ES_SERVER} \\\n-e LOG_ES_USERNAME=${LOG_ES_USERNAME} \\\n-e LOG_ES_PASSWORD=${LOG_ES_PASSWORD} \\\n-e TZ=$(cat /etc/timezone) \\\n-v /etc/localtime:/etc/localtime:ro \\\n-v /etc/timezone:/etc/timezone:ro \\\n--net=host \\\n--restart=unless-stopped \\\n--name=${APP_NAME}-${APP_PORT} \\\n${REGISTRY_SERVER}/${APP_NAME}:${APP_VERSION}','docker stop ${CONTAINER_HASH}',NULL,30,NULL,2,2,1000,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',0,1),
(3,'#{NACOS_NAMESPACE}','uw-ops-center部署方案','uw-ops-center部署方案','','uw-ops-center','1.1.0',0,3,103,'APP_PORT=1000','#!/bin/bash\ndocker stop ${APP_NAME}-${APP_PORT}\ndocker rm ${APP_NAME}-${APP_PORT}\ndocker run -d \\\n-m ${APP_MEM}m \\\n-e JAVA_OPTS=\"-XX:+UseShenandoahGC -XX:+UseContainerSupport -XX:MaxRAMPercentage=80.0\" \\\n-e SPRING_OPTS=\"--app.info=${APP_NAME}:${APP_VERSION} --spring.profiles.active=${NACOS_NAMESPACE} --server.port=${APP_PORT}\" \\\n-e APP_HOST=${APP_HOST} \\\n-e APP_PORT=${APP_PORT} \\\n-e NACOS_SERVER=${NACOS_SERVER} \\\n-e NACOS_USERNAME=${NACOS_USERNAME} \\\n-e NACOS_PASSWORD=${NACOS_PASSWORD} \\\n-e NACOS_NAMESPACE=${NACOS_NAMESPACE} \\\n-e LOG_ES_SERVER=${LOG_ES_SERVER} \\\n-e LOG_ES_USERNAME=${LOG_ES_USERNAME} \\\n-e LOG_ES_PASSWORD=${LOG_ES_PASSWORD} \\\n-e TZ=$(cat /etc/timezone) \\\n-v /etc/localtime:/etc/localtime:ro \\\n-v /etc/timezone:/etc/timezone:ro \\\n--net=host \\\n--restart=unless-stopped \\\n--name=${APP_NAME}-${APP_PORT} \\\n${REGISTRY_SERVER}/${APP_NAME}:${APP_VERSION}','docker stop ${CONTAINER_HASH}',NULL,30,NULL,2,6,1000,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',0,1),
(5,'#{NACOS_NAMESPACE}','uw-mydb-center部署方案','uw-mydb-center部署方案','','uw-mydb-center','1.0.0',0,3,103,'APP_PORT=10020','#!/bin/bash\ndocker stop ${APP_NAME}-${APP_PORT}\ndocker rm ${APP_NAME}-${APP_PORT}\ndocker run -d \\\n-m ${APP_MEM}m \\\n-e JAVA_OPTS=\"-XX:+UseShenandoahGC -XX:+UseContainerSupport -XX:MaxRAMPercentage=80.0\" \\\n-e SPRING_OPTS=\"--app.info=${APP_NAME}:${APP_VERSION} --spring.profiles.active=${NACOS_NAMESPACE} --server.port=${APP_PORT}\" \\\n-e APP_HOST=${APP_HOST} \\\n-e APP_PORT=${APP_PORT} \\\n-e NACOS_SERVER=${NACOS_SERVER} \\\n-e NACOS_USERNAME=${NACOS_USERNAME} \\\n-e NACOS_PASSWORD=${NACOS_PASSWORD} \\\n-e NACOS_NAMESPACE=${NACOS_NAMESPACE} \\\n-e LOG_ES_SERVER=${LOG_ES_SERVER} \\\n-e LOG_ES_USERNAME=${LOG_ES_USERNAME} \\\n-e LOG_ES_PASSWORD=${LOG_ES_PASSWORD} \\\n-e TZ=$(cat /etc/timezone) \\\n-v /etc/localtime:/etc/localtime:ro \\\n-v /etc/timezone:/etc/timezone:ro \\\n--net=host \\\n--restart=unless-stopped \\\n--name=${APP_NAME}-${APP_PORT} \\\n${REGISTRY_SERVER}/${APP_NAME}:${APP_VERSION}','docker stop ${CONTAINER_HASH}',NULL,30,NULL,2,6,1000,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',0,1),
(6,'#{NACOS_NAMESPACE}','uw-mydb-proxy部署方案','uw-mydb-proxy部署方案','','uw-mydb-proxy','1.0.0',0,3,103,'APP_PORT=3300','#!/bin/bash\ndocker stop ${APP_NAME}-${APP_PORT}\ndocker rm ${APP_NAME}-${APP_PORT}\ndocker run -d \\\n-m ${APP_MEM}m \\\n-e JAVA_OPTS=\"-XX:+UseShenandoahGC -XX:+UseContainerSupport -XX:MaxRAMPercentage=80.0\" \\\n-e SPRING_OPTS=\"--app.info=${APP_NAME}:${APP_VERSION} --spring.profiles.active=${NACOS_NAMESPACE} --server.port=${APP_PORT}\" \\\n-e APP_HOST=${APP_HOST} \\\n-e APP_PORT=${APP_PORT} \\\n-e NACOS_SERVER=${NACOS_SERVER} \\\n-e NACOS_USERNAME=${NACOS_USERNAME} \\\n-e NACOS_PASSWORD=${NACOS_PASSWORD} \\\n-e NACOS_NAMESPACE=${NACOS_NAMESPACE} \\\n-e LOG_ES_SERVER=${LOG_ES_SERVER} \\\n-e LOG_ES_USERNAME=${LOG_ES_USERNAME} \\\n-e LOG_ES_PASSWORD=${LOG_ES_PASSWORD} \\\n-e TZ=$(cat /etc/timezone) \\\n-v /etc/localtime:/etc/localtime:ro \\\n-v /etc/timezone:/etc/timezone:ro \\\n--net=host \\\n--restart=unless-stopped \\\n--name=${APP_NAME}-${APP_PORT} \\\n${REGISTRY_SERVER}/${APP_NAME}:${APP_VERSION}','docker stop ${CONTAINER_HASH}',NULL,30,NULL,2,6,1000,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',0,1),
(7,'#{NACOS_NAMESPACE}','uw-lms-center部署方案','uw-lms-center部署方案','','uw-lms-center','2.1.0',0,3,103,'APP_PORT=666','#!/bin/bash\ndocker stop ${APP_NAME}-${APP_PORT}\ndocker rm ${APP_NAME}-${APP_PORT}\ndocker run -d \\\n-m ${APP_MEM}m \\\n-e JAVA_OPTS=\"-XX:+UseShenandoahGC -XX:+UseContainerSupport -XX:MaxRAMPercentage=80.0\" \\\n-e SPRING_OPTS=\"--app.info=${APP_NAME}:${APP_VERSION} --spring.profiles.active=${NACOS_NAMESPACE} --server.port=${APP_PORT}\" \\\n-e APP_HOST=${APP_HOST} \\\n-e APP_PORT=${APP_PORT} \\\n-e NACOS_SERVER=${NACOS_SERVER} \\\n-e NACOS_USERNAME=${NACOS_USERNAME} \\\n-e NACOS_PASSWORD=${NACOS_PASSWORD} \\\n-e NACOS_NAMESPACE=${NACOS_NAMESPACE} \\\n-e LOG_ES_SERVER=${LOG_ES_SERVER} \\\n-e LOG_ES_USERNAME=${LOG_ES_USERNAME} \\\n-e LOG_ES_PASSWORD=${LOG_ES_PASSWORD} \\\n-e TZ=$(cat /etc/timezone) \\\n-v /etc/localtime:/etc/localtime:ro \\\n-v /etc/timezone:/etc/timezone:ro \\\n--net=host \\\n--restart=unless-stopped \\\n--name=${APP_NAME}-${APP_PORT} \\\n${REGISTRY_SERVER}/${APP_NAME}:${APP_VERSION}','docker stop ${CONTAINER_HASH}',NULL,30,NULL,2,6,1000,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',0,1),
(8,'#{NACOS_NAMESPACE}','uw-gateway-center部署方案','uw-gateway-center部署方案','','uw-gateway-center','1.0.0',0,3,103,'APP_PORT=10030','#!/bin/bash\ndocker stop ${APP_NAME}-${APP_PORT}\ndocker rm ${APP_NAME}-${APP_PORT}\ndocker run -d \\\n-m ${APP_MEM}m \\\n-e JAVA_OPTS=\"-XX:+UseShenandoahGC -XX:+UseContainerSupport -XX:MaxRAMPercentage=80.0\" \\\n-e SPRING_OPTS=\"--app.info=${APP_NAME}:${APP_VERSION} --spring.profiles.active=${NACOS_NAMESPACE} --server.port=${APP_PORT}\" \\\n-e APP_HOST=${APP_HOST} \\\n-e APP_PORT=${APP_PORT} \\\n-e NACOS_SERVER=${NACOS_SERVER} \\\n-e NACOS_USERNAME=${NACOS_USERNAME} \\\n-e NACOS_PASSWORD=${NACOS_PASSWORD} \\\n-e NACOS_NAMESPACE=${NACOS_NAMESPACE} \\\n-e LOG_ES_SERVER=${LOG_ES_SERVER} \\\n-e LOG_ES_USERNAME=${LOG_ES_USERNAME} \\\n-e LOG_ES_PASSWORD=${LOG_ES_PASSWORD} \\\n-e TZ=$(cat /etc/timezone) \\\n-v /etc/localtime:/etc/localtime:ro \\\n-v /etc/timezone:/etc/timezone:ro \\\n--net=host \\\n--restart=unless-stopped \\\n--name=${APP_NAME}-${APP_PORT} \\\n${REGISTRY_SERVER}/${APP_NAME}:${APP_VERSION}','docker stop ${CONTAINER_HASH}',NULL,30,NULL,2,6,1000,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',0,1),
(9,'#{NACOS_NAMESPACE}','uw-gateway部署方案','uw-gateway部署方案','','uw-gateway','1.1.0',0,3,102,'','#!/bin/bash\ndocker stop ${APP_NAME}-80\ndocker rm ${APP_NAME}-80\ndocker run -d \\\n-m ${APP_MEM}m \\\n-e JAVA_OPTS=\"-XX:+UseShenandoahGC -XX:+UseContainerSupport -XX:MaxRAMPercentage=80.0\" \\\n-e SPRING_OPTS=\"--app.info=${APP_NAME}:${APP_VERSION} --spring.profiles.active=${NACOS_NAMESPACE} --server.port=80\" \\\n-e APP_HOST=${APP_HOST} \\\n-e APP_PORT=80 \\\n-e NACOS_SERVER=${NACOS_SERVER} \\\n-e NACOS_USERNAME=${NACOS_USERNAME} \\\n-e NACOS_PASSWORD=${NACOS_PASSWORD} \\\n-e NACOS_NAMESPACE=${NACOS_NAMESPACE} \\\n-e LOG_ES_SERVER=${LOG_ES_SERVER} \\\n-e LOG_ES_USERNAME=${LOG_ES_USERNAME} \\\n-e LOG_ES_PASSWORD=${LOG_ES_PASSWORD} \\\n-e TZ=$(cat /etc/timezone) \\\n-v /etc/localtime:/etc/localtime:ro \\\n-v /etc/timezone:/etc/timezone:ro \\\n--net=host \\\n--restart=unless-stopped \\\n--name=${APP_NAME}-80 \\\n${REGISTRY_SERVER}/${APP_NAME}:${APP_VERSION}','',NULL,30,NULL,2,6,1000,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',0,1),
(10,'#{NACOS_NAMESPACE}','uw-gateway-ssl部署方案','uw-gateway-ssl部署方案','','uw-gateway','1.1.0',0,3,102,'','#!/bin/bash\ndocker stop ${APP_NAME}-443\ndocker rm ${APP_NAME}-443\ndocker run -d \\\n-m ${APP_MEM}m \\\n-e JAVA_OPTS=\"-XX:+UseShenandoahGC -XX:+UseContainerSupport -XX:MaxRAMPercentage=80.0\" \\\n-e SPRING_OPTS=\"--app.info=${APP_NAME}:${APP_VERSION} --spring.profiles.active=${NACOS_NAMESPACE} --spring.application.name=${APP_NAME}-ssl  --server.port=443\" \\\n-e APP_HOST=${APP_HOST} \\\n-e APP_PORT=443 \\\n-e NACOS_SERVER=${NACOS_SERVER} \\\n-e NACOS_USERNAME=${NACOS_USERNAME} \\\n-e NACOS_PASSWORD=${NACOS_PASSWORD} \\\n-e NACOS_NAMESPACE=${NACOS_NAMESPACE} \\\n-e LOG_ES_SERVER=${LOG_ES_SERVER} \\\n-e LOG_ES_USERNAME=${LOG_ES_USERNAME} \\\n-e LOG_ES_PASSWORD=${LOG_ES_PASSWORD} \\\n-e TZ=$(cat /etc/timezone) \\\n-v /etc/localtime:/etc/localtime:ro \\\n-v /etc/timezone:/etc/timezone:ro \\\n--net=host \\\n--restart=unless-stopped \\\n--name=${APP_NAME}-443 \\\n${REGISTRY_SERVER}/${APP_NAME}:${APP_VERSION}','',NULL,30,NULL,2,6,1000,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',0,1),
(11,'#{NACOS_NAMESPACE}','uw-notify-center部署方案','uw-notify-center部署方案','','uw-notify-center','1.0.0',0,3,103,'APP_PORT=10070','#!/bin/bash\ndocker stop ${APP_NAME}-${APP_PORT}\ndocker rm ${APP_NAME}-${APP_PORT}\ndocker run -d \\\n-m ${APP_MEM}m \\\n-e JAVA_OPTS=\"-XX:+UseShenandoahGC -XX:+UseContainerSupport -XX:MaxRAMPercentage=80.0\" \\\n-e SPRING_OPTS=\"--app.info=${APP_NAME}:${APP_VERSION} --spring.profiles.active=${NACOS_NAMESPACE} --server.port=${APP_PORT}\" \\\n-e APP_HOST=${APP_HOST} \\\n-e APP_PORT=${APP_PORT} \\\n-e NACOS_SERVER=${NACOS_SERVER} \\\n-e NACOS_USERNAME=${NACOS_USERNAME} \\\n-e NACOS_PASSWORD=${NACOS_PASSWORD} \\\n-e NACOS_NAMESPACE=${NACOS_NAMESPACE} \\\n-e LOG_ES_SERVER=${LOG_ES_SERVER} \\\n-e LOG_ES_USERNAME=${LOG_ES_USERNAME} \\\n-e LOG_ES_PASSWORD=${LOG_ES_PASSWORD} \\\n-e TZ=$(cat /etc/timezone) \\\n-v /etc/localtime:/etc/localtime:ro \\\n-v /etc/timezone:/etc/timezone:ro \\\n--net=host \\\n--restart=unless-stopped \\\n--name=${APP_NAME}-${APP_PORT} \\\n${REGISTRY_SERVER}/${APP_NAME}:${APP_VERSION}','docker stop ${CONTAINER_HASH}',NULL,30,NULL,2,6,1000,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',0,1),
(12,'#{NACOS_NAMESPACE}','uw-tinyurl-center部署方案','uw-tinyurl-center部署方案','','uw-tinyurl-center','1.0.0',0,3,103,'APP_PORT=10060','#!/bin/bash\ndocker stop ${APP_NAME}-${APP_PORT}\ndocker rm ${APP_NAME}-${APP_PORT}\ndocker run -d \\\n-m ${APP_MEM}m \\\n-e JAVA_OPTS=\"-XX:+UseShenandoahGC -XX:+UseContainerSupport -XX:MaxRAMPercentage=80.0\" \\\n-e SPRING_OPTS=\"--app.info=${APP_NAME}:${APP_VERSION} --spring.profiles.active=${NACOS_NAMESPACE} --server.port=${APP_PORT}\" \\\n-e APP_HOST=${APP_HOST} \\\n-e APP_PORT=${APP_PORT} \\\n-e NACOS_SERVER=${NACOS_SERVER} \\\n-e NACOS_USERNAME=${NACOS_USERNAME} \\\n-e NACOS_PASSWORD=${NACOS_PASSWORD} \\\n-e NACOS_NAMESPACE=${NACOS_NAMESPACE} \\\n-e LOG_ES_SERVER=${LOG_ES_SERVER} \\\n-e LOG_ES_USERNAME=${LOG_ES_USERNAME} \\\n-e LOG_ES_PASSWORD=${LOG_ES_PASSWORD} \\\n-e TZ=$(cat /etc/timezone) \\\n-v /etc/localtime:/etc/localtime:ro \\\n-v /etc/timezone:/etc/timezone:ro \\\n--net=host \\\n--restart=unless-stopped \\\n--name=${APP_NAME}-${APP_PORT} \\\n${REGISTRY_SERVER}/${APP_NAME}:${APP_VERSION}','docker stop ${CONTAINER_HASH}',NULL,30,NULL,2,6,1000,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',0,1),
(15,'#{NACOS_NAMESPACE}','uw-code-center部署方案','uw-code-center部署方案','','uw-code-center','1.1.0',0,3,103,'APP_PORT=10050','#!/bin/bash\ndocker stop ${APP_NAME}-${APP_PORT}\ndocker rm ${APP_NAME}-${APP_PORT}\ndocker run -d \\\n-m ${APP_MEM}m \\\n-e JAVA_OPTS=\"-XX:+UseShenandoahGC -XX:+UseContainerSupport -XX:MaxRAMPercentage=80.0\" \\\n-e SPRING_OPTS=\"--app.info=${APP_NAME}:${APP_VERSION} --spring.profiles.active=${NACOS_NAMESPACE} --server.port=${APP_PORT}\" \\\n-e APP_HOST=${APP_HOST} \\\n-e APP_PORT=${APP_PORT} \\\n-e NACOS_SERVER=${NACOS_SERVER} \\\n-e NACOS_USERNAME=${NACOS_USERNAME} \\\n-e NACOS_PASSWORD=${NACOS_PASSWORD} \\\n-e NACOS_NAMESPACE=${NACOS_NAMESPACE} \\\n-e LOG_ES_SERVER=${LOG_ES_SERVER} \\\n-e LOG_ES_USERNAME=${LOG_ES_USERNAME} \\\n-e LOG_ES_PASSWORD=${LOG_ES_PASSWORD} \\\n-e TZ=$(cat /etc/timezone) \\\n-v /etc/localtime:/etc/localtime:ro \\\n-v /etc/timezone:/etc/timezone:ro \\\n--net=host \\\n--restart=unless-stopped \\\n--name=${APP_NAME}-${APP_PORT} \\\n${REGISTRY_SERVER}/${APP_NAME}:${APP_VERSION}','docker stop ${CONTAINER_HASH}',NULL,30,NULL,1,2,500,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',0,1),
(16,'#{NACOS_NAMESPACE}','root-pc-ui部署方案','root-pc-ui部署方案','','root-pc-ui','1.1.0',0,3,103,'APP_PORT=30100','#!/bin/bash\ndocker stop ${APP_NAME}-${APP_PORT}\ndocker rm ${APP_NAME}-${APP_PORT}\ndocker run -d \\\n-m ${APP_MEM}m \\\n-e APP_NAME=${APP_NAME} \\\n-e APP_HOST=${APP_HOST} \\\n-e APP_PORT=${APP_PORT} \\\n-e NACOS_SERVER=${NACOS_SERVER} \\\n-e NACOS_USERNAME=${NACOS_USERNAME} \\\n-e NACOS_PASSWORD=${NACOS_PASSWORD} \\\n-e NACOS_NAMESPACE=${NACOS_NAMESPACE} \\\n-e TZ=$(cat /etc/timezone) \\\n-v /etc/localtime:/etc/localtime:ro \\\n-v /etc/timezone:/etc/timezone:ro \\\n--net=host \\\n--restart=unless-stopped \\\n--name=${APP_NAME}-${APP_PORT} \\\n${REGISTRY_SERVER}/${APP_NAME}:${APP_VERSION}','docker stop ${CONTAINER_HASH}',NULL,5,NULL,2,2,100,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',0,1),
(18,'#{NACOS_NAMESPACE}','ops-pc-ui部署方案','ops-pc-ui部署方案','','ops-pc-ui','1.1.0',0,3,103,'APP_PORT=30110','#!/bin/bash\ndocker stop ${APP_NAME}-${APP_PORT}\ndocker rm ${APP_NAME}-${APP_PORT}\ndocker run -d \\\n-m ${APP_MEM}m \\\n-e APP_NAME=${APP_NAME} \\\n-e APP_HOST=${APP_HOST} \\\n-e APP_PORT=${APP_PORT} \\\n-e NACOS_SERVER=${NACOS_SERVER} \\\n-e NACOS_USERNAME=${NACOS_USERNAME} \\\n-e NACOS_PASSWORD=${NACOS_PASSWORD} \\\n-e NACOS_NAMESPACE=${NACOS_NAMESPACE} \\\n-e TZ=$(cat /etc/timezone) \\\n-v /etc/localtime:/etc/localtime:ro \\\n-v /etc/timezone:/etc/timezone:ro \\\n--net=host \\\n--restart=unless-stopped \\\n--name=${APP_NAME}-${APP_PORT} \\\n${REGISTRY_SERVER}/${APP_NAME}:${APP_VERSION}','docker stop ${CONTAINER_HASH}',NULL,5,NULL,2,2,100,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',0,1),
(19,'#{NACOS_NAMESPACE}','admin-pc-ui部署方案','admin-pc-ui部署方案','','admin-pc-ui','1.0.0',0,3,103,'APP_PORT=30200','#!/bin/bash\ndocker stop ${APP_NAME}-${APP_PORT}\ndocker rm ${APP_NAME}-${APP_PORT}\ndocker run -d \\\n-m ${APP_MEM}m \\\n-e APP_NAME=${APP_NAME} \\\n-e APP_HOST=${APP_HOST} \\\n-e APP_PORT=${APP_PORT} \\\n-e NACOS_SERVER=${NACOS_SERVER} \\\n-e NACOS_USERNAME=${NACOS_USERNAME} \\\n-e NACOS_PASSWORD=${NACOS_PASSWORD} \\\n-e NACOS_NAMESPACE=${NACOS_NAMESPACE} \\\n-e TZ=$(cat /etc/timezone) \\\n-v /etc/localtime:/etc/localtime:ro \\\n-v /etc/timezone:/etc/timezone:ro \\\n--net=host \\\n--restart=unless-stopped \\\n--name=${APP_NAME}-${APP_PORT} \\\n${REGISTRY_SERVER}/${APP_NAME}:${APP_VERSION}','docker stop ${CONTAINER_HASH}',NULL,5,NULL,2,2,100,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',0,1),
(20,'#{NACOS_NAMESPACE}','saas-base-app部署方案','saas-base-app部署方案','','saas-base-app','2.0.0',0,3,103,'APP_PORT=20000','#!/bin/bash\ndocker stop ${APP_NAME}-${APP_PORT}\ndocker rm ${APP_NAME}-${APP_PORT}\ndocker run -d \\\n-m ${APP_MEM}m \\\n-e JAVA_OPTS=\"-XX:+UseShenandoahGC -XX:+UseContainerSupport -XX:MaxRAMPercentage=80.0\" \\\n-e SPRING_OPTS=\"--app.info=${APP_NAME}:${APP_VERSION} --spring.profiles.active=${NACOS_NAMESPACE} --server.port=${APP_PORT}\" \\\n-e APP_HOST=${APP_HOST} \\\n-e APP_PORT=${APP_PORT} \\\n-e NACOS_SERVER=${NACOS_SERVER} \\\n-e NACOS_USERNAME=${NACOS_USERNAME} \\\n-e NACOS_PASSWORD=${NACOS_PASSWORD} \\\n-e NACOS_NAMESPACE=${NACOS_NAMESPACE} \\\n-e LOG_ES_SERVER=${LOG_ES_SERVER} \\\n-e LOG_ES_USERNAME=${LOG_ES_USERNAME} \\\n-e LOG_ES_PASSWORD=${LOG_ES_PASSWORD} \\\n-e TZ=$(cat /etc/timezone) \\\n-v /etc/localtime:/etc/localtime:ro \\\n-v /etc/timezone:/etc/timezone:ro \\\n--net=host \\\n--restart=unless-stopped \\\n--name=${APP_NAME}-${APP_PORT} \\\n${REGISTRY_SERVER}/${APP_NAME}:${APP_VERSION}','docker stop ${CONTAINER_HASH}',NULL,30,NULL,2,6,1000,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',0,1),
(21,'#{NACOS_NAMESPACE}','saas-finance-app部署方案','saas-finance-app部署方案','','saas-finance-app','2.0.0',0,3,103,'APP_PORT=20080','#!/bin/bash\ndocker stop ${APP_NAME}-${APP_PORT}\ndocker rm ${APP_NAME}-${APP_PORT}\ndocker run -d \\\n-m ${APP_MEM}m \\\n-e JAVA_OPTS=\"-XX:+UseShenandoahGC -XX:+UseContainerSupport -XX:MaxRAMPercentage=80.0\" \\\n-e SPRING_OPTS=\"--app.info=${APP_NAME}:${APP_VERSION} --spring.profiles.active=${NACOS_NAMESPACE} --server.port=${APP_PORT}\" \\\n-e APP_HOST=${APP_HOST} \\\n-e APP_PORT=${APP_PORT} \\\n-e NACOS_SERVER=${NACOS_SERVER} \\\n-e NACOS_USERNAME=${NACOS_USERNAME} \\\n-e NACOS_PASSWORD=${NACOS_PASSWORD} \\\n-e NACOS_NAMESPACE=${NACOS_NAMESPACE} \\\n-e LOG_ES_SERVER=${LOG_ES_SERVER} \\\n-e LOG_ES_USERNAME=${LOG_ES_USERNAME} \\\n-e LOG_ES_PASSWORD=${LOG_ES_PASSWORD} \\\n-e TZ=$(cat /etc/timezone) \\\n-v /etc/localtime:/etc/localtime:ro \\\n-v /etc/timezone:/etc/timezone:ro \\\n--net=host \\\n--restart=unless-stopped \\\n--name=${APP_NAME}-${APP_PORT} \\\n${REGISTRY_SERVER}/${APP_NAME}:${APP_VERSION}','docker stop ${CONTAINER_HASH}',NULL,30,NULL,2,6,1000,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',0,1),
(22,'#{NACOS_NAMESPACE}','saas-pc-ui部署方案','saas-pc-ui部署方案','','saas-pc-ui','1.0.0',0,3,103,'APP_PORT=30300','#!/bin/bash\ndocker stop ${APP_NAME}-${APP_PORT}\ndocker rm ${APP_NAME}-${APP_PORT}\ndocker run -d \\\n-m ${APP_MEM}m \\\n-e APP_NAME=${APP_NAME} \\\n-e APP_HOST=${APP_HOST} \\\n-e APP_PORT=${APP_PORT} \\\n-e NACOS_SERVER=${NACOS_SERVER} \\\n-e NACOS_USERNAME=${NACOS_USERNAME} \\\n-e NACOS_PASSWORD=${NACOS_PASSWORD} \\\n-e NACOS_NAMESPACE=${NACOS_NAMESPACE} \\\n-e TZ=$(cat /etc/timezone) \\\n-v /etc/localtime:/etc/localtime:ro \\\n-v /etc/timezone:/etc/timezone:ro \\\n--net=host \\\n--restart=unless-stopped \\\n--name=${APP_NAME}-${APP_PORT} \\\n${REGISTRY_SERVER}/${APP_NAME}:${APP_VERSION}','docker stop ${CONTAINER_HASH}',NULL,5,NULL,2,2,100,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',0,1);

INSERT INTO `ops_host_cluster` VALUES (0,NULL,'全部主机集群','全部主机集群',NULL,'2023-11-10 08:00:00.000',NULL,1);

INSERT INTO `sys_seq` VALUES ('OpsDeployPlan',30,'OpsDeployPlan',1,'2023-11-10 08:00:00.000','2023-11-10 08:00:00.000'),
                             ('OpsDeployProfile',9,'OpsDeployProfile',1,'2023-11-10 08:00:00.000','2023-11-10 08:00:00.000'),
                             ('OpsDeployScript',5,'OpsDeployScript',1,'2023-11-10 08:00:00.000','2023-11-10 08:00:00.000');

