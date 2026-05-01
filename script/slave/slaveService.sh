#!/bin/bash
# slaveService.sh — 从机安装 HTTP 分发服务
# 由 systemd socket activation 调用
# source uniweb-system.config 后动态输出带实际配置的安装脚本

source /root/uniweb/uniweb-system.config 2>/dev/null || exit 1

cat > /dev/null

RESPONSE=$(cat << SLAVEEOF
#!/bin/bash
REGISTRY_SERVER="${REGISTRY_SERVER}"
REGISTRY_USERNAME="${REGISTRY_USERNAME}"
REGISTRY_PASSWORD="${REGISTRY_PASSWORD}"
GATEWAY_SERVER="${GATEWAY_SERVER}"
MASTER_IP="${SYSTEM_IP}"

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'
log_info()  { echo -e "\${GREEN}[INFO]\${NC} \$*"; }
log_step()  { echo -e "\${CYAN}[STEP]\${NC} \$*"; }
log_ok()    { echo -e "\${CYAN}[OK]\${NC} \$*"; }
log_warn()  { echo -e "\033[1;33m[WARN]\${NC} \$*"; }
log_error() { echo -e "\${RED}[ERROR]\${NC} \$*"; }

[ "\$EUID" -ne 0 ] && { echo "请使用 root 用户运行"; exit 1; }

if command -v docker &>/dev/null && docker info &>/dev/null; then
    log_ok "Docker 已安装，跳过"
else
    log_step "安装系统依赖..."
    apt-get update -y
    apt-get install -y ca-certificates curl gnupg
    install -m 0755 -d /etc/apt/keyrings

    GPG_OK=false
    for url in "https://download.docker.com/linux/debian/gpg" "https://mirrors.aliyun.com/docker-ce/linux/debian/gpg"; do
        log_info "尝试下载 Docker GPG key: \$url"
        for retry in 1 2 3; do
            if curl -fsSL --connect-timeout 10 "\$url" -o /etc/apt/keyrings/docker.asc; then
                GPG_OK=true
                break 2
            fi
            log_warn "下载失败，重试 (\$retry/3)..."
            sleep 3
        done
    done
    if [ "\$GPG_OK" = "false" ]; then
        log_error "Docker GPG key 下载失败，请检查网络连接"
        exit 1
    fi
    chmod a+r /etc/apt/keyrings/docker.asc

    CODENAME=\$(. /etc/os-release && echo "\$VERSION_CODENAME")
    echo "deb [arch=\$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
\${CODENAME} stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    if ! apt-get update -y; then
        log_warn "Docker 官方源更新失败，尝试阿里云镜像源"
        echo "deb [arch=\$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://mirrors.aliyun.com/docker-ce/linux/debian \
\${CODENAME} stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
        apt-get update -y || { log_error "Docker 源更新失败"; exit 1; }
    fi

    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || {
        log_error "Docker 安装失败"
        exit 1
    }

    mkdir -p /etc/docker /etc/containerd

    cat > /etc/containerd/config.toml << 'DAEMON_CTR'
disabled_plugins = ["cri"]
root = "/home/docker/containerd"
state = "/home/docker/containerd/state"
DAEMON_CTR

    cat > /etc/docker/daemon.json << DAEMON_EOF
{
  "live-restore": true,
  "registry-mirrors": ["https://docker.1panel.live"],
  "data-root":"/home/docker/lib",
  "insecure-registries":["${REGISTRY_SERVER}","127.0.0.1:5000"]
}
DAEMON_EOF

    mkdir -p /home/docker/lib /home/docker/containerd /home/docker/containerd/state
    systemctl daemon-reload
    systemctl restart containerd
    systemctl restart docker
fi

log_step "登录镜像仓库..."
echo "\${REGISTRY_PASSWORD}" | docker login --username="\${REGISTRY_USERNAME}" --password-stdin "\${REGISTRY_SERVER}" || {
    log_error "docker login 失败"
    exit 1
}

log_step "安装 ops-agent..."
sleep 10
OPS_RETRY=0
installer=""
while [ \$OPS_RETRY -lt 10 ]; do
    installer=\$(curl -sf "\${GATEWAY_SERVER}/uw-ops-center/agent/installer/install") && break
    OPS_RETRY=\$((OPS_RETRY + 1))
    echo "[WARN] ops-agent 安装脚本获取失败，重试 (\$OPS_RETRY/10)..."
    sleep 10
done
if [ -n "\$installer" ]; then
    echo "\$installer" | bash
else
    echo "[ERROR] ops-agent 安装脚本获取失败，请手动安装"
    exit 1
fi

log_ok "从机安装完成！"
log_info "ops-agent 已启动，Master 可通过 \${GATEWAY_SERVER} 管理本机"
SLAVEEOF
)

CONTENT_LENGTH=${#RESPONSE}
echo -ne "HTTP/1.1 200 OK\r\nContent-Type: text/x-shellscript\r\nContent-Length: ${CONTENT_LENGTH}\r\nConnection: close\r\n\r\n${RESPONSE}"
