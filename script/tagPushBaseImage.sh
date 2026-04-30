#!/bin/bash
# tagPushBaseImage.sh — 从上游仓库批量推送基础服务镜像到目标仓库
# 用法: $0 <target_registry>
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/../uniweb-registry.config" 2>/dev/null || source "/root/uniweb/uniweb-registry.config" 2>/dev/null

./tagPushImage.sh $1 uw-mydb-mysql:${UW_MYDB_MYSQL}
./tagPushImage.sh $1 uw-auth-center:${UW_AUTH_CENTER}
./tagPushImage.sh $1 uw-task-center:${UW_TASK_CENTER}
./tagPushImage.sh $1 uw-mydb-center:${UW_MYDB_CENTER}
./tagPushImage.sh $1 uw-ops-center:${UW_OPS_CENTER}
./tagPushImage.sh $1 uw-gateway-center:${UW_GATEWAY_CENTER}
./tagPushImage.sh $1 uw-gateway:${UW_GATEWAY}
./tagPushImage.sh $1 saas-base-app:${SAAS_BASE_APP}
./tagPushImage.sh $1 root-pc-ui:${ROOT_PC_UI}
./tagPushImage.sh $1 ops-pc-ui:${OPS_PC_UI}
./tagPushImage.sh $1 admin-pc-ui:${ADMIN_PC_UI}
