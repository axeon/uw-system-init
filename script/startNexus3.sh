#!/bin/bash
# startNexus3.sh — 启动 Nexus3 制品仓库
source "$(dirname "$0")/common.sh"

create_dir /home/nexus3/data
chown -R 200 /home/nexus3/data

docker_remove nexus3

CID=$(docker run -d \
-v /home/nexus3/data:/nexus-data \
${DOCKER_COMMON_OPTS} \
--name=nexus3 \
"${IMAGE_NEXUS3}")

docker_run_check "$CID" "nexus3"
