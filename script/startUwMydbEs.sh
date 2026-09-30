#!/bin/bash
# startUwMydbEs.sh — 启动 uw-mydb-es agent 节点 (Elasticsearch + 注册到 mydb-center)
# 端口由 entrypoint 自动协商（默认 9200/9300，被占则 +1 递增，粘性落 data/agent/port）。
# 目录用 /home/uw-es9200 而非 /home/es9200：官方 es9200 同机共存时（entrypoint 端口协商
# 即为此设计）数据目录不能共用——ES node lock 互斥，第二个实例起不来。
source "$(dirname "$0")/common.sh"

create_dir /home/uw-es9200/config
create_dir /home/uw-es9200/data
create_dir /home/uw-es9200/logs
create_dir /home/uw-es9200/plugins

# 基础 yml 缺失时自举（initHome 模板未分发时兜底；安全关闭形态免证书栈，http 明文）。
# 内容须与 initHome/uw-es9200/config/elasticsearch.yml 模板保持同步（双份维护，调参两处同改）。
# 切勿预置 cluster.initial_master_nodes / node.name：单机初始化写 discovery.type=single-node
# 会与 initial_master_nodes 冲突（ES 启动直接报错），组队/join 段由 center 标记块注入。
if [ ! -f /home/uw-es9200/config/elasticsearch.yml ]; then
    cat > /home/uw-es9200/config/elasticsearch.yml <<'EOF'
# uw-mydb-es agent 节点基础配置（演示/联调形态）
# - 安全默认关闭：免证书栈；凭据后续经 mydb-center 集群行/改密链路开启
# - 组队/join/单机的 discovery 段由 center 追加标记块（# >>> uw-es-orchestration >>>）注入
network.host: 0.0.0.0
xpack.security.enabled: false
EOF
    echo "/home/uw-es9200/config/elasticsearch.yml seeded!"
fi

# vm.max_map_count: ES mmap 内核前提（数据节点主机未跑过 init/initEs.sh 时自助补齐）
if [ "$(sysctl -n vm.max_map_count 2>/dev/null || echo 0)" -lt 262144 ]; then
    sysctl -w vm.max_map_count=262144
    grep -q 'vm.max_map_count=262144' /etc/sysctl.conf 2>/dev/null \
        || echo 'vm.max_map_count=262144' >> /etc/sysctl.conf
fi

chown -R 1000:1000 /home/uw-es9200

docker_remove uw-mydb-es-9200

CID=$(docker run -d \
--ulimit nofile=65535:65535 \
--ulimit nproc=32768:32768 \
--ulimit memlock=-1:-1 \
-e "ES_JAVA_OPTS=-Xms1g -Xmx1g" \
-e "MYDB_CENTER_HOST=${GATEWAY_SERVER}/uw-mydb-center" \
-v /home/uw-es9200/config:/usr/share/elasticsearch/config \
-v /home/uw-es9200/data:/usr/share/elasticsearch/data \
-v /home/uw-es9200/logs:/usr/share/elasticsearch/logs \
-v /home/uw-es9200/plugins:/usr/share/elasticsearch/plugins \
${DOCKER_COMMON_OPTS} \
--name=uw-mydb-es-9200 \
"${REGISTRY_SERVER}/${IMAGE_ES_UW}")

docker_run_check "$CID" "uw-mydb-es-9200"
