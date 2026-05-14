#!/bin/bash
set -e

RUNNER_VERSION=""
RUNNER_BASE_URL="https://dl.gitea.com/act_runner"
RUNNER_DIR="/home/gitea/runner"
BIN_DIR="${RUNNER_DIR}/bin"
CONFIG_DIR="${RUNNER_DIR}/config"
RUNNER_BIN="${BIN_DIR}/act_runner"
RUNNER_USER="gitea-runner"

log_info() {
    echo "[INFO] $1"
}

log_error() {
    echo "[ERROR] $1" >&2
}

detect_arch() {
    local arch
    arch="$(uname -m)"
    case "${arch}" in
        x86_64)  echo "amd64" ;;
        aarch64) echo "arm64" ;;
        armv7l)  echo "arm-7" ;;
        *)       echo "${arch}" ;;
    esac
}

detect_os() {
    local os
    os="$(uname -s | tr '[:upper:]' '[:lower:]')"
    echo "${os}"
}

fetch_latest_version() {
    local page

    if command -v curl > /dev/null 2>&1; then
        page="$(curl -fSs "${RUNNER_BASE_URL}/" 2>/dev/null)"
    elif command -v wget > /dev/null 2>&1; then
        page="$(wget -qO- "${RUNNER_BASE_URL}/" 2>/dev/null)"
    else
        log_error "未找到 curl 或 wget，无法获取最新版本"
        exit 1
    fi

    RUNNER_VERSION="$(echo "${page}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)"

    if [ -z "${RUNNER_VERSION}" ]; then
        log_error "无法解析最新版本号，将使用默认版本 0.6.1"
        RUNNER_VERSION="0.6.1"
    fi

    log_info "获取到最新版本: ${RUNNER_VERSION}"
}

download_runner() {
    local os arch filename url

    os="$(detect_os)"
    arch="$(detect_arch)"
    filename="act_runner-${RUNNER_VERSION}-${os}-${arch}"
    url="${RUNNER_BASE_URL}/${RUNNER_VERSION}/${filename}"

    if [ -f "${RUNNER_BIN}" ]; then
        log_info "act_runner 已存在，跳过下载: ${RUNNER_BIN}"
        return 0
    fi

    log_info "正在下载 act_runner ${RUNNER_VERSION} (${os}-${arch})..."
    log_info "下载地址: ${url}"

    if command -v curl > /dev/null 2>&1; then
        curl -fSL -o "${RUNNER_BIN}" "${url}"
    elif command -v wget > /dev/null 2>&1; then
        wget -q -O "${RUNNER_BIN}" "${url}"
    else
        log_error "未找到 curl 或 wget，请先安装其中之一"
        exit 1
    fi

    if [ ! -f "${RUNNER_BIN}" ] || [ ! -s "${RUNNER_BIN}" ]; then
        log_error "下载失败: ${url}"
        exit 1
    fi

    chmod 755 "${RUNNER_BIN}"
    chmod 755 ${RUNNER_DIR}/deploy/*.sh
    log_info "act_runner 下载完成并已赋予执行权限"
}

create_user() {
    if id "${RUNNER_USER}" > /dev/null 2>&1; then
        log_info "用户 ${RUNNER_USER} 已存在，跳过创建"
    else
        useradd -m -d "${RUNNER_DIR}" -s /bin/bash "${RUNNER_USER}"
        log_info "已创建用户 ${RUNNER_USER}"
    fi

    if id -nG "${RUNNER_USER}" | grep -qw "docker"; then
        log_info "用户 ${RUNNER_USER} 已在 docker 组中，跳过"
    else
        usermod -aG docker "${RUNNER_USER}"
        log_info "已将 ${RUNNER_USER} 添加到 docker 组"
    fi
}

create_dirs() {
    mkdir -p "${RUNNER_DIR}/cache"
    mkdir -p "${RUNNER_DIR}/build"
    mkdir -p "${BIN_DIR}"
    mkdir -p "${CONFIG_DIR}"
    log_info "目录结构已创建"
}

setup_systemd() {
    cat > /etc/systemd/system/gitea-runner.service << 'EOF'
[Unit]
Description=Gitea Actions runner
Documentation=https://gitea.com/gitea/act_runner
After=docker.service

[Service]
ExecStart=/bin/bash -lc 'source /etc/profile || true;/home/gitea/runner/bin/act_runner daemon --config /home/gitea/runner/config/config.yaml'
ExecReload=/bin/kill -s HUP $MAINPID
WorkingDirectory=/home/gitea/runner
TimeoutSec=0
RestartSec=10
Restart=always
User=gitea-runner

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    log_info "systemd 服务文件已配置"
}

register_runner() {
    if [ -f "${BIN_DIR}/.runner" ]; then
        log_info "Runner 已注册（.runner 文件存在），跳过注册"
        return 0
    fi

    if [ ! -f "${CONFIG_DIR}/config.yaml" ]; then
        log_error "未找到配置文件: ${CONFIG_DIR}/config.yaml"
        log_error "请先放置配置文件后再运行注册"
        exit 1
    fi

    log_info "开始注册 Runner，请按提示输入信息..."
    su - "${RUNNER_USER}" -c "cd ${RUNNER_DIR} && ${RUNNER_BIN} register --config ${CONFIG_DIR}/config.yaml --no-interactive" \
        || su - "${RUNNER_USER}" -c "cd ${RUNNER_DIR} && ${RUNNER_BIN} register --config ${CONFIG_DIR}/config.yaml"

    if [ -f "${BIN_DIR}/.runner" ]; then
        log_info "Runner 注册成功"
    else
        log_error "Runner 注册失败，请检查输入信息"
        exit 1
    fi
}

fix_permissions() {
    chown -R "${RUNNER_USER}:${RUNNER_USER}" "${RUNNER_DIR}"

    log_info "目录权限已修正"
}

start_service() {
    systemctl enable gitea-runner.service --now
    systemctl restart gitea-runner.service
    log_info "gitea-runner 服务已启动"
}

main() {
    echo "========================================="
    echo "  Gitea Runner 自动初始化脚本"
    echo "========================================="

    log_info "步骤 1/8: 获取最新版本"
    fetch_latest_version

    log_info "步骤 2/8: 创建目录结构"
    create_dirs

    log_info "步骤 3/8: 下载 act_runner"
    download_runner

    log_info "步骤 4/8: 创建用户"
    create_user

    log_info "步骤 5/8: 修正目录权限"
    fix_permissions

    log_info "步骤 6/8: 注册 Runner"
    register_runner

    log_info "步骤 7/8: 配置 systemd 服务"
    setup_systemd

    log_info "步骤 8/8: 启动服务"
    start_service

    echo ""
    echo "========================================="
    echo "  Gitea Runner v${RUNNER_VERSION} 初始化完成！"
    echo "========================================="
    systemctl status gitea-runner.service --no-pager
}

main "$@"
