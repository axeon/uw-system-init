#!/bin/bash
# ==============================================================================
# common.sh — 所有 start*.sh 脚本的共享基础
# 自动加载: uniweb-registry.config (镜像版本) + uniweb-system.config (连接信息)
# 提供: create_dir / get_app_host / docker_remove / docker_run_check / DOCKER_COMMON_OPTS
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 加载镜像版本配置 (优先相对路径，其次 /root/uniweb/)
_config_loaded=false
for f in "${SCRIPT_DIR}/../uniweb-registry.config" "/root/uniweb/uniweb-registry.config"; do
    if [ -f "$f" ]; then source "$f"; _config_loaded=true; break; fi
done
[ "$_config_loaded" = "false" ] && echo "[WARN] uniweb-registry.config 未找到"

# 加载部署配置 (IP/密码/连接串)
_config_loaded=false
for f in "${SCRIPT_DIR}/../uniweb-system.config" "/root/uniweb/uniweb-system.config"; do
    if [ -f "$f" ]; then source "$f"; _config_loaded=true; break; fi
done
[ "$_config_loaded" = "false" ] && echo "[WARN] uniweb-system.config 未找到"

# 创建目录 (已存在则跳过)
create_dir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        echo "$1 created!"
    else
        echo "$1 exists!"
    fi
}

# 获取本机内网 IP (10.x / 192.168.x)
get_app_host() {
    ip addr show | awk '/inet / && /10\.|192\.168\./ {print $2}' | cut -d/ -f1
}

# 停止并删除同名容器 (用于重启场景)
docker_remove() {
    local name="$1"
    docker stop "$name" 2>/dev/null
    docker rm "$name" 2>/dev/null
}

# 检查容器是否正常运行，异常退出则打印日志并终止脚本
docker_run_check() {
    local container_id="$1"
    local name="$2"
    if [ -z "$container_id" ]; then
        echo "[ERROR] ${name} 启动失败"
        exit 1
    fi
    local status
    status=$(docker inspect --format='{{.State.Status}}' "$container_id" 2>/dev/null || echo "error")
    if [ "$status" != "running" ]; then
        echo "[ERROR] ${name} 启动后异常退出 (status: ${status})"
        docker logs "$container_id" 2>&1 | tail -20
        exit 1
    fi
}

# Docker 通用启动参数: 时区 + host 网络 + 自动重启
TZ_NAME=$(cat /etc/timezone 2>/dev/null || echo "UTC")
[ ! -f /etc/timezone ] && echo "$TZ_NAME" > /etc/timezone
DOCKER_COMMON_OPTS="-e TZ=${TZ_NAME} -v /etc/localtime:/etc/localtime:ro -v /etc/timezone:/etc/timezone:ro --network=host --restart=unless-stopped"
