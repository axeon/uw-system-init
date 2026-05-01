#!/bin/bash
# startNacos8848.sh — 启动 Nacos 服务管理 (端口 8848, standalone 模式)
source "$(dirname "$0")/common.sh"

create_dir /home/nacos8848/logs
create_dir /home/nacos8848/conf

docker_remove nacos8848

CID=$(docker run -d \
-m 1g \
-e "MODE=standalone" \
-v /home/nacos8848/logs:/home/nacos/logs \
-v /home/nacos8848/conf:/home/nacos/conf \
${DOCKER_COMMON_OPTS} \
--cpus=1 \
--name=nacos8848 \
"${REGISTRY_SERVER}/${IMAGE_NACOS}")

docker_run_check "$CID" "nacos8848"
