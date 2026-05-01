#!/bin/bash
# slaveService.sh — 从机安装 HTTP 分发服务
# 由 systemd socket activation 调用
# source config 后将实际值注入 slaveInstaller.sh 并通过 HTTP 返回

source /root/uniweb/uniweb-system.config 2>/dev/null || exit 1

while IFS= read -t 5 -r line; do
    line="${line%$'\r'}"
    [ -z "$line" ] && break
done

INSTALLER_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE="${INSTALLER_DIR}/slaveInstaller.sh"

if [ ! -f "$TEMPLATE" ]; then
    printf "HTTP/1.1 500 Internal Server Error\r\nContent-Type: text/plain\r\nConnection: close\r\n\r\nslaveInstaller.sh not found"
    exit 1
fi

BODY=$(sed \
    -e "s|^REGISTRY_SERVER=\"\"|REGISTRY_SERVER=\"${REGISTRY_SERVER}\"|" \
    -e "s|^REGISTRY_USERNAME=\"\"|REGISTRY_USERNAME=\"${REGISTRY_USERNAME}\"|" \
    -e "s|^REGISTRY_PASSWORD=\"\"|REGISTRY_PASSWORD=\"${REGISTRY_PASSWORD}\"|" \
    -e "s|^GATEWAY_SERVER=\"\"|GATEWAY_SERVER=\"${GATEWAY_SERVER}\"|" \
    "$TEMPLATE")

SIZE=${#BODY}
printf "HTTP/1.1 200 OK\r\nContent-Type: text/x-shellscript\r\nContent-Length: %d\r\nConnection: close\r\n\r\n" "$SIZE"
printf '%s' "$BODY"
