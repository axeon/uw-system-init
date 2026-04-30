#!/bin/bash
# ==============================================================================
# install.sh — UniWeb 服务器初始化入口
# 用法: curl -fsSL https://raw.githubusercontent.com/axeon/uw-system-init/main/install.sh | bash
# 选项: --branch <分支名>
# 流程: 克隆仓库 → 启动 setup.sh 向导 → 清理临时目录
# ==============================================================================
set -e

BRANCH="main"

while [[ $# -gt 0 ]]; do
    case $1 in
        --branch)  BRANCH="$2";  shift 2 ;;
        *) shift ;;
    esac
done

if [ "$EUID" -ne 0 ]; then
    echo "[ERROR] 请使用 root 用户运行: curl ... | sudo bash"
    exit 1
fi

if [ ! -f /etc/debian_version ]; then
    echo "[ERROR] 本工具仅支持 Debian/Ubuntu 系列 Linux 发行版。"
    echo "       当前系统不被支持，请使用 Debian、Ubuntu、Linux Mint 等发行版。"
    exit 1
fi

echo "[INFO] 安装基础依赖..."
apt-get update -y
apt-get install -y git curl bash

INSTALL_DIR="/root/.uw-system-init-$(date +%y%m%d%H%M%S)"

REPO_URL="https://github.com/axeon/uw-system-init.git"
echo "[INFO] 使用 GitHub 源: $REPO_URL"

echo "[INFO] 克隆仓库..."
rm -fr "$INSTALL_DIR"
git clone -b "$BRANCH" "$REPO_URL" "$INSTALL_DIR"

echo "[INFO] 设置脚本权限..."
find "$INSTALL_DIR" -type f -name "*.sh" -exec chmod +x {} \;

echo "[INFO] 启动安装向导..."
cd "$INSTALL_DIR"
bash setup.sh < /dev/tty

echo ""
read -p "安装完成，是否删除临时克隆目录 $INSTALL_DIR? [Y/n]: " CLEANUP < /dev/tty
case "$CLEANUP" in
    n|N) echo "[INFO] 临时目录保留: $INSTALL_DIR" ;;
    *)   rm -fr "$INSTALL_DIR"; echo "[INFO] 临时目录已清理" ;;
esac
