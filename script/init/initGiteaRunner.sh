#!/bin/bash
# initGiteaRunner.sh — 初始化 Gitea Actions Runner (创建用户/目录/systemd 服务)
set -e

useradd -m -d /home/gitea/runner gitea-runner
usermod -aG docker gitea-runner
mkdir -p /home/gitea/runner/cache
mkdir -p /home/gitea/runner/build
chown -R gitea-runner:gitea-runner /home/gitea/runner

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

systemctl daemon-reload
systemctl enable gitea-runner.service --now
systemctl restart gitea-runner.service
echo "gitea-runner服务已启动!"
