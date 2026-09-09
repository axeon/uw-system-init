#!/bin/bash
# initRegistry.sh — 安装/重置本地 Registry 镜像仓库 (端口 5000)
# 功能:
#   1. 依据 uniweb-system.config 生成 htpasswd 认证文件
#   2. 启动 Registry 容器 (startRegistry5000.sh) 并等待就绪
#   3. docker login 到本地仓库 (凭据写入 /root/.docker/config.json)
# 说明:
#   - 可独立重复执行，用于重置 Registry 认证
#     (如修改 uniweb-system.config 中的 REGISTRY_PASSWORD 后重新生成 htpasswd)
# 前置: uniweb-system.config 已生成; Docker 已安装; registry 镜像已在本地仓库

# ============================================================
#  配置加载
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

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

if [ "$EUID" -ne 0 ]; then
    log_error "请使用 root 用户运行此脚本"
    exit 1
fi
# common.sh 自动加载 uniweb-registry.config + uniweb-system.config (会写 /etc/timezone, 需 root)
source "${SCRIPT_DIR}/../common.sh"

if [ -z "$REGISTRY_SERVER" ] || [ -z "$REGISTRY_PASSWORD" ]; then
    log_error "REGISTRY_SERVER/REGISTRY_PASSWORD 未配置，请先运行 setup.sh 生成 uniweb-system.config"
    exit 1
fi

# ============================================================
#  主流程
# ============================================================

log_step "===== Registry 安装 ====="

log_info "设置 Registry 密码..."
mkdir -p /home/registry/auth /home/registry/data
htpasswd -Bbc /home/registry/auth/htpasswd "$REGISTRY_USERNAME" "$REGISTRY_PASSWORD" || {
    log_error "htpasswd 生成失败"
    exit 1
}

log_step "启动 Registry 镜像仓库..."
bash "${SCRIPT_DIR}/../startRegistry5000.sh" || {
    log_error "Registry 启动失败"
    exit 1
}

log_info "等待 Registry 就绪..."
retries=0
while [ $retries -lt 30 ]; do
    http_code=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:5000/v2/" 2>/dev/null)
    if [ "$http_code" -ge 200 ] && [ "$http_code" -lt 500 ]; then
        break
    fi
    retries=$((retries + 1))
    echo "  等待 Registry... ($retries/30)"
    sleep 2
done
if [ $retries -ge 30 ]; then
    log_error "Registry 等待超时"
    exit 1
fi

log_info "docker login ${REGISTRY_SERVER}..."
echo "$REGISTRY_PASSWORD" | docker login --username="$REGISTRY_USERNAME" --password-stdin "$REGISTRY_SERVER" || {
    log_error "docker login 失败"
    exit 1
}

log_ok "Registry 安装完成"
