#!/bin/bash
# tagPullAllImage.sh — 从上游仓库批量搬运所有 UniWeb 镜像到本地仓库
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/../../uniweb-registry.config" 2>/dev/null || source "/root/uniweb/uniweb-registry.config" 2>/dev/null

bash "${SCRIPT_DIR}/tagPullImage.sh" uw-mydb-mysql:${UW_MYDB_MYSQL}
bash "${SCRIPT_DIR}/tagPullImage.sh" uw-auth-center:${UW_AUTH_CENTER}
bash "${SCRIPT_DIR}/tagPullImage.sh" uw-task-center:${UW_TASK_CENTER}
bash "${SCRIPT_DIR}/tagPullImage.sh" uw-gateway-center:${UW_GATEWAY_CENTER}
bash "${SCRIPT_DIR}/tagPullImage.sh" uw-gateway:${UW_GATEWAY}
bash "${SCRIPT_DIR}/tagPullImage.sh" uw-ops-center:${UW_OPS_CENTER}
bash "${SCRIPT_DIR}/tagPullImage.sh" uw-mydb-center:${UW_MYDB_CENTER}
bash "${SCRIPT_DIR}/tagPullImage.sh" uw-mydb-proxy:${UW_MYDB_PROXY}
bash "${SCRIPT_DIR}/tagPullImage.sh" uw-tinyurl-center:${UW_TINYURL_CENTER}
bash "${SCRIPT_DIR}/tagPullImage.sh" uw-notify-center:${UW_NOTIFY_CENTER}
bash "${SCRIPT_DIR}/tagPullImage.sh" root-pc-ui:${ROOT_PC_UI}
bash "${SCRIPT_DIR}/tagPullImage.sh" ops-pc-ui:${OPS_PC_UI}
bash "${SCRIPT_DIR}/tagPullImage.sh" admin-pc-ui:${ADMIN_PC_UI}
bash "${SCRIPT_DIR}/tagPullImage.sh" saas-base-app:${SAAS_BASE_APP}
bash "${SCRIPT_DIR}/tagPullImage.sh" saas-finance-app:${SAAS_FINANCE_APP}
bash "${SCRIPT_DIR}/tagPullImage.sh" saas-pc-ui:${SAAS_PC_UI}
