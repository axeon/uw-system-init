#!/bin/bash
# startUI.sh — 通用前端 UI 启动器
# 用法: $0 <name> <version> <port> [mem_limit]
# 示例: $0 root-pc-ui 1.1.53 30100
#       $0 root-pc-ui 1.1.53 30100 200m
source "$(dirname "$0")/common.sh"

APP_NAME=$1
APP_VERSION=$2
APP_PORT=$3
APP_MEM_LIMIT=${4:-100m}

if [ -z "$APP_NAME" ] || [ -z "$APP_VERSION" ] || [ -z "$APP_PORT" ]; then
    echo "[ERROR] 用法: $0 <name> <version> <port> [mem_limit]"
    exit 1
fi

CONTAINER_NAME="${APP_NAME}-${APP_PORT}"
docker_remove "$CONTAINER_NAME"

CID=$(docker run -d \
-m ${APP_MEM_LIMIT} \
-e "APP_NAME=${APP_NAME}" \
-e "APP_HOST=${APP_HOST:-$(get_app_host)}" \
-e "APP_PORT=${APP_PORT}" \
-e "NACOS_SERVER=${NACOS_SERVER}" \
-e "NACOS_USERNAME=${NACOS_USERNAME}" \
-e "NACOS_PASSWORD=${NACOS_PASSWORD}" \
-e "NACOS_NAMESPACE=${NACOS_NAMESPACE}" \
${DOCKER_COMMON_OPTS} \
--name=${CONTAINER_NAME} \
"${REGISTRY_SERVER}/${APP_NAME}:${APP_VERSION}")

docker_run_check "$CID" "$CONTAINER_NAME"
