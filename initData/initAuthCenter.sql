/*!50503 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS `uw_auth` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `uw_auth`;

-- uw_auth.msc_app definition

CREATE TABLE `msc_app` (
                           `id` bigint NOT NULL COMMENT '主键',
                           `app_name` varchar(255) NOT NULL COMMENT '应用名称',
                           `app_label` varchar(255) DEFAULT NULL COMMENT '应用显示名称',
                           `app_version` varchar(255) DEFAULT NULL COMMENT '应用版本',
                           `app_rank` int NOT NULL DEFAULT '0' COMMENT '应用显示顺序',
                           `remark` varchar(255) DEFAULT NULL COMMENT '备注',
                           `perm_num` int NOT NULL DEFAULT '0' COMMENT '权限数量',
                           `run_host` int DEFAULT '0' COMMENT '运行主机数量',
                           `run_thread` int DEFAULT NULL COMMENT '运行线程数',
                           `run_mem` bigint DEFAULT NULL COMMENT '运行内存数',
                           `run_user` int DEFAULT NULL COMMENT '运行用户数',
                           `run_access` bigint DEFAULT NULL COMMENT '运行访问数',
                           `create_date` datetime(3) DEFAULT NULL COMMENT '创建时间',
                           `modify_date` datetime DEFAULT NULL COMMENT '修改时间',
                           `last_update` datetime(3) NOT NULL COMMENT '最后更新时间',
                           `display_state` int NOT NULL DEFAULT '1' COMMENT '是否显示0不显示 1显示 2 VIP',
                           `state` int NOT NULL COMMENT '应用状态1: 上线; 0: 下线 -1:删除',
                           PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='MSC应用';


-- uw_auth.msc_app_host definition

CREATE TABLE `msc_app_host` (
                                `id` bigint NOT NULL COMMENT '主键',
                                `app_id` bigint DEFAULT NULL COMMENT 'appId',
                                `app_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '应用名称',
                                `app_version` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '应用版本',
                                `app_host` varchar(100) DEFAULT NULL COMMENT 'app主机',
                                `app_port` int DEFAULT NULL COMMENT 'app端口',
                                `user_rpc_num` int DEFAULT NULL COMMENT '在线rpc户数',
                                `user_root_num` int DEFAULT NULL COMMENT '在线root数',
                                `user_ops_num` int DEFAULT NULL COMMENT '在线ops数',
                                `user_admin_num` int DEFAULT NULL COMMENT '在线admin数',
                                `user_saas_num` int DEFAULT NULL COMMENT '在线saas用户',
                                `user_guest_num` int DEFAULT NULL COMMENT '在线会员数',
                                `access_count` bigint DEFAULT NULL COMMENT '访问计数',
                                `jvm_mem_max` bigint DEFAULT NULL COMMENT 'jvm内存总数',
                                `jvm_mem_total` bigint DEFAULT NULL COMMENT 'jvm内存总数',
                                `jvm_mem_free` bigint DEFAULT NULL COMMENT 'jvm空闲内存',
                                `thread_active` int DEFAULT NULL COMMENT '活跃线程',
                                `thread_peak` int DEFAULT NULL COMMENT '峰值线程',
                                `thread_daemon` int DEFAULT NULL COMMENT '守护线程',
                                `thread_started` bigint DEFAULT NULL COMMENT '累计启动线程',
                                `create_date` datetime(3) DEFAULT NULL COMMENT '创建时间',
                                `modify_date` datetime DEFAULT NULL COMMENT '修改时间',
                                `last_update` datetime(3) NOT NULL COMMENT '最后更新时间',
                                `state` int NOT NULL COMMENT '应用状态1: 上线; 0: 下线 -1:删除',
                                PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='MSC应用主机';


-- uw_auth.msc_metrics definition

CREATE TABLE `msc_metrics` (
                               `id` bigint DEFAULT NULL COMMENT 'id',
                               `stats_date` datetime(3) DEFAULT NULL COMMENT '创建日期',
                               `login_limit` int DEFAULT '0' COMMENT '登录峰值指数',
                               `user_active` int DEFAULT '0' COMMENT '在线用户峰值',
                               `user_logon` int DEFAULT '0' COMMENT '登录用户峰值',
                               `invalid_token` int DEFAULT '0' COMMENT '非法token峰值',
                               `login_success` int DEFAULT '0' COMMENT '登录成功',
                               `login_fail` int DEFAULT '0' COMMENT '登录失败',
                               `login_captcha` int DEFAULT '0' COMMENT 'captcha计数',
                               `login_captcha_success` int DEFAULT '0' COMMENT 'captcha成功',
                               `login_captcha_fail` int DEFAULT '0' COMMENT 'captcha失败',
                               `login_code` int DEFAULT '0' COMMENT '验证码',
                               `login_code_success` int DEFAULT '0' COMMENT '验证码成功',
                               `login_code_fail` int DEFAULT '0' COMMENT '验证码失败',
                               `token_refresh_success` int DEFAULT '0' COMMENT '刷新成功',
                               `token_refresh_fail` int DEFAULT '0' COMMENT '刷新失败',
                               `token_logout` int DEFAULT '0' COMMENT '登出',
                               `token_double` int DEFAULT '0' COMMENT '双登',
                               `token_kickout` int DEFAULT '0' COMMENT '踢出',
                               `guest_login_success` int DEFAULT '0' COMMENT '客户登录成功',
                               `guest_login_fail` int DEFAULT '0' COMMENT '客户登录错误',
                               `guest_refresh_success` int DEFAULT '0' COMMENT '客户刷新成功',
                               `guest_refresh_fail` int DEFAULT '0' COMMENT '客户刷新失败',
                               `guest_logout` int DEFAULT '0' COMMENT '客户登出',
                               `guest_double` int DEFAULT '0' COMMENT '客户双登',
                               `guest_kickout` int DEFAULT '0' COMMENT '客户踢出',
                               `new_saas` int DEFAULT '0' COMMENT '新增saas',
                               `new_group` int DEFAULT '0' COMMENT '新增组',
                               `new_user` int DEFAULT '0' COMMENT '新增用户',
                               `run_app` int DEFAULT '0' COMMENT '运行应用数',
                               `run_host` int DEFAULT '0' COMMENT '运行主机数',
                               `run_thread` int DEFAULT NULL COMMENT '运行线程数',
                               `run_mem` bigint DEFAULT '0' COMMENT '运行内存数',
                               `run_user` int DEFAULT '0' COMMENT '运行用户数',
                               `run_access` bigint DEFAULT '0' COMMENT '主机访问数'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='MSC实时指标信息';

-- uw_auth.msc_oauth_info definition

CREATE TABLE `msc_oauth_info` (
                                  `id` bigint NOT NULL COMMENT 'ID',
                                  `saas_id` bigint NOT NULL COMMENT '运营商Id',
                                  `user_id` bigint NOT NULL COMMENT '本地用户ID',
                                  `provider_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '三方平台标识（如：google、wechat、github、alipay、weibo、apple）',
                                  `open_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '三方平台用户ID',
                                  `union_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '三方平台统一ID',
                                  `username` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户名',
                                  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户头像',
                                  `gender` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '性别',
                                  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'email地址',
                                  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '电话号码',
                                  `area` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '地区',
                                  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '地址',
                                  `raw_user_info` json DEFAULT NULL COMMENT '用户信息',
                                  `last_login_date` datetime(3) DEFAULT NULL COMMENT '最近登录时间',
                                  `last_login_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新时间',
                                  `logon_count` int DEFAULT '0' COMMENT '登录次数',
                                  `create_date` datetime(3) NOT NULL COMMENT '建立时间',
                                  `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                  `bind_date` datetime(3) DEFAULT NULL COMMENT '创建时间',
                                  `unbind_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                                  `state` int NOT NULL COMMENT '状态',
                                  PRIMARY KEY (`id`),
                                  KEY `idx_user_id` (`user_id`),
                                  KEY `idx_provider_user` (`open_id`,`provider_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='MSC三方登录信息';

-- uw_auth.msc_perm definition

CREATE TABLE `msc_perm` (
                            `id` bigint NOT NULL COMMENT '主键',
                            `app_id` bigint NOT NULL COMMENT '应用 app_id',
                            `perm_name` varchar(200) DEFAULT NULL COMMENT '应用权限名称',
                            `perm_desc` varchar(255) DEFAULT NULL COMMENT '应用权限描述',
                            `user_type` int DEFAULT NULL COMMENT '权限类型',
                            `perm_level` int DEFAULT NULL COMMENT '权限等级：1分类2分类菜单3菜单4权限',
                            `perm_code` varchar(255) NOT NULL COMMENT '应用权限描述值: URI or 资源Id',
                            `license_code` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '授权Key',
                            `perm_rank` bigint DEFAULT NULL COMMENT '权限排序，管理显示用',
                            `create_date` datetime(3) DEFAULT NULL COMMENT '创建日期',
                            `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                            `display_state` int NOT NULL DEFAULT '1' COMMENT '是否显示0不显示 1显示 2 VIP',
                            `state` tinyint NOT NULL COMMENT '-1: 删除; 0: 冻结; 1: 启用',
                            PRIMARY KEY (`id`),
                            KEY `msc_perm_app_id_index` (`app_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='MSC权限';


-- uw_auth.msc_saas_perm definition

CREATE TABLE `msc_saas_perm` (
                                 `id` bigint NOT NULL COMMENT '运营商Id',
                                 `saas_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '系统名',
                                 `saas_host` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '运营商域名',
                                 `saas_perm` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT 'SAAS权限',
                                 `saas_config` json DEFAULT NULL COMMENT 'SAAS配置',
                                 `user_limit` int DEFAULT '1' COMMENT '用户数限制',
                                 `user_num` int DEFAULT '0' COMMENT '用户数',
                                 `user_mch_num` int DEFAULT '0' COMMENT '商户用户数',
                                 `create_date` datetime(3) NOT NULL COMMENT '创建时间',
                                 `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                 `state` int NOT NULL COMMENT '状态值: -1: 删除 0: 冻结 1: 正常',
                                 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='MSC运营商权限';


-- uw_auth.msc_stats definition

CREATE TABLE `msc_stats` (
                             `id` bigint DEFAULT NULL COMMENT 'id',
                             `reporter_info` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '报告者信息',
                             `stats_date` datetime(3) DEFAULT NULL COMMENT '创建日期',
                             `msc_app` int DEFAULT '0' COMMENT 'msc_app数量',
                             `msc_perm` int DEFAULT '0' COMMENT 'msc_perm数量',
                             `all_saas` int DEFAULT '0' COMMENT 'saas数量',
                             `all_group` int DEFAULT '0' COMMENT '用户组数量',
                             `all_user` int DEFAULT '0' COMMENT '用户数量',
                             `user_root` int DEFAULT '0' COMMENT 'root用户数量',
                             `user_admin` int DEFAULT '0' COMMENT '管理员用户数量',
                             `user_rpc` int DEFAULT '0' COMMENT 'rpc用户数量',
                             `user_ops` int DEFAULT '0' COMMENT 'ops用户数量',
                             `user_saas` int DEFAULT '0' COMMENT 'saas用户数量',
                             `user_mch` int DEFAULT '0' COMMENT 'saas商户数量',
                             `user_active_max` int DEFAULT '0' COMMENT '活跃用户峰值',
                             `user_logon_max` int DEFAULT '0' COMMENT '登录用户峰值',
                             `invalid_token_max` int DEFAULT '0' COMMENT '非法token峰值',
                             `login_limit_max` int DEFAULT '0' COMMENT '登录峰值指数',
                             `log_action_success` bigint DEFAULT '0' COMMENT '用户操作错误计数',
                             `log_action_fail` bigint DEFAULT '0' COMMENT '用户操作错误计数',
                             `login_success` int DEFAULT '0' COMMENT '登录成功',
                             `login_fail` int DEFAULT '0' COMMENT '登录失败',
                             `login_captcha` int DEFAULT '0' COMMENT 'captcha计数',
                             `login_captcha_success` int DEFAULT '0' COMMENT 'captcha成功',
                             `login_captcha_fail` int DEFAULT '0' COMMENT 'captcha失败',
                             `login_code` int DEFAULT '0' COMMENT '验证码',
                             `login_code_success` int DEFAULT '0' COMMENT '验证码成功',
                             `login_code_fail` int DEFAULT '0' COMMENT '验证码失败',
                             `token_refresh_success` int DEFAULT '0' COMMENT '刷新成功',
                             `token_refresh_fail` int DEFAULT '0' COMMENT '刷新失败',
                             `token_logout` int DEFAULT '0' COMMENT '登出',
                             `token_double` int DEFAULT '0' COMMENT '双登',
                             `token_kickout` int DEFAULT '0' COMMENT '踢出',
                             `guest_login_success` int DEFAULT '0' COMMENT '客户登录成功',
                             `guest_login_fail` int DEFAULT '0' COMMENT '客户登录错误数',
                             `guest_refresh_success` int DEFAULT '0' COMMENT '客户刷新成功',
                             `guest_refresh_fail` int DEFAULT '0' COMMENT '客户刷新失败',
                             `guest_logout` int DEFAULT '0' COMMENT '客户登出',
                             `guest_double` int DEFAULT '0' COMMENT '客户双登',
                             `guest_kickout` int DEFAULT '0' COMMENT '客户踢出',
                             `new_saas` int DEFAULT '0' COMMENT '新增saas',
                             `new_group` int DEFAULT '0' COMMENT '新增组',
                             `new_user` int DEFAULT '0' COMMENT '新增用户',
                             `run_app` int DEFAULT '0' COMMENT '运行应用数',
                             `run_host` int DEFAULT '0' COMMENT '运行主机数',
                             `run_thread` int DEFAULT NULL COMMENT '运行线程数',
                             `run_mem` bigint DEFAULT '0' COMMENT '运行内存数',
                             `run_user` int DEFAULT '0' COMMENT '运行用户数',
                             `run_access` bigint DEFAULT '0' COMMENT '主机访问数'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='MSC日统计信息';


-- uw_auth.msc_user definition

CREATE TABLE `msc_user` (
                            `id` bigint NOT NULL COMMENT '用户Id',
                            `saas_id` bigint NOT NULL COMMENT '运营商Id',
                            `user_type` int NOT NULL COMMENT '用户类型',
                            `mch_id` bigint DEFAULT NULL COMMENT '商户编号',
                            `group_id` bigint DEFAULT NULL COMMENT '所属用户组ID',
                            `is_master` int DEFAULT '0' COMMENT '是否管理员',
                            `username` varchar(100) NOT NULL COMMENT '登录名称',
                            `password` varchar(100) NOT NULL COMMENT '登录密码',
                            `real_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '真实名称',
                            `nick_name` varchar(100) DEFAULT NULL COMMENT '别名 [用于业务前台匿名]',
                            `mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '手机号码',
                            `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT 'email',
                            `wx_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '微信ID',
                            `gender` int DEFAULT '-1' COMMENT '性别-1未知0女1男',
                            `area_code` bigint DEFAULT NULL COMMENT '地区',
                            `id_type` int DEFAULT NULL COMMENT '证件类型',
                            `id_info` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '证件信息',
                            `user_icon` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户头像',
                            `user_grade` int DEFAULT '0' COMMENT '用户级别',
                            `auth_flag` int DEFAULT NULL COMMENT '验证标识',
                            `auth_secret` varchar(100) DEFAULT NULL COMMENT '验证密钥',
                            `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
                            `last_passwd_date` datetime(3) DEFAULT NULL COMMENT '最后更新密码时间',
                            `last_logon_type` int DEFAULT NULL COMMENT '最后登录类型',
                            `last_logon_date` datetime(3) DEFAULT NULL COMMENT '最后登录时间',
                            `last_logon_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '最后登录ip',
                            `logon_count` int DEFAULT '0' COMMENT '登录次数',
                            `create_date` datetime(3) NOT NULL COMMENT '创建日期',
                            `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                            `state` int NOT NULL COMMENT '状态：-1: 删除 0: 冻结 1: 正常',
                            PRIMARY KEY (`id`),
                            KEY `msc_user_username_IDX` (`username`) USING BTREE,
                            KEY `msc_user_mobile_IDX` (`mobile`) USING BTREE,
                            KEY `msc_user_email_IDX` (`email`) USING BTREE,
                            KEY `msc_user_wx_id_IDX` (`wx_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='MSC用户';


-- uw_auth.msc_user_group definition

CREATE TABLE `msc_user_group` (
                                  `id` bigint NOT NULL COMMENT '主键',
                                  `saas_id` bigint NOT NULL COMMENT '运营商编号。0为全局权限。',
                                  `mch_id` bigint DEFAULT NULL COMMENT '商户编号。0运营商1默认供应商2默认分销商',
                                  `user_type` int DEFAULT NULL COMMENT '用户类型',
                                  `group_name` varchar(100) DEFAULT NULL COMMENT '分组名称',
                                  `group_desc` varchar(500) DEFAULT NULL COMMENT '分组描述',
                                  `group_perm` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '分组默认权限',
                                  `group_config` json DEFAULT NULL COMMENT '分组默认配置',
                                  `user_num` int DEFAULT '0' COMMENT '用户数',
                                  `create_date` datetime(3) NOT NULL COMMENT '创建时间',
                                  `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                  `state` int NOT NULL COMMENT '状态值: -1: 删除 0: 冻结 1: 正常',
                                  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='MSC用户组';


-- uw_auth.msc_user_perm definition

CREATE TABLE `msc_user_perm` (
                                 `id` bigint NOT NULL COMMENT 'id',
                                 `saas_id` bigint DEFAULT NULL COMMENT 'saasId',
                                 `user_perm` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '用户权限ID列表',
                                 `user_config` json DEFAULT NULL COMMENT '用户资源权限json',
                                 `create_date` datetime(3) NOT NULL COMMENT '创建时间',
                                 `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                 `state` int NOT NULL COMMENT '状态值: -1: 删除 0: 冻结 1: 正常',
                                 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='MSC用户权限';


-- uw_auth.sys_crit_log definition

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


-- uw_auth.sys_data_history definition

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


-- uw_auth.sys_seq definition

CREATE TABLE `sys_seq` (
                           `seq_name` varchar(200) NOT NULL,
                           `seq_id` bigint DEFAULT NULL,
                           `seq_desc` varchar(200) DEFAULT NULL,
                           `increment_num` int DEFAULT NULL,
                           `create_date` datetime DEFAULT NULL,
                           `last_update` datetime(3) DEFAULT NULL,
                           PRIMARY KEY (`seq_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='表主键自增位置标记';


INSERT INTO `msc_saas_perm` VALUES (0,'系统平台',NULL,NULL,NULL,0,0,0,'2023-10-01 00:00:00.000',NULL,1);

INSERT INTO `msc_user` VALUES (1,0,100,0,0,1,'#{MSC_ROOT_USERNAME}','#{MSC_ROOT_PASSWORD_BCRYPT}','超级管理员','root',NULL,NULL,NULL,1,0,0,NULL,NULL,0,NULL,NULL,NULL,'2023-10-01 00:00:00.000',0,'2023-10-01 00:00:00.000','',0,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',1),
                              (2,0,10,0,0,1,'#{MSC_RPC_USERNAME}','#{MSC_RPC_PASSWORD_BCRYPT}','rpc','rpc','','','',1,0,0,NULL,NULL,0,NULL,NULL,NULL,'2023-10-01 00:00:00.000',0,'2023-10-01 00:00:00.000',NULL,0,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',1),
                              (3,0,110,0,0,1,'#{MSC_OPS_USERNAME}','#{MSC_OPS_PASSWORD_BCRYPT}','ops','ops','','','',1,0,0,NULL,NULL,0,NULL,NULL,NULL,'2023-10-01 00:00:00.000',0,'2023-10-01 00:00:00.000',NULL,0,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',1),
                              (5,0,200,0,0,1,'#{MSC_ADMIN_USERNAME}','#{MSC_ADMIN_PASSWORD_BCRYPT}','平台管理员','平台管理员','','','',1,0,0,NULL,NULL,0,NULL,NULL,NULL,'2023-10-01 00:00:00.000',0,'2023-10-01 00:00:00.000',NULL,0,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',1);
INSERT INTO `msc_user_perm` VALUES (1,0,NULL,NULL,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',1),
                                   (2,0,NULL,NULL,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',1),
                                   (3,0,NULL,NULL,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',1),
                                   (5,0,NULL,NULL,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000',1);

INSERT INTO `sys_seq` VALUES ('MscUser',6,'MscUser',1,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000'),
                             ('MscUserPerm',6,'MscUserPerm',1,'2023-10-01 00:00:00.000','2023-10-01 00:00:00.000');