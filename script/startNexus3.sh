#!/bin/bash
# startNexus3.sh — 启动 Nexus3 制品仓库
source "$(dirname "$0")/common.sh"

create_dir /home/nexus3/data
chown -R 200 /home/nexus3/data

docker_remove nexus3

CID=$(docker run -d \
-p 61881:8081 \
-v /home/nexus3/data:/nexus-data \
-e TZ=$(cat /etc/timezone) \
-v /etc/localtime:/etc/localtime:ro \
-v /etc/timezone:/etc/timezone:ro \
--privileged=true \
--restart=unless-stopped \
--name=nexus3 \
"${REGISTRY_SERVER}/${IMAGE_NEXUS3}")

docker_run_check "$CID" "nexus3"
