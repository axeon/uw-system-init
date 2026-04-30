#!/bin/bash
# startRedis6380.sh — 启动 Redis 缓存服务 (端口 6380)
source "$(dirname "$0")/common.sh"

create_dir /home/redis6380/conf
create_dir /home/redis6380/data

docker_remove redis6380

CID=$(docker run -d \
-v /home/redis6380/conf:/usr/local/etc/redis \
-v /home/redis6380/data:/data \
${DOCKER_COMMON_OPTS} \
--name=redis6380 \
"${IMAGE_REDIS}" redis-server /usr/local/etc/redis/redis.conf)

docker_run_check "$CID" "redis6380"
