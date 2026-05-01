#!/bin/bash
# startES9200.sh — 启动 Elasticsearch (端口 9200, 需先执行 sysctl/ulimit 配置)
source "$(dirname "$0")/common.sh"

create_dir /home/es9200/config
create_dir /home/es9200/data
create_dir /home/es9200/logs
create_dir /home/es9200/plugins
chown -R 1000:1000 /home/es9200

docker_remove es9200

CID=$(docker run -d \
--ulimit nofile=65535:65535 \
--ulimit nproc=32768:32768 \
--ulimit memlock=-1:-1 \
-e "ES_JAVA_OPTS=-Xms1g -Xmx1g" \
-e "ELASTIC_PASSWORD=${LOG_ES_PASSWORD}" \
-v /home/es9200/config:/usr/share/elasticsearch/config \
-v /home/es9200/data:/usr/share/elasticsearch/data \
-v /home/es9200/logs:/usr/share/elasticsearch/logs \
-v /home/es9200/plugins:/usr/share/elasticsearch/plugins \
${DOCKER_COMMON_OPTS} \
--name=es9200 \
"${REGISTRY_SERVER}/${IMAGE_ELASTICSEARCH}")

docker_run_check "$CID" "es9200"
