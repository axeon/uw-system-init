#!/bin/bash
# localPullImage.sh — 从本地仓库批量拉取所有 UniWeb 服务镜像
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/../common.sh"
source "${SCRIPT_DIR}/../../uniweb-registry.config" 2>/dev/null || source "/root/uniweb/uniweb-registry.config" 2>/dev/null
source "${SCRIPT_DIR}/../../uniweb-system.config" 2>/dev/null || source "/root/uniweb/uniweb-system.config" 2>/dev/null

docker pull ${REGISTRY_SERVER}/uw-mydb-mysql:${UW_MYDB_MYSQL}
docker pull ${REGISTRY_SERVER}/uw-auth-center:${UW_AUTH_CENTER}
docker pull ${REGISTRY_SERVER}/uw-task-center:${UW_TASK_CENTER}
docker pull ${REGISTRY_SERVER}/uw-gateway-center:${UW_GATEWAY_CENTER}
docker pull ${REGISTRY_SERVER}/uw-gateway:${UW_GATEWAY}
docker pull ${REGISTRY_SERVER}/uw-ops-center:${UW_OPS_CENTER}
docker pull ${REGISTRY_SERVER}/uw-mydb-center:${UW_MYDB_CENTER}
docker pull ${REGISTRY_SERVER}/uw-mydb-proxy:${UW_MYDB_PROXY}
docker pull ${REGISTRY_SERVER}/uw-tinyurl-center:${UW_TINYURL_CENTER}
docker pull ${REGISTRY_SERVER}/uw-notify-center:${UW_NOTIFY_CENTER}
docker pull ${REGISTRY_SERVER}/root-pc-ui:${ROOT_PC_UI}
docker pull ${REGISTRY_SERVER}/ops-pc-ui:${OPS_PC_UI}
docker pull ${REGISTRY_SERVER}/admin-pc-ui:${ADMIN_PC_UI}
docker pull ${REGISTRY_SERVER}/saas-base-app:${SAAS_BASE_APP}
docker pull ${REGISTRY_SERVER}/saas-finance-app:${SAAS_FINANCE_APP}
docker pull ${REGISTRY_SERVER}/saas-pc-ui:${SAAS_PC_UI}
