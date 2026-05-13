#!/bin/bash
# startMinio9000.sh — 启动 MinIO 对象存储 (API 9000 / 控制台 9001)
source "$(dirname "$0")/common.sh"

create_dir /home/minio9000/data

docker_remove minio9000

CID=$(docker run -d \
-e "MINIO_ROOT_USER=${MINIO_ROOT_USERNAME}" \
-e "MINIO_ROOT_PASSWORD=${MINIO_ROOT_PASSWORD}" \
-e "MINIO_VOLUMES=/data" \
-v /home/minio9000/data:/data \
${DOCKER_COMMON_OPTS} \
--name=minio9000 \
"${REGISTRY_SERVER}/${IMAGE_MINIO}" server --address ":9000" --console-address ":9001")

docker_run_check "$CID" "minio9000"
