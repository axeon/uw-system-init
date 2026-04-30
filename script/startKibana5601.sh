#!/bin/bash
# startKibana5601.sh — 启动 Kibana 日志可视化 (端口 5601)
source "$(dirname "$0")/common.sh"

create_dir /home/kibana5601/config
create_dir /home/kibana5601/data
create_dir /home/kibana5601/log
create_dir /home/kibana5601/plugins
chown -R 1000:1000 /home/kibana5601

docker_remove kibana5601

CID=$(docker run -d \
-v /home/kibana5601/config:/usr/share/kibana/config \
-v /home/kibana5601/data:/usr/share/kibana/data \
-v /home/kibana5601/log:/usr/share/kibana/log \
-v /home/kibana5601/plugins:/usr/share/kibana/plugins \
${DOCKER_COMMON_OPTS} \
--name=kibana5601 \
"${IMAGE_KIBANA}")

docker_run_check "$CID" "kibana5601"
