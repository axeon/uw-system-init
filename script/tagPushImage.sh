#!/bin/bash
# tagPushImage.sh — 从上游仓库拉取单个镜像并推送到目标仓库
# 用法: $0 <target_registry> <image:tag>
# 流程: pull (UNIWEB_REGISTRY_SERVER) → tag → push (target_registry)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

TARGET_REGISTRY="$1"
APP_INFO="$2"

if [ -z "$TARGET_REGISTRY" ] || [ -z "$APP_INFO" ]; then
    echo "[ERROR] 用法: $0 <target_registry> <image:tag>"
    exit 1
fi

echo "[INFO] 拉取 ${UNIWEB_REGISTRY_SERVER}/${APP_INFO}..."
docker pull "${UNIWEB_REGISTRY_SERVER}/${APP_INFO}"

echo "[INFO] 标记为 ${TARGET_REGISTRY}/${APP_INFO}..."
docker tag "${UNIWEB_REGISTRY_SERVER}/${APP_INFO}" "${TARGET_REGISTRY}/${APP_INFO}"

echo "[INFO] 推送到 ${TARGET_REGISTRY}/${APP_INFO}..."
docker push "${TARGET_REGISTRY}/${APP_INFO}"
