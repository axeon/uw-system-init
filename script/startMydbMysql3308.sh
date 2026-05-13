#!/bin/bash
# startMydbMysql3308.sh — 启动 MySQL 数据库 (端口 3308)
source "$(dirname "$0")/common.sh"

create_dir /home/mysql3308/conf
create_dir /home/mysql3308/data
create_dir /home/mysql3308/logs
create_dir /home/mysql3308/files

docker_remove uw-mydb-mysql-3308

CID=$(docker run -d \
-e "MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}" \
-e "MYDB_CENTER_HOST=${GATEWAY_SERVER}/uw-mydb-center" \
-v /home/mysql3308/conf:/etc/mysql/conf.d \
-v /home/mysql3308/logs:/logs \
-v /home/mysql3308/data:/var/lib/mysql \
-v /home/mysql3308/files:/var/lib/mysql-files \
${DOCKER_COMMON_OPTS} \
--name=uw-mydb-mysql-3308 \
"${REGISTRY_SERVER}/${IMAGE_MYSQL}")

docker_run_check "$CID" "uw-mydb-mysql-3308"
