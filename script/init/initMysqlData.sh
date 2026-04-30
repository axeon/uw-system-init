#!/bin/bash
# initMysqlData.sh — 导入 MySQL 初始化数据
# 用法: $0 [sql_file ...]
# 无参数: 导入全部 SQL (initUser + initNacos + 所有 center)
# 有参数: 导入 initUser + initNacos + 指定的 SQL 文件
# 前置: MySQL 容器 (uw-mydb-mysql-3308) 已启动

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/../../uniweb-system.config" 2>/dev/null || source "/root/uniweb/uniweb-system.config" 2>/dev/null

# initData 目录 (优先相对路径，其次已安装目录)
INIT_DATA_DIR="${SCRIPT_DIR}/../../initData"
[ ! -d "$INIT_DATA_DIR" ] && INIT_DATA_DIR="/root/uniweb/initData"

MYSQL_HOST="${MYSQL_HOST:-127.0.0.1}"
MYSQL_PORT="${MYSQL_PORT:-3308}"

wait_mysql() {
    echo "[INFO] 等待 MySQL 就绪..."
    local max_retries=30
    local retries=0
    while [ $retries -lt $max_retries ]; do
        if docker exec -i uw-mydb-mysql-3308 mysqladmin ping \
            -h "${MYSQL_HOST}" -P "${MYSQL_PORT}" \
            -u "${MYSQL_ROOT_USERNAME}" -p"${MYSQL_ROOT_PASSWORD}" \
            --silent 2>/dev/null; then
            echo "[OK] MySQL 已就绪"
            return 0
        fi
        retries=$((retries + 1))
        echo "[INFO] 等待 MySQL... ($retries/$max_retries)"
        sleep 2
    done
    echo "[ERROR] MySQL 等待超时"
    exit 1
}

import_sql() {
    local sql_file="$1"
    if [ -f "${INIT_DATA_DIR}/${sql_file}" ]; then
        echo "[SQL] 导入 ${sql_file}..."
        docker exec -i uw-mydb-mysql-3308 mysql \
            -h "${MYSQL_HOST}" -P "${MYSQL_PORT}" \
            -u "${MYSQL_ROOT_USERNAME}" -p"${MYSQL_ROOT_PASSWORD}" \
            < "${INIT_DATA_DIR}/${sql_file}"
    else
        echo "[WARN] ${sql_file} 不存在，跳过"
    fi
}

wait_mysql

# 无参数: 导入全部 SQL; 有参数: initUser + initNacos + 指定文件
if [ $# -eq 0 ]; then
    import_sql initUser.sql
    import_sql initNacos.sql
    import_sql initAuthCenter.sql
    import_sql initTaskCenter.sql
    import_sql initOpsCenter.sql
    import_sql initGatewayCenter.sql
    import_sql initMydbCenter.sql
    import_sql initAiCenter.sql
    import_sql initTinyurlCenter.sql
    import_sql initNotifyCenter.sql
    import_sql initCodeCenter.sql
    import_sql initSaasBase.sql
    import_sql initSaasFinance.sql
else
    import_sql initUser.sql
    import_sql initNacos.sql
    for sql in "$@"; do
        import_sql "${sql}"
    done
fi
