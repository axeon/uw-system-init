/*!50503 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS `saas_base` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `saas_base`;

-- saas_base.aip_ad_info definition

CREATE TABLE `aip_ad_info` (
                               `id` bigint NOT NULL COMMENT '主键',
                               `saas_id` bigint DEFAULT NULL COMMENT '运营商id',
                               `space_id` bigint DEFAULT NULL COMMENT '广告位id',
                               `space_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '分类代码',
                               `ad_title` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '主标题',
                               `sub_title` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '副标题（可以不输入）',
                               `ad_link` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '对应链接',
                               `ad_img` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '对应图片',
                               `rank_order` int DEFAULT NULL COMMENT '推荐值',
                               `click_num` bigint DEFAULT NULL COMMENT '点击数',
                               `expire_date` datetime(3) DEFAULT NULL COMMENT '到期时间',
                               `create_date` datetime(3) DEFAULT NULL COMMENT '创建时间',
                               `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                               `state` int NOT NULL COMMENT '状态',
                               PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='AIP广告';


-- saas_base.aip_ad_space definition

CREATE TABLE `aip_ad_space` (
                                `id` bigint NOT NULL COMMENT '主键',
                                `saas_id` bigint DEFAULT NULL COMMENT '运营商id',
                                `space_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '分类代码',
                                `space_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '分类名称',
                                `space_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '分类描述',
                                `create_date` datetime(3) NOT NULL COMMENT '创建时间',
                                `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                `state` int NOT NULL COMMENT '状态',
                                PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='AIP广告位';


-- saas_base.aip_balance_info definition

CREATE TABLE `aip_balance_info` (
                                    `id` bigint NOT NULL COMMENT 'id',
                                    `saas_id` bigint NOT NULL COMMENT 'saasId',
                                    `currency` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '币种类型',
                                    `deposit_balance` bigint NOT NULL DEFAULT '0' COMMENT '预存余额',
                                    `deposit_sum_recharge` bigint NOT NULL DEFAULT '0' COMMENT '存款总充值金额',
                                    `deposit_sum_recharge_refund` bigint NOT NULL DEFAULT '0' COMMENT '存款总充值退款',
                                    `deposit_sum_consume` bigint NOT NULL DEFAULT '0' COMMENT '存款总消费金额',
                                    `deposit_sum_consume_refund` bigint NOT NULL DEFAULT '0' COMMENT '存款总消费退款',
                                    `order_num` int DEFAULT '0' COMMENT '已售数量',
                                    `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                    `last_recharge_date` datetime(3) DEFAULT NULL COMMENT '最近充值时间',
                                    `last_consume_date` datetime(3) DEFAULT NULL COMMENT '最近消费时间',
                                    `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                    `state` int NOT NULL COMMENT '状态',
                                    PRIMARY KEY (`id`,`saas_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='AIP余额';


-- saas_base.aip_balance_log definition

CREATE TABLE `aip_balance_log` (
                                   `id` bigint NOT NULL COMMENT 'ID',
                                   `parent_id` bigint NOT NULL DEFAULT '0' COMMENT '父ID',
                                   `saas_id` bigint NOT NULL COMMENT 'SaasId',
                                   `currency` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '币种类型',
                                   `biz_order_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '应用订单类型',
                                   `biz_order_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '应用订单号',
                                   `biz_order_ext` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '应用订单扩展信息',
                                   `biz_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '业务备注',
                                   `pay_info_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '支付id',
                                   `balance_type` int DEFAULT NULL COMMENT '余额类型',
                                   `deal_type` int DEFAULT NULL COMMENT '交易类型',
                                   `deal_amount` bigint DEFAULT NULL COMMENT '交易金额',
                                   `deal_refund` bigint DEFAULT NULL COMMENT '交易退款',
                                   `deal_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '交易备注',
                                   `user_id` bigint DEFAULT NULL COMMENT '用户ID',
                                   `user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户IP',
                                   `user_info` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户名',
                                   `audit_user_id` bigint DEFAULT NULL COMMENT '审批人ID',
                                   `audit_user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审批人IP',
                                   `audit_user_info` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '操作人名',
                                   `audit_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审批备注',
                                   `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                   `audit_date` datetime(3) DEFAULT NULL COMMENT '审批时间',
                                   `deal_date` datetime(3) DEFAULT NULL COMMENT '完成时间',
                                   `state` int DEFAULT NULL COMMENT '状态',
                                   `bill_state` int DEFAULT NULL COMMENT '对账状态',
                                   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='AIP余额日志';


-- saas_base.aip_coupon_info definition

CREATE TABLE `aip_coupon_info` (
                                   `id` bigint NOT NULL COMMENT '主键ID',
                                   `coupon_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '优惠券名称',
                                   `coupon_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '优惠券描述',
                                   `coupon_rank` int DEFAULT NULL COMMENT '排序',
                                   `coupon_type` int DEFAULT NULL COMMENT '优惠券类型',
                                   `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                   `modify_date` datetime(3) DEFAULT NULL COMMENT '更新时间',
                                   `state` int NOT NULL COMMENT '状态',
                                   PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='AIP优惠券';


-- saas_base.aip_coupon_log definition

CREATE TABLE `aip_coupon_log` (
                                  `id` bigint NOT NULL COMMENT '主键ID',
                                  `saas_id` bigint DEFAULT NULL COMMENT 'saasId',
                                  `coupon_id` bigint DEFAULT NULL COMMENT '优惠券id',
                                  `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                  `modify_date` datetime(3) DEFAULT NULL COMMENT '更新时间',
                                  `state` int NOT NULL COMMENT '状态',
                                  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='AIP优惠券日志';


-- saas_base.aip_invoice_info definition

CREATE TABLE `aip_invoice_info` (
                                    `id` bigint NOT NULL COMMENT '主键ID',
                                    `saas_id` bigint NOT NULL COMMENT '运营商编号',
                                    `invoice_type` int NOT NULL COMMENT '发票类型（1-增值税普通发票 2-增值税专用发票）',
                                    `invoice_title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '发票抬头',
                                    `invoice_item` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '发票项目',
                                    `invoice_amount` bigint NOT NULL COMMENT '发票金额',
                                    `invoice_tax_num` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '纳税人识别号',
                                    `invoice_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '发票号码',
                                    `invoice_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '发票链接',
                                    `invoice_address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '地址',
                                    `invoice_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '电话',
                                    `bank_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '开户行',
                                    `bank_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '账号',
                                    `apply_user_id` bigint NOT NULL COMMENT '申请人ID',
                                    `apply_user_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '申请人用户名',
                                    `apply_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '申请备注',
                                    `audit_user_id` bigint DEFAULT NULL COMMENT '审批人ID',
                                    `audit_user_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审批人用户名',
                                    `audit_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审批备注',
                                    `drawer_id` bigint DEFAULT NULL COMMENT '登记人ID',
                                    `drawer_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '登记人用户名',
                                    `drawer_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '登记备注',
                                    `consume_log_ids` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '消费记录ID',
                                    `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                    `make_date` datetime(3) DEFAULT NULL COMMENT '开票时间',
                                    `last_update` datetime(3) DEFAULT NULL COMMENT '最后更新时间',
                                    `state` int NOT NULL COMMENT '发票状态',
                                    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='AIP发票';


-- saas_base.aip_license_info definition

CREATE TABLE `aip_license_info` (
                                    `id` bigint NOT NULL COMMENT '主键ID',
                                    `saas_id` bigint NOT NULL COMMENT '运营商编号',
                                    `app_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '应用名',
                                    `vendor_id` bigint DEFAULT NULL COMMENT '功能id',
                                    `renew_id` bigint NOT NULL COMMENT '续期ID',
                                    `vendor_type` int DEFAULT NULL COMMENT '功能类型',
                                    `vendor_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '服务名称',
                                    `vendor_class` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '服务类',
                                    `license_code` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '授权标识（授权名称）',
                                    `license_alert_limit` bigint DEFAULT '0' COMMENT '授权报警限值',
                                    `license_value` bigint DEFAULT '0' COMMENT '授权数值',
                                    `last_order_detail_id` bigint NOT NULL COMMENT '最近订单明细ID',
                                    `last_order_id` bigint NOT NULL COMMENT '最近订单ID',
                                    `effect_date` datetime(3) DEFAULT NULL COMMENT '生效时间',
                                    `expire_date` datetime(3) DEFAULT NULL COMMENT '过期时间',
                                    `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                    `last_order_date` datetime(3) DEFAULT NULL COMMENT '最近重购时间',
                                    `last_consume_date` datetime(3) DEFAULT NULL COMMENT '最近扣费时间',
                                    `state` int NOT NULL COMMENT '状态',
                                    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='AIP授权';


-- saas_base.aip_order_detail definition

CREATE TABLE `aip_order_detail` (
                                    `id` bigint NOT NULL COMMENT '主键ID',
                                    `saas_id` bigint NOT NULL COMMENT '运营商编号',
                                    `order_id` bigint NOT NULL COMMENT '订单ID',
                                    `app_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '功能对应的应用',
                                    `vendor_id` bigint NOT NULL COMMENT '服务ID',
                                    `vendor_type` int DEFAULT NULL COMMENT '服务类型',
                                    `vendor_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '服务名',
                                    `vendor_class` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '服务类',
                                    `execute_param` json DEFAULT NULL COMMENT '运行参数',
                                    `license_id` bigint DEFAULT NULL COMMENT 'boss授权Id',
                                    `license_code` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '授权代码',
                                    `license_value` bigint NOT NULL COMMENT '授权值',
                                    `license_period` bigint DEFAULT NULL COMMENT '限制时间',
                                    `license_unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '单位',
                                    `license_currency` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '授权币种',
                                    `license_fee` bigint NOT NULL COMMENT '服务费',
                                    `license_effect_date` datetime(3) DEFAULT NULL COMMENT '生效时间',
                                    `license_expire_date` datetime(3) DEFAULT NULL COMMENT '过期时间',
                                    `execute_log` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '授权日志',
                                    `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                    `execute_date` datetime(3) DEFAULT NULL COMMENT '更新时间',
                                    `finish_date` datetime(3) DEFAULT NULL COMMENT '完成时间',
                                    `state` int NOT NULL COMMENT '状态',
                                    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='AIP订单明细';


-- saas_base.aip_order_info definition

CREATE TABLE `aip_order_info` (
                                  `id` bigint NOT NULL COMMENT '主键ID',
                                  `saas_id` bigint NOT NULL COMMENT '运营商编号',
                                  `order_info` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '产品名',
                                  `product_id` bigint NOT NULL COMMENT '产品ID',
                                  `product_num` int NOT NULL COMMENT '产品数量',
                                  `product_price` bigint NOT NULL COMMENT '产品价格',
                                  `order_currency` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '币种类型',
                                  `order_amount` bigint NOT NULL COMMENT '订单总价',
                                  `pay_amount` bigint NOT NULL COMMENT '支付金额',
                                  `pay_info_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '支付id',
                                  `refund_amount` bigint NOT NULL COMMENT '退款金额',
                                  `remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
                                  `user_id` bigint DEFAULT NULL COMMENT '支付用户',
                                  `user_info` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户信息',
                                  `user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '支付IP',
                                  `order_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '问题创建时间',
                                  `pay_date` datetime(3) DEFAULT NULL COMMENT '支付时间',
                                  `execute_date` datetime(3) DEFAULT NULL COMMENT '执行时间',
                                  `finish_date` datetime(3) DEFAULT NULL COMMENT '执行完成时间',
                                  `refund_date` datetime(3) DEFAULT NULL COMMENT '退款时间',
                                  `state` int NOT NULL COMMENT '状态',
                                  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='AIP订单';


-- saas_base.aip_product_detail definition

CREATE TABLE `aip_product_detail` (
                                      `id` bigint NOT NULL COMMENT '主键ID',
                                      `product_id` bigint NOT NULL COMMENT '产品ID',
                                      `vendor_rank` int DEFAULT NULL COMMENT '排序',
                                      `app_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '功能对应的应用',
                                      `vendor_id` bigint DEFAULT NULL COMMENT '功能对应的类',
                                      `vendor_type` int DEFAULT NULL COMMENT '服务类型',
                                      `vendor_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '服务名',
                                      `vendor_class` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '服务类',
                                      `license_code` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '授权代码',
                                      `license_value` bigint DEFAULT NULL COMMENT '授权值',
                                      `license_period` bigint DEFAULT NULL COMMENT '授权时间段',
                                      `license_unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '单位',
                                      `license_currency` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '授权币种',
                                      `license_fee` bigint DEFAULT NULL COMMENT '服务费',
                                      `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                      `modify_date` datetime(3) DEFAULT NULL COMMENT '更新时间',
                                      `state` int NOT NULL COMMENT '状态：-1（删除）、0（未生效）、1（已生效）',
                                      PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='AIP产品明细';


-- saas_base.aip_product_info definition

CREATE TABLE `aip_product_info` (
                                    `id` bigint NOT NULL COMMENT '主键ID',
                                    `product_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '功能对应的应用',
                                    `product_intro` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '功能简介',
                                    `product_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '功能简介',
                                    `product_rank` int DEFAULT '0' COMMENT '排序',
                                    `product_tag` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '业务标签',
                                    `product_unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '单位',
                                    `product_currency` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '货币类型',
                                    `product_price` bigint NOT NULL COMMENT '功能价格(分)',
                                    `product_img` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '主图地址',
                                    `start_sale_date` datetime(3) DEFAULT NULL COMMENT '开始销售时间',
                                    `end_sale_date` datetime(3) DEFAULT NULL COMMENT '结束销售时间',
                                    `stock_num` int DEFAULT '0' COMMENT '总库存量',
                                    `book_limit_num` int DEFAULT '0' COMMENT '预定限制数量',
                                    `order_amount` bigint DEFAULT '0' COMMENT '已售金额',
                                    `order_num` int DEFAULT '0' COMMENT '已售数量',
                                    `order_num_virtual` int DEFAULT '0' COMMENT '虚拟已售数量',
                                    `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                    `modify_date` datetime(3) DEFAULT NULL COMMENT '更新时间',
                                    `state` int NOT NULL COMMENT '状态',
                                    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='AIP产品';


-- saas_base.aip_vendor_info definition

CREATE TABLE `aip_vendor_info` (
                                   `id` bigint NOT NULL COMMENT '主键ID',
                                   `app_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '应用名称',
                                   `vendor_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '服务名称',
                                   `vendor_intro` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '服务简介',
                                   `vendor_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '服务描述',
                                   `vendor_rank` int DEFAULT NULL COMMENT '服务排序',
                                   `vendor_type` int DEFAULT NULL COMMENT '服务类型',
                                   `vendor_tag` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '业务标签',
                                   `vendor_img` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '服务图片',
                                   `vendor_class` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '功能对应的类',
                                   `license_code` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '授权代码',
                                   `license_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '授权data',
                                   `license_alert_limit` bigint DEFAULT '0' COMMENT '授权报警限值',
                                   `license_value` bigint DEFAULT NULL COMMENT '授权值',
                                   `license_period` bigint DEFAULT NULL COMMENT '限制时间，0不限制',
                                   `license_unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '单位',
                                   `license_currency` varchar(10) DEFAULT NULL COMMENT '授权币种',
                                   `license_fee` bigint DEFAULT NULL COMMENT '授权费用',
                                   `order_num` bigint DEFAULT NULL COMMENT '下单数量',
                                   `order_num_virtual` int DEFAULT '0' COMMENT '虚拟已售数量',
                                   `order_amount` bigint DEFAULT NULL COMMENT '下单金额',
                                   `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                   `modify_date` datetime(3) DEFAULT NULL COMMENT '更新时间',
                                   `state` int NOT NULL COMMENT '状态',
                                   PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='AIP服务';


-- saas_base.ais_linker_config definition

CREATE TABLE `ais_linker_config` (
                                     `id` bigint NOT NULL COMMENT '主键ID',
                                     `saas_id` bigint NOT NULL DEFAULT '0' COMMENT 'SAAS ID',
                                     `mch_id` bigint NOT NULL DEFAULT '0' COMMENT '商户ID',
                                     `app_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '应用名',
                                     `linker_id` bigint NOT NULL COMMENT '链接器ID',
                                     `type_id` bigint NOT NULL COMMENT '类型ID',
                                     `config_sid` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '配置标识',
                                     `config_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '配置名称',
                                     `config_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '配置描述',
                                     `pub_data` json DEFAULT NULL COMMENT '公开配置',
                                     `api_data` json DEFAULT NULL COMMENT 'API配置',
                                     `sys_data` json DEFAULT NULL COMMENT '系统配置',
                                     `log_data` json DEFAULT NULL COMMENT '日志配置',
                                     `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                     `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                     `state` int DEFAULT '0' COMMENT '状态',
                                     PRIMARY KEY (`id`),
                                     KEY `saas_interface_config_interface_index` (`linker_id`) USING BTREE,
                                     KEY `saas_interface_config_mch_index` (`saas_id`,`mch_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='AIS链接器配置';


-- saas_base.ais_linker_info definition

CREATE TABLE `ais_linker_info` (
                                   `id` bigint NOT NULL COMMENT '主键ID',
                                   `app_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '应用名',
                                   `type_id` bigint NOT NULL COMMENT '类型ID',
                                   `type_class` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类型类',
                                   `linker_class` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '链接器类',
                                   `linker_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '链接器名',
                                   `linker_version` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '链接器版本',
                                   `linker_function` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '链接器功能',
                                   `linker_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '链接器描述',
                                   `linker_icon` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'AIS图标',
                                   `pub_param` json DEFAULT NULL COMMENT '公开配置',
                                   `api_param` json DEFAULT NULL COMMENT 'API配置',
                                   `sys_param` json DEFAULT NULL COMMENT '系统配置',
                                   `log_param` json DEFAULT NULL COMMENT '日志配置',
                                   `dev_info` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '开发者信息',
                                   `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                   `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                   `state` int DEFAULT '0' COMMENT '状态',
                                   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='AIS链接器信息';


-- saas_base.ais_linker_stats definition

CREATE TABLE `ais_linker_stats` (
                                    `id` bigint NOT NULL COMMENT '主键ID',
                                    `saas_id` bigint NOT NULL COMMENT '运营商编号',
                                    `app_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '应用名',
                                    `linker_id` bigint DEFAULT NULL COMMENT '链接器ID',
                                    `config_id` bigint DEFAULT NULL COMMENT '配置ID',
                                    `linker_function` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '链接器方法',
                                    `invoke_date` date DEFAULT NULL COMMENT '调用日期',
                                    `invoke_count` bigint DEFAULT NULL COMMENT '调用总次数',
                                    `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                    PRIMARY KEY (`id`),
                                    KEY `saas_interface_invoke_stats_saas_index` (`saas_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='AIS链接器统计';


-- saas_base.ais_linker_type definition

CREATE TABLE `ais_linker_type` (
                                   `id` bigint NOT NULL COMMENT '主键ID',
                                   `app_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '应用名',
                                   `type_class` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类型类',
                                   `type_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类型名称',
                                   `type_version` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '类型版本',
                                   `type_function` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '类型功能',
                                   `type_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '类型描述',
                                   `type_icon` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '类型ICON',
                                   `dev_info` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '开发者信息',
                                   `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                   `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                   `state` int DEFAULT '0' COMMENT '状态',
                                   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='AIS链接器类型';


-- saas_base.msg_mail_history definition

CREATE TABLE `msg_mail_history` (
                                    `id` bigint NOT NULL,
                                    `saas_id` bigint NOT NULL COMMENT '运营商ID',
                                    `config_id` bigint NOT NULL COMMENT '发送mail使用的配置',
                                    `send_tag` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '邮件发送ID',
                                    `ref_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '业务关联类',
                                    `ref_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '业务关联id',
                                    `from_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '发信人地址',
                                    `to_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '收信人地址',
                                    `subject` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '邮件标题',
                                    `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '邮件内容(若为模板发送，该内容为模板替换json数据）',
                                    `is_html` int NOT NULL DEFAULT '0' COMMENT '邮件内容格式是否为html（0-否  1-是）',
                                    `attachment` json DEFAULT NULL COMMENT '邮件附件地址',
                                    `create_date` datetime(3) NOT NULL COMMENT '创建时间',
                                    `schedule_date` datetime(3) DEFAULT NULL COMMENT '计划发送时间',
                                    `sent_date` datetime(3) DEFAULT NULL COMMENT '发送时间',
                                    `sent_times` int NOT NULL COMMENT '发送次数',
                                    `sent_limit` int NOT NULL DEFAULT '0' COMMENT '发送限制',
                                    `error_msg` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '错误信息',
                                    `state` int NOT NULL COMMENT '邮件发送状态',
                                    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='邮件通知记录';


-- saas_base.msg_mail_queue definition

CREATE TABLE `msg_mail_queue` (
                                  `id` bigint NOT NULL,
                                  `saas_id` bigint NOT NULL COMMENT '运营商ID',
                                  `config_id` bigint NOT NULL COMMENT '发送mail使用的配置',
                                  `send_tag` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '邮件发送ID',
                                  `ref_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '业务关联类',
                                  `ref_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '业务关联id',
                                  `from_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '发信人地址',
                                  `to_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '收信人地址',
                                  `subject` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '邮件标题',
                                  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '邮件内容(若为模板发送，该内容为模板替换json数据）',
                                  `is_html` int NOT NULL DEFAULT '0' COMMENT '邮件内容格式是否为html（0-否  1-是）',
                                  `attachment` json DEFAULT NULL COMMENT '邮件附件地址',
                                  `create_date` datetime(3) NOT NULL COMMENT '创建时间',
                                  `schedule_date` datetime(3) DEFAULT NULL COMMENT '计划发送时间',
                                  `sent_date` datetime(3) DEFAULT NULL COMMENT '发送时间',
                                  `sent_times` int NOT NULL COMMENT '发送次数',
                                  `sent_limit` int NOT NULL DEFAULT '0' COMMENT '发送限制',
                                  `error_msg` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '错误信息',
                                  `state` int NOT NULL COMMENT '邮件发送状态',
                                  PRIMARY KEY (`id`),
                                  KEY `msg_mail_queue_schedule_date_IDX` (`schedule_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='邮件通知记录';


-- saas_base.msg_sms_history definition

CREATE TABLE `msg_sms_history` (
                                   `id` bigint NOT NULL COMMENT '主键ID',
                                   `saas_id` bigint NOT NULL COMMENT '运营商ID',
                                   `config_id` bigint NOT NULL COMMENT '发送短信使用的配置',
                                   `send_tag` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '接口发送id',
                                   `ref_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '业务关联类',
                                   `ref_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '业务关联ID',
                                   `mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '收信人手机号码',
                                   `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '短信内容',
                                   `create_date` datetime(3) NOT NULL COMMENT '创建时间',
                                   `schedule_date` datetime(3) DEFAULT NULL COMMENT '计划发送时间',
                                   `sent_date` datetime(3) DEFAULT NULL COMMENT '发送时间',
                                   `sent_times` int NOT NULL COMMENT '发送次数',
                                   `sent_limit` int NOT NULL DEFAULT '0' COMMENT '发送限制',
                                   `error_msg` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '错误消息',
                                   `state` int NOT NULL COMMENT '短信发送状态',
                                   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='短信通知记录';


-- saas_base.msg_sms_queue definition

CREATE TABLE `msg_sms_queue` (
                                 `id` bigint NOT NULL COMMENT '主键ID',
                                 `saas_id` bigint NOT NULL COMMENT '运营商ID',
                                 `config_id` bigint NOT NULL COMMENT '发送短信使用的配置',
                                 `send_tag` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '接口发送id',
                                 `ref_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '业务关联类',
                                 `ref_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '业务关联ID',
                                 `mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '收信人手机号码',
                                 `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '短信内容',
                                 `create_date` datetime(3) NOT NULL COMMENT '创建时间',
                                 `schedule_date` datetime(3) DEFAULT NULL COMMENT '计划发送时间',
                                 `sent_date` datetime(3) DEFAULT NULL COMMENT '发送时间',
                                 `sent_times` int NOT NULL COMMENT '发送次数',
                                 `sent_limit` int NOT NULL DEFAULT '0' COMMENT '发送限制',
                                 `error_msg` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '错误消息',
                                 `state` int NOT NULL COMMENT '短信发送状态',
                                 PRIMARY KEY (`id`),
                                 KEY `msg_sms_queue_schedule_date_IDX` (`schedule_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='短信通知记录';


-- saas_base.saas_cert_info definition

CREATE TABLE `saas_cert_info` (
                                  `id` bigint NOT NULL COMMENT '主键ID',
                                  `saas_id` bigint NOT NULL COMMENT '运营商编号',
                                  `cert_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '证书类型',
                                  `cert_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '证书编码',
                                  `cert_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '证书信息',
                                  `cert_img` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '证书照片',
                                  `access_type` int NOT NULL COMMENT '访问类型',
                                  `start_date` datetime DEFAULT NULL COMMENT '有效期开始时间',
                                  `end_date` datetime DEFAULT NULL COMMENT '有效期结束时间',
                                  `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                  `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                                  `audit_state` int DEFAULT NULL COMMENT '审批状态',
                                  `audit_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审批信息',
                                  `audit_user_id` bigint DEFAULT NULL COMMENT '审批人ID',
                                  `audit_user_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审批人信息',
                                  `audit_date` datetime(3) DEFAULT NULL COMMENT '审核时间',
                                  `state` int NOT NULL COMMENT '状态',
                                  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='运营商证件信息';


-- saas_base.saas_contact_event definition

CREATE TABLE `saas_contact_event` (
                                      `id` bigint NOT NULL COMMENT '主键ID',
                                      `saas_id` bigint NOT NULL COMMENT '运营商编号',
                                      `contact_id` bigint DEFAULT NULL COMMENT '联系人ID',
                                      `contact_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系人信息',
                                      `event_type` int DEFAULT NULL COMMENT '事件类型',
                                      `contact_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系方式',
                                      `event_body` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '联系内容',
                                      `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                      `state` int DEFAULT '0' COMMENT '状态',
                                      PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='运营商联络记录';


-- saas_base.saas_contact_info definition

CREATE TABLE `saas_contact_info` (
                                     `id` bigint NOT NULL COMMENT '主键ID',
                                     `saas_id` bigint NOT NULL COMMENT '运营商编号',
                                     `contact_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '公司联系人姓名',
                                     `contact_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系人职位',
                                     `contact_phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '公司联系电话',
                                     `contact_mobile` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '公司联系手机',
                                     `contact_wechat` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '公司联系QQ',
                                     `contact_email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '公司联系邮箱',
                                     `contact_times` int DEFAULT NULL COMMENT '联络次数',
                                     `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                     `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                     `last_update` datetime(3) DEFAULT NULL COMMENT '上次联系时间',
                                     `state` int DEFAULT '0' COMMENT '状态',
                                     PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='运营商联系人信息';


-- saas_base.saas_info definition

CREATE TABLE `saas_info` (
                             `id` bigint NOT NULL COMMENT '主键ID',
                             `saas_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '运营商名称',
                             `saas_logo` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '运营商logo',
                             `org_type` int DEFAULT NULL COMMENT '组织类型',
                             `service_type` int DEFAULT '0' COMMENT '付费类型',
                             `saas_currency` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '系统币种',
                             `saas_lang` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '系统默认语言',
                             `bd_id` bigint DEFAULT NULL COMMENT '招商负责人',
                             `bd_info` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '招商负责人姓名',
                             `op_id` bigint DEFAULT NULL COMMENT '运营负责人',
                             `op_info` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '运营负责人姓名',
                             `area_code` bigint DEFAULT '0' COMMENT '区域编码',
                             `org_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '机构名称',
                             `org_desc` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '机构简介',
                             `org_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '机构号码',
                             `org_address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '机构地址',
                             `contact_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '公司联系人姓名',
                             `contact_phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '公司联系电话',
                             `contact_fax` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '公司联系传真',
                             `contact_email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '公司联系邮箱',
                             `contact_mobile` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '公司联系手机',
                             `contact_im` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '公司联系IM',
                             `stats_product_num` bigint DEFAULT NULL COMMENT '统计产品数',
                             `stats_order_num` bigint DEFAULT NULL COMMENT '统计订单数',
                             `stats_order_amount` bigint DEFAULT NULL COMMENT '统计订单额',
                             `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                             `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                             `audit_date` datetime(3) DEFAULT NULL COMMENT '审核时间',
                             `audit_state` int NOT NULL COMMENT '审核状态',
                             `last_login_date` datetime(3) DEFAULT NULL COMMENT '最后登录时间',
                             `last_order_date` datetime(3) DEFAULT NULL COMMENT '最后下单时间',
                             `state` int DEFAULT '0' COMMENT '运营商状态',
                             PRIMARY KEY (`id`) USING BTREE,
                             KEY `saas_info_area_code_index` (`area_code`) USING BTREE,
                             KEY `saas_info_name_index` (`saas_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='运营商信息';


-- saas_base.saas_mch_cert definition

CREATE TABLE `saas_mch_cert` (
                                 `id` bigint NOT NULL COMMENT '主键ID',
                                 `saas_id` bigint NOT NULL COMMENT '运营商编号',
                                 `mch_id` bigint NOT NULL COMMENT '商户编号',
                                 `cert_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '证书类型',
                                 `cert_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '证书编码',
                                 `cert_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '证书信息',
                                 `cert_img` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '证书照片',
                                 `access_type` int NOT NULL COMMENT '访问类型',
                                 `start_date` datetime DEFAULT NULL COMMENT '有效期开始时间',
                                 `end_date` datetime DEFAULT NULL COMMENT '有效期结束时间',
                                 `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                 `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                                 `audit_state` int DEFAULT NULL COMMENT '审批状态',
                                 `audit_user_id` bigint DEFAULT NULL COMMENT '审批人ID',
                                 `audit_user_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审批人信息',
                                 `audit_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审批信息',
                                 `audit_date` datetime(3) DEFAULT NULL COMMENT '审核时间',
                                 `state` int NOT NULL COMMENT '状态',
                                 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商户证件信息';


-- saas_base.saas_mch_grade definition

CREATE TABLE `saas_mch_grade` (
                                  `id` bigint NOT NULL COMMENT '主键ID',
                                  `saas_id` bigint NOT NULL COMMENT '运营商编号',
                                  `mch_type` int DEFAULT NULL COMMENT '商户类型 1-供应商 2-分销商',
                                  `grade_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '等级名称',
                                  `grade_level` int NOT NULL COMMENT '等级',
                                  `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                  `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                  `state` int NOT NULL COMMENT '状态',
                                  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商户等级';


-- saas_base.saas_mch_info definition

CREATE TABLE `saas_mch_info` (
                                 `id` bigint NOT NULL COMMENT '主键ID',
                                 `saas_id` bigint NOT NULL COMMENT '运营商编号',
                                 `mch_type` int DEFAULT NULL COMMENT '商户类型 1-供应商 2-分销商',
                                 `bd_id` bigint DEFAULT NULL COMMENT '关联业务员ID',
                                 `parent_id` bigint DEFAULT NULL COMMENT '上级ID',
                                 `agent_id` bigint DEFAULT NULL COMMENT '合伙人编号',
                                 `mch_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商户名称',
                                 `mch_lang` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '语种类型',
                                 `mch_currency` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '货币类型',
                                 `grade_level` bigint DEFAULT NULL COMMENT '商户等级Id',
                                 `contact_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商户联系人',
                                 `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商户联系电话',
                                 `contact_mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商户联系手机',
                                 `contact_email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商户联系邮箱',
                                 `contact_address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '公司地址',
                                 `mch_desc` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商户介绍',
                                 `mch_config` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商户资源',
                                 `stats_order` bigint DEFAULT NULL COMMENT '总订单量',
                                 `stats_money` bigint DEFAULT NULL COMMENT '总订单金额',
                                 `stats_product` bigint DEFAULT NULL COMMENT '总销售量',
                                 `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                 `modify_date` datetime(3) DEFAULT NULL COMMENT '修改时间',
                                 `state` int NOT NULL COMMENT '状态',
                                 PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商户信息';


-- saas_base.saas_notice_info definition

CREATE TABLE `saas_notice_info` (
                                    `id` bigint NOT NULL COMMENT '主键ID',
                                    `saas_id` bigint NOT NULL COMMENT '运营商编号',
                                    `access_type` int DEFAULT NULL COMMENT '访问类型',
                                    `release_type` int DEFAULT NULL COMMENT '发布类型',
                                    `stick` int DEFAULT NULL COMMENT '是否置顶 0 不置顶 1 置顶',
                                    `tags` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '标签 用 "," 分割 ',
                                    `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '标题',
                                    `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '公告内容',
                                    `view_num` int DEFAULT NULL COMMENT '点击数',
                                    `user_id` bigint DEFAULT NULL COMMENT '发布人',
                                    `user_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '发布人名称',
                                    `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                    `release_date` datetime(6) DEFAULT NULL COMMENT '发布时间',
                                    `stick_date` datetime(3) DEFAULT NULL COMMENT '截止置顶时间',
                                    `expire_date` datetime DEFAULT NULL COMMENT '过期时间',
                                    `modify_date` datetime(6) DEFAULT NULL COMMENT '最后修改时间',
                                    `state` int NOT NULL COMMENT '状态',
                                    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='运营商公告';


-- saas_base.saas_notify_config definition

CREATE TABLE `saas_notify_config` (
                                      `user_id` bigint NOT NULL COMMENT '用户ID',
                                      `saas_id` bigint NOT NULL COMMENT '运营商编号',
                                      `mch_id` bigint NOT NULL COMMENT '商户编号',
                                      `user_type` int NOT NULL COMMENT '用户类型',
                                      `mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系电话',
                                      `email` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系邮箱',
                                      `wechat` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '微信',
                                      `notify_web` bigint DEFAULT NULL COMMENT 'web通知',
                                      `notify_ding` bigint DEFAULT NULL COMMENT '钉钉通知',
                                      `notify_weixin` bigint DEFAULT NULL COMMENT '微信通知',
                                      `notify_sms` bigint DEFAULT NULL COMMENT '短信通知',
                                      `notify_mail` bigint DEFAULT NULL COMMENT '邮件通知',
                                      `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                      `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                                      `state` int NOT NULL DEFAULT '0' COMMENT '状态.1正常、0屏蔽',
                                      PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='系统通知配置';


-- saas_base.saas_stats_day definition

CREATE TABLE `saas_stats_day` (
                                  `id` bigint NOT NULL COMMENT 'ID',
                                  `saas_id` bigint NOT NULL COMMENT '运营商编号',
                                  `saas_name` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '运营商名称',
                                  `area_code` bigint DEFAULT NULL COMMENT '地区编号',
                                  `product_num` int DEFAULT NULL COMMENT '产品数量',
                                  `order_num` int DEFAULT NULL COMMENT '订单总量',
                                  `order_amount` bigint DEFAULT NULL COMMENT '订单金额',
                                  `file_num` bigint DEFAULT NULL COMMENT '文件数量',
                                  `file_size` bigint DEFAULT NULL COMMENT '文件大小',
                                  `stats_date` datetime DEFAULT NULL COMMENT '统计日期',
                                  `create_date` datetime DEFAULT NULL COMMENT '创建日期',
                                  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='SAAS分日统计';


-- saas_base.sps_ticket_event definition

CREATE TABLE `sps_ticket_event` (
                                    `id` bigint NOT NULL COMMENT '事件id',
                                    `saas_id` bigint DEFAULT NULL COMMENT '回复者saasId',
                                    `user_id` bigint DEFAULT NULL COMMENT '回复者id',
                                    `user_type` int DEFAULT NULL COMMENT '回复者用户类型',
                                    `user_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '回复者用户名',
                                    `ticket_id` bigint DEFAULT NULL COMMENT '问题id',
                                    `event_type` int DEFAULT NULL COMMENT '事件类型',
                                    `event_body` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '回复内容',
                                    `event_img` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '图片',
                                    `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                    `state` int DEFAULT NULL COMMENT '状态',
                                    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='支持工单事件';


-- saas_base.sps_ticket_info definition

CREATE TABLE `sps_ticket_info` (
                                   `id` bigint NOT NULL COMMENT '工单id',
                                   `saas_id` bigint NOT NULL COMMENT '用户saasId',
                                   `user_id` bigint NOT NULL COMMENT '用户id',
                                   `user_type` int DEFAULT NULL COMMENT '用户类型',
                                   `user_account` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户账号',
                                   `user_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
                                   `user_phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '手机号',
                                   `user_email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '邮箱',
                                   `op_id` bigint DEFAULT NULL COMMENT '指定处理者id',
                                   `op_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'op信息',
                                   `app_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '应用名',
                                   `ticket_title` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '问题标题',
                                   `ticket_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '问题内容',
                                   `ticket_img` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '图片路径',
                                   `ticket_tag` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '问题描述标签',
                                   `ticket_level` int NOT NULL COMMENT '紧急程度',
                                   `ticket_ref_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '关联业务类型',
                                   `ticket_ref_id` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '关联业务ID',
                                   `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                   `last_update` datetime(3) NOT NULL COMMENT '最后更新时间',
                                   `state` int NOT NULL COMMENT '问题处理进度',
                                   PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='支持工单信息';


-- saas_base.sys_area_info definition

CREATE TABLE `sys_area_info` (
                                 `id` bigint NOT NULL,
                                 `parent_id` bigint DEFAULT '0' COMMENT '父级区域id，0代表没有父节点',
                                 `area_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '区域名称',
                                 `area_path` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '分级名称存储',
                                 `area_code` bigint DEFAULT NULL COMMENT '地址编码',
                                 `area_rank` int DEFAULT '0' COMMENT '地区排序，多的排在前面',
                                 `area_level` int DEFAULT NULL COMMENT '地区级别，总共5级，从0开始。',
                                 `spell` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '区域英文/拼音名称',
                                 `spell_short` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '区域英文/拼音简称',
                                 `spell_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '英文名称路径',
                                 `geo_lat` double DEFAULT NULL COMMENT '纬度',
                                 `geo_lng` double DEFAULT NULL COMMENT '经度',
                                 `geo_hash` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Geo Hash',
                                 `create_date` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                 `modify_date` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
                                 `state` int DEFAULT '-1' COMMENT '状态 1-正常 -1删除',
                                 PRIMARY KEY (`id`),
                                 KEY `saas_area_info_area_code_index` (`area_code`),
                                 KEY `saas_area_info_name_index` (`area_name`,`spell`,`spell_short`),
                                 KEY `saas_area_info_parent_id_index` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统地区';


-- saas_base.sys_crit_log definition

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
                                `user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '操作人ip',
                                `api_uri` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '请求uri',
                                `api_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'API名称',
                                `biz_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '操作对象类型',
                                `biz_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '操作对象id',
                                `biz_log` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '业务日志',
                                `op_state` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '操作状态',
                                `op_log` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '日志内容',
                                `request_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                `response_state` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '响应状态',
                                `request_body` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '请求参数',
                                `response_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '响应代码',
                                `response_body` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '响应日志',
                                `response_msg` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '响应消息',
                                `response_millis` bigint DEFAULT NULL COMMENT '请求毫秒数',
                                `exception` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '异常信息',
                                `status_code` int DEFAULT NULL COMMENT '响应状态码',
                                `app_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '应用信息',
                                `app_host` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '应用主机',
                                PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统关键日志';


-- saas_base.sys_data_history definition

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
                                    `user_ip` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户IP',
                                    `create_date` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建日期',
                                    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统数据历史';


-- saas_base.sys_dict_info definition

CREATE TABLE `sys_dict_info` (
                                 `id` bigint NOT NULL COMMENT '主键',
                                 `saas_id` bigint NOT NULL COMMENT 'saasId',
                                 `parent_id` bigint DEFAULT NULL COMMENT '父级id',
                                 `dict_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '字典项数值',
                                 `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '字典项名称',
                                 `dict_desc` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '字典项描述',
                                 `dict_rank` int DEFAULT NULL COMMENT '同一层级的排序',
                                 `create_date` datetime(3) DEFAULT NULL COMMENT '创建时间',
                                 `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                                 `state` int DEFAULT NULL COMMENT '状态',
                                 PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='系统字典';


-- saas_base.sys_dict_lang definition

CREATE TABLE `sys_dict_lang` (
                                 `id` bigint NOT NULL COMMENT '主键',
                                 `saas_id` bigint NOT NULL COMMENT 'saasId',
                                 `dict_id` bigint DEFAULT NULL COMMENT '字典id',
                                 `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '字典项名称',
                                 `dict_desc` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '字典项描述',
                                 `lang_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '多语言类型',
                                 `create_date` datetime(3) DEFAULT NULL COMMENT '创建时间',
                                 `modify_date` datetime(3) DEFAULT NULL COMMENT '修改日期',
                                 `state` int DEFAULT NULL COMMENT '状态',
                                 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='字典多语言';


-- saas_base.sys_notice_info definition

CREATE TABLE `sys_notice_info` (
                                   `id` bigint NOT NULL COMMENT '主键ID',
                                   `access_type` int DEFAULT NULL COMMENT '访问类型',
                                   `release_type` int DEFAULT NULL COMMENT '发布类型',
                                   `stick` int DEFAULT NULL COMMENT '是否置顶 0 不置顶 1 置顶',
                                   `tags` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '标签 用 "," 分割',
                                   `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '标题',
                                   `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '公告内容',
                                   `view_num` int DEFAULT NULL COMMENT '点击数',
                                   `user_id` bigint DEFAULT NULL COMMENT '发布人',
                                   `user_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '发布人名称',
                                   `create_date` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
                                   `release_date` datetime(6) DEFAULT NULL COMMENT '发布时间',
                                   `stick_date` datetime(3) DEFAULT NULL COMMENT '截止置顶时间',
                                   `expire_date` datetime DEFAULT NULL COMMENT '过期时间',
                                   `modify_date` datetime(6) DEFAULT NULL COMMENT '最后修改时间',
                                   `state` int NOT NULL COMMENT '状态',
                                   PRIMARY KEY (`id`) USING BTREE,
                                   KEY `notice_index` (`access_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='系统公告';


-- saas_base.sys_oss_file definition

CREATE TABLE `sys_oss_file` (
                                `id` bigint NOT NULL COMMENT '主键',
                                `parent_id` bigint DEFAULT '0' COMMENT '父级ID',
                                `saas_id` bigint NOT NULL DEFAULT '0' COMMENT 'saas id',
                                `mch_id` bigint NOT NULL DEFAULT '0' COMMENT '商户id',
                                `config_id` bigint DEFAULT NULL COMMENT '配置id',
                                `access_type` int DEFAULT NULL COMMENT '访问类型',
                                `file_info` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '文件信息',
                                `file_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '文件路径',
                                `file_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '文件后缀',
                                `file_size` bigint DEFAULT NULL COMMENT '文件大小',
                                `file_hash` varchar(50) DEFAULT NULL COMMENT '文件hash',
                                `ref_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '关联表名',
                                `ref_id` varchar(100) DEFAULT NULL COMMENT '关联表的id',
                                `link_num` int DEFAULT NULL COMMENT '链接计数',
                                `user_id` bigint NOT NULL COMMENT 'userId',
                                `user_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户名',
                                `user_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户IP',
                                `user_type` int DEFAULT NULL COMMENT '用户类型',
                                `request_date` datetime(3) DEFAULT NULL COMMENT '请求日期',
                                `upload_date` datetime(3) DEFAULT NULL COMMENT '上传日期',
                                `expire_date` datetime(3) DEFAULT NULL COMMENT '过期日期',
                                `last_update` datetime(3) DEFAULT NULL COMMENT '更新时间',
                                `state` int DEFAULT NULL COMMENT '状态',
                                PRIMARY KEY (`id`,`saas_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统存储文件';


-- saas_base.sys_seq definition

CREATE TABLE `sys_seq` (
                           `seq_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                           `seq_id` bigint DEFAULT NULL,
                           `seq_desc` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
                           `increment_num` int DEFAULT NULL,
                           `create_date` datetime DEFAULT NULL,
                           `last_update` datetime(3) DEFAULT NULL,
                           PRIMARY KEY (`seq_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='表主键自增位置标记';

-- saas_base.saas_info_view source

CREATE OR REPLACE  ALGORITHM=UNDEFINED  VIEW `saas_base`.`saas_info_view` AS select `si`.`id` AS `id`,`si`.`saas_name` AS `saas_name`,`si`.`saas_logo` AS `saas_logo`,`si`.`org_type` AS `org_type`,`si`.`service_type` AS `service_type`,`si`.`saas_currency` AS `saas_currency`,`si`.`saas_lang` AS `saas_lang`,`si`.`bd_id` AS `bd_id`,`si`.`bd_info` AS `bd_info`,`si`.`op_id` AS `op_id`,`si`.`op_info` AS `op_info`,`si`.`area_code` AS `area_code`,`si`.`org_name` AS `org_name`,`si`.`org_desc` AS `org_desc`,`si`.`org_id` AS `org_id`,`si`.`org_address` AS `org_address`,`si`.`contact_name` AS `contact_name`,`si`.`contact_phone` AS `contact_phone`,`si`.`contact_fax` AS `contact_fax`,`si`.`contact_mobile` AS `contact_mobile`,`si`.`contact_im` AS `contact_im`,`si`.`contact_email` AS `contact_email`,`si`.`create_date` AS `create_date`,`si`.`modify_date` AS `modify_date`,`si`.`audit_date` AS `audit_date`,`si`.`audit_state` AS `audit_state`,`si`.`last_login_date` AS `last_login_date`,`si`.`stats_order_num` AS `stats_order_num`,`si`.`stats_order_amount` AS `stats_order_amount`,`si`.`stats_product_num` AS `stats_product_num`,`si`.`last_order_date` AS `last_order_date`,`si`.`state` AS `state`,`ab`.`deposit_balance` AS `aip_balance`,`ab`.`deposit_sum_recharge` AS `aip_sum_recharge`,`ab`.`deposit_sum_recharge_refund` AS `aip_sum_recharge_refund`,`ab`.`deposit_sum_consume` AS `aip_sum_consume`,`ab`.`deposit_sum_consume_refund` AS `aip_sum_consume_refund`,`ab`.`order_num` AS `aip_order_num`,`ab`.`last_recharge_date` AS `aip_recharge_date`,`ab`.`last_consume_date` AS `aip_consume_date` from (`saas_base`.`saas_info` `si` left join `saas_base`.`aip_balance_info` `ab` on(((`si`.`id` = `ab`.`saas_id`) and (`si`.`saas_currency` = `ab`.`currency`))));


INSERT INTO `saas_info` VALUES (0,'默认系统',NULL,1,0,'CNY','zh_CN',0,NULL,0,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2023-10-01 00:00:00.000',NULL,NULL,1,NULL,NULL,1);