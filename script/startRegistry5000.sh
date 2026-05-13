#!/bin/bash
# startRegistry5000.sh — 启动 Docker Registry 镜像仓库 (端口 5000, htpasswd 认证)
source "$(dirname "$0")/common.sh"

create_dir /home/registry/data
create_dir /home/registry/auth

docker_remove registry

CID=$(docker run -d \
-e "REGISTRY_AUTH=htpasswd" \
-e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
-e "REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd" \
-e "REGISTRY_STORAGE_DELETE_ENABLED=true" \
-v /home/registry/data:/var/lib/registry \
-v /home/registry/auth:/auth \
${DOCKER_COMMON_OPTS} \
--name registry \
"${IMAGE_REGISTRY}")

docker_run_check "$CID" "registry"
