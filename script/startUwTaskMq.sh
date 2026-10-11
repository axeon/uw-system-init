#!/bin/bash
# startUwTaskMq.sh — 启动 uw-task-mq agent 节点 (RabbitMQ management + 注册到 task-center)
# 端口由 entrypoint 自动协商（默认 5672 amqp / 15672 mgmt / 15692 prometheus，被占则 +1 递增，
# 粘性落 /var/lib/rabbitmq/agent/port）；erlang cookie 由 center 组队任务统一下发。
source "$(dirname "$0")/common.sh"

create_dir /home/mq5672/data

docker_remove uw-task-mq-5672

CID=$(docker run -d \
-e "OPS_CENTER_HOST=${GATEWAY_SERVER}/uw-ops-center" \
-e "RABBITMQ_DEFAULT_USER=${RABBITMQ_USERNAME}" \
-e "RABBITMQ_DEFAULT_PASS=${RABBITMQ_PASSWORD}" \
-v /home/mq5672/data:/var/lib/rabbitmq \
${DOCKER_COMMON_OPTS} \
--name=uw-task-mq-5672 \
"${REGISTRY_SERVER}/${IMAGE_MQ_UW}")

docker_run_check "$CID" "uw-task-mq-5672"
