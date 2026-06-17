#!/bin/bash
# cleanRegistry.sh — 清理 Docker Registry 镜像仓库
# 用法:
#   ./cleanRegistry.sh [选项]
# 选项:
#   --host <host>            Registry 地址 (或 REGISTRY_HOST 环境变量)
#   --user <user>            用户名     (或 USERNAME     环境变量)
#   --password <password>    密码       (或 PASSWORD     环境变量)
#   --keep <N>               每个镜像保留最新 N 个，默认 1 (或 KEEP_LATEST 环境变量)
#   --yes                    跳过 DRY RUN 确认，直接执行
#   -h, --help               显示帮助
# 示例:
#   REGISTRY_HOST=registry.example.com USERNAME=admin PASSWORD=pass ./cleanRegistry.sh
#   ./cleanRegistry.sh --host 127.0.0.1:5000 --user admin --password pass --keep 2
#   ./cleanRegistry.sh --host 127.0.0.1:5000 --user admin              # 交互式询问密码
#   ./cleanRegistry.sh --host 127.0.0.1:5000 --keep 3 --yes
# 说明:
#   - latest 标签始终保留，不计入 KEEP_LATEST 配额
#   - 认证强制：未提供 --user/--password 时交互式询问 (密码不回显)
#   - 执行流程: 配置确认 -> 扫描 -> DRY RUN 预览 -> 用户确认 -> 删除 -> GC
#   - 删除不可逆，请确认参数后再执行

set -euo pipefail

# ---------- 默认参数 ----------
REGISTRY_HOST="${REGISTRY_HOST:-http://127.0.0.1:5000}"
USERNAME="${USERNAME:-}"
PASSWORD="${PASSWORD:-}"
KEEP_LATEST="${KEEP_LATEST:-1}"
ASSUME_YES=false

# ---------- 颜色输出 ----------
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'
_echo() {
    local color="$1" tag="$2"; shift 2
    echo -e "${color}[${tag}]${NC} $*"
}
log_info()  { _echo "$GREEN"  "INFO"  "$@"; }
log_warn()  { _echo "$YELLOW" "WARN"  "$@"; }
log_error() { _echo "$RED"    "ERROR" "$@"; }
log_ok()    { _echo "$CYAN"   "OK"    "$@"; }

# ---------- 参数解析 ----------
# 用法: usage [exit_code]
usage() {
    sed -n '2,19p' "$0"
    exit "${1:-0}"
}

while [ $# -gt 0 ]; do
    case "$1" in
        --host|--user|--password|--keep)
            [ $# -ge 2 ] || { log_error "$1 需要一个参数值"; usage 1; }
            opt="$1"; val="$2"; shift 2
            case "$opt" in
                --host)     REGISTRY_HOST="$val" ;;
                --user)     USERNAME="$val" ;;
                --password) PASSWORD="$val" ;;
                --keep)     KEEP_LATEST="$val" ;;
            esac
            ;;
        --yes|-y)   ASSUME_YES=true;   shift ;;
        -h|--help)  usage 0 ;;
        *) log_error "未知参数: $1"; usage 1 ;;
    esac
done

# ---------- 校验 ----------
if [ -z "$REGISTRY_HOST" ]; then
    log_error "缺少 Registry 地址，请通过 --host 或 REGISTRY_HOST 环境变量指定"
    exit 1
fi
if ! echo "$KEEP_LATEST" | grep -qE '^[0-9]+$' || [ "$KEEP_LATEST" -lt 0 ]; then
    log_error "KEEP_LATEST 必须为非负整数: $KEEP_LATEST"
    exit 1
fi
# 认证是强制的 (清理/删除操作不允许匿名)
# 用户名未提供 → 交互式询问
if [ -z "$USERNAME" ]; then
    if [ -t 0 ]; then
        read -r -p "请输入 Registry 用户名: " USERNAME
        [ -z "$USERNAME" ] && { log_error "用户名不能为空"; exit 1; }
    else
        log_error "缺少 USERNAME (非交互式终端无法询问，请通过 --user 或 USERNAME 环境变量提供)"
        exit 1
    fi
fi
# 密码未提供 → 交互式询问 (不回显)
if [ -z "$PASSWORD" ]; then
    if [ -t 0 ]; then
        read -rs -p "请输入 ${USERNAME} 的密码: " PASSWORD
        echo ""
        [ -z "$PASSWORD" ] && { log_error "密码不能为空"; exit 1; }
    else
        log_error "缺少 PASSWORD (非交互式终端无法询问，请通过 --password 或 PASSWORD 环境变量提供)"
        exit 1
    fi
fi

# 保留用户传入的协议；未指定协议时默认 http
case "$REGISTRY_HOST" in
    http://*)  REGISTRY_BASE="$REGISTRY_HOST" ;;
    https://*) REGISTRY_BASE="$REGISTRY_HOST" ;;
    *)         REGISTRY_BASE="http://${REGISTRY_HOST}" ;;
esac

# ---------- API 工具 ----------
CURL_OPTS=(-sS -u "${USERNAME}:${PASSWORD}")

_api() {
    # 注意: 不加 -f，调用方按需处理 HTTP 错误
    local method="$1" path="$2"
    curl "${CURL_OPTS[@]}" -X "$method" "${REGISTRY_BASE}/v2${path}"
}

_api_head() {
    # 注意: 不加 -f；失败时返回非零，调用方需用 if/command 包裹避免 set -e 中断
    # 同时声明接受多架构 manifest list 和 OCI index，确保 Registry 返回顶层 digest
    local path="$1"
    curl "${CURL_OPTS[@]}" -sS -I \
        -H "Accept: application/vnd.oci.image.index.v1+json" \
        -H "Accept: application/vnd.docker.distribution.manifest.list.v2+json" \
        -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
        -H "Accept: application/vnd.oci.image.manifest.v1+json" \
        "${REGISTRY_BASE}/v2${path}"
}

_catalog() {
    local resp
    resp=$(_api GET /_catalog 2>/dev/null) || return 1
    echo "$resp" | python3 -c "import sys,json; d=json.load(sys.stdin); print('\n'.join(d.get('repositories',[])))" 2>/dev/null
}

_tags() {
    local repo="$1" resp
    resp=$(_api GET "/${repo}/tags/list" 2>/dev/null) || return 1
    echo "$resp" | python3 -c "import sys,json; d=json.load(sys.stdin); print('\n'.join(d.get('tags',[])))" 2>/dev/null
}

# 获取 digest，失败返回非零（调用方须用 if 包裹）
_digest() {
    local repo="$1" tag="$2" header
    header=$(_api_head "/${repo}/manifests/${tag}") || return 1
    echo "$header" | grep -i 'Docker-Content-Digest' | awk '{print $2}' | tr -d '\r'
}

# 获取 manifest list / OCI index 中各子架构 manifest 的 digest
# 输入: repo, digest(顶层 manifest list)
# 输出: 各子 manifest digest (每行一个)
_get_submanifest_digests() {
    local repo="$1" digest="$2" body
    body=$(curl "${CURL_OPTS[@]}" -sS \
        -H "Accept: application/vnd.oci.image.index.v1+json" \
        -H "Accept: application/vnd.docker.distribution.manifest.list.v2+json" \
        "${REGISTRY_BASE}/v2/${repo}/manifests/${digest}" 2>/dev/null) || return 0
    # 解析 manifests 数组中的 digest 字段 (适用于 Docker manifest list 和 OCI index)
    echo "$body" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    for m in d.get('manifests', []):
        print(m.get('digest', ''))
except Exception:
    pass
" 2>/dev/null
}

_delete_manifest() {
    local repo="$1" digest="$2"
    # 加 -f: HTTP 4xx/5xx 视为失败
    curl "${CURL_OPTS[@]}" -sSf -X DELETE "${REGISTRY_BASE}/v2/${repo}/manifests/${digest}" >/dev/null
}

_check_registry() {
    local code
    code=$(curl "${CURL_OPTS[@]}" -s -o /dev/null -w '%{http_code}' "${REGISTRY_BASE}/v2/" 2>/dev/null || echo "000")
    case "$code" in
        200) return 0 ;;
        401) log_error "认证失败 (HTTP 401): 用户名或密码错误 — ${USERNAME}"; exit 1 ;;
        403) log_error "访问被拒绝 (HTTP 403): 账号无权限"; exit 1 ;;
        000) log_error "无法连接 Registry: ${REGISTRY_BASE}"; exit 1 ;;
        *)   log_error "Registry 返回异常状态: HTTP ${code}"; exit 1 ;;
    esac
}

# ---------- GC ----------
_gc_registry() {
    local container
    container=$(docker ps --filter "ancestor=registry" --format '{{.Names}}' | head -1)
    if [ -z "$container" ]; then
        container=$(docker ps --format '{{.Names}}' | grep -i registry | head -1)
    fi
    if [ -z "$container" ]; then
        log_warn "未找到 Registry 容器，请手动执行 GC:"
        log_warn "  docker exec <registry> registry garbage-collect --delete-untagged <config.yml>"
        return
    fi

    # 确定 registry 二进制路径
    local bin
    if docker exec "$container" test -x /bin/registry 2>/dev/null; then
        bin=/bin/registry
    else
        bin=registry
    fi

    # 自动探测配置文件路径 (不同 registry 版本/镜像可能不同)
    # v3 (distribution) → /etc/distribution/config.yml
    # v2 (registry)     → /etc/docker/registry/config.yml
    local config=""
    for candidate in \
        /etc/distribution/config.yml \
        /etc/docker/registry/config.yml \
        /config.yml \
        /etc/registry/config.yml \
        /etc/registry.yml
    do
        if docker exec "$container" test -f "$candidate" 2>/dev/null; then
            config="$candidate"
            break
        fi
    done
    # 如果常见路径都找不到，尝试在常见目录下搜索 (限定深度避免太慢)
    if [ -z "$config" ]; then
        config=$(docker exec "$container" find /etc /opt /usr/local -maxdepth 4 -name 'config.yml' 2>/dev/null | head -1)
    fi
    if [ -z "$config" ]; then
        log_error "无法在容器 ${container} 中找到 registry 配置文件"
        log_error "请手动执行: docker exec ${container} ${bin} garbage-collect --delete-untagged <config.yml>"
        return
    fi

    log_info "触发 Registry GC (容器: ${container}, 配置: ${config})..."

    # 探测 --delete-untagged 是否被支持 (registry >= 2.7)
    local gc_help supports_delete_untagged=0
    gc_help=$(docker exec "$container" "$bin" garbage-collect --help 2>&1) || true
    if echo "$gc_help" | grep -q -- '--delete-untagged'; then
        supports_delete_untagged=1
    fi

    local gc_cmd="docker exec $container $bin garbage-collect"
    [ "$supports_delete_untagged" = "1" ] && gc_cmd="$gc_cmd --delete-untagged"
    gc_cmd="$gc_cmd $config"

    log_info "执行: ${gc_cmd}"
    # 直接执行，错误输出到 stderr，不再吞掉
    if eval "$gc_cmd"; then
        log_ok "GC 完成"
    else
        local rc=$?
        log_error "GC 执行失败 (exit=${rc})，请手动检查:"
        log_error "  ${gc_cmd}"
    fi
}

# ---------- 主流程 ----------
# 展示配置信息，用户确认后再执行
echo ""
log_info "=========== 清理配置确认 ==========="
log_info "Registry    : ${REGISTRY_BASE}"
log_info "Auth        : ${USERNAME} (已认证)"
log_info "KEEP_LATEST : ${KEEP_LATEST} (latest 标签始终保留)"
log_info "删除后 GC   : --delete-untagged"
echo ""

if [ "$ASSUME_YES" = "false" ]; then
    read -r -p "$(echo -e "${YELLOW}确认以上配置并开始扫描? [y/N] ${NC}")" start_confirm
    case "$start_confirm" in
        y|Y|yes|YES) ;;
        *) log_info "已取消，未做任何更改"; exit 0 ;;
    esac
fi

echo ""
_check_registry

# 收集需要删除的条目
# 注意: 不能用 mapfile < <(_catalog)，因为进程替换中子 shell 退出码不传播
# 这里先用普通变量捕获输出和退出码
catalog_out=""
if catalog_out=$(_catalog); then
    mapfile -t repos <<< "$catalog_out"
else
    log_error "获取 catalog 失败 (可能是认证失败或网络错误)"
    exit 1
fi

# 统一的"无镜像/无删除"处理: 询问是否仍要执行 GC
_nothing_to_delete() {
    local msg="$1"
    log_ok "$msg"
    echo ""
    log_info "是否仍要执行垃圾收集 (清理历史 untagged 层)?"
    if [ "$ASSUME_YES" = "true" ]; then
        _gc_registry
    else
        read -r -p "$(echo -e "${YELLOW}执行 GC? [y/N] ${NC}")" gc_confirm
        case "$gc_confirm" in
            y|Y|yes|YES) _gc_registry ;;
            *) log_info "已跳过 GC";;
        esac
    fi
    echo ""
    log_ok "全部操作完成"
    exit 0
}

if [ ${#repos[@]} -eq 0 ]; then
    _nothing_to_delete "Registry 中没有镜像"
fi

# 声明存放待删除项的数组: "repo|tag|digest"
declare -a delete_list=()

log_info "扫描所有镜像..."
echo ""

for repo in "${repos[@]}"; do
    [ -z "$repo" ] && continue

    # 同 catalog: 先捕获输出和退出码，避免 mapfile 吞掉失败
    tags_out=""
    if tags_out=$(_tags "$repo"); then
        mapfile -t tags <<< "$tags_out"
    else
        log_warn "${repo}: 获取 tags 失败，跳过"
        continue
    fi
    if [ ${#tags[@]} -eq 0 ]; then
        log_warn "${repo}: 无标签，跳过"
        continue
    fi

    # latest 单独保护，其余按版本号倒序保留前 N 个
    local_latest=false
    others=()
    for t in "${tags[@]}"; do
        if [ "$t" = "latest" ]; then
            local_latest=true
        else
            others+=("$t")
        fi
    done

    # 倒序排序 (版本号)
    if [ ${#others[@]} -gt 0 ]; then
        IFS=$'\n' read -r -d '' -a sorted_others < <(printf '%s\n' "${others[@]}" | sort -rV && printf '\0') || true
    else
        sorted_others=()
    fi

    kept_count=0
    for tag in "${sorted_others[@]}"; do
        kept_count=$((kept_count + 1))
        if [ "$kept_count" -le "$KEEP_LATEST" ]; then
            continue
        fi
        # 用 if 包裹避免 _digest 失败时 set -e 中断整个脚本
        if digest=$(_digest "$repo" "$tag"); then
            if [ -n "$digest" ]; then
                delete_list+=("${repo}|${tag}|${digest}")
            else
                log_warn "${repo}:${tag}: 响应中无 Docker-Content-Digest，跳过"
            fi
        else
            log_warn "${repo}:${tag}: 无法获取 digest，跳过"
        fi
    done

    # 打印该 repo 的保留策略
    kept_tags="${sorted_others[*]:0:$KEEP_LATEST}"
    [ "$local_latest" = true ] && kept_tags="latest ${kept_tags}"
    # 去除多余空格 (KEEP_LATEST=0 或无其它 tag 时可能产生前导/尾随空格)
    kept_tags="${kept_tags#"${kept_tags%%[![:space:]]*}"}"
    kept_tags="${kept_tags%"${kept_tags##*[![:space:]]}"}"
    log_ok "${repo}: 保留 [${kept_tags}]"
done

echo ""
total=${#delete_list[@]}

# 即便没有需要删除的镜像，也询问是否执行 GC (统一入口)
if [ "$total" -eq 0 ]; then
    _nothing_to_delete "没有需要删除的镜像"
fi

# ---------- DRY RUN 预览 ----------
log_info "=========== DRY RUN (预览) ==========="
log_info "以下 ${total} 个镜像将被删除:"
echo ""
printf "%-40s %-20s %s\n" "REPOSITORY" "TAG" "DIGEST"
for entry in "${delete_list[@]}"; do
    IFS='|' read -r repo tag digest <<< "$entry"
    printf "%-40s %-20s %s\n" "$repo" "$tag" "${digest:0:24}..."
done
echo ""
log_warn "将保留每个镜像最新 ${KEEP_LATEST} 个 + latest 标签"
log_warn "多架构镜像将递归删除 manifest list 及子架构 manifest"
log_warn "删除后将运行 GC (--delete-untagged)"
echo ""

if [ "$ASSUME_YES" = "false" ]; then
    read -r -p "$(echo -e "${YELLOW}确认执行以上删除操作? [y/N] ${NC}")" confirm
    case "$confirm" in
        y|Y|yes|YES) ;;
        *) log_info "已取消，未做任何更改"; exit 0 ;;
    esac
fi

# ---------- 真正执行删除 ----------
log_info "=========== 开始执行删除 ==========="
deleted_ok=0
deleted_fail=0
for entry in "${delete_list[@]}"; do
    IFS='|' read -r repo tag digest <<< "$entry"

    # 多架构镜像: 先删除 manifest list 中的各子架构 manifest
    sub_digests=""
    sub_digests=$(_get_submanifest_digests "$repo" "$digest") || true
    if [ -n "$sub_digests" ]; then
        while IFS= read -r sub; do
            [ -z "$sub" ] && continue
            if _delete_manifest "$repo" "$sub"; then
                log_info "  ↳ 已删除子 manifest ${sub:0:19}..."
            else
                # 子 manifest 删除失败不致命 (可能被其它 tag 共享)，继续
                log_warn "  ↳ 子 manifest 删除失败 (可能被共享): ${sub:0:19}..."
            fi
        done <<< "$sub_digests"
    fi

    # 删除顶层 manifest list / 单架构 manifest
    if _delete_manifest "$repo" "$digest"; then
        log_info "已删除 ${repo}:${tag}"
        deleted_ok=$((deleted_ok + 1))
    else
        log_error "删除失败 ${repo}:${tag}"
        deleted_fail=$((deleted_fail + 1))
    fi
done

echo ""
log_ok "删除完成: 成功 ${deleted_ok} 个, 失败 ${deleted_fail} 个"

# ---------- 运行 GC ----------
# 每次都强制执行 GC，即使本次没有删除 (可清理之前遗留的 untagged 层)
_gc_registry

echo ""
log_ok "全部操作完成"
