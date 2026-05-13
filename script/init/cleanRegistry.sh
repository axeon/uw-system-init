#!/bin/bash
# cleanRegistry.sh — 清理 Registry 镜像仓库，只保留每个镜像的最新 N 个版本
# 用法: $0 [保留数量]
#   保留数量: 每个镜像保留的最新版本数，默认 3
# 示例:
#   $0          # 每个镜像保留最新 3 个版本
#   $0 5        # 每个镜像保留最新 5 个版本
# 前置:
#   - Registry 容器已启动 (端口 5000)
#   - 需要认证时已通过 docker login 登录
# 注意:
#   - 执行后会自动触发 Registry GC 清理磁盘空间
#   - 删除操作不可逆，请确认保留数量

KEEP="${1:-3}"

REGISTRY_URL="${REGISTRY_URL:-127.0.0.1:5000}"

_echo() {
    local color="$1" tag="$2"; shift 2
    echo -e "${color}[${tag}]${NC} $*"
}
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'
log_info()  { _echo "$GREEN"  "INFO"  "$@"; }
log_warn()  { _echo "$YELLOW" "WARN"  "$@"; }
log_error() { _echo "$RED"    "ERROR" "$@"; }
log_ok()    { _echo "$CYAN"   "OK"    "$@"; }

_registry_api() {
    local method="$1" path="$2"
    local url="http://${REGISTRY_URL}/v2${path}"
    if [ "$method" = "GET" ]; then
        curl -sf "$url" 2>/dev/null
    else
        curl -sf -X "$method" "$url" 2>/dev/null
    fi
}

_catalog() {
    _registry_api GET /_catalog | python3 -c "import sys,json; data=json.load(sys.stdin); print('\n'.join(data.get('repositories',[])))" 2>/dev/null
}

_tags() {
    local repo="$1"
    _registry_api GET "/${repo}/tags/list" | python3 -c "import sys,json; data=json.load(sys.stdin); print('\n'.join(data.get('tags',[])))" 2>/dev/null
}

_digest() {
    local repo="$1" tag="$2"
    local header
    header=$(curl -sfI -H "Accept: application/vnd.docker.distribution.manifest.v2+json" "http://${REGISTRY_URL}/v2/${repo}/manifests/${tag}" 2>/dev/null)
    echo "$header" | grep -i 'Docker-Content-Digest' | awk '{print $2}' | tr -d '\r'
}

_delete_manifest() {
    local repo="$1" digest="$2"
    curl -sf -X DELETE "http://${REGISTRY_URL}/v2/${repo}/manifests/${digest}" 2>/dev/null
}

_gc_registry() {
    local container
    container=$(docker ps --filter "ancestor=registry" --filter "publish=5000" --format '{{.Names}}' | head -1)
    if [ -z "$container" ]; then
        container=$(docker ps --format '{{.Names}}' | grep -i registry | head -1)
    fi
    if [ -n "$container" ]; then
        log_info "触发 Registry GC (容器: ${container})..."
        docker exec "$container" bin/registry garbage-collect /etc/docker/registry/config.yml 2>/dev/null || \
            docker exec "$container" registry garbage-collect /etc/docker/registry/config.yml 2>/dev/null || \
            log_warn "GC 执行失败，可手动执行: docker exec ${container} bin/registry garbage-collect /etc/docker/registry/config.yml"
    else
        log_warn "未找到 Registry 容器，请手动执行 GC"
    fi
}

if ! echo "$KEEP" | grep -qE '^[0-9]+$' || [ "$KEEP" -lt 1 ]; then
    log_error "保留数量必须是正整数: $KEEP"
    echo "用法: $0 [保留数量]"
    exit 1
fi

log_info "Registry: ${REGISTRY_URL}"
log_info "每个镜像保留最新 ${KEEP} 个版本"
echo ""

repos=$(_catalog)

if [ -z "$repos" ]; then
    log_warn "Registry 中没有镜像"
    exit 0
fi

total_deleted=0
total_kept=0

while IFS= read -r repo; do
    [ -z "$repo" ] && continue

    tags=$(_tags "$repo")
    if [ -z "$tags" ]; then
        log_warn "${repo}: 无标签，跳过"
        continue
    fi

    sorted_tags=$(echo "$tags" | sort -rV)

    count=0
    kept=0
    deleted=0

    while IFS= read -r tag; do
        [ -z "$tag" ] && continue
        count=$((count + 1))

        if [ $count -le "$KEEP" ]; then
            kept=$((kept + 1))
        else
            digest=$(_digest "$repo" "$tag")
            if [ -n "$digest" ]; then
                if _delete_manifest "$repo" "$digest"; then
                    log_info "删除 ${repo}:${tag} (${digest:0:20}...)"
                    deleted=$((deleted + 1))
                else
                    log_error "删除失败 ${repo}:${tag}"
                fi
            else
                log_warn "${repo}:${tag}: 无法获取 digest，跳过"
            fi
        fi
    done <<< "$sorted_tags"

    log_ok "${repo}: 保留 ${kept} 个，删除 ${deleted} 个"
    total_deleted=$((total_deleted + deleted))
    total_kept=$((total_kept + kept))
done <<< "$repos"

echo ""
log_ok "清理完成: 保留 ${total_kept} 个，删除 ${total_deleted} 个"

if [ $total_deleted -gt 0 ]; then
    _gc_registry
fi
