#!/bin/bash
set -e

REPO="MetaCubeX/mihomo"
ARCH=$(dpkg --print-architecture)

case "$ARCH" in
    amd64) MIHOMO_ARCH="amd64" ;;
    arm64|aarch64) MIHOMO_ARCH="arm64" ;;
    armhf) MIHOMO_ARCH="armv7" ;;
    *)
        echo "[ERROR] 不支持的架构: $ARCH"
        exit 1
        ;;
esac

echo "[INFO] 检测架构: $ARCH -> mihomo-$MIHOMO_ARCH"

if command -v mihomo &>/dev/null; then
    INSTALLED=$(mihomo -v 2>/dev/null | head -1 | grep -oP 'v[\d.]+' || echo "unknown")
    echo "[OK] mihomo 已安装: $INSTALLED，跳过"
    exit 0
fi

echo "[INFO] 获取 mihomo 最新版本..."
LATEST_VERSION=$(curl -sf "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name"' | head -1 | sed -E 's/.*"tag_name":\s*"([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    echo "[ERROR] 获取最新版本失败，请检查网络连接"
    exit 1
fi

echo "[INFO] 最新版本: $LATEST_VERSION"

DEB_NAME="mihomo-linux-${MIHOMO_ARCH}-${LATEST_VERSION}.deb"
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${LATEST_VERSION}/${DEB_NAME}"

TMP_DIR=$(mktemp -d)
trap 'rm -fr "$TMP_DIR" 2>/dev/null' EXIT

echo "[INFO] 下载 ${DEB_NAME}..."
for retry in 1 2 3; do
    if curl -fSL --connect-timeout 15 -o "${TMP_DIR}/${DEB_NAME}" "$DOWNLOAD_URL"; then
        break
    fi
    echo "[WARN] 下载失败，重试 ($retry/3)..."
    sleep 3
done

if [ ! -f "${TMP_DIR}/${DEB_NAME}" ]; then
    echo "[ERROR] 下载失败: ${DEB_NAME}"
    exit 1
fi

echo "[INFO] 安装 ${DEB_NAME}..."
dpkg -i "${TMP_DIR}/${DEB_NAME}" || {
    echo "[ERROR] dpkg 安装失败"
    exit 1
}

if command -v mihomo &>/dev/null; then
    echo "[OK] mihomo 安装成功: $(mihomo -v 2>/dev/null | head -1)"
else
    echo "[ERROR] mihomo 安装验证失败"
    exit 1
fi
