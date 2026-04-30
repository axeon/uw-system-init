#!/bin/bash
# tagPullImage.sh — 从上游仓库拉取镜像并推送到本地仓库
# 用法: $0 <image:tag> [target_registry]
# 默认推送到 REGISTRY_SERVER (本机仓库)
# 流程: pull (UNIWEB_REGISTRY_SERVER) → tag → push (本地仓库)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/../common.sh"

APP_INFO="$1"
TARGET_REGISTRY="$2"

if [ -z "$APP_INFO" ]; then
    echo "[ERROR] 用法: $0 <image:tag> [target_registry]"
    exit 1
fi

DEST_REGISTRY="${TARGET_REGISTRY:-${REGISTRY_SERVER}}"

# Step 1: 从上游仓库拉取
echo "[INFO] 拉取 ${UNIWEB_REGISTRY_SERVER}/${APP_INFO}..."
docker pull "${UNIWEB_REGISTRY_SERVER}/${APP_INFO}"

# Step 2: 打标签为本地仓库地址
echo "[INFO] 标记为 ${DEST_REGISTRY}/${APP_INFO}..."
docker tag "${UNIWEB_REGISTRY_SERVER}/${APP_INFO}" "${DEST_REGISTRY}/${APP_INFO}"

# Step 3: 推送到本地仓库
echo "[INFO] 推送到 ${DEST_REGISTRY}/${APP_INFO}..."
docker push "${DEST_REGISTRY}/${APP_INFO}"
