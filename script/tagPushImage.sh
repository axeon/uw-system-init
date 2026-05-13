#!/bin/bash
# tagPushImage.sh — 拉取镜像并推送到目标仓库
# 用法: $0 <target_registry> <image:tag>
# 流程: 优先 UNIWEB_REGISTRY_SERVER，失败回退 PUBLIC_REGISTRY_SERVER (Docker Hub) → tag → push
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

TARGET_REGISTRY="$1"
APP_INFO="$2"

if [ -z "$TARGET_REGISTRY" ] || [ -z "$APP_INFO" ]; then
    echo "[ERROR] 用法: $0 <target_registry> <image:tag>"
    exit 1
fi

DEST_REF="${TARGET_REGISTRY}/${APP_INFO}"
PUBLIC_REF="${PUBLIC_REGISTRY_SERVER:+${PUBLIC_REGISTRY_SERVER}/}${APP_INFO}"

if docker image inspect "$DEST_REF" &>/dev/null; then
    echo "[OK] 镜像已存在: ${DEST_REF}"
    exit 0
fi

PULLED_REF=""
echo "[INFO] 拉取 ${APP_INFO}..."

UPSTREAM_REF="${UNIWEB_REGISTRY_SERVER}/${APP_INFO}"
if docker pull "$UPSTREAM_REF"; then
    PULLED_REF="$UPSTREAM_REF"
else
    echo "[WARN] 上游仓库拉取失败，尝试公共仓库..."
    if docker pull "$PUBLIC_REF"; then
        PULLED_REF="$PUBLIC_REF"
    else
        echo "[ERROR] 镜像拉取失败: ${APP_INFO}"
        exit 1
    fi
fi

echo "[INFO] 标记为 ${DEST_REF}..."
docker tag "$PULLED_REF" "$DEST_REF"

echo "[INFO] 推送到 ${DEST_REF}..."
docker push "$DEST_REF"

echo "[OK] 完成: ${DEST_REF}"
