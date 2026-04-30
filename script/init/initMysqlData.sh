#!/bin/bash
# initMysqlData.sh — 导入 MySQL 初始化数据
# 用法: $0 sql_file [sql_file ...]
#   sql_file 可以是:
#     - 文件名 (如 initNacos.sql) → 自动从 initData 目录查找
#     - 绝对路径 (如 /tmp/test.sql) → 直接使用
#     - 相对路径 (如 ./other/test.sql) → 相对于当前工作目录
#   无参数则报错退出
# 安全机制:
#   - 从 SQL 文件内容自动提取库名 (CREATE DATABASE / USE 语句)
#   - 库已存在且无 DROP 语句时，自动跳过
#   - 库已存在且 SQL 含 DROP 语句时，询问客户是否执行 (默认 N)
# 前置: MySQL 容器 (uw-mydb-mysql-3308) 已启动

# ============================================================
#  配置加载
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/../../uniweb-system.config" 2>/dev/null || source "/root/uniweb/uniweb-system.config" 2>/dev/null

INIT_DATA_DIR="${SCRIPT_DIR}/../../initData"
[ ! -d "$INIT_DATA_DIR" ] && INIT_DATA_DIR="/root/uniweb/initData"

MYSQL_HOST="${MYSQL_HOST:-127.0.0.1}"
MYSQL_PORT="${MYSQL_PORT:-3308}"
MYSQL_CONTAINER="uw-mydb-mysql-3308"

# ============================================================
#  底层工具: MySQL 执行 / 路径解析
# ============================================================

_mysql_exec() {
    docker exec -i "$MYSQL_CONTAINER" mysql \
        -h "${MYSQL_HOST}" -P "${MYSQL_PORT}" \
        -u "${MYSQL_ROOT_USERNAME}" -p"${MYSQL_ROOT_PASSWORD}" \
        "$@" 2>/dev/null
}

_resolve_sql_path() {
    local sql_file="$1"
    if [[ "$sql_file" == /* ]] || [[ "$sql_file" == */* ]]; then
        echo "$sql_file"
    else
        echo "${INIT_DATA_DIR}/${sql_file}"
    fi
}

# ============================================================
#  中层检测: 库名提取 / 库存在检测 / DROP 语句检测
# ============================================================

_extract_db_name() {
    local sql_path
    sql_path=$(_resolve_sql_path "$1")
    local line
    line=$(grep -iE '^\s*(CREATE\s+DATABASE|USE)\s+' "$sql_path" 2>/dev/null | head -1)
    if [ -n "$line" ]; then
        local db
        db=$(echo "$line" \
            | sed -E 's/.*USE[[:space:]]+[`"]*([^`" ;]+).*/\1/' \
            | sed -E 's/.*CREATE[[:space:]]+DATABASE[[:space:]]+(IF[[:space:]]+NOT[[:space:]]+EXISTS[[:space:]]+)?[`"]*([^`" ;]+).*/\2/')
        echo "$db"
    fi
}

_db_exists() {
    local db_name="$1"
    [ -z "$db_name" ] && return 1
    local result
    result=$(_mysql_exec -sN -e "SELECT SCHEMA_NAME FROM information_schema.SCHEMATA WHERE SCHEMA_NAME='${db_name}'")
    [ -n "$result" ]
}

_has_drop() {
    local sql_path
    sql_path=$(_resolve_sql_path "$1")
    grep -qiE '^\s*DROP\s+(TABLE|DATABASE|PROCEDURE|FUNCTION|TRIGGER|VIEW)' "$sql_path" 2>/dev/null
}

# ============================================================
#  高层业务: 等待 MySQL / 导入 SQL
# ============================================================

wait_mysql() {
    echo "[INFO] 等待 MySQL 就绪..."
    local retries=0
    while [ $retries -lt 30 ]; do
        if _mysql_exec --silent -e "SELECT 1" &>/dev/null; then
            echo "[OK] MySQL 已就绪"
            return 0
        fi
        retries=$((retries + 1))
        echo "[INFO] 等待 MySQL... ($retries/30)"
        sleep 2
    done
    echo "[ERROR] MySQL 等待超时"
    exit 1
}

import_sql() {
    local sql_file="$1"
    local sql_path
    sql_path=$(_resolve_sql_path "$sql_file")

    if [ ! -f "$sql_path" ]; then
        echo "[WARN] ${sql_file} 不存在，跳过"
        return
    fi

    local db_name
    db_name=$(_extract_db_name "$sql_file")

    if [ -n "$db_name" ] && _db_exists "$db_name"; then
        if _has_drop "$sql_file"; then
            echo "[WARN] ${sql_file}: 数据库 ${db_name} 已存在，且 SQL 中包含 DROP 语句"
            local answer="n"
            read -e -p "  是否仍然执行? [y/N]: " answer
            case "$answer" in
                y|Y) ;;
                *)   echo "[WARN] 跳过 ${sql_file}"; return 0 ;;
            esac
        else
            echo "[WARN] ${sql_file}: 数据库 ${db_name} 已存在，跳过"
            return 0
        fi
    fi

    echo "[SQL] 导入 ${sql_file}$( [ -n "$db_name" ] && echo " -> ${db_name}" )..."
    _mysql_exec < "$sql_path"
    local rc=$?
    if [ $rc -ne 0 ]; then
        echo "[ERROR] ${sql_file} 导入失败 (退出码: $rc)"
        return 1
    fi
    echo "[OK] ${sql_file} 导入完成"
}

# ============================================================
#  主流程
# ============================================================

if [ $# -eq 0 ]; then
    echo "[ERROR] 必须指定要导入的 SQL 文件"
    echo "用法: $0 sql_file [sql_file ...]"
    echo "可用文件:"
    ls -1 "${INIT_DATA_DIR}/"*.sql 2>/dev/null | while read -r f; do echo "  $(basename "$f")"; done
    exit 1
fi

wait_mysql

for sql in "$@"; do
    import_sql "${sql}"
done
