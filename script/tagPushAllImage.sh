#!/bin/bash
# tagPushAllImage.sh — 从上游仓库批量推送所有 UniWeb 镜像到目标仓库
# 用法: $0 <target_registry>
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

TARGET_REGISTRY="$1"
if [ -z "$TARGET_REGISTRY" ]; then
    echo "[ERROR] 用法: $0 <target_registry>"
    exit 1
fi

bash "${SCRIPT_DIR}/tagPushImage.sh" "$TARGET_REGISTRY" "${IMAGE_MYSQL}"
bash "${SCRIPT_DIR}/tagPushImage.sh" "$TARGET_REGISTRY" "${IMAGE_UW_AUTH_CENTER}"
bash "${SCRIPT_DIR}/tagPushImage.sh" "$TARGET_REGISTRY" "${IMAGE_UW_TASK_CENTER}"
bash "${SCRIPT_DIR}/tagPushImage.sh" "$TARGET_REGISTRY" "${IMAGE_UW_OPS_CENTER}"
bash "${SCRIPT_DIR}/tagPushImage.sh" "$TARGET_REGISTRY" "${IMAGE_UW_MYDB_CENTER}"
bash "${SCRIPT_DIR}/tagPushImage.sh" "$TARGET_REGISTRY" "${IMAGE_UW_MYDB_PROXY}"
bash "${SCRIPT_DIR}/tagPushImage.sh" "$TARGET_REGISTRY" "${IMAGE_UW_TINYURL_CENTER}"
bash "${SCRIPT_DIR}/tagPushImage.sh" "$TARGET_REGISTRY" "${IMAGE_UW_NOTIFY_CENTER}"
bash "${SCRIPT_DIR}/tagPushImage.sh" "$TARGET_REGISTRY" "${IMAGE_UW_GATEWAY_CENTER}"
bash "${SCRIPT_DIR}/tagPushImage.sh" "$TARGET_REGISTRY" "${IMAGE_UW_GATEWAY}"
bash "${SCRIPT_DIR}/tagPushImage.sh" "$TARGET_REGISTRY" "${IMAGE_SAAS_BASE_APP}"
bash "${SCRIPT_DIR}/tagPushImage.sh" "$TARGET_REGISTRY" "${IMAGE_SAAS_FINANCE_APP}"
bash "${SCRIPT_DIR}/tagPushImage.sh" "$TARGET_REGISTRY" "${IMAGE_ROOT_PC_UI}"
bash "${SCRIPT_DIR}/tagPushImage.sh" "$TARGET_REGISTRY" "${IMAGE_OPS_PC_UI}"
bash "${SCRIPT_DIR}/tagPushImage.sh" "$TARGET_REGISTRY" "${IMAGE_ADMIN_PC_UI}"
bash "${SCRIPT_DIR}/tagPushImage.sh" "$TARGET_REGISTRY" "${IMAGE_SAAS_PC_UI}"
