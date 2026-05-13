#!/bin/bash
APP_HOST=$(ip addr show | awk '/inet / && /10\.|192\.168\./ {print $2}' | cut -d/ -f1)
APP_NAME=$1
APP_VERSION=$2
APP_PORT=$3

docker stop ${APP_NAME}-${APP_PORT}
docker rm ${APP_NAME}-${APP_PORT}
docker rmi #{REGISTRY_SERVER}/${APP_NAME}:${APP_VERSION}
docker run -d \
-m 800m \
-e "JAVA_OPTS=-XX:+UseShenandoahGC -XX:+UseContainerSupport -XX:MaxRAMPercentage=80.0" \
-e SPRING_OPTS="--app.info=${APP_NAME}:${APP_VERSION} --spring.profiles.active=#{NACOS_NAMESPACE} --server.port=${APP_PORT}" \
-e APP_HOST=${APP_HOST} \
-e APP_PORT=${APP_PORT} \
-e NACOS_SERVER=#{NACOS_SERVER} \
-e NACOS_USERNAME=#{NACOS_USERNAME} \
-e NACOS_PASSWORD=#{NACOS_PASSWORD} \
-e NACOS_NAMESPACE=#{NACOS_NAMESPACE} \
-e LOG_ES_SERVER=#{LOG_ES_SERVER} \
-e LOG_ES_USERNAME=#{LOG_ES_USERNAME} \
-e LOG_ES_PASSWORD=#{LOG_ES_PASSWORD} \
-e TZ=$(cat /etc/timezone) \
-v /etc/localtime:/etc/localtime:ro \
-v /etc/timezone:/etc/timezone:ro \
--network=host \
--restart=unless-stopped \
--name=${APP_NAME}-${APP_PORT} \
#{REGISTRY_SERVER}/${APP_NAME}:${APP_VERSION}
