#!/bin/bash
# initEs.sh — 初始化 ES+Kibana 日志服务
# 功能:
#   1. 配置宿主机内核参数 (vm.max_map_count / nofile / nproc / memlock)
#   2. 启动 ES 容器并等待就绪 (startES9200.sh)
#   3. 创建日志索引模板 uw-app-log / uw-biz-log (logsdb + synthetic _source)
#   4. 生成 Kibana service account token 并写入 kibana.yml
#   5. 启动 Kibana 容器 (startKibana5601.sh)
# 说明:
#   - 可独立重复执行，用于重置/重装 ES+Kibana 组件
#   - token 已存在时直接复用，重复执行不会轮换 token
#   - 索引模板使用 logsdb 模式 (ES 9.x 日志专用，synthetic _source +
#     best_compression，存储占用显著低于标准模式)；仅对之后新建的
#     数据流生效，存量索引不受影响，需删除数据流重建后才会切换
# 前置: uniweb-system.config 已生成; ES/Kibana 镜像已推送到本地仓库

# ============================================================
#  配置加载
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/../../uniweb-system.config" 2>/dev/null || source "/root/uniweb/uniweb-system.config" 2>/dev/null

ES_CONTAINER="es9200"
KIBANA_CONFIG="/home/kibana5601/config/kibana.yml"

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
if [ -z "$LOG_ES_SERVER" ] || [ -z "$LOG_ES_PASSWORD" ]; then
    log_error "LOG_ES_SERVER/LOG_ES_PASSWORD 未配置，请先运行 setup.sh 生成 uniweb-system.config"
    exit 1
fi

# ============================================================
#  1. 宿主机内核参数
# ============================================================

config_kernel_params() {
    log_step "配置 ES 宿主机内核参数..."

    grep -q 'vm.max_map_count=262144' /etc/sysctl.conf 2>/dev/null || {
        cat >> /etc/sysctl.conf <<'EOF'
vm.max_map_count=262144
fs.file-max=6815744
EOF
    }
    sysctl -p /etc/sysctl.conf >/dev/null 2>&1 || true

    # 当前会话限制 (容器内限制由 startES9200.sh 的 --ulimit 指定)
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

    log_ok "ES 内核参数已配置"
}

# ============================================================
#  2. 启动 ES 并等待就绪
# ============================================================

start_elasticsearch() {
    log_step "启动 Elasticsearch..."
    bash "${SCRIPT_DIR}/../startES9200.sh" || {
        log_error "ES 容器启动失败"
        exit 1
    }

    log_info "等待 ES 就绪..."
    local retries=0 http_code
    while [ $retries -lt 30 ]; do
        # 必须显式判定 200: 安全子系统未就绪时返回 401，curl 本身仍退出 0
        http_code=$(curl -sk -o /dev/null -w "%{http_code}" \
            -u "${LOG_ES_USERNAME}:${LOG_ES_PASSWORD}" \
            "${LOG_ES_SERVER}/_cluster/health" 2>/dev/null)
        if [ "$http_code" = "200" ]; then
            log_ok "ES 已就绪"
            return 0
        fi
        retries=$((retries + 1))
        echo "  等待 ES... ($retries/30)"
        sleep 2
    done
    log_error "ES 等待超时"
    exit 1
}

# ============================================================
#  3. 日志索引模板 (logsdb + synthetic _source)
# ============================================================

# 从 stdin 读取模板 JSON 并 PUT
put_index_template() {
    local name="$1" http_code
    http_code=$(curl -sk -o /dev/null -w "%{http_code}" \
        -u "${LOG_ES_USERNAME}:${LOG_ES_PASSWORD}" \
        -H "Content-Type: application/json" \
        -X PUT "${LOG_ES_SERVER}/_index_template/${name}" \
        --data-binary @-)
    if [ "$http_code" -ge 200 ] && [ "$http_code" -lt 300 ]; then
        log_ok "索引模板 ${name} 创建成功 ($http_code)"
    else
        log_warn "索引模板 ${name} 创建失败 (HTTP $http_code)"
    fi
}

create_index_templates() {
    log_step "创建日志索引模板 (logsdb + synthetic _source)..."

    # 应用日志 (uw-* / *-app / *-center)，保留 30 天
    # logsdb: 强制 synthetic _source + best_compression，磁盘与堆外内存占用
    #         显著低于标准模式；synthetic _source 不支持 includes/excludes
    #         过滤（原模板为空列表，无影响）
    put_index_template "uw-app-log" <<'EOF'
{
  "priority": 9,
  "template": {
    "settings": {
      "index": {
        "mode": "logsdb",
        "number_of_shards": 1,
        "number_of_replicas": 0,
        "refresh_interval": "10s",
        "codec": "best_compression"
      }
    },
    "mappings": {
      "dynamic": true,
      "numeric_detection": false,
      "date_detection": true,
      "dynamic_date_formats": ["strict_date_optional_time", "yyyy/MM/dd HH:mm:ss Z||yyyy/MM/dd Z"],
      "_source": { "mode": "synthetic" },
      "_routing": { "required": false },
      "subobjects": true,
      "dynamic_templates": []
    },
    "lifecycle": { "enabled": true, "data_retention": "30d" }
  },
  "index_patterns": ["uw-*", "*-app", "*-center"],
  "data_stream": { "hidden": false, "allow_custom_routing": false },
  "composed_of": []
}
EOF

    # 业务日志 (*.log)，保留 180 天
    put_index_template "uw-biz-log" <<'EOF'
{
  "priority": 10,
  "template": {
    "settings": {
      "index": {
        "mode": "logsdb",
        "number_of_shards": 1,
        "number_of_replicas": 0,
        "refresh_interval": "10s",
        "codec": "best_compression"
      }
    },
    "mappings": {
      "dynamic": true,
      "numeric_detection": false,
      "date_detection": true,
      "dynamic_date_formats": ["strict_date_optional_time", "yyyy/MM/dd HH:mm:ss Z||yyyy/MM/dd Z"],
      "_source": { "mode": "synthetic" },
      "_routing": { "required": false },
      "subobjects": true,
      "dynamic_templates": []
    },
    "lifecycle": { "enabled": true, "data_retention": "180d" }
  },
  "index_patterns": ["*.log"],
  "data_stream": { "hidden": false, "allow_custom_routing": false }
}
EOF
}

# ============================================================
#  4. Kibana Service Account Token
# ============================================================

setup_kibana_token() {
    log_step "配置 Kibana 访问 Token..."

    # 已存在则复用，避免重复执行时轮换 token。
    # list 输出官方文档未保证固定前缀，解析取"首个 = 之后的内容"，对前缀/空格变化不敏感
    local token=""
    token=$(docker exec "$ES_CONTAINER" /usr/share/elasticsearch/bin/elasticsearch-service-tokens list 2>/dev/null \
        | awk '/elastic\/kibana\/my-token[[:space:]]*=/ {sub(/^[^=]*=[[:space:]]*/, ""); gsub(/\r/, ""); gsub(/[[:space:]]+$/, ""); print}')
    if [ -z "$token" ]; then
        token=$(docker exec "$ES_CONTAINER" /usr/share/elasticsearch/bin/elasticsearch-service-tokens create elastic/kibana my-token 2>/dev/null \
            | awk -F ' = ' '{print $NF}' | tr -d '\r')
    fi
    if [ -z "$token" ]; then
        log_error "Kibana service account token 生成失败"
        exit 1
    fi

    # 整行替换: 兼容首次的 #{ELASTICSEARCH_SERVICE_ACCOUNT_TOKEN} 占位符与重跑时的旧 token 值
    if [ -f "$KIBANA_CONFIG" ]; then
        sed -i -E "s|^elasticsearch[.]serviceAccountToken:.*|elasticsearch.serviceAccountToken: \"${token}\"|" "$KIBANA_CONFIG"
        grep -q '^elasticsearch[.]serviceAccountToken:' "$KIBANA_CONFIG" \
            || echo "elasticsearch.serviceAccountToken: \"${token}\"" >> "$KIBANA_CONFIG"
        log_ok "Kibana Token 已写入 ${KIBANA_CONFIG}"
    else
        log_warn "未找到 ${KIBANA_CONFIG}，跳过 Token 写入"
    fi
}

# ============================================================
#  5. 启动 Kibana
# ============================================================

start_kibana() {
    log_step "启动 Kibana..."
    bash "${SCRIPT_DIR}/../startKibana5601.sh" || {
        log_error "Kibana 容器启动失败"
        exit 1
    }
    log_ok "Kibana 已启动"
}

# ============================================================
#  主流程
# ============================================================

config_kernel_params
start_elasticsearch
create_index_templates
setup_kibana_token
start_kibana

log_ok "ES+Kibana 初始化完成"
