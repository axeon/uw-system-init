#!/bin/bash
# initOpsAgent.sh — 安装 ops-agent
# 用法: $0 [等待秒数]
#   等待秒数: 启动后等待服务就绪的时间，默认 10
# 前置: uw-ops-center 服务已启动且可访问

WAIT_SECONDS="${1:-10}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/../../uniweb-system.config" 2>/dev/null || source "/root/uniweb/uniweb-system.config" 2>/dev/null

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'
log_info()  { echo -e "${GREEN}[INFO]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*"; }
log_step()  { echo -e "${CYAN}[STEP]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*"; }
log_ok()    { echo -e "${CYAN}[OK]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $(date '+%Y-%m-%d %H:%M:%S') $*"; }

if [ -z "$GATEWAY_SERVER" ]; then
    log_error "GATEWAY_SERVER 未配置"
    exit 1
fi

log_step "===== OPS Agent 安装 ====="
log_info "等待服务就绪 (${WAIT_SECONDS}s)..."
sleep "$WAIT_SECONDS"

retries=0
installer=""
while [ $retries -lt 10 ]; do
    installer=$(curl -sf "${GATEWAY_SERVER}/uw-ops-center/agent/installer/install" 2>/dev/null) && break
    retries=$((retries + 1))
    log_warn "ops-agent 安装脚本获取失败，重试 ($retries/10)..."
    sleep 10
done

if [ $retries -ge 10 ] || [ -z "$installer" ]; then
    log_error "ops-agent 安装脚本获取失败，请手动安装"
    exit 1
fi

echo "$installer" | bash
log_ok "ops-agent 已安装，OPS 已接管本机"
