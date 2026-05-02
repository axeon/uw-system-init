#!/bin/bash
# ==============================================================================
# setup.sh — UniWeb 服务器部署主脚本
# 由 install.sh 调用，或直接在克隆目录内执行
# 流程:
#   阶段1: 安装系统依赖 (apt-get)
#   阶段2: 配置生成 (系统名/IP/密码 → uniweb-system.config)
#   阶段3: 配置应用 (替换 initHome/initData 中的 #{KEY} 占位符)
#   阶段4: 选择安装组件 (whiptail 多选菜单)
#   阶段5: 按需分发文件 (initHome/initData/script → 目标目录)
#   执行:  Docker + Registry → 拉取镜像 → MySQL → 导数据库 → 基础服务
#          → 微服务 → 前端 → SaaS → 开发服务 → init_ops → setup_slave_service
# 配置文件:
#   uniweb-system.config  — 部署实例信息 (IP/密码/连接串)
#   uniweb-registry.config — 镜像配置 (仓库地址/各组件版本)
# ==============================================================================

# ============================================================
#  全局变量
# ============================================================

export LANG="zh_CN.UTF-8"
export LC_ALL="zh_CN.UTF-8"
export TERM="${TERM:-xterm-256color}"

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UNIWEB_DIR="/root/uniweb"
SCRIPT_DIR="${UNIWEB_DIR}/script"
CONFIG_FILE="${UNIWEB_DIR}/uniweb-system.config"
REGISTRY_FILE="${UNIWEB_DIR}/uniweb-registry.config"
LOG_DIR="${UNIWEB_DIR}/log"
LOG_FILE="${LOG_DIR}/uniweb-init.log"

mkdir -p "$LOG_DIR"

# ============================================================
#  日志系统
#  终端输出带颜色，日志文件无颜色 + 时间戳
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

_log() {
    local color="$1" tag="$2"; shift 2
    local msg="$*"
    local ts
    ts=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${ts} ${color}[${tag}]${NC} ${msg}"
    echo "${ts} [${tag}] ${msg}" >> "$LOG_FILE"
}

log_info()   { _log "$GREEN"  "INFO"  "$@"; }
log_warn()   { _log "$YELLOW" "WARN"  "$@"; }
log_error()  { _log "$RED"    "ERROR" "$@"; }
log_step()   { _log "$BLUE"   "STEP"  "$@"; }
log_ok()     { _log "$CYAN"   "OK"    "$@"; }

run_log() {
    local desc="$1"; shift
    log_info "${desc}..."
    local rc
    "$@" 2>&1 | tee -a "$LOG_FILE"
    rc=${PIPESTATUS[0]}
    if [ $rc -ne 0 ]; then
        log_warn "${desc} 失败 (退出码: $rc)"
    fi
    return $rc
}

run_silent() {
    local desc="$1"; shift
    log_info "${desc}..."
    local rc=0
    "$@" >> "$LOG_FILE" 2>&1 || rc=$?
    if [ $rc -ne 0 ]; then
        log_warn "${desc} 失败 (退出码: $rc)"
    fi
    return $rc
}

generate_password() {
    openssl rand -base64 50 | tr -dc A-Z-a-z-0-9 | head -c "${1:-32}"
}

source_versions() {
    if [ -f "$REGISTRY_FILE" ]; then
        source "$REGISTRY_FILE"
    else
        local repo_versions="${REPO_DIR}/uniweb-registry.config"
        if [ -f "$repo_versions" ]; then
            source "$repo_versions"
        else
            log_error "uniweb-registry.config 未找到"
            exit 1
        fi
    fi
}

source_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        log_error "uniweb-system.config 不存在，请先运行配置生成"
        exit 1
    fi
    while IFS='=' read -r key value; do
        case "$key" in
            \#*|"") continue ;;
        esac
        export "$key=$value"
    done < "$CONFIG_FILE"
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        log_error "请使用 root 用户运行此脚本"
        exit 1
    fi
}

print_banner() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║        UniWeb 服务器初始化安装向导             ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
}

run_checklist() {
    local title="$1"
    local defaults="$2"
    shift 2
    local items=("$@")
    local args=()
    local idx=0
    for item in "${items[@]}"; do
        local state="OFF"
        for d in $defaults; do
            if [ "$d" = "$idx" ]; then state="ON"; break; fi
        done
        args+=("$idx" "$item" "$state")
        idx=$((idx + 1))
    done
    local result
    result=$(whiptail --title "$title" --checklist \
        "用 方向键 移动，空格 选择/取消，回车 确认" \
        --separate-output \
        $(( ${#items[@]} + 7 )) 80 ${#items[@]} \
        "${args[@]}" 3>&1 1>&2 2>&3)
    SELECTED=()
    while IFS= read -r line; do
        [ -n "$line" ] && SELECTED+=("$line")
    done <<< "$result"
}

_show_selection() {
    local label="$1" items_var="$2" sel_var="$3"
    local -n _items_ref="$items_var"
    local -n _sel_ref="$sel_var"
    echo "  ${label}:"
    if [ ${#_sel_ref[@]} -eq 0 ]; then
        echo "    (无)"
    else
        for i in "${_sel_ref[@]}"; do echo "    [*] ${_items_ref[$i]}"; done
    fi
}

# ============================================================
#  阶段 1: 系统依赖
# ============================================================

install_system_deps() {
    log_step "安装系统依赖..."
    grep -q 'zh_CN.UTF-8 UTF-8' /etc/locale.gen 2>/dev/null || echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen zh_CN.UTF-8 2>/dev/null || true
    run_log "apt-get update" apt-get update -y
    run_log "apt-get install" apt-get install -y ca-certificates curl gnupg apache2-utils whiptail
    log_ok "系统依赖安装完成"
}

# ============================================================
#  阶段 2: 配置生成
# ============================================================

generate_config() {
    read -e -p "请输入系统名称（如: my-company）: " SYSTEM_NAME
    SYSTEM_NAME="${SYSTEM_NAME:-uniweb}"
    log_info "系统名称: $SYSTEM_NAME"

    HOST_IPS=$(ip addr show | awk '/inet / && !/172\.1[6-9]\./ && !/172\.2[0-9]\./ && !/172\.3[0-1]\./ {print $2}' | cut -d/ -f1)

    HOST_IP="127.0.0.1"
    if [ "$(echo "$HOST_IPS" | wc -w)" -eq 1 ]; then
        HOST_IP="$HOST_IPS"
        log_info "本机IP是: $HOST_IP"
    else
        echo "本机有多个IP，请选择一个IP作为配置文件的主机配置:"
        PS3="请输入编号 [1-$(echo "$HOST_IPS" | wc -w)]: "
        select HOST_IP in $HOST_IPS; do
            if [ -n "$HOST_IP" ]; then
                log_info "您选择的IP地址是: $HOST_IP"
                break
            else
                echo "无效的选择，请输入对应的数字编号。"
            fi
        done
        unset PS3
    fi

    local tmp_config
    tmp_config="$(mktemp)"
    cat > "$tmp_config" << EOF
# UniWeb 部署配置文件 [$(date --rfc-3339=seconds)]
# 系统名称
SYSTEM_NAME=${SYSTEM_NAME}
# 系统IP
SYSTEM_IP=${HOST_IP}
# DOCKER仓库相关配置
REGISTRY_SERVER=${HOST_IP}:5000
REGISTRY_USERNAME=registry
REGISTRY_PASSWORD=$(generate_password)

# MYSQL相关配置
MYSQL_HOST=${HOST_IP}
MYSQL_PORT=3308
MYSQL_ROOT_USERNAME=root
MYSQL_ROOT_PASSWORD=$(generate_password)
MYSQL_NACOS_PASSWORD=$(generate_password)
MYSQL_UW_PASSWORD=$(generate_password)
MYSQL_SAAS_PASSWORD=$(generate_password)

# NACOS相关配置
NACOS_SERVER=${HOST_IP}:8848
NACOS_USERNAME=nacos
NACOS_PASSWORD=$(generate_password)
NACOS_NAMESPACE=test
NACOS_IDENTITY_KEY=$(generate_password)
NACOS_IDENTITY_VALUE=$(generate_password)
NACOS_TOKEN_KEY=$(generate_password | base64 | tr -d '\n')

# ES相关配置
LOG_ES_SERVER=http://${HOST_IP}:9200
LOG_ES_USERNAME=elastic
LOG_ES_PASSWORD=$(generate_password)

# REDIS相关配置
REDIS_HOST=${HOST_IP}
REDIS_PORT=6380
REDIS_SSL=false
REDIS_USERNAME=
REDIS_PASSWORD=$(generate_password)

# RABBITMQ相关配置
RABBITMQ_HOST=${HOST_IP}
RABBITMQ_PORT=5672
RABBITMQ_SSL=false
RABBITMQ_USERNAME=rabbit
RABBITMQ_PASSWORD=$(generate_password)

# MINIO相关配置
MINIO_SERVER=http://${HOST_IP}:9000
MINIO_ROOT_USERNAME=minio
MINIO_ROOT_PASSWORD=$(generate_password)

# GATEWAY相关配置
GATEWAY_SERVER=http://${HOST_IP}

# MSC账号相关配置
MSC_ROOT_PASSWORD=$(generate_password)
MSC_RPC_PASSWORD=$(generate_password)
MSC_OPS_PASSWORD=$(generate_password)
MSC_ADMIN_PASSWORD=$(generate_password)
EOF

    chmod 600 "$tmp_config"
    mv -f "$tmp_config" "$CONFIG_FILE"
    log_ok "配置文件已生成: $CONFIG_FILE"
}

show_config() {
    echo ""
    echo "═══════════════════════════════════════"
    echo "  配置文件摘要: $CONFIG_FILE"
    echo "═══════════════════════════════════════"
    grep -v '^$\|^\#' "$CONFIG_FILE" | column -t -s'='
    echo "═══════════════════════════════════════"
    echo ""
}

# ============================================================
#  阶段 3: 配置应用
# ============================================================

apply_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        log_error "配置文件不存在: $CONFIG_FILE"
        exit 1
    fi

    log_step "恢复原始文件（确保替换基线干净）..."
    cd "$REPO_DIR" && git checkout -- . 2>/dev/null || true

    log_step "开始替换配置变量..."

    while IFS='=' read -r key value; do
        case "$key" in
            \#*|"") continue ;;
        esac
        log_info "替换变量 $key => $value"
        find "$REPO_DIR" -type f -not -path "*/.git/*" -print0 | xargs -0 sed -i "s|#{${key}}|${value}|g"
        if [[ $key == *"_PASSWORD" ]]; then
            local bcrypt_value
            bcrypt_value=$(htpasswd -nbBC 10 test "$value" | cut -c 6-)
            log_info "替换BCRYPT密码变量 ${key}_BCRYPT"
            find "$REPO_DIR" -type f -not -path "*/.git/*" -print0 | xargs -0 sed -i "s|#{${key}_BCRYPT}|${bcrypt_value}|g"
        fi
    done < "$CONFIG_FILE"

    log_ok "配置替换完成"
}

# ============================================================
#  Docker + Registry
# ============================================================

install_docker() {
    source_config
    source_versions
    log_step "安装 Docker..."

    if command -v docker &>/dev/null && docker info &>/dev/null; then
        log_ok "Docker 已安装，跳过"
        return 0
    fi

    install -m 0755 -d /etc/apt/keyrings

    local gpg_ok=false
    local gpg_urls=(
        "https://download.docker.com/linux/debian/gpg"
        "https://mirrors.aliyun.com/docker-ce/linux/debian/gpg"
    )
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

    if ! run_log "apt-get update (docker)" apt-get update -y; then
        log_warn "Docker 官方源更新失败，尝试阿里云镜像源"
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://mirrors.aliyun.com/docker-ce/linux/debian \
${codename} stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
        run_log "apt-get update (aliyun docker)" apt-get update -y || {
            log_error "Docker 源更新失败，请检查网络连接"
            exit 1
        }
    fi

    run_log "apt-get install docker" apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || {
        log_error "Docker 安装失败"
        exit 1
    }

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
    run_log "systemctl daemon-reload" systemctl daemon-reload
    run_log "重启 containerd" systemctl restart containerd
    run_log "重启 docker" systemctl restart docker
    log_ok "Docker 安装完成"
}

install_registry() {
    source_config

    log_info "设置 Registry 密码..."
    mkdir -p /home/registry/auth /home/registry/data
    run_log "htpasswd" htpasswd -Bbc /home/registry/auth/htpasswd "$REGISTRY_USERNAME" "$REGISTRY_PASSWORD"

    log_step "启动 Registry 镜像仓库..."
    run_log "startRegistry5000" bash "${SCRIPT_DIR}/startRegistry5000.sh" || {
        log_error "Registry 启动失败"
        exit 1
    }

    log_info "等待 Registry 就绪..."
    local reg_retries=0
    while [ $reg_retries -lt 30 ]; do
        local http_code
        http_code=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:5000/v2/" 2>/dev/null)
        if [ "$http_code" -ge 200 ] && [ "$http_code" -lt 500 ]; then
            break
        fi
        reg_retries=$((reg_retries + 1))
        echo "  等待 Registry... ($reg_retries/30)"
        sleep 2
    done
    if [ $reg_retries -ge 30 ]; then
        log_error "Registry 等待超时"
        exit 1
    fi

    log_info "docker login ${REGISTRY_SERVER}..."
    echo "$REGISTRY_PASSWORD" | docker login --username="$REGISTRY_USERNAME" --password-stdin "$REGISTRY_SERVER" 2>&1 | tee -a "$LOG_FILE" || {
        log_error "docker login 失败"
        exit 1
    }
    log_ok "Registry 安装完成"
}

# ============================================================
#  Docker 镜像拉取（上游 → 公共回退 → 按需登录）
# ============================================================

_docker_logged_in=" "

_docker_login() {
    local server="$1"
    server="${server%%/*}"
    [[ "$_docker_logged_in" == *" $server "* ]] && return 0
    log_step "镜像仓库 ${server} 需要认证，请登录"
    local reg_user reg_pass login_attempt
    for login_attempt in 1 2 3; do
        read -e -p "用户名: " reg_user
        read -e -s -p "密码: " reg_pass
        echo ""
        if [ -z "$reg_user" ] || [ -z "$reg_pass" ]; then
            log_warn "用户名或密码为空"
            [ $login_attempt -lt 3 ] && log_warn "请重新输入 ($login_attempt/3)..." && continue
            return 1
        fi
        log_info "docker login ${server}..."
        local login_output
        login_output=$(echo "$reg_pass" | docker login --username="$reg_user" --password-stdin "$server" 2>&1) || true
        echo "$login_output" | tee -a "$LOG_FILE"
        if echo "$login_output" | grep -qiE 'login succeeded'; then
            log_ok "仓库 ${server} 登录成功"
            _docker_logged_in="${_docker_logged_in}${server} "
            return 0
        fi
        log_warn "仓库 ${server} 登录失败"
        [ $login_attempt -lt 3 ] && log_warn "请重新输入 ($login_attempt/3)..."
    done
    log_error "仓库 ${server} 登录失败次数过多，退出"
    exit 1
}

_docker_pull() {
    local desc="$1" ref="$2" server="$3"
    _PULL_FAIL_REASON="retry"
    local attempt
    for attempt in 1 2 3 4 5; do
        local pull_output
        pull_output=$(timeout 30 docker pull "$ref" 2>&1) || true
        echo "$pull_output" | tee -a "$LOG_FILE"

        local img_name="${ref%%:*}"
        local img_tag="${ref#*:}"
        if docker images --format '{{.Repository}}:{{.Tag}}' | grep -qFx "$ref" 2>/dev/null \
            || docker images --format '{{.Repository}}:{{.Tag}}' | grep -qFx "${img_name}:${img_tag}" 2>/dev/null; then
            _PULL_FAIL_REASON=""
            return 0
        fi

        if echo "$pull_output" | grep -qiE 'unauthorized|authentication required|no basic auth credentials|401'; then
            _PULL_FAIL_REASON="auth"
            if [ -n "$server" ]; then
                log_info "${desc}需要认证，引导登录..."
                if _docker_login "$server"; then
                    pull_output=$(timeout 30 docker pull "$ref" 2>&1) || true
                    echo "$pull_output" | tee -a "$LOG_FILE"
                    if docker images --format '{{.Repository}}:{{.Tag}}' | grep -qFx "$ref" 2>/dev/null; then
                        _PULL_FAIL_REASON=""
                        return 0
                    fi
                fi
            fi
            return 1
        fi
        if echo "$pull_output" | grep -qiE 'not found|manifest unknown|404|403|denied|forbidden'; then
            _PULL_FAIL_REASON="not_found"
            return 1
        fi
        [ $attempt -lt 5 ] && log_warn "拉取失败，重试 ($attempt/5)..." && sleep 5
    done
    return 1
}

_pull_image_to_local() {
    local image="$1"
    local local_ref="${REGISTRY_SERVER}/${image}"
    local upstream_ref="${UNIWEB_REGISTRY_SERVER}/${image}"
    local public_ref="${PUBLIC_REGISTRY_SERVER:+${PUBLIC_REGISTRY_SERVER}/}${image}"

    log_info "拉取 ${image}..."

    if _docker_pull "上游仓库 " "$upstream_ref" "${UNIWEB_REGISTRY_SERVER}"; then
        docker tag "$upstream_ref" "$local_ref"
        log_info "推送 ${local_ref}..."
        docker push "$local_ref" 2>&1 | tee -a "$LOG_FILE"
        return 0
    fi
    case "$_PULL_FAIL_REASON" in
        not_found) log_warn "上游仓库 ${image} 不存在" ;;
        auth)      log_warn "上游仓库 ${image} 需要认证，登录失败" ;;
        *)         log_warn "上游仓库 ${image} 拉取失败 (网络错误)" ;;
    esac

    local img_name="${image%%:*}"
    case "$img_name" in
        uw-*|saas-*)
            log_error "私有镜像 ${image} 上游仓库拉取失败，退出"
            exit 1
            ;;
    esac

    log_info "尝试公共仓库..."
    if _docker_pull "" "$public_ref" "${PUBLIC_REGISTRY_SERVER}"; then
        docker tag "$public_ref" "$local_ref"
        log_info "推送 ${local_ref}..."
        docker push "$local_ref" 2>&1 | tee -a "$LOG_FILE"
        return 0
    fi
    case "$_PULL_FAIL_REASON" in
        not_found) log_error "公共仓库 ${image} 不存在" ;;
        auth)      log_error "公共仓库 ${image} 需要认证，登录失败" ;;
        *)         log_error "公共仓库 ${image} 拉取失败 (网络错误)" ;;
    esac

    log_error "镜像 ${image} 从所有仓库拉取均失败，退出"
    exit 1
}

pull_selected_images() {
    local images=()

    for i in "${BASIC_SELECTED[@]}"; do
        case $i in
            0) images+=("${IMAGE_MYSQL}") ;;
            1) images+=("${IMAGE_REDIS}") ;;
            2) images+=("${IMAGE_RABBITMQ}") ;;
            3) images+=("${IMAGE_ELASTICSEARCH}" "${IMAGE_KIBANA}") ;;
            4) images+=("${IMAGE_NACOS}") ;;
            5) images+=("${IMAGE_MINIO}") ;;
        esac
    done

    for i in "${UW_SELECTED[@]}"; do
        case $i in
            0) images+=("${IMAGE_UW_GATEWAY}") ;;
            1) images+=("${IMAGE_UW_AUTH_CENTER}") ;;
            2) images+=("${IMAGE_UW_TASK_CENTER}") ;;
            3) images+=("${IMAGE_UW_OPS_CENTER}") ;;
            4) images+=("${IMAGE_UW_GATEWAY_CENTER}") ;;
            5) images+=("${IMAGE_UW_MYDB_CENTER}") ;;
            6) images+=("${IMAGE_UW_AI_CENTER}") ;;
            7) images+=("${IMAGE_UW_MYDB_PROXY}") ;;
            8) images+=("${IMAGE_UW_TINYURL_CENTER}") ;;
            9) images+=("${IMAGE_UW_NOTIFY_CENTER}") ;;
        esac
    done

    for i in "${UI_SELECTED[@]}"; do
        case $i in
            0) images+=("${IMAGE_ROOT_PC_UI}") ;;
            1) images+=("${IMAGE_OPS_PC_UI}") ;;
            2) images+=("${IMAGE_ADMIN_PC_UI}") ;;
        esac
    done

    for i in "${SAAS_SELECTED[@]}"; do
        case $i in
            0) images+=("${IMAGE_SAAS_BASE_APP}") ;;
            1) images+=("${IMAGE_SAAS_FINANCE_APP}") ;;
            2) images+=("${IMAGE_SAAS_PC_UI}") ;;
        esac
    done

    for i in "${DEV_SELECTED[@]}"; do
        case $i in
            0) images+=("${IMAGE_GITEA}") ;;
            1) images+=("${IMAGE_NEXUS3}") ;;
            2) images+=("${IMAGE_UW_CODE_CENTER}") ;;
        esac
    done

    if [ ${#images[@]} -gt 0 ]; then
        log_step "拉取镜像 (${#images[@]} 个)..."
        for img in "${images[@]}"; do
            _pull_image_to_local "$img"
        done
        log_ok "镜像拉取完成"
    fi
}

# ============================================================
#  基础服务启动
# ============================================================

setup_mysql() {
    source_config
    log_step "启动 MySQL..."
    run_log "启动 MySQL" bash "${SCRIPT_DIR}/startMydbMysql3308.sh" || {
        log_error "MySQL 容器启动脚本失败"
        exit 1
    }
    log_info "等待 MySQL 就绪..."
    local retries=0
    while [ $retries -lt 30 ]; do
        if MYSQL_PWD="${MYSQL_ROOT_PASSWORD}" docker exec -i -e MYSQL_PWD uw-mydb-mysql-3308 mysqladmin ping -h 127.0.0.1 -P 3308 -u root --silent 2>/dev/null; then
            log_ok "MySQL 已启动"
            return
        fi
        retries=$((retries + 1))
        echo "  等待 MySQL... ($retries/30)"
        sleep 2
    done
    log_error "MySQL 等待超时"
    exit 1
}

_start_service() {
    local name="$1" script="$2"
    log_step "启动 ${name}..."
    run_log "启动 ${name}" bash "${SCRIPT_DIR}/${script}" || return 1
    log_ok "${name} 已启动"
}

setup_redis()    { _start_service "Redis"    "startRedis6380.sh"; }
setup_rabbitmq() { _start_service "RabbitMQ" "startRabbitMQ5672.sh"; }
setup_nacos() {
    _start_service "Nacos" "startNacos8848.sh" || return 1
    log_info "等待 Nacos 就绪 (30s)..."
    sleep 30
}
setup_minio()    { _start_service "MinIO"    "startMinio9000.sh"; }
setup_gitea()    { _start_service "Gitea"    "startGitea.sh"; }
setup_nexus3()   { _start_service "Nexus3"   "startNexus3.sh"; }

setup_es() {
    log_step "初始化 ES 环境..."

    grep -q 'vm.max_map_count=262144' /etc/sysctl.conf 2>/dev/null || {
        cat >> /etc/sysctl.conf <<'EOF'
vm.max_map_count=262144
fs.file-max=6815744
EOF
    }
    sysctl -p 2>/dev/null | tail -5 >> "$LOG_FILE"

    ulimit -n 65535
    ulimit -u 32768
    ulimit -l unlimited

    grep -q 'soft nofile 65535' /etc/security/limits.conf 2>/dev/null || {
        cat >> /etc/security/limits.conf <<'EOF'
* soft nofile 65535
* hard nofile 65535
* soft nproc 32768
* hard nproc 32768
* soft memlock unlimited
* hard memlock unlimited
EOF
    }

    log_ok "ES 环境参数已设置"

    log_step "启动 Elasticsearch..."
    run_log "启动 ES" bash "${SCRIPT_DIR}/startES9200.sh" || {
        log_error "ES 容器启动失败"
        return 1
    }
    log_info "等待 ES 就绪..."
    local es_retries=0
    while [ $es_retries -lt 30 ]; do
        if curl -sk -u "${LOG_ES_USERNAME}:${LOG_ES_PASSWORD}" "${LOG_ES_SERVER}/_cluster/health" > /dev/null 2>&1; then
            log_ok "ES 已就绪"
            break
        fi
        es_retries=$((es_retries + 1))
        echo "  等待 ES... ($es_retries/30)"
        sleep 2
    done
    if [ $es_retries -ge 30 ]; then
        log_error "ES 等待超时"
        return 1
    fi

    log_step "初始化 ES 配置（数据流 + Kibana Token）..."

    local http_code
    http_code=$(curl -sk -o /dev/null -w "%{http_code}" -u "${LOG_ES_USERNAME}:${LOG_ES_PASSWORD}" -H "Content-Type: application/json" -d '
{
  "priority": 9,
  "template": {
    "settings": { "index": { "number_of_replicas": "0", "refresh_interval": "10s" } },
    "mappings": {
      "dynamic": true, "numeric_detection": false, "date_detection": true,
      "dynamic_date_formats": ["strict_date_optional_time","yyyy/MM/dd HH:mm:ss Z||yyyy/MM/dd Z"],
      "_source": { "enabled": true, "includes": [], "excludes": [] },
      "_routing": { "required": false }, "subobjects": true, "dynamic_templates": []
    },
    "lifecycle": { "enabled": true, "data_retention": "30d" }
  },
  "index_patterns": ["uw-*","saas-*","*-app","*-center"],
  "data_stream": { "hidden": false, "allow_custom_routing": false },
  "composed_of": []
}
' -X PUT "${LOG_ES_SERVER}/_index_template/uw-app-log")
    if [ "$http_code" -ge 200 ] && [ "$http_code" -lt 300 ]; then
        log_ok "索引模板 uw-app-log 创建成功 ($http_code)"
    else
        log_warn "索引模板 uw-app-log 创建失败 (HTTP $http_code)"
    fi

    http_code=$(curl -sk -o /dev/null -w "%{http_code}" -u "${LOG_ES_USERNAME}:${LOG_ES_PASSWORD}" -H "Content-Type: application/json" -d '
{
  "priority": 10,
  "template": {
    "settings": { "index": { "number_of_replicas": "0", "refresh_interval": "10s" } },
    "mappings": {
      "_source": { "excludes": [], "includes": [], "enabled": true },
      "_routing": { "required": false }, "dynamic": true, "numeric_detection": false,
      "date_detection": true,
      "dynamic_date_formats": ["strict_date_optional_time","yyyy/MM/dd HH:mm:ss Z||yyyy/MM/dd Z"],
      "subobjects": true, "dynamic_templates": []
    },
    "lifecycle": { "enabled": true, "data_retention": "180d" }
  },
  "index_patterns": ["*.log"],
  "data_stream": { "hidden": false, "allow_custom_routing": false }
}
' -X PUT "${LOG_ES_SERVER}/_index_template/uw-biz-log")
    if [ "$http_code" -ge 200 ] && [ "$http_code" -lt 300 ]; then
        log_ok "索引模板 uw-biz-log 创建成功 ($http_code)"
    else
        log_warn "索引模板 uw-biz-log 创建失败 (HTTP $http_code)"
    fi

    ELASTICSEARCH_SERVICE_ACCOUNT_TOKEN=$(docker exec es9200 /usr/share/elasticsearch/bin/elasticsearch-service-tokens create elastic/kibana my-token|awk -F ' = ' '{print $NF}'|sed 's/\r//g')
    log_info "替换变量ELASTICSEARCH_SERVICE_ACCOUNT_TOKEN=${ELASTICSEARCH_SERVICE_ACCOUNT_TOKEN}"
    find "/home/kibana5601/config" -type f -exec sed -i "s|#{ELASTICSEARCH_SERVICE_ACCOUNT_TOKEN}|${ELASTICSEARCH_SERVICE_ACCOUNT_TOKEN}|g" {} +

    log_ok "ES 配置初始化完成"

    log_step "启动 Kibana..."
    run_log "启动 Kibana" bash "${SCRIPT_DIR}/startKibana5601.sh"
    log_ok "Kibana 已启动"
}

# ============================================================
#  数据库导入（基础服务启动后）
# ============================================================

_get_sql_files() {
    SQL_FILES=(initUser.sql)
    for i in "${BASIC_SELECTED[@]}"; do
        case $i in 4) SQL_FILES+=(initNacos.sql) ;; esac
    done
    for i in "${UW_SELECTED[@]}"; do
        case $i in
            1) SQL_FILES+=(initAuthCenter.sql) ;;
            2) SQL_FILES+=(initTaskCenter.sql) ;;
            3) SQL_FILES+=(initOpsCenter.sql) ;;
            4) SQL_FILES+=(initGatewayCenter.sql) ;;
            5) SQL_FILES+=(initMydbCenter.sql) ;;
            6) SQL_FILES+=(initAiCenter.sql) ;;
            7) SQL_FILES+=(initTinyurlCenter.sql) ;;
            8) SQL_FILES+=(initNotifyCenter.sql) ;;
        esac
    done
    for i in "${SAAS_SELECTED[@]}"; do
        case $i in
            0) SQL_FILES+=(initSaasBase.sql) ;;
            1) SQL_FILES+=(initSaasFinance.sql) ;;
        esac
    done
    for i in "${DEV_SELECTED[@]}"; do
        case $i in 2) SQL_FILES+=(initCodeCenter.sql) ;; esac
    done
}

import_selected_databases() {
    if ! docker ps --format '{{.Names}}' | grep -q '^uw-mydb-mysql-3308$'; then
        log_warn "MySQL 容器未运行，跳过数据库导入"
        return
    fi

    _get_sql_files

    if [ ${#SQL_FILES[@]} -gt 0 ]; then
        local unique_sqls=()
        for sql in "${SQL_FILES[@]}"; do
            local found=false
            for u in "${unique_sqls[@]}"; do
                [ "$sql" = "$u" ] && found=true && break
            done
            [ "$found" = "false" ] && unique_sqls+=("$sql")
        done

        log_step "导入数据库 (${#unique_sqls[@]} 个)..."
        run_log "导入数据库" bash "${SCRIPT_DIR}/init/initMysqlData.sh" "${unique_sqls[@]}"
        log_ok "数据库导入完成"
    fi
}

# ============================================================
#  微服务 / UI 启动
# ============================================================

start_uw_image() {
    local image="$1"
    local port="$2"
    local mem_limit="${3:-800m}"
    local name="${image%%:*}"
    local version="${image#*:}"
    log_step "启动 ${name}..."
    run_log "启动 ${name}" bash "${SCRIPT_DIR}/startApp.sh" "$name" "$version" "$port" "$mem_limit"
    log_ok "${name} 已启动 (${port})"
}

start_uw_ui_image() {
    local image="$1"
    local port="$2"
    local name="${image%%:*}"
    local version="${image#*:}"
    log_step "启动 ${name}..."
    run_log "启动 ${name}" bash "${SCRIPT_DIR}/startUI.sh" "$name" "$version" "$port"
    log_ok "${name} 已启动 (${port})"
}

# ============================================================
#  文件分发辅助
# ============================================================

_copy_dir_safe() {
    local src="$1" dest="$2"
    if [ -d "$dest" ]; then
        local answer="n"
        read -e -p "[WARN] ${dest} 已存在，是否覆盖? [y/N]: " answer
        case "$answer" in
            y|Y)
                rm -fr "$dest" || { log_error "删除 ${dest} 失败"; return 1; }
                cp -r "$src" "$dest"
                log_ok "已覆盖 ${dest}"
                ;;
            *) log_warn "跳过 ${dest}"; return 0 ;;
        esac
    fi
    cp -r "$src" "$dest"
    log_ok "已复制 ${dest}"
}

_copy_init_home() {
    local name="$1"
    local src="${REPO_DIR}/initHome/${name}"
    local dest="/home/${name}"
    if [ ! -d "$src" ]; then
        log_warn "源目录不存在: ${src}"
        return 0
    fi
    if [ -d "$dest" ]; then
        local answer="n"
        read -e -p "[WARN] ${dest} 已存在，是否覆盖? [y/N]: " answer
        case "$answer" in
            y|Y)
                rm -fr "$dest" || { log_error "删除 ${dest} 失败"; return 1; }
                cp -r "$src" "$dest"
                log_ok "已覆盖 ${dest}"
                ;;
            *) log_warn "跳过 ${dest}" ;;
        esac
    else
        cp -r "$src" "$dest"
        log_ok "已复制 ${dest}"
    fi
}

# ============================================================
#  开发服务
# ============================================================

init_ops() {
    log_step "===== OPS 初始化 ====="
    run_log "安装 ops-agent" bash "${SCRIPT_DIR}/init/initOpsAgent.sh" || {
        log_warn "ops-agent 安装失败, 请手动执行 ${SCRIPT_DIR}/init/initOpsAgent.sh"
        return 1
    }
    log_ok "OPS 已接管本机"
}

# ============================================================
#  从机安装脚本生成 + HTTP 服务
# ============================================================

setup_slave_service() {
    source_config
    local port="${1:-900}"
    local service_script="${SCRIPT_DIR}/slave/slaveService.sh"

    if [ ! -f "$service_script" ]; then
        log_warn "从机安装服务脚本不存在: $service_script"
        return 1
    fi

    cat > /etc/systemd/system/uniweb-slave-service.socket << EOF
[Unit]
Description=UniWeb Slave Service Socket

[Socket]
ListenStream=${port}
Accept=yes

[Install]
WantedBy=sockets.target
EOF

    cat > /etc/systemd/system/uniweb-slave-service@.service << EOF
[Unit]
Description=UniWeb Slave Service Handler

[Service]
Type=simple
ExecStart=${service_script}
StandardInput=socket
StandardOutput=socket
EOF

    systemctl stop uniweb-slave-service.socket 2>/dev/null || true
    systemctl stop uniweb-slave-service.service 2>/dev/null || true
    run_log "systemctl daemon-reload" systemctl daemon-reload
    run_log "enable slave-service.socket" systemctl enable uniweb-slave-service.socket
    run_log "start slave-service.socket" systemctl start uniweb-slave-service.socket

    log_ok "从机安装服务已启动 (端口 ${port})"
    log_ok "从机安装命令:"
    echo ""
    echo -e "  ${CYAN}curl -fsSL http://${SYSTEM_IP}:${port}/slaveInstaller.sh | bash${NC}"
    echo ""
    log_info "管理命令:"
    echo "  systemctl status uniweb-slave-service.socket"
    echo "  systemctl stop uniweb-slave-service.socket"
    echo "  systemctl disable uniweb-slave-service.socket"
}


# ============================================================
#  主流程入口
# ============================================================

check_root
print_banner

# --- 阶段 1: 安装系统依赖 ---
log_step "===== 阶段 1: 安装系统依赖 ====="
install_system_deps

# --- 阶段 2: Mihomo 代理服务 ---
log_step "===== 阶段 2: Mihomo 代理服务 ====="
read -e -p "是否需要安装启动 mihomo 代理服务以加速 GitHub 和 Docker 访问? [y/N]: " USE_MIHOMO
case "$USE_MIHOMO" in
    y|Y)
        log_info "正在安装 mihomo..."
        if ! bash "${REPO_DIR}/script/mihomo/proxyInstall.sh"; then
            log_error "mihomo 安装失败，请手动安装后重新运行"
            exit 1
        fi
        read -e -p "请输入 mihomo 订阅 URL: " SUB_URL
        if ! bash "${REPO_DIR}/script/mihomo/proxyConfig.sh" "$SUB_URL"; then
            log_error "mihomo 配置失败，请手动配置"
            exit 1
        fi
        log_ok "mihomo 代理服务已启动"
        ;;
    *)
        log_info "跳过 mihomo 代理服务"
        ;;
esac


# --- 阶段 3: 配置生成 ---
log_step "===== 阶段 3: 配置生成 ====="
if [ -f "$CONFIG_FILE" ]; then
    log_info "检测到已有配置文件: $CONFIG_FILE"
    read -e -p "是否使用已有配置? [Y/n]: " USE_EXISTING
    case "$USE_EXISTING" in
        n|N) mkdir -p "${UNIWEB_DIR}"; generate_config ;;
        y|Y|"") log_ok "使用已有配置文件" ;;
        *)   log_warn "无效输入，重新生成配置"; mkdir -p "${UNIWEB_DIR}"; generate_config ;;
    esac
else
    mkdir -p "${UNIWEB_DIR}"
    generate_config
fi
show_config
read -e -p "是否需要编辑配置文件? [y/N]: " EDIT_IT
case "$EDIT_IT" in
    y|Y) ${EDITOR:-vi} "$CONFIG_FILE" ;;
    *) ;;
esac

# --- 阶段 4: 配置应用 (替换 #{KEY} 占位符) ---
log_step "===== 阶段 4: 配置应用 ====="
apply_config

# --- 阶段 5: 选择安装组件 (whiptail 多选菜单) ---
log_step "===== 阶段 5: 选择安装组件 ====="

BASIC_ITEMS=("MySQL 数据库" "Redis 缓存服务" "RabbitMQ 队列服务" "ES+Kibana 日志服务" "Nacos 服务管理" "MinIO 存储服务")
UW_ITEMS=("uw-gateway 网关服务" "uw-auth-center 鉴权中心" "uw-task-center 任务中心" "uw-ops-center 运维中心" "uw-gateway-center 网关中心" "uw-mydb-center 数据中心" "uw-ai-center AI中心" "uw-mydb-proxy 数据代理" "uw-tinyurl-center 短链中心" "uw-notify-center 通知中心")
UI_ITEMS=("root-pc-ui 系统管理" "ops-pc-ui 运维管理" "admin-pc-ui 平台管理")
SAAS_ITEMS=("saas-base 基础服务" "saas-finance 财务服务" "saas-pc-ui SaaS管理端")
DEV_ITEMS=("Gitea Git服务" "Nexus3 构件服务" "uw-code-center 代码中心")

BASIC_SELECTED=()
UW_SELECTED=()
UI_SELECTED=()
SAAS_SELECTED=()
DEV_SELECTED=()

SELECTED=(); run_checklist "基础组件" "0 1 2 3 4" "${BASIC_ITEMS[@]}";         BASIC_SELECTED=("${SELECTED[@]}")
SELECTED=(); run_checklist "UniWeb微服务" "0 1 2 3 4 5" "${UW_ITEMS[@]}";      UW_SELECTED=("${SELECTED[@]}")
SELECTED=(); run_checklist "UniWeb微前端" "0 1" "${UI_ITEMS[@]}";              UI_SELECTED=("${SELECTED[@]}")
SELECTED=(); run_checklist "SaaS微服务" "" "${SAAS_ITEMS[@]}";                      SAAS_SELECTED=("${SELECTED[@]}")
SELECTED=(); run_checklist "开发组件" "" "${DEV_ITEMS[@]}";                        DEV_SELECTED=("${SELECTED[@]}")

# --- 确认 ---
echo ""
echo -e "${CYAN}═══════════════════════════════════════${NC}"
echo -e "${CYAN}  安装确认${NC}"
echo -e "${CYAN}═══════════════════════════════════════${NC}"
echo ""
echo "  将自动安装: Docker + Registry"
echo ""
_show_selection "基础服务"      BASIC_ITEMS BASIC_SELECTED
echo ""
_show_selection "UniWeb 微服务" UW_ITEMS    UW_SELECTED
echo ""
_show_selection "UniWeb 前端"   UI_ITEMS    UI_SELECTED
echo ""
_show_selection "SaaS 服务"     SAAS_ITEMS  SAAS_SELECTED
echo ""
_show_selection "开发服务"      DEV_ITEMS   DEV_SELECTED
echo ""

read -e -p "确认开始安装? [Y/n]: " CONFIRM
case "$CONFIRM" in
    n|N) log_info "取消安装"; exit 0 ;;
    y|Y|"") ;;
    *)   log_warn "无效输入，请重新确认"; exit 0 ;;
esac

# --- 阶段 6: 按需分发文件 (仅复制选中组件对应的 initHome/initData) ---
log_step "===== 阶段 6: 按需分发文件 ====="

log_info "复制 script -> ${UNIWEB_DIR}/script/"
_copy_dir_safe "${REPO_DIR}/script" "${UNIWEB_DIR}/script"

log_info "复制 uniweb-registry.config -> ${UNIWEB_DIR}/uniweb-registry.config"
cp "${REPO_DIR}/uniweb-registry.config" "${UNIWEB_DIR}/uniweb-registry.config"
chmod 600 "${UNIWEB_DIR}/uniweb-registry.config"

for i in "${BASIC_SELECTED[@]}"; do
    case $i in
        0) _copy_init_home "mysql3308" ;;
        1) _copy_init_home "redis6380" ;;
        2) _copy_init_home "rabbitmq5672" ;;
        3) _copy_init_home "es9200"; _copy_init_home "kibana5601" ;;
        4) _copy_init_home "nacos8848" ;;
        5) _copy_init_home "minio9000" ;;
    esac
done

_copy_init_home "registry"

for i in "${DEV_SELECTED[@]}"; do
    case $i in
        0) _copy_init_home "gitea" ;;
    esac
done

SQL_NEEDED=false
for i in "${BASIC_SELECTED[@]}"; do [ "$i" = "0" ] && SQL_NEEDED=true; done
if [ "$SQL_NEEDED" = "true" ]; then
    _get_sql_files
    mkdir -p "${UNIWEB_DIR}/initData"
    for sql in "${SQL_FILES[@]}"; do
        if [ -f "${REPO_DIR}/initData/${sql}" ]; then
            log_info "复制 initData/${sql}"
            cp "${REPO_DIR}/initData/${sql}" "${UNIWEB_DIR}/initData/${sql}"
        fi
    done
fi

find "${UNIWEB_DIR}/script" -type f -name "*.sh" -exec chmod +x {} \;
log_ok "文件分发完成"

# --- 阶段 7: 执行安装 ---
log_step "===== 阶段 7: 执行安装 ====="

source_versions
source_config

install_docker
install_registry

pull_selected_images

MYSQL_INSTALLED=false
for i in "${BASIC_SELECTED[@]}"; do
    case $i in
        0) setup_mysql; MYSQL_INSTALLED=true ;;
    esac
done

if [ "$MYSQL_INSTALLED" = "true" ]; then
    import_selected_databases
fi

for i in "${BASIC_SELECTED[@]}"; do
    case $i in
        0) ;;
        1) setup_redis ;;
        2) setup_rabbitmq ;;
        3) setup_es ;;
        4) setup_nacos ;;
        5) setup_minio ;;
    esac
done

for i in "${UW_SELECTED[@]}"; do
    case $i in
        1) start_uw_image "${IMAGE_UW_AUTH_CENTER}" 10000; sleep 20 ;;
        2) start_uw_image "${IMAGE_UW_TASK_CENTER}" 10010; sleep 20 ;;
        3) start_uw_image "${IMAGE_UW_OPS_CENTER}" 1000; sleep 20 ;;
        4) start_uw_image "${IMAGE_UW_GATEWAY_CENTER}" 10030; sleep 20 ;;
        5) start_uw_image "${IMAGE_UW_MYDB_CENTER}" 10020; sleep 20 ;;
        6) start_uw_image "${IMAGE_UW_AI_CENTER}" 10081 ;;
        7) start_uw_image "${IMAGE_UW_MYDB_PROXY}" 3300 ;;
        8) start_uw_image "${IMAGE_UW_TINYURL_CENTER}" 10060 ;;
        9) start_uw_image "${IMAGE_UW_NOTIFY_CENTER}" 10070 ;;
    esac
done

for i in "${UI_SELECTED[@]}"; do
    case $i in
        0) start_uw_ui_image "${IMAGE_ROOT_PC_UI}" 30100 ;;
        1) start_uw_ui_image "${IMAGE_OPS_PC_UI}" 30110 ;;
        2) start_uw_ui_image "${IMAGE_ADMIN_PC_UI}" 30200 ;;
    esac
done

for i in "${SAAS_SELECTED[@]}"; do
    case $i in
        0) start_uw_image "${IMAGE_SAAS_BASE_APP}" 20000; sleep 20 ;;
        1) start_uw_image "${IMAGE_SAAS_FINANCE_APP}" 20080; sleep 20 ;;
        2) start_uw_ui_image "${IMAGE_SAAS_PC_UI}" 30300 ;;
    esac
done

for i in "${DEV_SELECTED[@]}"; do
    case $i in
        0) setup_gitea ;;
        1) setup_nexus3 ;;
        2) start_uw_image "${IMAGE_UW_CODE_CENTER}" 10050; sleep 20 ;;
    esac
done

start_uw_image "${IMAGE_UW_GATEWAY}" 80

log_ok "===== 服务安装完成 ====="

init_ops

setup_slave_service

log_ok "===== 全部完成 ====="
echo ""
log_info "配置文件: ${CONFIG_FILE}"
log_info "镜像配置: ${REGISTRY_FILE}"
log_info "脚本目录: ${SCRIPT_DIR}"
log_info "日志文件: ${LOG_FILE}"
