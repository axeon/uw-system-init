#!/bin/bash
# 启动Mihomo服务
source "$(dirname "$0")/common.sh"

create_dir /home/mihomo/conf

docker_remove mihomo

CID=$(docker run -d \
-v /home/mihomo/conf:/root/.config/mihomo \
${DOCKER_COMMON_OPTS} \
--name=mihomo \
"${IMAGE_MIHOMO}")

docker_run_check "$CID" "mihomo"
