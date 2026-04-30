#!/bin/sh
set -e  # 遇到错误立即退出

# 创建gitea-runner用户
useradd -m -d /home/gitea/runner gitea-runner
# 添加gitea-runner用户到docker组
usermod -aG docker gitea-runner
# 创建缓存目录和工作目录
mkdir -p /home/gitea/runner/cache
mkdir -p /home/gitea/runner/build
# 修改目录所有者
chown -R gitea-runner:gitea-runner /home/gitea/runner
# 复制gitea-runner.service文件
cat > /etc/systemd/system/gitea-runner.service << 'EOF'
[Unit]
Description=Gitea Actions runner
Documentation=https://gitea.com/gitea/act_runner
After=docker.service

[Service]
ExecStart=/bin/bash -lc 'source /etc/profile || true;/home/gitea/runner/bin/act_runner daemon --config /home/gitea/runner/config/config.yaml'
ExecReload=/bin/kill -s HUP $MAINPID
WorkingDirectory=/home/gitea/runner
TimeoutSec=0
RestartSec=10
Restart=always
User=gitea-runner

[Install]
WantedBy=multi-user.target
EOF

# 配置gitea-runner.service文件
systemctl daemon-reload
# 启动gitea-runner服务
systemctl enable gitea-runner.service --now
systemctl restart gitea-runner.service
echo "gitea-runner服务已启动!"
