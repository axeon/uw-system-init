#!/bin/bash
# startApp.sh — 通用 Java 微服务启动器
# 用法: $0 <name> <version> <port> [mem_limit] [extra_spring_opts]
# 示例: $0 uw-auth-center 6.1.15 10000
#       $0 uw-auth-center 6.1.15 10000 2g
# JVM:  ZGC + MaxRAMPercentage=80.0 (JDK 25, 自动归还内存给 OS)
source "$(dirname "$0")/common.sh"

APP_NAME=$1
APP_VERSION=$2
APP_PORT=$3
APP_MEM_LIMIT=${4:-800m}
APP_EXTRA=${5:-}

if [ -z "$APP_NAME" ] || [ -z "$APP_VERSION" ] || [ -z "$APP_PORT" ]; then
    echo "[ERROR] 用法: $0 <name> <version> <port> [mem_limit] [extra_spring_opts]"
    exit 1
fi

CONTAINER_NAME="${APP_NAME}-${APP_PORT}"
docker_remove "$CONTAINER_NAME"

# Docker 内存限制 (JVM 通过 MaxRAMPercentage 自动感知 cgroup 上限)
DOCKER_MEM_OPTS="-m ${APP_MEM_LIMIT}"


CID=$(docker run -d \
${DOCKER_MEM_OPTS} \
-e "JAVA_OPTS=-XX:+UseZGC -XX:MaxRAMPercentage=80.0" \
-e "SPRING_OPTS=--app.info=${APP_NAME}:${APP_VERSION} --spring.profiles.active=${NACOS_NAMESPACE} ${APP_EXTRA} --server.port=${APP_PORT}" \
-e "APP_HOST=${APP_HOST:-$(get_app_host)}" \
-e "APP_PORT=${APP_PORT}" \
-e "NACOS_SERVER=${NACOS_SERVER}" \
-e "NACOS_USERNAME=${NACOS_USERNAME}" \
-e "NACOS_PASSWORD=${NACOS_PASSWORD}" \
-e "NACOS_NAMESPACE=${NACOS_NAMESPACE}" \
-e "LOG_ES_SERVER=${LOG_ES_SERVER}" \
-e "LOG_ES_USERNAME=${LOG_ES_USERNAME}" \
-e "LOG_ES_PASSWORD=${LOG_ES_PASSWORD}" \
${DOCKER_COMMON_OPTS} \
--name=${CONTAINER_NAME} \
"${REGISTRY_SERVER}/${APP_NAME}:${APP_VERSION}")

docker_run_check "$CID" "$CONTAINER_NAME"
