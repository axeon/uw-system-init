#!/bin/bash
# initDocker.sh — 安装/修复 Docker + containerd 运行环境
# 功能:
#   1. 安装 Docker CE (GPG key + apt 源, 官方源失败自动回退阿里云镜像源)
#   2. sshd 自检修复 (apt 升级后 OpenSSL 版本不匹配的已知问题)
#   3. 写入 daemon.json (data-root/容器日志上限/insecure-registries) 与 containerd 配置
# 说明:
#   - 可独立重复执行，用于 Docker 环境修复/重装
#   - 已安装且运行正常时直接跳过; daemon 异常时会重装包并重写 daemon.json/containerd 配置
#   - insecure-registries 含本地 Registry (REGISTRY_SERVER)，
#     上游仓库 UNIWEB_REGISTRY_SERVER 带端口时一并加入
# 前置: uniweb-system.config / uniweb-registry.config 已生成

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

if [ -z "$REGISTRY_SERVER" ]; then
    log_error "REGISTRY_SERVER 未配置，请先运行 setup.sh 生成 uniweb-system.config"
    exit 1
fi

# ============================================================
#  1. GPG key + apt 源 (官方源优先, 失败回退阿里云)
# ============================================================

setup_apt_source() {
    install -m 0755 -d /etc/apt/keyrings

    local gpg_ok=false
    local gpg_urls=(
        "https://download.docker.com/linux/debian/gpg"
        "https://mirrors.aliyun.com/docker-ce/linux/debian/gpg"
    )
    local url retry
    for url in "${gpg_urls[@]}"; do
        log_info "尝试下载 Docker GPG key: $url"
        for retry in 1 2 3; do
            if curl -fsSL --connect-timeout 10 "$url" -o /etc/apt/keyrings/docker.asc; then
                gpg_ok=true
                break 2
            fi
            log_warn "下载失败，重试 ($retry/3)..."
            sleep 3
        done
    done
    if [ "$gpg_ok" = "false" ]; then
        log_error "Docker GPG key 下载失败，请检查网络连接"
        exit 1
    fi
    chmod a+r /etc/apt/keyrings/docker.asc

    local codename
    codename=$(. /etc/os-release && echo "$VERSION_CODENAME")
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
${codename} stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    log_info "apt-get update (docker 官方源)..."
    if ! apt-get update -y; then
        log_warn "Docker 官方源更新失败，尝试阿里云镜像源"
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://mirrors.aliyun.com/docker-ce/linux/debian \
${codename} stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
        log_info "apt-get update (aliyun docker)..."
        apt-get update -y || {
            log_error "Docker 源更新失败，请检查网络连接"
            exit 1
        }
    fi
}

# ============================================================
#  2. 安装 Docker CE
# ============================================================

install_docker_packages() {
    log_step "安装 Docker CE..."
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || {
        log_error "Docker 安装失败"
        exit 1
    }
}

# ============================================================
#  3. sshd 自检修复
# ============================================================

repair_sshd() {
    log_info "检查 sshd 是否因 OpenSSL 版本变化而异常..."
    if ! sshd -t 2>/dev/null; then
        log_warn "sshd 配置检测失败，可能 OpenSSL 版本不匹配，正在重装..."
        apt-get install -y --reinstall openssh-server openssh-client || true
        systemctl restart sshd 2>/dev/null || systemctl restart ssh 2>/dev/null || true
        if sshd -t 2>/dev/null; then
            log_ok "sshd 修复成功"
        else
            log_error "sshd 修复失败，请手动检查"
        fi
    fi
}

# ============================================================
#  4. daemon.json + containerd 配置
# ============================================================

write_docker_config() {
    mkdir -p /etc/docker /etc/containerd

    local _insecure="\"127.0.0.1:5000\",\"${REGISTRY_SERVER}\""
    case "$UNIWEB_REGISTRY_SERVER" in
        *:*) _insecure="${_insecure},\"${UNIWEB_REGISTRY_SERVER}\"" ;;
    esac
    cat > /etc/docker/daemon.json << EOF
{
  "live-restore": true,
  "data-root":"/home/docker/lib",
  "log-driver": "json-file",
  "log-opts": { "max-size": "100m", "max-file": "3" },
  "insecure-registries":[${_insecure}]
}
EOF

    cat > /etc/containerd/config.toml << 'EOF'
disabled_plugins = ["cri"]
root = "/home/docker/containerd"
state = "/home/docker/containerd/state"
EOF

    mkdir -p /home/docker/lib /home/docker/containerd /home/docker/containerd/state
    log_info "systemctl daemon-reload..."
    systemctl daemon-reload
    log_info "重启 containerd..."
    systemctl restart containerd
    log_info "重启 docker..."
    systemctl restart docker
}

# ============================================================
#  主流程
# ============================================================

log_step "===== Docker 环境安装 ====="

if command -v docker &>/dev/null && docker info &>/dev/null; then
    log_ok "Docker 已安装且运行正常，跳过"
    exit 0
fi

setup_apt_source
install_docker_packages
repair_sshd
write_docker_config

log_ok "Docker 安装完成"
