#!/bin/bash
set -e

# 用法: ./proxyUpdate.sh "订阅链接"
# 示例: ./proxyUpdate.sh "https://example.com/sub?token=xxx"

SUB_URL="${1:-}"
CONFIG_DIR="$HOME/mihomo/conf"
CONFIG_FILE="$CONFIG_DIR/config.yaml"
BACKUP_FILE="$CONFIG_FILE.bak.$(date +%Y%m%d_%H%M%S)"

# 检查参数
if [ -z "$SUB_URL" ]; then
   echo "错误: 缺少订阅链接"
   echo "用法: $0 \"订阅链接\""
   exit 1
fi

mkdir -p "$CONFIG_DIR"

# 备份旧配置
[ -f "$CONFIG_FILE" ] && cp "$CONFIG_FILE" "$BACKUP_FILE"

# 下载新配置
curl -L -s --max-time 30 -o "${CONFIG_FILE}.tmp" "$SUB_URL"

# 简单验证（非空且包含 proxy/proxies 关键字）
if grep -qE "proxy|proxies" "${CONFIG_FILE}.tmp" 2>/dev/null; then
   mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
   echo "$(date '+%Y-%m-%d %H:%M:%S'): 订阅更新成功"

   # 重启容器生效
   docker restart mihomo
else
   rm -f "${CONFIG_FILE}.tmp"
   echo "$(date '+%Y-%m-%d %H:%M:%S'): 订阅验证失败，保留旧配置"
   exit 1
fi