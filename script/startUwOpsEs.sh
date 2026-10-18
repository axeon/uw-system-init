#!/bin/bash
# startUwOpsEs.sh — 启动 uw-ops-es agent 节点 (Elasticsearch + 注册到 mydb-center)
# 规划端口 UW_ES_PORT（缺省 9200）贯通容器名/数据目录/协商基数：容器名=uw-ops-es-{port}
# （全平台命名模板），--hostname 与容器名同源（agent uname -n 即容器名，台账关联键）；
# entrypoint 以规划端口为基数协商端口组（被占则 +1 递增，粘性落 data/agent/port）。
# 目录用 /home/uw-ops-es-{port} 而非 /home/es9200：官方 es9200 同机共存时（entrypoint 端口协商
# 即为此设计）数据目录不能共用——ES node lock 互斥，第二个实例起不来。
source "$(dirname "$0")/common.sh"

UW_ES_PORT=${UW_ES_PORT:-9200}
CONTAINER_NAME="uw-ops-es-${UW_ES_PORT}"
# 数据目录根=容器名（目录名与容器名同源耦合，单点表达）
BASE_DIR="/home/${CONTAINER_NAME}"

create_dir ${BASE_DIR}/config
create_dir ${BASE_DIR}/data
create_dir ${BASE_DIR}/logs
create_dir ${BASE_DIR}/plugins

# 基础 yml 缺失时自举（镜像 Dockerfile 已烤默认值，此处兜底空挂载目录；调参单源在镜像）。
# 切勿预置 cluster.initial_master_nodes / node.name：单机初始化写 discovery.type=single-node
# 会与 initial_master_nodes 冲突（ES 启动直接报错），组队/join 段由 center 标记块注入
# （node.name 由 entrypoint 以 -E 注入 ip:port 身份名，不落 yml）。
if [ ! -f ${BASE_DIR}/config/elasticsearch.yml ]; then
    cat > ${BASE_DIR}/config/elasticsearch.yml <<'EOF'
# uw-ops-es agent 节点基础配置（演示/联调形态）
# - 安全默认关闭：免证书栈；凭据后续经 mydb-center 集群行/改密链路开启
# - 组队/join/单机的 discovery 段由 center 追加标记块（# >>> uw-es-orchestration >>>）注入
network.host: 0.0.0.0
xpack.security.enabled: false
EOF
    echo "${BASE_DIR}/config/elasticsearch.yml seeded!"
fi

# vm.max_map_count: ES mmap 内核前提（数据节点主机未跑过 init/initEs.sh 时自助补齐）
if [ "$(sysctl -n vm.max_map_count 2>/dev/null || echo 0)" -lt 262144 ]; then
    sysctl -w vm.max_map_count=262144
    grep -q 'vm.max_map_count=262144' /etc/sysctl.conf 2>/dev/null \
        || echo 'vm.max_map_count=262144' >> /etc/sysctl.conf
fi

chown -R 1000:1000 ${BASE_DIR}

docker_remove ${CONTAINER_NAME}

CID=$(docker run -d \
--ulimit nofile=65535:65535 \
--ulimit nproc=32768:32768 \
--ulimit memlock=-1:-1 \
-e "ES_JAVA_OPTS=-Xms1g -Xmx1g" \
-e "OPS_CENTER_HOST=${GATEWAY_SERVER}/uw-ops-center" \
-e "UW_ES_PORT=${UW_ES_PORT}" \
--hostname=${CONTAINER_NAME} \
-v ${BASE_DIR}/config:/usr/share/elasticsearch/config \
-v ${BASE_DIR}/data:/usr/share/elasticsearch/data \
-v ${BASE_DIR}/logs:/usr/share/elasticsearch/logs \
-v ${BASE_DIR}/plugins:/usr/share/elasticsearch/plugins \
${DOCKER_COMMON_OPTS} \
--name=${CONTAINER_NAME} \
"${REGISTRY_SERVER}/${IMAGE_ES_UW}")

docker_run_check "$CID" "${CONTAINER_NAME}"
