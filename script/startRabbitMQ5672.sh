#!/bin/bash
# startRabbitMQ5672.sh — 启动 RabbitMQ 队列服务 (端口 5672)
source "$(dirname "$0")/common.sh"

create_dir /home/rabbitmq5672/data

docker_remove rabbitmq5672

CID=$(docker run -d \
-e "RABBITMQ_DEFAULT_USER=${RABBITMQ_USERNAME}" \
-e "RABBITMQ_DEFAULT_PASS=${RABBITMQ_PASSWORD}" \
-v /home/rabbitmq5672/data:/var/lib/rabbitmq \
${DOCKER_COMMON_OPTS} \
--name=rabbitmq5672 \
"${REGISTRY_SERVER}/${IMAGE_RABBITMQ}")

docker_run_check "$CID" "rabbitmq5672"
