#!/bin/bash
# startGateway80.sh — 启动 uw-gateway (HTTP 80, 限 1g 内存)
source "$(dirname "$0")/common.sh"
GATEWAY_VERSION="${IMAGE_UW_GATEWAY#*:}"
bash "${SCRIPT_DIR}/startApp.sh" uw-gateway "$GATEWAY_VERSION" 80 1g
