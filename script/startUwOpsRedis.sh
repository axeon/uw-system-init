#!/bin/bash
# startUwOpsRedis.sh — 启动 uw-ops-redis agent 节点 (Redis + 注册到 mydb-center)
# 端口由 entrypoint 自动协商（默认 6379/16379 cluster-bus，被占则 +1 递增，粘性落 data/agent/port）。
source "$(dirname "$0")/common.sh"

create_dir /home/uw-ops-redis-6379/conf
create_dir /home/uw-ops-redis-6379/data

# redis.conf 缺失时自举（默认 CMD 读取 /usr/local/etc/redis/redis.conf，无该文件容器直接退出；
# 端口/TLS/改密经 CLI 参数与编排标记块动态注入，conf 调参单源在官方镜像默认值）
if [ ! -f /home/uw-ops-redis-6379/conf/redis.conf ]; then
    cat > /home/uw-ops-redis-6379/conf/redis.conf <<'EOF'
# network
# port 行仅兜底：实际端口由 entrypoint 以 --port 注入（协商结果）
port 6379
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
        printf 'requirepass %s\n' "${REDIS_PASSWORD}" >> /home/uw-ops-redis-6379/conf/redis.conf
    fi
    echo "/home/uw-ops-redis-6379/conf/redis.conf seeded!"
fi

# conf 属主对齐容器内 redis 用户 (uid 999)：center 改密链路的 CONFIG REWRITE
# 由 redis-server 进程回写 conf，root 属主会写失败（凭据不持久化）
chown -R 999:999 /home/uw-ops-redis-6379/conf

docker_remove uw-ops-redis-6379

CID=$(docker run -d \
-e "OPS_CENTER_HOST=${GATEWAY_SERVER}/uw-ops-center" \
-v /home/uw-ops-redis-6379/conf:/usr/local/etc/redis \
-v /home/uw-ops-redis-6379/data:/data \
${DOCKER_COMMON_OPTS} \
--name=uw-ops-redis-6379 \
"${REGISTRY_SERVER}/${IMAGE_REDIS_UW}")

docker_run_check "$CID" "uw-ops-redis-6379"
