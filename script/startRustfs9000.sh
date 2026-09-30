#!/bin/bash
# startRustfs9000.sh — 启动 RustFS 对象存储 (API 9000 / 控制台 9001)
# 凭证使用 uniweb-system.config 的 RUSTFS_ROOT_USERNAME / RUSTFS_ROOT_PASSWORD
source "$(dirname "$0")/common.sh"

create_dir /home/rustfs9000/data
create_dir /home/rustfs9000/logs

docker_remove rustfs9000

# RustFS 容器以非 root 用户 rustfs (UID/GID 10001) 运行，bind-mount 目录须归其所有
chown -R 10001:10001 /home/rustfs9000/data /home/rustfs9000/logs

CID=$(docker run -d \
-e "RUSTFS_ACCESS_KEY=${RUSTFS_ROOT_USERNAME}" \
-e "RUSTFS_SECRET_KEY=${RUSTFS_ROOT_PASSWORD}" \
-e "RUSTFS_VOLUMES=/data" \
-e "RUSTFS_ADDRESS=0.0.0.0:9000" \
-e "RUSTFS_CONSOLE_ADDRESS=0.0.0.0:9001" \
-e "RUSTFS_CONSOLE_ENABLE=true" \
-e "RUSTFS_OBS_LOG_DIRECTORY=/logs" \
-v /home/rustfs9000/data:/data \
-v /home/rustfs9000/logs:/logs \
${DOCKER_COMMON_OPTS} \
--name=rustfs9000 \
"${REGISTRY_SERVER}/${IMAGE_RUSTFS}")

docker_run_check "$CID" "rustfs9000"
