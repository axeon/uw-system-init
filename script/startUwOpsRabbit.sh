#!/bin/bash
# startUwOpsRabbit.sh — 启动 uw-ops-rabbit agent 节点 (RabbitMQ management + 注册到 task-center)
# 规划端口 UW_RABBIT_PORT（缺省 5672）贯通容器名/数据目录/协商基数：容器名=uw-ops-rabbit-{port}
# （全平台命名模板），--hostname 与容器名同源（agent uname -n 即容器名，台账关联键）；
# entrypoint 以规划端口为基数协商整组端口（被占则 +1 递增，粘性落 /var/lib/rabbitmq/agent/port）；
# erlang cookie 由 center 组队任务统一下发。
source "$(dirname "$0")/common.sh"

UW_RABBIT_PORT=${UW_RABBIT_PORT:-5672}
CONTAINER_NAME="uw-ops-rabbit-${UW_RABBIT_PORT}"
# 数据目录根=容器名（目录名与容器名同源耦合，单点表达）
BASE_DIR="/home/${CONTAINER_NAME}"

create_dir ${BASE_DIR}/data

docker_remove ${CONTAINER_NAME}

CID=$(docker run -d \
-e "OPS_CENTER_HOST=${GATEWAY_SERVER}/uw-ops-center" \
-e "UW_RABBIT_PORT=${UW_RABBIT_PORT}" \
-e "RABBITMQ_DEFAULT_USER=${RABBITMQ_USERNAME}" \
-e "RABBITMQ_DEFAULT_PASS=${RABBITMQ_PASSWORD}" \
--hostname=${CONTAINER_NAME} \
-v ${BASE_DIR}/data:/var/lib/rabbitmq \
${DOCKER_COMMON_OPTS} \
--name=${CONTAINER_NAME} \
"${REGISTRY_SERVER}/${IMAGE_MQ_UW}")

docker_run_check "$CID" "${CONTAINER_NAME}"
