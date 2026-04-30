/*!50503 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS `uw_nacos` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `uw_nacos`;

--
-- Table structure for table `config_info`
--

DROP TABLE IF EXISTS `config_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `config_info` (
                               `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
                               `data_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'data_id',
                               `group_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
                               `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'content',
                               `md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'md5',
                               `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                               `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
                               `src_user` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT 'source user',
                               `src_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'source ip',
                               `app_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
                               `tenant_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '租户字段',
                               `c_desc` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
                               `c_use` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
                               `effect` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
                               `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
                               `c_schema` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
                               `encrypted_data_key` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '秘钥',
                               PRIMARY KEY (`id`),
                               UNIQUE KEY `uk_configinfo_datagrouptenant` (`data_id`,`group_id`,`tenant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='config_info';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config_info`
--

LOCK TABLES `config_info` WRITE;
/*!40000 ALTER TABLE `config_info` DISABLE KEYS */;
INSERT INTO `config_info` VALUES (1,'uw-auth-center','DEFAULT_GROUP','server:\n  port: 10000\n  shutdown: graceful\n  forward-headers-strategy: native\n  tomcat:\n    threads:\n      min-spare: 10\n      max: 200\n    max-connections: 10000\n    uri-encoding: UTF-8\n  error:\n    include-message: always\n\nspring:\n  cloud:\n    config:\n      allow-override: true\n      override-none: true\n      override-system-properties: false\n  jackson:\n    default-property-inclusion: NON_NULL\n    serialization:\n      write-dates-as-timestamps: true\n \nuw:\n  auth:\n    center:\n      center-name: \"MSC管理系统\"\n      center-site: #{GATEWAY_SERVER}\n      key-redis:\n        database: 0\n        host: #{REDIS_HOST}\n        port: #{REDIS_PORT}\n        username: #{REDIS_USERNAME}\n        password: #{REDIS_PASSWORD}\n        lettuce:\n          pool:\n            max-active: 200\n            max-idle: 8\n            max-wait: 10s\n            min-idle: 1\n        timeout: 30s\n        ssl:\n          enabled: #{REDIS_SSL}\n      token-redis:\n        database: 1\n        host: #{REDIS_HOST}\n        port: #{REDIS_PORT}\n        username: #{REDIS_USERNAME}\n        password: #{REDIS_PASSWORD}\n        lettuce:\n          pool:\n            max-active: 200\n            max-idle: 8\n            max-wait: 10s\n            min-idle: 1\n        timeout: 30s\n        ssl:\n          enabled: #{REDIS_SSL}\n      token-secret-redis:\n        database: 2\n        host: #{REDIS_HOST}\n        port: #{REDIS_PORT}\n        username: #{REDIS_USERNAME}\n        password: #{REDIS_PASSWORD}\n        lettuce:\n          pool:\n            max-active: 200\n            max-idle: 8\n            max-wait: 10s\n            min-idle: 1\n        timeout: 30s\n        ssl:\n          enabled: #{REDIS_SSL}\n    service:\n      app-label: \"MSC管理中心\"\n    client:\n      login-id: rpc\n      login-pass: #{MSC_RPC_PASSWORD}\n  dao:\n    conn-pool:\n      root:\n        driver: com.mysql.cj.jdbc.Driver\n        url: jdbc:mysql://#{MYSQL_HOST}:#{MYSQL_PORT}/uw_auth\n        username: uw\n        password: #{MYSQL_UW_PASSWORD}\n        min-conn: 3\n        max-conn: 100\n    redis:\n      database: 5\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  cache:\n    redis:\n      database: 6\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  mfa:\n    device-notify-mobile-api: http://saas-base-app/rpc/msg/sendSms\n    device-notify-email-api: http://saas-base-app/rpc/msg/sendMail\n    redis:\n      database: 3\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  log:\n    es:\n      server: #{LOG_ES_SERVER}\n      username: #{LOG_ES_USERNAME}\n      password: #{LOG_ES_PASSWORD}','e3aa8852c8cba97e45a4bbf9947b351e','2025-01-01 00:00:00','2025-01-01 00:00:00','nacos','127.0.0.1','','#{NACOS_NAMESPACE}','','','','yaml','',''),(2,'uw-task-center','DEFAULT_GROUP','server:\n  port: 10010\n  shutdown: graceful\n  forward-headers-strategy: native\n  tomcat:\n    threads:\n      min-spare: 10\n      max: 200\n    max-connections: 10000\n    uri-encoding: UTF-8\n  error:\n    include-message: always\n\nspring:\n  cloud:\n    config:\n      allow-override: true\n      override-none: true\n      override-system-properties: false\n  jackson:\n    default-property-inclusion: NON_NULL\n    serialization:\n      write-dates-as-timestamps: true\n\nuw:\n  task:\n    center:\n      center-name: \"任务管理中心\"\n      alert-ding:\n        notify-key: \"TASK报警!\"\n        notify-url: https://oapi.dingtalk.com/robot/send?access_token=0c337a739e72ce9418224636fdd30abf56696c1bc38a79d77eb757554618b895\n    enable-registry: true\n    task-project: uw.task.center\n    croner-thread-num: 5\n    rabbitmq:\n      host: #{RABBITMQ_HOST}\n      port: #{RABBITMQ_PORT}\n      username: #{RABBITMQ_USERNAME}\n      password: #{RABBITMQ_PASSWORD}\n      publisher-confirm-type: correlated\n      virtual-host: /\n      ssl:\n        enabled: #{RABBITMQ_SSL}\n    redis:\n      database: 7\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  auth:\n    service:\n      app-label: \"任务管理中心\"\n    client:\n      login-id: rpc\n      login-pass: #{MSC_RPC_PASSWORD}\n  dao:\n    conn-pool:\n      root:\n        driver: com.mysql.cj.jdbc.Driver\n        url: jdbc:mysql://#{MYSQL_HOST}:#{MYSQL_PORT}/uw_task?rewriteBatchedStatements=true\n        username: uw\n        password: #{MYSQL_UW_PASSWORD}\n        min-conn: 3\n        max-conn: 100\n    table-shard:\n      task_runner_stats:\n        shard-type: date\n        shard-rule: month\n        auto-gen: true\n      task_croner_stats:\n        shard-type: date\n        shard-rule: month\n        auto-gen: true\n    redis:\n      database: 5\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  log:\n    es:\n      server: #{LOG_ES_SERVER}\n      username: #{LOG_ES_USERNAME}\n      password: #{LOG_ES_PASSWORD}','fec2392c64996b15d2f47beb2f8a8784','2025-01-01 00:00:00','2025-01-01 00:00:00','nacos','127.0.0.1','','#{NACOS_NAMESPACE}','','','','yaml','',''),(3,'uw-ops-center','DEFAULT_GROUP','server:\n  port: 1000\n  shutdown: graceful\n  forward-headers-strategy: native\n  tomcat:\n    threads:\n      min-spare: 10\n      max: 200\n    max-connections: 10000\n    uri-encoding: UTF-8\n  error:\n    include-message: always\n\nspring:\n  cloud:\n    config:\n      allow-override: true\n      override-none: true\n      override-system-properties: false\n  jackson:\n    default-property-inclusion: NON_NULL\n    serialization:\n      write-dates-as-timestamps: true\n \nuw:\n  ops:\n    center:\n      center-name: \"运维管理中心\"\n      center-site: #{GATEWAY_SERVER}/uw-ops-center\n      registry:\n        host: http://#{REGISTRY_SERVER}\n        username: #{REGISTRY_USERNAME}\n        password: #{REGISTRY_PASSWORD}\n      notify-ding:\n        notify-key: \"OPS通知!\"\n        notify-url: \"https://oapi.dingtalk.com/robot/send?access_token=0c337a739e72ce9418224636fdd30abf56696c1bc38a79d77eb757554618b895\"\n      alert-ding:\n        notify-key: \"OPS报警!\"\n        notify-url: \"https://oapi.dingtalk.com/robot/send?access_token=0c337a739e72ce9418224636fdd30abf56696c1bc38a79d77eb757554618b895\"\n  auth:\n    service:\n      app-label: \"运维管理中心\"\n    client:\n      login-id: rpc\n      login-pass: #{MSC_RPC_PASSWORD}\n  dao:\n    conn-pool:\n      root:\n        driver: com.mysql.cj.jdbc.Driver\n        url: jdbc:mysql://#{MYSQL_HOST}:#{MYSQL_PORT}/uw_ops\n        username: uw\n        password: #{MYSQL_UW_PASSWORD}\n        min-conn: 3\n        max-conn: 100\n    table-shard:\n      ops_host_stats:\n        shard-type: date\n        shard-rule: month\n        auto-gen: true\n      ops_instance_stats:\n        shard-type: date\n        shard-rule: month\n        auto-gen: true\n    redis:\n      database: 5\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  task:\n    enable-registry: true\n    task-project: uw.ops.center\n    croner-thread-num: 5\n    rabbitmq:\n      host: #{RABBITMQ_HOST}\n      port: #{RABBITMQ_PORT}\n      username: #{RABBITMQ_USERNAME}\n      password: #{RABBITMQ_PASSWORD}\n      publisher-confirm-type: correlated\n      virtual-host: /\n      ssl:\n        enabled: #{RABBITMQ_SSL}\n    redis:\n      database: 7\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  cache:\n    redis:\n      database: 6\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  log:\n    es:\n      server: #{LOG_ES_SERVER}\n      username: #{LOG_ES_USERNAME}\n      password: #{LOG_ES_PASSWORD}\n','1dbb8fb1c35f4ec239858e915daee017','2025-01-01 00:00:00','2025-01-01 00:00:00','nacos','127.0.0.1','','#{NACOS_NAMESPACE}','','','','yaml','',''),(5,'uw-mydb-center','DEFAULT_GROUP','server:\n  port: 10020\n  shutdown: graceful\n  forward-headers-strategy: native\n  tomcat:\n    threads:\n      min-spare: 10\n      max: 200\n    max-connections: 10000\n    uri-encoding: UTF-8\n  error:\n    include-message: always\n\nspring:\n  cloud:\n    config:\n      allow-override: true\n      override-none: true\n      override-system-properties: false\n  jackson:\n    default-property-inclusion: NON_NULL\n    serialization:\n      write-dates-as-timestamps: true\n \nuw:\n  mydb:\n    center:\n      center-name: \"数据管理中心\"\n      notify-ding:\n        notify-key: \"MYDB通知!\"\n        notify-url: \"https://oapi.dingtalk.com/robot/send?access_token=0c337a739e72ce9418224636fdd30abf56696c1bc38a79d77eb757554618b895\"\n      alert-ding:\n        notify-key: \"MYDB报警!\"\n        notify-url: \"https://oapi.dingtalk.com/robot/send?access_token=0c337a739e72ce9418224636fdd30abf56696c1bc38a79d77eb757554618b895\"\n      minio:\n        host: #{MINIO_SERVER}\n        access-key: \"#{MINIO_ROOT_USERNAME}\"\n        secret-key: \"#{MINIO_ROOT_PASSWORD}\"\n  auth:\n    service:\n      app-label: \"数据管理中心\"\n    client:\n      login-id: rpc\n      login-pass: #{MSC_RPC_PASSWORD}\n  dao:\n    conn-pool:\n      root:\n        driver: com.mysql.cj.jdbc.Driver\n        url: jdbc:mysql://#{MYSQL_HOST}:#{MYSQL_PORT}/uw_mydb\n        username: #{MYSQL_ROOT_USERNAME}\n        password: #{MYSQL_ROOT_PASSWORD}\n        min-conn: 3\n        max-conn: 100\n    table-shard:\n      mydb_proxy_stats:\n        shard-type: date\n        shard-rule: month\n        auto-gen: true\n      mydb_mysql_stats:\n        shard-type: date\n        shard-rule: month\n        auto-gen: true\n      mydb_data_run_stats:\n        shard-type: date\n        shard-rule: month\n        auto-gen: true\n      mydb_data_node_stats:\n        shard-type: date\n        shard-rule: month\n        auto-gen: true\n    redis:\n      database: 5\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  task:\n    enable-registry: true\n    task-project: uw.mydb.center\n    croner-thread-num: 2\n    rabbitmq:\n      host: #{RABBITMQ_HOST}\n      port: #{RABBITMQ_PORT}\n      username: #{RABBITMQ_USERNAME}\n      password: #{RABBITMQ_PASSWORD}\n      publisher-confirm-type: correlated\n      virtual-host: /\n      ssl:\n        enabled: #{RABBITMQ_SSL}\n    redis:\n      database: 7\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  cache:\n    redis:\n      database: 6\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  log:\n    es:\n      server: #{LOG_ES_SERVER}\n      username: #{LOG_ES_USERNAME}\n      password: #{LOG_ES_PASSWORD}\n','ef5ffcbc8b4f1143ffaa67474d4ced95','2025-01-01 00:00:00','2025-01-01 00:00:00','nacos','127.0.0.1','','#{NACOS_NAMESPACE}','','','','yaml','',''),(6,'uw-mydb-proxy','DEFAULT_GROUP','spring:\n  cloud:\n    config:\n      allow-override: true\n      override-none: true\n  jackson:\n    default-property-inclusion: NON_NULL\n    serialization:\n      write-dates-as-timestamps: true\n\nuw:\n  auth:\n    client:\n      login-id: rpc\n      login-pass: #{MSC_RPC_PASSWORD}\n  mydb:\n    proxy:\n      mydb-center-host: http://uw-mydb-center\n      config-key: default\n      proxyPort: 3300\n  cache:\n    redis:\n      database: 6\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  log:\n    es:\n      server: #{LOG_ES_SERVER}\n      username: #{LOG_ES_USERNAME}\n      password: #{LOG_ES_PASSWORD}\nlogging:\n  level:\n    uw.mydb: trace','71d5dc954ab72da17306de79be2c4a50','2025-01-01 00:00:00','2025-01-01 00:00:00','nacos','127.0.0.1','','#{NACOS_NAMESPACE}','','','','yaml','',''),(7,'uw-lms-center','DEFAULT_GROUP','server:\n  port: 666\n  shutdown: graceful\n  forward-headers-strategy: native\n  tomcat:\n    threads:\n      min-spare: 10\n      max: 200\n    max-connections: 10000\n    uri-encoding: UTF-8\n  error:\n    include-message: always\n\nspring:\n  cloud:\n    config:\n      allow-override: true\n      override-none: true\n      override-system-properties: false\n  jackson:\n    default-property-inclusion: NON_NULL\n    serialization:\n      write-dates-as-timestamps: true\n \nuw:\n  auth:\n    service:\n      app-label: \"LMS管理中心\"\n    client:\n      login-id: rpc\n      login-pass: #{MSC_RPC_PASSWORD}\n  dao:\n    conn-pool:\n      root:\n        driver: com.mysql.cj.jdbc.Driver\n        url: jdbc:mysql://#{MYSQL_HOST}:#{MYSQL_PORT}/uw_lms\n        username: uw\n        password: #{MYSQL_UW_PASSWORD}\n        min-conn: 3\n        max-conn: 100\n    redis:\n      database: 5\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  task:\n    enable-registry: true\n    task-project: uw.lms.center\n    croner-thread-num: 5\n    rabbitmq:\n      host: #{RABBITMQ_HOST}\n      port: #{RABBITMQ_PORT}\n      username: #{RABBITMQ_USERNAME}\n      password: #{RABBITMQ_PASSWORD}\n      publisher-confirm-type: correlated\n      virtual-host: /\n      ssl:\n        enabled: #{RABBITMQ_SSL}\n    redis:\n      database: 7\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  cache:\n    redis:\n      database: 6\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}        \n  log:\n    es:\n      server: #{LOG_ES_SERVER}\n      username: #{LOG_ES_USERNAME}\n      password: #{LOG_ES_PASSWORD}','142e8083cffa57a3a1626175bdcd7f00','2025-01-01 00:00:00','2025-01-01 00:00:00','nacos','127.0.0.1','','#{NACOS_NAMESPACE}','','','','yaml','',''),(8,'uw-gateway-center','DEFAULT_GROUP','server:\n  port: 10030\n  shutdown: graceful\n  forward-headers-strategy: native\n  tomcat:\n    threads:\n      min-spare: 10\n      max: 200\n    max-connections: 10000\n    uri-encoding: UTF-8\n  error:\n    include-message: always\n\nspring:\n  cloud:\n    config:\n      allow-override: true\n      override-none: true\n      override-system-properties: false\n  jackson:\n    default-property-inclusion: NON_NULL\n    serialization:\n      write-dates-as-timestamps: true\n \nuw:\n  gateway:\n    center:\n      center-name: \"网关管理中心\"\n      access-log-es:\n        server: #{LOG_ES_SERVER}\n        username: #{LOG_ES_USERNAME}\n        password: #{LOG_ES_PASSWORD}\n      notify-ding:\n        notify-key: \"GW通知!\"\n        notify-url: \"https://oapi.dingtalk.com/robot/send?access_token=0c337a739e72ce9418224636fdd30abf56696c1bc38a79d77eb757554618b895\"\n      alert-ding:\n        notify-key: \"GW报警!\"\n        notify-url: \"https://oapi.dingtalk.com/robot/send?access_token=0c337a739e72ce9418224636fdd30abf56696c1bc38a79d77eb757554618b895\"\n  auth:\n    service:\n      app-label: \"网关管理中心\"\n    client:\n      login-id: rpc\n      login-pass: #{MSC_RPC_PASSWORD}\n  dao:\n    conn-pool:\n      root:\n        driver: com.mysql.cj.jdbc.Driver\n        url: jdbc:mysql://#{MYSQL_HOST}:#{MYSQL_PORT}/uw_gateway\n        username: uw\n        password: #{MYSQL_UW_PASSWORD}\n        min-conn: 3\n        max-conn: 100\n    redis:\n      database: 5\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  task:\n    enable-registry: true\n    task-project: uw.gateway.center\n    croner-thread-num: 5\n    rabbitmq:\n      host: #{RABBITMQ_HOST}\n      port: #{RABBITMQ_PORT}\n      username: #{RABBITMQ_USERNAME}\n      password: #{RABBITMQ_PASSWORD}\n      publisher-confirm-type: correlated\n      virtual-host: /\n      ssl:\n        enabled: #{RABBITMQ_SSL}\n    redis:\n      database: 7\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  cache:\n    redis:\n      database: 6\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}        \n  log:\n    es:\n      server: #{LOG_ES_SERVER}\n      username: #{LOG_ES_USERNAME}\n      password: #{LOG_ES_PASSWORD}','24f0ea3e8f62d3a32c7d96a304a0cc72','2025-01-01 00:00:00','2025-01-01 00:00:00','nacos','127.0.0.1','','#{NACOS_NAMESPACE}','','','','yaml','',''),(9,'uw-gateway','DEFAULT_GROUP','server:\n  port: 80\n  shutdown: graceful\n  forward-headers-strategy: native\n  compression:\n    enabled: true\n  error:\n    include-message: always\nspring:\n  cloud:\n    config:\n      allow-override: true\n      override-none: true\n      override-system-properties: false\n    gateway.server.webflux:\n      globalcors:\n        add-to-simple-url-handler-mapping: true\n        cors-configurations:\n          \"[/**]\":\n            allowCredentials: true\n            allowedOriginPatterns: \"*\"\n            allowedMethods: \"*\"\n            allowedHeaders: \"*\"\n      discovery:\n        locator:\n          enabled: true\n          lower-case-service-id: true\n#      routes:\n#        - id: rewrite_app_verify # 针对腾讯开放平台的url重写\n#          uri: lb://saas-market-app\n#          predicates: \n#          - Path=/**\n#          filters:\n#          - RewritePath=/(?<appId>^[A-Za-z0-9]+$\\.txt$), /$\\{appId}.txt\n\nmanagement:\n  endpoints:\n    enabled-by-default: false\n\nuw:\n  gateway:\n    enable-access-log: true\n    enable-acme-ssl: false\n    enable-acl-filter: false\n    enable-acl-rate: false\n    enable-saas-load-balance: false\n  auth:\n    client:\n      login-id: rpc\n      login-pass: #{MSC_RPC_PASSWORD}\n  cache:\n    redis:\n      database: 6\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  log:\n    es:\n      server: #{LOG_ES_SERVER}\n      username: #{LOG_ES_USERNAME}\n      password: #{LOG_ES_PASSWORD}','9f653085c0154c30359d8a34514e9769','2025-01-01 00:00:00','2025-01-01 00:00:00','nacos','127.0.0.1','','#{NACOS_NAMESPACE}','','','','yaml','',''),(10,'uw-gateway-ssl','DEFAULT_GROUP','server:\n  port: 443\n  http2:\n    enabled: true\n  shutdown: graceful\n  forward-headers-strategy: native\n  compression:\n    enabled: true\n  error:\n    include-message: always\n  ssl:\n    certificate: \"classpath:/cert/default/cert.crt\"\n    certificate-private-key: \"classpath:/cert/default/private.key\"\n\nspring:\n  cloud:\n    config:\n      allow-override: true\n      override-none: true\n      override-system-properties: false\n    gateway.server.webflux:\n      globalcors:\n        add-to-simple-url-handler-mapping: true\n        cors-configurations:\n          \"[/**]\":\n            allowCredentials: true\n            allowedOriginPatterns: \"*\"\n            allowedMethods: \"*\"\n            allowedHeaders: \"*\"\n      discovery:\n        locator:\n          enabled: true\n          lower-case-service-id: true\n#      routes:\n#        - id: rewrite_app_verify # 针对腾讯开放平台的url重写\n#          uri: lb://saas-market-app\n#          predicates: \n#          - Path=/**\n#          filters:\n#          - RewritePath=/(?<appId>^[A-Za-z0-9]+$\\.txt$), /$\\{appId}.txt\n      \nmanagement:\n  endpoints:\n    enabled-by-default: false\n    \nuw:\n  gateway:\n    enable-access-log: true\n    enable-acme-ssl: false\n    enable-acl-filter: false\n    enable-acl-rate: false\n    enable-saas-load-balance: false\n  auth:\n    client:\n      login-id: rpc\n      login-pass: #{MSC_RPC_PASSWORD}\n  cache:\n    redis:\n      database: 6\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  log:\n    es:\n      server: #{LOG_ES_SERVER}\n      username: #{LOG_ES_USERNAME}\n      password: #{LOG_ES_PASSWORD}','05369aaba6be39dc14c6c5f044a5222e','2025-01-01 00:00:00','2025-01-01 00:00:00','nacos','127.0.0.1','','#{NACOS_NAMESPACE}','','','','yaml','',''),(11,'uw-notify-center','DEFAULT_GROUP','server:\n  port: 10070\n  shutdown: graceful\n  forward-headers-strategy: native\n  tomcat:\n    threads:\n      min-spare: 10\n      max: 200\n    max-connections: 10000\n    uri-encoding: UTF-8\n  error:\n    include-message: always\n\nspring:\n  cloud:\n    config:\n      allow-override: true\n      override-none: true\n      override-system-properties: false\n  jackson:\n    default-property-inclusion: NON_NULL\n    serialization:\n      write-dates-as-timestamps: true\n \nuw:\n  notify:\n    center:\n      redis:\n        database: 8\n        host: #{REDIS_HOST}\n        port: #{REDIS_PORT}\n        username: #{REDIS_USERNAME}\n        password: #{REDIS_PASSWORD}\n        lettuce:\n          pool:\n            max-active: 200\n            max-idle: 8\n            max-wait: 10s\n            min-idle: 1\n        timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  auth:\n    service:\n      app-label: \"消息通知中心\"\n    client:\n      login-id: rpc\n      login-pass: #{MSC_RPC_PASSWORD}\n  log:\n    es:\n      server: #{LOG_ES_SERVER}\n      username: #{LOG_ES_USERNAME}\n      password: #{LOG_ES_PASSWORD}','bf9fc7a366053e6890a0e6b59fec55c9','2025-01-01 00:00:00','2025-01-01 00:00:00','nacos','127.0.0.1','','#{NACOS_NAMESPACE}','','','','yaml','',''),(12,'uw-tinyurl-center','DEFAULT_GROUP','server:\n  port: 10060\n  shutdown: graceful\n  forward-headers-strategy: native\n  tomcat:\n    threads:\n      min-spare: 10\n      max: 200\n    max-connections: 10000\n    uri-encoding: UTF-8\n  error:\n    include-message: always\n\nspring:\n  cloud:\n    config:\n      allow-override: true\n      override-none: true\n      override-system-properties: false\n  jackson:\n    default-property-inclusion: NON_NULL\n    serialization:\n      write-dates-as-timestamps: true\n \nuw:\n  auth:\n    service:\n      app-label: \"系统短链中心\"\n    client:\n      login-id: rpc\n      login-pass: #{MSC_RPC_PASSWORD}\n  dao:\n    conn-pool:\n      root:\n        driver: com.mysql.cj.jdbc.Driver\n        url: jdbc:mysql://#{MYSQL_HOST}:#{MYSQL_PORT}/uw_tinyurl\n        username: uw\n        password: #{MYSQL_UW_PASSWORD}\n        min-conn: 3\n        max-conn: 100\n    table-shard:\n      tinyurl:\n        shard-type: id\n        shard-rule: 10_000_000\n    redis:\n      database: 5\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  log:\n    es:\n      server: #{LOG_ES_SERVER}\n      username: #{LOG_ES_USERNAME}\n      password: #{LOG_ES_PASSWORD}','23ebcc87ca9fd978536e36ee0674f238','2025-01-01 00:00:00','2025-01-01 00:00:00','nacos','127.0.0.1','','#{NACOS_NAMESPACE}','','','','yaml','',''),(15,'uw-code-center','DEFAULT_GROUP','server:\n  port: 10050\n  shutdown: graceful\n  forward-headers-strategy: native\n  tomcat:\n    threads:\n      min-spare: 10\n      max: 200\n    max-connections: 10000\n    uri-encoding: UTF-8\n  error:\n    include-message: always\n\nspring:\n  cloud:\n    config:\n      allow-override: true\n      override-none: true\n      override-system-properties: false\n  jackson:\n    default-property-inclusion: NON_NULL\n    serialization:\n      write-dates-as-timestamps: true\n \nuw:\n  auth:\n    service:\n      app-label: \"代码生成中心\"\n    client:\n      login-id: rpc\n      login-pass: #{MSC_RPC_PASSWORD}\n  dao:\n    conn-pool:\n      root:\n        driver: com.mysql.cj.jdbc.Driver\n        url: jdbc:mysql://#{MYSQL_HOST}:#{MYSQL_PORT}/uw_code\n        username: #{MYSQL_ROOT_USERNAME}\n        password: #{MYSQL_ROOT_PASSWORD}\n        min-conn: 3\n        max-conn: 10\n    redis:\n      database: 5\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  log:\n    es:\n      server: #{LOG_ES_SERVER}\n      username: #{LOG_ES_USERNAME}\n      password: #{LOG_ES_PASSWORD}','24f0ea3e8f62d3a32c7d96a304a0cc72','2025-01-01 00:00:00','2025-01-01 00:00:00','nacos','127.0.0.1','','#{NACOS_NAMESPACE}','','','','yaml','',''),(20,'saas-base-app','DEFAULT_GROUP','server:\n  port: 20000\n  shutdown: graceful\n  forward-headers-strategy: native\n  tomcat:\n    threads:\n      min-spare: 10\n      max: 200\n    max-connections: 10000\n    uri-encoding: UTF-8\n  error:\n    include-message: always\n\nspring:\n  cloud:\n    config:\n      allow-override: true\n      override-none: true\n      override-system-properties: false\n  jackson:\n    default-property-inclusion: NON_NULL\n    serialization:\n      write-dates-as-timestamps: true\n \nuw:\n  auth:\n    service:\n      app-label: \"系统设置\"\n    client:\n      login-id: rpc\n      login-pass: #{MSC_RPC_PASSWORD}\n  dao:\n    conn-pool:\n      root:\n        driver: com.mysql.cj.jdbc.Driver\n        url: jdbc:mysql://#{MYSQL_HOST}:#{MYSQL_PORT}/saas_base\n        username: saas\n        password: #{MYSQL_SAAS_PASSWORD}\n        min-conn: 3\n        max-conn: 100\n    redis:\n      database: 5\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  task:\n    enable-registry: true\n    task-project: saas.base\n    croner-thread-num: 5\n    rabbitmq:\n      host: #{RABBITMQ_HOST}\n      port: #{RABBITMQ_PORT}\n      username: #{RABBITMQ_USERNAME}\n      password: #{RABBITMQ_PASSWORD}\n      publisher-confirm-type: correlated\n      virtual-host: /\n      ssl:\n        enabled: #{RABBITMQ_SSL}\n    redis:\n      database: 7\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  cache:\n    redis:\n      database: 6\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  mfa:\n    device-notify-mobile-api: http://saas-base-app/rpc/msg/sendSms\n    device-notify-email-api: http://saas-base-app/rpc/msg/sendMail\n    redis:\n      database: 3\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  log:\n    es:\n      server: #{LOG_ES_SERVER}\n      username: #{LOG_ES_USERNAME}\n      password: #{LOG_ES_PASSWORD}','e1bbebd63828cd9c1ce63fa3463ada70','2025-01-01 00:00:00','2025-01-01 00:00:00','nacos','127.0.0.1','','#{NACOS_NAMESPACE}','','','','yaml','',''),(21,'saas-finance-app','DEFAULT_GROUP','server:\n  port: 20080\n  shutdown: graceful\n  forward-headers-strategy: native\n  tomcat:\n    threads:\n      min-spare: 10\n      max: 200\n    max-connections: 10000\n    uri-encoding: UTF-8\n  error:\n    include-message: always\n\nspring:\n  cloud:\n    config:\n      allow-override: true\n      override-none: true\n      override-system-properties: false\n  jackson:\n    default-property-inclusion: NON_NULL\n    serialization:\n      write-dates-as-timestamps: true\n \n\nsaas:\n  finance:\n    client:\n      saas-finance-host: http://saas-finance-app\n      saas-finance-site: http://111.230.210.168:80\n\nuw:\n  auth:\n    service:\n      app-label: \"财务中心\"\n    client:\n      login-id: rpc\n      login-pass: #{MSC_RPC_PASSWORD}\n  dao:\n    conn-pool:\n      root:\n        driver: com.mysql.cj.jdbc.Driver\n        url: jdbc:mysql://#{MYSQL_HOST}:#{MYSQL_PORT}/saas_finance\n        username: saas\n        password: #{MYSQL_SAAS_PASSWORD}\n        min-conn: 3\n        max-conn: 100\n    redis:\n      database: 5\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  task:\n    enable-task-registry: true\n    task-project: saas.finance\n    croner-thread-num: 5\n    rabbitmq:\n      host: #{RABBITMQ_HOST}\n      port: #{RABBITMQ_PORT}\n      username: #{RABBITMQ_USERNAME}\n      password: #{RABBITMQ_PASSWORD}\n      publisher-confirm-type: correlated\n      virtual-host: /\n      ssl:\n        enabled: #{RABBITMQ_SSL}\n    redis:\n      database: 7\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  cache:\n    redis:\n      database: 6\n      host: #{REDIS_HOST}\n      port: #{REDIS_PORT}\n      username: #{REDIS_USERNAME}\n      password: #{REDIS_PASSWORD}\n      lettuce:\n        pool:\n          max-active: 200\n          max-idle: 8\n          max-wait: 10s\n          min-idle: 1\n      timeout: 30s\n      ssl:\n        enabled: #{REDIS_SSL}\n  log:\n    es:\n      server: #{LOG_ES_SERVER}\n      username: #{LOG_ES_USERNAME}\n      password: #{LOG_ES_PASSWORD}\n','d368649f3c08b1a197162673a781a885','2025-01-01 00:00:00','2025-01-01 00:00:00','nacos','127.0.0.1','','#{NACOS_NAMESPACE}','','','','yaml','','');
/*!40000 ALTER TABLE `config_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `config_info_aggr`
--

DROP TABLE IF EXISTS `config_info_aggr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `config_info_aggr` (
                                    `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
                                    `data_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'data_id',
                                    `group_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'group_id',
                                    `datum_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'datum_id',
                                    `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '内容',
                                    `gmt_modified` datetime NOT NULL COMMENT '修改时间',
                                    `app_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
                                    `tenant_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '租户字段',
                                    PRIMARY KEY (`id`),
                                    UNIQUE KEY `uk_configinfoaggr_datagrouptenantdatum` (`data_id`,`group_id`,`tenant_id`,`datum_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='增加租户字段';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config_info_aggr`
--

LOCK TABLES `config_info_aggr` WRITE;
/*!40000 ALTER TABLE `config_info_aggr` DISABLE KEYS */;
/*!40000 ALTER TABLE `config_info_aggr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `config_info_beta`
--

DROP TABLE IF EXISTS `config_info_beta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `config_info_beta` (
                                    `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
                                    `data_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'data_id',
                                    `group_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'group_id',
                                    `app_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'app_name',
                                    `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'content',
                                    `beta_ips` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'betaIps',
                                    `md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'md5',
                                    `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                    `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
                                    `src_user` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT 'source user',
                                    `src_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'source ip',
                                    `tenant_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '租户字段',
                                    `encrypted_data_key` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '秘钥',
                                    PRIMARY KEY (`id`),
                                    UNIQUE KEY `uk_configinfobeta_datagrouptenant` (`data_id`,`group_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='config_info_beta';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config_info_beta`
--

LOCK TABLES `config_info_beta` WRITE;
/*!40000 ALTER TABLE `config_info_beta` DISABLE KEYS */;
/*!40000 ALTER TABLE `config_info_beta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `config_info_tag`
--

DROP TABLE IF EXISTS `config_info_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `config_info_tag` (
                                   `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
                                   `data_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'data_id',
                                   `group_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'group_id',
                                   `tenant_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT 'tenant_id',
                                   `tag_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'tag_id',
                                   `app_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'app_name',
                                   `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'content',
                                   `md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'md5',
                                   `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                   `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
                                   `src_user` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT 'source user',
                                   `src_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'source ip',
                                   PRIMARY KEY (`id`),
                                   UNIQUE KEY `uk_configinfotag_datagrouptenanttag` (`data_id`,`group_id`,`tenant_id`,`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='config_info_tag';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config_info_tag`
--

LOCK TABLES `config_info_tag` WRITE;
/*!40000 ALTER TABLE `config_info_tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `config_info_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `config_tags_relation`
--

DROP TABLE IF EXISTS `config_tags_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `config_tags_relation` (
                                        `id` bigint NOT NULL COMMENT 'id',
                                        `tag_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'tag_name',
                                        `tag_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'tag_type',
                                        `data_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'data_id',
                                        `group_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'group_id',
                                        `tenant_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT 'tenant_id',
                                        `nid` bigint NOT NULL AUTO_INCREMENT,
                                        PRIMARY KEY (`nid`),
                                        UNIQUE KEY `uk_configtagrelation_configidtag` (`id`,`tag_name`,`tag_type`),
                                        KEY `idx_tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='config_tag_relation';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config_tags_relation`
--

LOCK TABLES `config_tags_relation` WRITE;
/*!40000 ALTER TABLE `config_tags_relation` DISABLE KEYS */;
/*!40000 ALTER TABLE `config_tags_relation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group_capacity`
--

DROP TABLE IF EXISTS `group_capacity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `group_capacity` (
                                  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                                  `group_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT 'Group ID，空字符表示整个集群',
                                  `quota` int unsigned NOT NULL DEFAULT '0' COMMENT '配额，0表示使用默认值',
                                  `usage` int unsigned NOT NULL DEFAULT '0' COMMENT '使用量',
                                  `max_size` int unsigned NOT NULL DEFAULT '0' COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
                                  `max_aggr_count` int unsigned NOT NULL DEFAULT '0' COMMENT '聚合子配置最大个数，，0表示使用默认值',
                                  `max_aggr_size` int unsigned NOT NULL DEFAULT '0' COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
                                  `max_history_count` int unsigned NOT NULL DEFAULT '0' COMMENT '最大变更历史数量',
                                  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
                                  PRIMARY KEY (`id`),
                                  UNIQUE KEY `uk_group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='集群、各Group容量信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group_capacity`
--

LOCK TABLES `group_capacity` WRITE;
/*!40000 ALTER TABLE `group_capacity` DISABLE KEYS */;
/*!40000 ALTER TABLE `group_capacity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `his_config_info`
--

DROP TABLE IF EXISTS `his_config_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `his_config_info` (
                                   `id` bigint unsigned NOT NULL,
                                   `nid` bigint unsigned NOT NULL AUTO_INCREMENT,
                                   `data_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
                                   `group_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
                                   `app_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'app_name',
                                   `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
                                   `md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
                                   `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                   `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                   `src_user` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
                                   `src_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
                                   `op_type` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
                                   `tenant_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '租户字段',
                                   `encrypted_data_key` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '秘钥',
                                   PRIMARY KEY (`nid`),
                                   KEY `idx_gmt_create` (`gmt_create`),
                                   KEY `idx_gmt_modified` (`gmt_modified`),
                                   KEY `idx_did` (`data_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='多租户改造';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `his_config_info`
--

LOCK TABLES `his_config_info` WRITE;
/*!40000 ALTER TABLE `his_config_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `his_config_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
                               `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
                               `resource` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
                               `action` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
                               UNIQUE KEY `uk_role_permission` (`role`,`resource`,`action`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
                         `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
                         `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
                         UNIQUE KEY `idx_user_role` (`username`,`role`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES ('nacos','ROLE_ADMIN');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tenant_capacity`
--

DROP TABLE IF EXISTS `tenant_capacity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tenant_capacity` (
                                   `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                                   `tenant_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT 'Tenant ID',
                                   `quota` int unsigned NOT NULL DEFAULT '0' COMMENT '配额，0表示使用默认值',
                                   `usage` int unsigned NOT NULL DEFAULT '0' COMMENT '使用量',
                                   `max_size` int unsigned NOT NULL DEFAULT '0' COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
                                   `max_aggr_count` int unsigned NOT NULL DEFAULT '0' COMMENT '聚合子配置最大个数',
                                   `max_aggr_size` int unsigned NOT NULL DEFAULT '0' COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
                                   `max_history_count` int unsigned NOT NULL DEFAULT '0' COMMENT '最大变更历史数量',
                                   `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                   `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
                                   PRIMARY KEY (`id`),
                                   UNIQUE KEY `uk_tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='租户容量信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tenant_capacity`
--

LOCK TABLES `tenant_capacity` WRITE;
/*!40000 ALTER TABLE `tenant_capacity` DISABLE KEYS */;
/*!40000 ALTER TABLE `tenant_capacity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tenant_info`
--

DROP TABLE IF EXISTS `tenant_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tenant_info` (
                               `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
                               `kp` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'kp',
                               `tenant_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT 'tenant_id',
                               `tenant_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT 'tenant_name',
                               `tenant_desc` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'tenant_desc',
                               `create_source` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'create_source',
                               `gmt_create` bigint NOT NULL COMMENT '创建时间',
                               `gmt_modified` bigint NOT NULL COMMENT '修改时间',
                               PRIMARY KEY (`id`),
                               UNIQUE KEY `uk_tenant_info_kptenantid` (`kp`,`tenant_id`),
                               KEY `idx_tenant_id` (`tenant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='tenant_info';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tenant_info`
--

LOCK TABLES `tenant_info` WRITE;
/*!40000 ALTER TABLE `tenant_info` DISABLE KEYS */;
INSERT INTO `tenant_info` VALUES (1,'1','dev','dev','本地开发模式','nacos',1693201249777,1693201249777),(2,'1','debug','debug','开发debug用','nacos',1689998371143,1689998385047),(3,'1','test','test','测试环境','nacos',1681352881570,1681357777616),(5,'1','stag','stag','预上线环境','nacos',1681357819161,1681357819161),(6,'1','prod','prod','线上生产环境','nacos',1681357837242,1681357837242),(8,'1','stab','stab','线上稳定环境','nacos',1687828599554,1687828599554);
/*!40000 ALTER TABLE `tenant_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
                         `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
                         `password` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
                         `enabled` tinyint(1) NOT NULL,
                         PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('nacos','#{NACOS_PASSWORD_BCRYPT}',1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;