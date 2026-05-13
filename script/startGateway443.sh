#!/bin/bash
# startGateway443.sh — 启动 uw-gateway (HTTPS 443, 限 1g 内存)
source "$(dirname "$0")/common.sh"
GATEWAY_VERSION="${IMAGE_UW_GATEWAY#*:}"
bash "${SCRIPT_DIR}/startApp.sh" uw-gateway "$GATEWAY_VERSION" 443 1g "--spring.application.name=uw-gateway-ssl"
