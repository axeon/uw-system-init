#!/bin/bash
# startGitea.sh — 启动 Gitea Git 服务 (HTTP 端口 61880, SSH 已禁用)
source "$(dirname "$0")/common.sh"

create_dir /home/gitea

docker_remove gitea

CID=$(docker run -d \
-e "HTTP_PORT=61880" \
-e "DISABLE_SSH=true" \
-v /home/gitea:/data \
${DOCKER_COMMON_OPTS} \
--name=gitea \
"${IMAGE_GITEA}")

docker_run_check "$CID" "gitea"
