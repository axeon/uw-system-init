#!/bin/bash
# tagPullBaseImage.sh — 从上游仓库搬运基础服务镜像到本地仓库
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/../common.sh"

bash "${SCRIPT_DIR}/tagPullImage.sh" "${IMAGE_MYSQL}"
bash "${SCRIPT_DIR}/tagPullImage.sh" "${IMAGE_UW_AUTH_CENTER}"
bash "${SCRIPT_DIR}/tagPullImage.sh" "${IMAGE_UW_TASK_CENTER}"
bash "${SCRIPT_DIR}/tagPullImage.sh" "${IMAGE_UW_MYDB_CENTER}"
bash "${SCRIPT_DIR}/tagPullImage.sh" "${IMAGE_UW_OPS_CENTER}"
bash "${SCRIPT_DIR}/tagPullImage.sh" "${IMAGE_UW_GATEWAY_CENTER}"
bash "${SCRIPT_DIR}/tagPullImage.sh" "${IMAGE_UW_GATEWAY}"
bash "${SCRIPT_DIR}/tagPullImage.sh" "${IMAGE_ROOT_PC_UI}"
bash "${SCRIPT_DIR}/tagPullImage.sh" "${IMAGE_OPS_PC_UI}"
bash "${SCRIPT_DIR}/tagPullImage.sh" "${IMAGE_ADMIN_PC_UI}"
bash "${SCRIPT_DIR}/tagPullImage.sh" "${IMAGE_SAAS_BASE_APP}"
