#!/bin/bash
# startUwOpsRedis.sh — 启动 uw-ops-redis agent 节点 (Redis + 注册到 mydb-center)
# 规划端口 UW_REDIS_PORT（缺省 6379）贯通容器名/数据目录/协商基数：容器名=uw-ops-redis-{port}
# （全平台命名模板），--hostname 与容器名同源（agent uname -n 即容器名，台账关联键）；
# entrypoint 以规划端口为基数协商端口组（6379/16379 cluster-bus，被占则 +1 递增，粘性落 data/agent/port）。
source "$(dirname "$0")/common.sh"

UW_REDIS_PORT=${UW_REDIS_PORT:-6379}
CONTAINER_NAME="uw-ops-redis-${UW_REDIS_PORT}"
# 数据目录根=容器名（目录名与容器名同源耦合，单点表达）
BASE_DIR="/home/${CONTAINER_NAME}"

create_dir ${BASE_DIR}/conf
create_dir ${BASE_DIR}/data

# redis.conf 缺失时自举（默认 CMD 读取 /usr/local/etc/redis/redis.conf，无该文件容器直接退出；
# 端口/TLS/改密经 CLI 参数与编排标记块动态注入，conf 调参单源在官方镜像默认值）
if [ ! -f ${BASE_DIR}/conf/redis.conf ]; then
    cat > ${BASE_DIR}/conf/redis.conf <<EOF
# network
# port 行仅兜底：实际端口由 entrypoint 以 --port 注入（协商结果），此处写规划端口
port ${UW_REDIS_PORT}
tcp-backlog 511
timeout 0
tcp-keepalive 300
# database
databases 128
maxclients 100000
# memory
maxmemory-policy volatile-lru
maxmemory 32gb
# aof&rdb
rdbcompression yes
appendonly yes
appendfilename "appendonly.aof"
appendfsync no
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 256mb
aof-load-truncated yes
aof-use-rdb-preamble yes
# lua
lua-time-limit 10000
# slowlog
slowlog-log-slower-than 10000
slowlog-max-len 128
EOF
    # 凭据仅在非空时写入（空参 requirepass 是非法指令，redis-server 会拒绝启动）
    if [ -n "${REDIS_PASSWORD}" ]; then
        printf 'requirepass %s\n' "${REDIS_PASSWORD}" >> ${BASE_DIR}/conf/redis.conf
    fi
    echo "${BASE_DIR}/conf/redis.conf seeded!"
fi

# conf 属主对齐容器内 redis 用户 (uid 999)：center 改密链路的 CONFIG REWRITE
# 由 redis-server 进程回写 conf，root 属主会写失败（凭据不持久化）
chown -R 999:999 ${BASE_DIR}/conf

docker_remove ${CONTAINER_NAME}

CID=$(docker run -d \
-e "OPS_CENTER_HOST=${GATEWAY_SERVER}/uw-ops-center" \
-e "UW_REDIS_PORT=${UW_REDIS_PORT}" \
--hostname=${CONTAINER_NAME} \
-v ${BASE_DIR}/conf:/usr/local/etc/redis \
-v ${BASE_DIR}/data:/data \
${DOCKER_COMMON_OPTS} \
--name=${CONTAINER_NAME} \
"${REGISTRY_SERVER}/${IMAGE_REDIS_UW}")

docker_run_check "$CID" "${CONTAINER_NAME}"
