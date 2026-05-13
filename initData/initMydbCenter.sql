/*!50503 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS `uw_mydb` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `uw_mydb`;

-- uw_mydb.mydb_alert_config_mysql definition

CREATE TABLE `mydb_alert_config_mysql` (
                                           `id` bigint NOT NULL COMMENT 'id',
                                           `config_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '配置名',
                                           `mem_rate_limit` double DEFAULT NULL COMMENT '内存使用率限制',
                                           `thread_limit` int DEFAULT NULL COMMENT '线程数量限制',
                                           `qps_limit` int DEFAULT NULL COMMENT 'qps限制',
                                           `temp_table_limit` int DEFAULT NULL COMMENT '临时表限制',
                                           `open_table_limit` int DEFAULT NULL COMMENT '系统打开表限制',
                                           `open_file_limit` int DEFAULT NULL COMMENT '系统打开文件限制',
                                           `slow_query_limit` int DEFAULT NULL COMMENT '慢查询限制',
                                           `select_scan_limit` int DEFAULT NULL COMMENT '全表扫描限制',
                                           `select_full_join_limit` int DEFAULT NULL COMMENT '全表join限制',
                                           `sort_scan_limit` int DEFAULT NULL COMMENT '全表排序限制',
                                           `create_date` datetime(3) NOT NULL COMMENT '创建日期',
                                           `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                                           `state` int NOT NULL COMMENT '状态。1正常-1标记删除',
                                           PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='mysql报警设置';


-- uw_mydb.mydb_alert_config_proxy definition

CREATE TABLE `mydb_alert_config_proxy` (
                                           `id` bigint NOT NULL COMMENT 'id',
                                           `config_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '配置名',
                                           `cpu_rate_limit` double DEFAULT NULL COMMENT 'cpu使用率限制',
                                           `mem_rate_limit` double DEFAULT NULL COMMENT '内存使用率限制',
                                           `thread_limit` int DEFAULT NULL COMMENT '线程数量限制',
                                           `client_conn_limit` int DEFAULT NULL COMMENT '客户端连接数限制',
                                           `mysql_conn_limit` int DEFAULT NULL COMMENT 'mysql连接数限制',
                                           `create_date` datetime(3) NOT NULL COMMENT '创建日期',
                                           `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                                           `state` int NOT NULL COMMENT '状态。1正常-1标记删除',
                                           PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='mydb报警设置';


-- uw_mydb.mydb_alert_info definition

CREATE TABLE `mydb_alert_info` (
                                   `id` bigint NOT NULL COMMENT 'id',
                                   `alert_object_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '报警对象类型',
                                   `alert_object_id` bigint DEFAULT NULL COMMENT '报警对象id',
                                   `alert_title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '报警标题',
                                   `alert_body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '报警信息',
                                   `create_date` datetime(3) DEFAULT NULL COMMENT '创建时间',
                                   `state` int DEFAULT NULL COMMENT '状态',
                                   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='mydb报警信息';


-- uw_mydb.mydb_config_proxy definition

CREATE TABLE `mydb_config_proxy` (
                                     `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '配置KEY',
                                     `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '配置名称',
                                     `config_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '配置描述',
                                     `username` varchar(100) DEFAULT NULL COMMENT '用户名',
                                     `password` varchar(100) DEFAULT NULL COMMENT '密码',
                                     `cluster_ids` varchar(19) DEFAULT NULL COMMENT '集群ID序列',
                                     `base_cluster` bigint DEFAULT NULL COMMENT '基础集群',
                                     `saas_per_node` int DEFAULT '1' COMMENT '每节点saas数',
                                     `create_date` datetime(3) NOT NULL COMMENT '创建日期',
                                     `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                                     `state` int NOT NULL COMMENT '状态。1正常-1标记删除',
                                     PRIMARY KEY (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='mydb代理配置';


-- uw_mydb.mydb_config_route definition

CREATE TABLE `mydb_config_route` (
                                     `id` bigint NOT NULL COMMENT 'id',
                                     `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '配置KEY',
                                     `parent_id` bigint DEFAULT NULL COMMENT '上级路由',
                                     `route_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '路由名',
                                     `route_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '路由描述',
                                     `route_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '路由key',
                                     `route_algorithm` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '路由算法',
                                     `route_param` json DEFAULT NULL COMMENT '路由参数',
                                     `create_date` datetime(3) NOT NULL COMMENT '创建日期',
                                     `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                                     `state` int NOT NULL COMMENT '状态。1正常-1标记删除',
                                     PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='mydb路由配置';


-- uw_mydb.mydb_config_saas definition

CREATE TABLE `mydb_config_saas` (
                                    `id` bigint NOT NULL COMMENT 'id',
                                    `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '配置KEY',
                                    `saas_id` varchar(100) NOT NULL COMMENT 'saasId',
                                    `base_cluster` bigint DEFAULT NULL COMMENT '基础集群',
                                    `base_database` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '基础库',
                                    `create_date` datetime(3) NOT NULL COMMENT '创建日期',
                                    `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                                    `state` int NOT NULL COMMENT '状态。1正常-1标记删除',
                                    PRIMARY KEY (`id`),
                                    KEY `mydb_config_saas_config_key_IDX` (`config_key`,`saas_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='saas节点信息';


-- uw_mydb.mydb_config_schema definition

CREATE TABLE `mydb_config_schema` (
                                      `id` bigint NOT NULL COMMENT 'id',
                                      `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '配置KEY',
                                      `schema_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '库名',
                                      `schema_desc` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '库描述',
                                      `base_cluster` bigint DEFAULT NULL COMMENT '基础集群',
                                      `base_database` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '基础库',
                                      `create_date` datetime(3) NOT NULL COMMENT '创建日期',
                                      `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                                      `state` int NOT NULL COMMENT '状态。1正常-1标记删除',
                                      PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='schema配置';


-- uw_mydb.mydb_config_table definition

CREATE TABLE `mydb_config_table` (
                                     `id` bigint NOT NULL COMMENT 'id',
                                     `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '配置KEY',
                                     `table_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '表名',
                                     `table_desc` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '表描述',
                                     `table_sql` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '建表sql',
                                     `route_id` bigint DEFAULT NULL COMMENT '路由ID',
                                     `match_type` int DEFAULT NULL COMMENT '匹配类型',
                                     `base_cluster` bigint DEFAULT NULL COMMENT '基础集群',
                                     `base_database` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '基础库',
                                     `create_date` datetime(3) NOT NULL COMMENT '创建日期',
                                     `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                                     `state` int NOT NULL COMMENT '状态。1正常-1标记删除',
                                     PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='mydb表配置';


-- uw_mydb.mydb_data_node definition

CREATE TABLE `mydb_data_node` (
                                  `cluster_id` bigint NOT NULL COMMENT 'mysql集群',
                                  `db_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'mysql数据库',
                                  `create_date` datetime(3) NOT NULL COMMENT '创建日期',
                                  `last_update` datetime(3) DEFAULT NULL COMMENT '最后更新日期',
                                  `db_num` int DEFAULT '0' COMMENT '库数量',
                                  `table_num` int DEFAULT '0' COMMENT '表数量',
                                  `row_num` bigint DEFAULT '0' COMMENT '表行数',
                                  `data_size` bigint DEFAULT '0' COMMENT '数据大小',
                                  `data_free` bigint DEFAULT '0' COMMENT '空闲数据',
                                  `index_size` bigint DEFAULT '0' COMMENT '索引大小',
                                  `insert_num` bigint DEFAULT '0' COMMENT 'insert计数',
                                  `update_num` bigint DEFAULT '0' COMMENT 'update计数',
                                  `delete_num` bigint DEFAULT '0' COMMENT 'delete计数',
                                  `select_num` bigint DEFAULT '0' COMMENT 'select计数',
                                  `other_num` bigint DEFAULT '0' COMMENT 'other计数',
                                  `insert_error_num` bigint DEFAULT '0' COMMENT 'insert错误计数',
                                  `update_error_num` bigint DEFAULT '0' COMMENT 'update错误计数',
                                  `delete_error_num` bigint DEFAULT '0' COMMENT 'delete错误计数',
                                  `select_error_num` bigint DEFAULT '0' COMMENT 'select错误计数',
                                  `other_error_num` bigint DEFAULT '0' COMMENT 'other错误计数',
                                  `insert_exe_millis` bigint DEFAULT '0' COMMENT 'insert执行时间',
                                  `update_exe_millis` bigint DEFAULT '0' COMMENT 'update执行时间',
                                  `delete_exe_millis` bigint DEFAULT '0' COMMENT 'delete执行时间',
                                  `select_exe_millis` bigint DEFAULT '0' COMMENT 'select执行时间',
                                  `other_exe_millis` bigint DEFAULT '0' COMMENT 'other执行时间',
                                  `insert_row_num` bigint DEFAULT '0' COMMENT 'insert行数',
                                  `update_row_num` bigint DEFAULT '0' COMMENT 'update行数',
                                  `delete_row_num` bigint DEFAULT '0' COMMENT 'delete行数',
                                  `select_row_num` bigint DEFAULT '0' COMMENT 'select行数',
                                  `other_row_num` bigint DEFAULT '0' COMMENT 'other行数',
                                  `insert_tx_bytes` bigint DEFAULT '0' COMMENT 'insert发送字节',
                                  `insert_rx_bytes` bigint DEFAULT '0' COMMENT 'insert接收字节',
                                  `update_tx_bytes` bigint DEFAULT '0' COMMENT 'update发送字节',
                                  `update_rx_bytes` bigint DEFAULT '0' COMMENT 'update接收字节',
                                  `delete_tx_bytes` bigint DEFAULT '0' COMMENT 'delete发送字节',
                                  `delete_rx_bytes` bigint DEFAULT '0' COMMENT 'delete接收字节',
                                  `select_tx_bytes` bigint DEFAULT '0' COMMENT 'select发送字节',
                                  `select_rx_bytes` bigint DEFAULT '0' COMMENT 'select接收字节',
                                  `other_tx_bytes` bigint DEFAULT '0' COMMENT 'other发送字节',
                                  `other_rx_bytes` bigint DEFAULT '0' COMMENT 'other接收字节',
                                  PRIMARY KEY (`cluster_id`,`db_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='数据节点信息';


-- uw_mydb.mydb_data_node_stats definition

CREATE TABLE `mydb_data_node_stats` (
                                        `id` bigint NOT NULL COMMENT 'id',
                                        `cluster_id` bigint NOT NULL COMMENT 'mysql集群',
                                        `db_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'mysql数据库',
                                        `create_date` datetime(3) NOT NULL COMMENT '创建日期',
                                        `last_update` datetime(3) DEFAULT NULL COMMENT '最后更新日期',
                                        `db_num` int DEFAULT '0' COMMENT '库数量',
                                        `table_num` int DEFAULT '0' COMMENT '表数量',
                                        `row_num` bigint DEFAULT '0' COMMENT '表行数',
                                        `data_size` bigint DEFAULT '0' COMMENT '数据大小',
                                        `data_free` bigint DEFAULT '0' COMMENT '空闲数据',
                                        `index_size` bigint DEFAULT '0' COMMENT '索引大小',
                                        `insert_num` bigint DEFAULT '0' COMMENT 'insert计数',
                                        `update_num` bigint DEFAULT '0' COMMENT 'update计数',
                                        `delete_num` bigint DEFAULT '0' COMMENT 'delete计数',
                                        `select_num` bigint DEFAULT '0' COMMENT 'select计数',
                                        `other_num` bigint DEFAULT '0' COMMENT 'other计数',
                                        `insert_error_num` bigint DEFAULT '0' COMMENT 'insert错误计数',
                                        `update_error_num` bigint DEFAULT '0' COMMENT 'update错误计数',
                                        `delete_error_num` bigint DEFAULT '0' COMMENT 'delete错误计数',
                                        `select_error_num` bigint DEFAULT '0' COMMENT 'select错误计数',
                                        `other_error_num` bigint DEFAULT '0' COMMENT 'other错误计数',
                                        `insert_exe_millis` bigint DEFAULT '0' COMMENT 'insert执行时间',
                                        `update_exe_millis` bigint DEFAULT '0' COMMENT 'update执行时间',
                                        `delete_exe_millis` bigint DEFAULT '0' COMMENT 'delete执行时间',
                                        `select_exe_millis` bigint DEFAULT '0' COMMENT 'select执行时间',
                                        `other_exe_millis` bigint DEFAULT '0' COMMENT 'other执行时间',
                                        `insert_row_num` bigint DEFAULT '0' COMMENT 'insert行数',
                                        `update_row_num` bigint DEFAULT '0' COMMENT 'update行数',
                                        `delete_row_num` bigint DEFAULT '0' COMMENT 'delete行数',
                                        `select_row_num` bigint DEFAULT '0' COMMENT 'select行数',
                                        `other_row_num` bigint DEFAULT '0' COMMENT 'other行数',
                                        `insert_tx_bytes` bigint DEFAULT '0' COMMENT 'insert发送字节',
                                        `insert_rx_bytes` bigint DEFAULT '0' COMMENT 'insert接收字节',
                                        `update_tx_bytes` bigint DEFAULT '0' COMMENT 'update发送字节',
                                        `update_rx_bytes` bigint DEFAULT '0' COMMENT 'update接收字节',
                                        `delete_tx_bytes` bigint DEFAULT '0' COMMENT 'delete发送字节',
                                        `delete_rx_bytes` bigint DEFAULT '0' COMMENT 'delete接收字节',
                                        `select_tx_bytes` bigint DEFAULT '0' COMMENT 'select发送字节',
                                        `select_rx_bytes` bigint DEFAULT '0' COMMENT 'select接收字节',
                                        `other_tx_bytes` bigint DEFAULT '0' COMMENT 'other发送字节',
                                        `other_rx_bytes` bigint DEFAULT '0' COMMENT 'other接收字节',
                                        PRIMARY KEY (`id`),
                                        KEY `mydb_data_node_stats_cluster_id_IDX` (`cluster_id`,`db_name`,`last_update`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='数据节点统计';


-- uw_mydb.mydb_data_run_stats definition

CREATE TABLE `mydb_data_run_stats` (
                                       `id` bigint NOT NULL COMMENT 'id',
                                       `create_date` datetime(3) NOT NULL COMMENT '创建日期',
                                       `proxy_id` bigint DEFAULT NULL COMMENT 'proxyId',
                                       `cluster_id` bigint DEFAULT NULL COMMENT 'clusterId',
                                       `server_id` bigint DEFAULT NULL COMMENT 'serverId',
                                       `db_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '数据库',
                                       `table_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '表',
                                       `insert_num` bigint DEFAULT '0' COMMENT 'insert计数',
                                       `update_num` bigint DEFAULT '0' COMMENT 'update计数',
                                       `delete_num` bigint DEFAULT '0' COMMENT 'delete计数',
                                       `select_num` bigint DEFAULT '0' COMMENT 'select计数',
                                       `other_num` bigint DEFAULT '0' COMMENT 'other计数',
                                       `insert_error_num` bigint DEFAULT '0' COMMENT 'insert错误计数',
                                       `update_error_num` bigint DEFAULT '0' COMMENT 'update错误计数',
                                       `delete_error_num` bigint DEFAULT '0' COMMENT 'delete错误计数',
                                       `select_error_num` bigint DEFAULT '0' COMMENT 'select错误计数',
                                       `other_error_num` bigint DEFAULT '0' COMMENT 'other错误计数',
                                       `insert_exe_millis` bigint DEFAULT '0' COMMENT 'insert执行时间',
                                       `update_exe_millis` bigint DEFAULT '0' COMMENT 'update执行时间',
                                       `delete_exe_millis` bigint DEFAULT '0' COMMENT 'delete执行时间',
                                       `select_exe_millis` bigint DEFAULT '0' COMMENT 'select执行时间',
                                       `other_exe_millis` bigint DEFAULT '0' COMMENT 'other执行时间',
                                       `insert_row_num` bigint DEFAULT '0' COMMENT 'insert行数',
                                       `update_row_num` bigint DEFAULT '0' COMMENT 'update行数',
                                       `delete_row_num` bigint DEFAULT '0' COMMENT 'delete行数',
                                       `select_row_num` bigint DEFAULT '0' COMMENT 'select行数',
                                       `other_row_num` bigint DEFAULT '0' COMMENT 'other行数',
                                       `insert_tx_bytes` bigint DEFAULT '0' COMMENT 'insert发送字节',
                                       `insert_rx_bytes` bigint DEFAULT '0' COMMENT 'insert接收字节',
                                       `update_tx_bytes` bigint DEFAULT '0' COMMENT 'update发送字节',
                                       `update_rx_bytes` bigint DEFAULT '0' COMMENT 'update接收字节',
                                       `delete_tx_bytes` bigint DEFAULT '0' COMMENT 'delete发送字节',
                                       `delete_rx_bytes` bigint DEFAULT '0' COMMENT 'delete接收字节',
                                       `select_tx_bytes` bigint DEFAULT '0' COMMENT 'select发送字节',
                                       `select_rx_bytes` bigint DEFAULT '0' COMMENT 'select接收字节',
                                       `other_tx_bytes` bigint DEFAULT '0' COMMENT 'other发送字节',
                                       `other_rx_bytes` bigint DEFAULT '0' COMMENT 'other接收字节',
                                       PRIMARY KEY (`id`),
                                       KEY `mydb_data_run_stats_create_date_IDX` (`create_date`,`proxy_id`,`cluster_id`,`server_id`,`db_name`,`table_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='数据运行统计';


-- uw_mydb.mydb_data_schema definition

CREATE TABLE `mydb_data_schema` (
                                    `cluster_id` bigint NOT NULL COMMENT 'id',
                                    `db_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '库名',
                                    `table_name` varchar(100) NOT NULL COMMENT '表名',
                                    `table_comment` varchar(200) DEFAULT NULL COMMENT '表备注',
                                    `table_type` varchar(100) DEFAULT NULL COMMENT '表类型',
                                    `table_engine` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '引擎',
                                    `row_format` varchar(100) DEFAULT NULL COMMENT '行格式',
                                    `table_collation` varchar(64) DEFAULT NULL COMMENT '字符集',
                                    `row_num` bigint DEFAULT NULL COMMENT '行数',
                                    `row_avg_size` bigint DEFAULT NULL COMMENT '平均行长度',
                                    `data_size` bigint DEFAULT NULL COMMENT '数据大小',
                                    `data_max_size` bigint DEFAULT NULL COMMENT '最大占用大小',
                                    `index_size` bigint DEFAULT NULL COMMENT '索引大小',
                                    `data_free` bigint DEFAULT NULL COMMENT '数据碎片',
                                    `seq_id` bigint DEFAULT NULL COMMENT '自增id',
                                    `create_date` datetime(3) NOT NULL COMMENT '创建日期',
                                    `last_update` datetime(3) DEFAULT NULL COMMENT '上次更新',
                                    `check_date` datetime(3) DEFAULT NULL COMMENT '检查时间',
                                    PRIMARY KEY (`cluster_id`,`db_name`,`table_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='数据库表信息';


-- uw_mydb.mydb_mysql_backup definition

CREATE TABLE `mydb_mysql_backup` (
                                     `id` bigint NOT NULL COMMENT 'id',
                                     `parent_id` bigint DEFAULT NULL COMMENT 'parentId',
                                     `cluster_id` bigint DEFAULT NULL COMMENT '集群id',
                                     `server_id` bigint DEFAULT NULL COMMENT '服务器id',
                                     `backup_stamp` varchar(100) NOT NULL COMMENT '备份戳',
                                     `backup_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备份key',
                                     `server_info` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '服务器信息',
                                     `file_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备份名',
                                     `file_size` bigint DEFAULT NULL COMMENT '备份大小',
                                     `tgz_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '压缩文件名',
                                     `tgz_size` bigint DEFAULT NULL COMMENT '压缩文件大小',
                                     `tgz_md5` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '压缩文件md5',
                                     `copy_info` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '拷贝信息',
                                     `copy_start_date` datetime(3) DEFAULT NULL COMMENT '开始拷贝时间',
                                     `copy_end_date` datetime(3) DEFAULT NULL COMMENT '结束拷贝时间',
                                     `compress_info` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '压缩信息',
                                     `compress_start_date` datetime(3) DEFAULT NULL COMMENT '开始压缩时间',
                                     `compress_end_date` datetime(3) DEFAULT NULL COMMENT '结束压缩时间',
                                     `upload_info` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '上传信息',
                                     `upload_start_date` datetime(3) DEFAULT NULL COMMENT '开始上传时间',
                                     `upload_end_date` datetime(3) DEFAULT NULL COMMENT '结束上传时间',
                                     `state` int DEFAULT '0' COMMENT '状态',
                                     PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='mysql数据备份';


-- uw_mydb.mydb_mysql_cluster definition

CREATE TABLE `mydb_mysql_cluster` (
                                      `id` bigint NOT NULL COMMENT 'id',
                                      `cluster_name` varchar(100) DEFAULT NULL COMMENT '集群名',
                                      `cluster_desc` text COMMENT '集群描述',
                                      `cluster_type` int DEFAULT NULL COMMENT '集群类型',
                                      `switch_type` int DEFAULT NULL COMMENT '切换类型',
                                      `db_num` int DEFAULT '0' COMMENT '库数量',
                                      `table_num` int DEFAULT '0' COMMENT '表数量',
                                      `row_num` bigint DEFAULT '0' COMMENT '表行数',
                                      `data_size` bigint DEFAULT '0' COMMENT '数据大小',
                                      `data_free` bigint DEFAULT '0' COMMENT '空闲数据',
                                      `index_size` bigint DEFAULT '0' COMMENT '索引大小',
                                      `insert_num` bigint DEFAULT '0' COMMENT 'insert计数',
                                      `update_num` bigint DEFAULT '0' COMMENT 'update计数',
                                      `delete_num` bigint DEFAULT '0' COMMENT 'delete计数',
                                      `select_num` bigint DEFAULT '0' COMMENT 'select计数',
                                      `other_num` bigint DEFAULT '0' COMMENT 'other计数',
                                      `insert_error_num` bigint DEFAULT '0' COMMENT 'insert错误计数',
                                      `update_error_num` bigint DEFAULT '0' COMMENT 'update错误计数',
                                      `delete_error_num` bigint DEFAULT '0' COMMENT 'delete错误计数',
                                      `select_error_num` bigint DEFAULT '0' COMMENT 'select错误计数',
                                      `other_error_num` bigint DEFAULT '0' COMMENT 'other错误计数',
                                      `insert_exe_millis` bigint DEFAULT '0' COMMENT 'insert执行时间',
                                      `update_exe_millis` bigint DEFAULT '0' COMMENT 'update执行时间',
                                      `delete_exe_millis` bigint DEFAULT '0' COMMENT 'delete执行时间',
                                      `select_exe_millis` bigint DEFAULT '0' COMMENT 'select执行时间',
                                      `other_exe_millis` bigint DEFAULT '0' COMMENT 'other执行时间',
                                      `insert_row_num` bigint DEFAULT '0' COMMENT 'insert行数',
                                      `update_row_num` bigint DEFAULT '0' COMMENT 'update行数',
                                      `delete_row_num` bigint DEFAULT '0' COMMENT 'delete行数',
                                      `select_row_num` bigint DEFAULT '0' COMMENT 'select行数',
                                      `other_row_num` bigint DEFAULT '0' COMMENT 'other行数',
                                      `insert_tx_bytes` bigint DEFAULT '0' COMMENT 'insert发送字节',
                                      `insert_rx_bytes` bigint DEFAULT '0' COMMENT 'insert接收字节',
                                      `update_tx_bytes` bigint DEFAULT '0' COMMENT 'update发送字节',
                                      `update_rx_bytes` bigint DEFAULT '0' COMMENT 'update接收字节',
                                      `delete_tx_bytes` bigint DEFAULT '0' COMMENT 'delete发送字节',
                                      `delete_rx_bytes` bigint DEFAULT '0' COMMENT 'delete接收字节',
                                      `select_tx_bytes` bigint DEFAULT '0' COMMENT 'select发送字节',
                                      `select_rx_bytes` bigint DEFAULT '0' COMMENT 'select接收字节',
                                      `other_tx_bytes` bigint DEFAULT '0' COMMENT 'other发送字节',
                                      `other_rx_bytes` bigint DEFAULT '0' COMMENT 'other接收字节',
                                      `create_date` datetime(3) NOT NULL COMMENT '创建日期',
                                      `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                                      `last_update` datetime(3) DEFAULT NULL COMMENT '最后更新日期',
                                      `state` int NOT NULL COMMENT '状态。1正常-1标记删除',
                                      PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='mysql集群';


-- uw_mydb.mydb_mysql_server definition

CREATE TABLE `mydb_mysql_server` (
                                     `id` bigint NOT NULL COMMENT 'id',
                                     `cluster_id` bigint DEFAULT NULL COMMENT '集群id',
                                     `server_type` int DEFAULT NULL COMMENT '主从类型',
                                     `server_host` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'mysql主机',
                                     `server_port` int DEFAULT NULL COMMENT 'mysql端口',
                                     `server_user` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'mysql用户',
                                     `server_pass` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'mysql密码',
                                     `server_weight` int DEFAULT NULL COMMENT '权重',
                                     `conn_min` int DEFAULT NULL COMMENT '最小连接数',
                                     `conn_max` int DEFAULT NULL COMMENT '最大连接数',
                                     `conn_idle_timeout` int DEFAULT NULL COMMENT '连接空闲超时',
                                     `conn_busy_timeout` int DEFAULT NULL COMMENT '连接忙时超时',
                                     `conn_max_age` int DEFAULT NULL COMMENT '连接寿命',
                                     `create_date` datetime(3) NOT NULL COMMENT '创建日期',
                                     `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                                     `state` int NOT NULL COMMENT '状态。1正常-1标记删除',
                                     PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='mysql服务器';


-- uw_mydb.mydb_mysql_stats definition

CREATE TABLE `mydb_mysql_stats` (
                                    `id` bigint NOT NULL COMMENT 'id',
                                    `cluster_id` bigint DEFAULT NULL COMMENT 'clusterId',
                                    `server_id` bigint DEFAULT NULL COMMENT 'serverId',
                                    `create_date` datetime(3) NOT NULL COMMENT '创建日期',
                                    `abort_clients` bigint DEFAULT NULL COMMENT '失败客户端数',
                                    `abort_connects` bigint DEFAULT NULL COMMENT '失败连接数',
                                    `bytes_tx` bigint DEFAULT NULL COMMENT '发送字节数',
                                    `bytes_rx` bigint DEFAULT NULL COMMENT '接收字节数',
                                    `create_temp_tables` bigint DEFAULT NULL COMMENT '创建临时表数',
                                    `create_temp_disk_tables` bigint DEFAULT NULL COMMENT '创建的磁盘临时表',
                                    `create_temp_files` bigint DEFAULT NULL COMMENT '创建临时文件数',
                                    `cmd_all` bigint DEFAULT NULL COMMENT '命令总数',
                                    `cmd_select` bigint DEFAULT NULL COMMENT '命令select',
                                    `cmd_insert` bigint DEFAULT NULL COMMENT '命令insert',
                                    `cmd_update` bigint DEFAULT NULL COMMENT '命令update',
                                    `cmd_delete` bigint DEFAULT NULL COMMENT '命令delete',
                                    `innodb_buffer_pool_data` bigint DEFAULT NULL COMMENT 'innodb在用内存',
                                    `innodb_buffer_pool_free` bigint DEFAULT NULL COMMENT 'innodb空闲内存',
                                    `innodb_buffer_pool_reads` bigint DEFAULT NULL COMMENT 'innodb内存读取数',
                                    `innodb_buffer_pool_requests` bigint DEFAULT NULL COMMENT 'innodb在用内存请求数',
                                    `innodb_data_read_bytes` bigint DEFAULT NULL COMMENT 'innodb读取字节',
                                    `innodb_data_read_times` bigint DEFAULT NULL COMMENT 'innodb数据读取次数',
                                    `innodb_data_write_bytes` bigint DEFAULT NULL COMMENT 'innodb写入字节',
                                    `innodb_data_write_times` bigint DEFAULT NULL COMMENT 'innodb数据写入次数',
                                    `innodb_rows_delete` bigint DEFAULT NULL COMMENT 'innodb删除行数',
                                    `innodb_rows_insert` bigint DEFAULT NULL COMMENT 'innodb插入行数',
                                    `innodb_rows_select` bigint DEFAULT NULL COMMENT 'innodb查询行数',
                                    `innodb_rows_update` bigint DEFAULT NULL COMMENT 'innodb更新行数',
                                    `open_tables` bigint DEFAULT NULL COMMENT '打开表数量',
                                    `opened_tables` bigint DEFAULT NULL COMMENT '已打开表数量',
                                    `open_files` bigint DEFAULT NULL COMMENT '打开文件数量',
                                    `opened_files` bigint DEFAULT NULL COMMENT '已打开文件数量',
                                    `slow_queries` bigint DEFAULT NULL COMMENT '慢查询数',
                                    `select_scan` bigint DEFAULT NULL COMMENT '全表扫描查询',
                                    `select_full_join` bigint DEFAULT NULL COMMENT '全表扫描join',
                                    `select_full_range_join` bigint DEFAULT NULL COMMENT '全表range join',
                                    `sort_rows` bigint DEFAULT NULL COMMENT '排序行数',
                                    `sort_scan` bigint DEFAULT NULL COMMENT '排序全表扫描',
                                    `sort_merge_passes` bigint DEFAULT NULL COMMENT '排序合并次数',
                                    `table_locks_immediate` bigint DEFAULT NULL COMMENT '表立即锁定',
                                    `table_locks_waited` bigint DEFAULT NULL COMMENT '表等待锁定',
                                    `innodb_row_lock_waits` bigint DEFAULT NULL COMMENT 'innodb行锁等待',
                                    `innodb_row_lock_time` bigint DEFAULT NULL COMMENT 'innodb行锁时间',
                                    `threads_cached` bigint DEFAULT NULL COMMENT '缓存进程',
                                    `threads_connected` bigint DEFAULT NULL COMMENT '打开进程数',
                                    `threads_created` bigint DEFAULT NULL COMMENT '已创建的进程数',
                                    `threads_running` bigint DEFAULT NULL COMMENT '执行的进程数',
                                    `up_time` bigint DEFAULT NULL COMMENT '启动时间',
                                    PRIMARY KEY (`id`),
                                    KEY `mydb_mysql_stats_server_id_IDX` (`server_id`,`create_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='mysql运行统计';


-- uw_mydb.mydb_proxy_server definition

CREATE TABLE `mydb_proxy_server` (
                                     `id` bigint NOT NULL COMMENT 'id',
                                     `report_version` bigint DEFAULT '0' COMMENT '报告版本',
                                     `report_count` bigint DEFAULT '0' COMMENT '报告次数',
                                     `config_key` varchar(100) DEFAULT NULL COMMENT '配置id',
                                     `proxy_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '代理名称',
                                     `proxy_desc` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '代理描述描述',
                                     `proxy_version` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '代理版本',
                                     `proxy_host` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '代理IP',
                                     `proxy_port` int DEFAULT NULL COMMENT '代理Port',
                                     `cpu_load` double DEFAULT '0' COMMENT 'cpu负载',
                                     `jvm_mem_max` bigint DEFAULT '0' COMMENT 'jvm内存总数',
                                     `jvm_mem_total` bigint DEFAULT '0' COMMENT 'jvm内存总数',
                                     `jvm_mem_free` bigint DEFAULT '0' COMMENT 'jvm空闲内存',
                                     `thread_active` int DEFAULT '0' COMMENT '活跃线程',
                                     `thread_peak` int DEFAULT '0' COMMENT '峰值线程',
                                     `thread_daemon` int DEFAULT '0' COMMENT '守护线程',
                                     `thread_started` bigint DEFAULT '0' COMMENT '累计启动线程',
                                     `client_num` bigint DEFAULT '0' COMMENT '客户端数量',
                                     `client_conn_num` bigint DEFAULT '0' COMMENT '客户端连接数量',
                                     `mysql_num` int DEFAULT '0' COMMENT 'mysql数量',
                                     `mysql_busy_conn_num` bigint DEFAULT '0' COMMENT 'mysql忙连接数',
                                     `mysql_idle_conn_num` bigint DEFAULT '0' COMMENT 'mysql闲连接数',
                                     `schema_stats_num` bigint DEFAULT '0' COMMENT 'schema统计条数',
                                     `insert_num` bigint DEFAULT '0' COMMENT 'insert计数',
                                     `update_num` bigint DEFAULT '0' COMMENT 'update计数',
                                     `delete_num` bigint DEFAULT '0' COMMENT 'delete计数',
                                     `select_num` bigint DEFAULT '0' COMMENT 'select计数',
                                     `other_num` bigint DEFAULT '0' COMMENT 'other计数',
                                     `insert_error_num` bigint DEFAULT '0' COMMENT 'insert错误计数',
                                     `update_error_num` bigint DEFAULT '0' COMMENT 'update错误计数',
                                     `delete_error_num` bigint DEFAULT '0' COMMENT 'delete错误计数',
                                     `select_error_num` bigint DEFAULT '0' COMMENT 'select错误计数',
                                     `other_error_num` bigint DEFAULT '0' COMMENT 'other错误计数',
                                     `insert_exe_millis` bigint DEFAULT '0' COMMENT 'insert执行时间',
                                     `update_exe_millis` bigint DEFAULT '0' COMMENT 'update执行时间',
                                     `delete_exe_millis` bigint DEFAULT '0' COMMENT 'delete执行时间',
                                     `select_exe_millis` bigint DEFAULT '0' COMMENT 'select执行时间',
                                     `other_exe_millis` bigint DEFAULT '0' COMMENT 'other执行时间',
                                     `insert_row_num` bigint DEFAULT '0' COMMENT 'insert行数',
                                     `update_row_num` bigint DEFAULT '0' COMMENT 'update行数',
                                     `delete_row_num` bigint DEFAULT '0' COMMENT 'delete行数',
                                     `select_row_num` bigint DEFAULT '0' COMMENT 'select行数',
                                     `other_row_num` bigint DEFAULT '0' COMMENT 'other行数',
                                     `insert_tx_bytes` bigint DEFAULT '0' COMMENT 'insert发送字节',
                                     `insert_rx_bytes` bigint DEFAULT '0' COMMENT 'insert接收字节',
                                     `update_tx_bytes` bigint DEFAULT '0' COMMENT 'update发送字节',
                                     `update_rx_bytes` bigint DEFAULT '0' COMMENT 'update接收字节',
                                     `delete_tx_bytes` bigint DEFAULT '0' COMMENT 'delete发送字节',
                                     `delete_rx_bytes` bigint DEFAULT '0' COMMENT 'delete接收字节',
                                     `select_tx_bytes` bigint DEFAULT '0' COMMENT 'select发送字节',
                                     `select_rx_bytes` bigint DEFAULT '0' COMMENT 'select接收字节',
                                     `other_tx_bytes` bigint DEFAULT '0' COMMENT 'other发送字节',
                                     `other_rx_bytes` bigint DEFAULT '0' COMMENT 'other接收字节',
                                     `create_date` datetime(3) NOT NULL COMMENT '创建日期',
                                     `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                                     `last_update` datetime(3) NOT NULL COMMENT '最后更新时间',
                                     `state` int NOT NULL COMMENT '状态。1正常-1标记删除',
                                     PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='mydb代理信息';


-- uw_mydb.mydb_proxy_stats definition

CREATE TABLE `mydb_proxy_stats` (
                                    `id` bigint NOT NULL COMMENT 'id',
                                    `proxy_id` bigint NOT NULL COMMENT 'proxyId',
                                    `report_version` bigint DEFAULT '0' COMMENT '报告版本',
                                    `report_count` bigint DEFAULT '0' COMMENT '报告次数',
                                    `config_key` varchar(100) DEFAULT NULL COMMENT '配置id',
                                    `proxy_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '代理名称',
                                    `proxy_desc` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '代理描述描述',
                                    `proxy_version` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '代理版本',
                                    `proxy_host` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '代理IP',
                                    `proxy_port` int DEFAULT NULL COMMENT '代理Port',
                                    `cpu_load` double DEFAULT '0' COMMENT 'cpu负载',
                                    `jvm_mem_max` bigint DEFAULT '0' COMMENT 'jvm内存总数',
                                    `jvm_mem_total` bigint DEFAULT '0' COMMENT 'jvm内存总数',
                                    `jvm_mem_free` bigint DEFAULT '0' COMMENT 'jvm空闲内存',
                                    `thread_active` int DEFAULT '0' COMMENT '活跃线程',
                                    `thread_peak` int DEFAULT '0' COMMENT '峰值线程',
                                    `thread_daemon` int DEFAULT '0' COMMENT '守护线程',
                                    `thread_started` bigint DEFAULT '0' COMMENT '累计启动线程',
                                    `client_num` bigint DEFAULT '0' COMMENT '客户端数量',
                                    `client_conn_num` bigint DEFAULT '0' COMMENT '客户端连接数量',
                                    `mysql_num` int DEFAULT '0' COMMENT 'mysql数量',
                                    `mysql_busy_conn_num` bigint DEFAULT '0' COMMENT 'mysql忙连接数',
                                    `mysql_idle_conn_num` bigint DEFAULT '0' COMMENT 'mysql闲连接数',
                                    `schema_stats_num` bigint DEFAULT '0' COMMENT 'schema统计条数',
                                    `insert_num` bigint DEFAULT '0' COMMENT 'insert计数',
                                    `update_num` bigint DEFAULT '0' COMMENT 'update计数',
                                    `delete_num` bigint DEFAULT '0' COMMENT 'delete计数',
                                    `select_num` bigint DEFAULT '0' COMMENT 'select计数',
                                    `other_num` bigint DEFAULT '0' COMMENT 'other计数',
                                    `insert_error_num` bigint DEFAULT '0' COMMENT 'insert错误计数',
                                    `update_error_num` bigint DEFAULT '0' COMMENT 'update错误计数',
                                    `delete_error_num` bigint DEFAULT '0' COMMENT 'delete错误计数',
                                    `select_error_num` bigint DEFAULT '0' COMMENT 'select错误计数',
                                    `other_error_num` bigint DEFAULT '0' COMMENT 'other错误计数',
                                    `insert_exe_millis` bigint DEFAULT '0' COMMENT 'insert执行时间',
                                    `update_exe_millis` bigint DEFAULT '0' COMMENT 'update执行时间',
                                    `delete_exe_millis` bigint DEFAULT '0' COMMENT 'delete执行时间',
                                    `select_exe_millis` bigint DEFAULT '0' COMMENT 'select执行时间',
                                    `other_exe_millis` bigint DEFAULT '0' COMMENT 'other执行时间',
                                    `insert_row_num` bigint DEFAULT '0' COMMENT 'insert行数',
                                    `update_row_num` bigint DEFAULT '0' COMMENT 'update行数',
                                    `delete_row_num` bigint DEFAULT '0' COMMENT 'delete行数',
                                    `select_row_num` bigint DEFAULT '0' COMMENT 'select行数',
                                    `other_row_num` bigint DEFAULT '0' COMMENT 'other行数',
                                    `insert_tx_bytes` bigint DEFAULT '0' COMMENT 'insert发送字节',
                                    `insert_rx_bytes` bigint DEFAULT '0' COMMENT 'insert接收字节',
                                    `update_tx_bytes` bigint DEFAULT '0' COMMENT 'update发送字节',
                                    `update_rx_bytes` bigint DEFAULT '0' COMMENT 'update接收字节',
                                    `delete_tx_bytes` bigint DEFAULT '0' COMMENT 'delete发送字节',
                                    `delete_rx_bytes` bigint DEFAULT '0' COMMENT 'delete接收字节',
                                    `select_tx_bytes` bigint DEFAULT '0' COMMENT 'select发送字节',
                                    `select_rx_bytes` bigint DEFAULT '0' COMMENT 'select接收字节',
                                    `other_tx_bytes` bigint DEFAULT '0' COMMENT 'other发送字节',
                                    `other_rx_bytes` bigint DEFAULT '0' COMMENT 'other接收字节',
                                    `create_date` datetime(3) NOT NULL COMMENT '创建日期',
                                    `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                                    `last_update` datetime(3) NOT NULL COMMENT '最后更新时间',
                                    `state` int NOT NULL COMMENT '状态。1正常-1标记删除',
                                    PRIMARY KEY (`id`),
                                    KEY `mydb_proxy_stats_proxy_id_IDX` (`proxy_id`,`last_update`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='mydb代理统计';


-- uw_mydb.mydb_sql_error definition

CREATE TABLE `mydb_sql_error` (
                                  `id` bigint NOT NULL COMMENT 'id',
                                  `proxy_id` bigint DEFAULT NULL COMMENT 'proxyId',
                                  `cluster_id` bigint DEFAULT NULL COMMENT 'clusterId',
                                  `server_id` bigint DEFAULT NULL COMMENT 'serverId',
                                  `db_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '数据库',
                                  `table_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '表',
                                  `sql_info` varchar(4000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'sql',
                                  `sql_type` int DEFAULT NULL COMMENT 'sql类型',
                                  `row_num` int DEFAULT NULL COMMENT '行数',
                                  `tx_bytes` bigint DEFAULT NULL COMMENT '发送字节数',
                                  `rx_bytes` bigint DEFAULT NULL COMMENT '接收字节数',
                                  `exe_millis` bigint DEFAULT NULL COMMENT '执行耗时',
                                  `run_date` datetime(3) DEFAULT NULL COMMENT '运行时间',
                                  `error_code` varchar(20) DEFAULT NULL COMMENT '错误码',
                                  `error_msg` varchar(2000) DEFAULT NULL COMMENT '错误信息',
                                  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='mydb错误SQL';


-- uw_mydb.mydb_sql_slow definition

CREATE TABLE `mydb_sql_slow` (
                                 `id` bigint NOT NULL COMMENT 'id',
                                 `proxy_id` bigint DEFAULT NULL COMMENT 'proxyId',
                                 `cluster_id` bigint DEFAULT NULL COMMENT 'clusterId',
                                 `server_id` bigint DEFAULT NULL COMMENT 'serverId',
                                 `db_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '数据库',
                                 `table_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '表',
                                 `sql_info` varchar(4000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'sql',
                                 `sql_type` int DEFAULT NULL COMMENT 'sql类型',
                                 `row_num` int DEFAULT NULL COMMENT '行数',
                                 `tx_bytes` bigint DEFAULT NULL COMMENT '发送字节数',
                                 `rx_bytes` bigint DEFAULT NULL COMMENT '接收字节数',
                                 `exe_millis` bigint DEFAULT NULL COMMENT '执行耗时',
                                 `run_date` datetime(3) DEFAULT NULL COMMENT '运行时间',
                                 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='mydb慢SQL';


-- uw_mydb.sys_crit_log definition

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


-- uw_mydb.sys_data_history definition

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


-- uw_mydb.sys_seq definition

CREATE TABLE `sys_seq` (
                           `seq_name` varchar(200) NOT NULL,
                           `seq_id` bigint DEFAULT NULL,
                           `seq_desc` varchar(200) DEFAULT NULL,
                           `increment_num` int DEFAULT NULL,
                           `create_date` datetime DEFAULT NULL,
                           `last_update` datetime(3) DEFAULT NULL,
                           PRIMARY KEY (`seq_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='表主键自增位置标记';

INSERT INTO mydb_mysql_cluster (id,cluster_name,cluster_desc,cluster_type,switch_type,create_date,modify_date,state) VALUES
    (1,'#{MYSQL_HOST}:#{MYSQL_PORT}','',0,0,'2023-10-30 00:00:00',NULL,1);

INSERT INTO mydb_mysql_server (id,cluster_id,server_type,server_host,server_port,server_user,server_pass,server_weight,conn_min,conn_max,conn_idle_timeout,conn_busy_timeout,conn_max_age,create_date,modify_date,state) VALUES
    (1,1,1,'#{MYSQL_HOST}',#{MYSQL_PORT},'#{MYSQL_ROOT_USERNAME}','#{MYSQL_ROOT_PASSWORD}',1,1,10000,600,1800,3600,'2023-10-30 00:00:00',NULL,1);

INSERT INTO `sys_seq` VALUES ('MydbMysqlCluster',1,'MscUser',1,'2023-10-01 00:00:00','2023-10-01 00:00:00.000'),
     ('MydbMysqlServer',6,'MscUserPerm',1,'2023-10-01 00:00:00','2023-10-01 00:00:00.000');