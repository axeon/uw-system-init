# gitea-runner 初始化配置

## 1. Runner 初始化

执行初始化脚本，自动完成以下操作：

- 从 `dl.gitea.com` 获取最新版本并下载匹配平台的 `act_runner`
- 创建 `gitea-runner` 用户（shell: `/bin/bash`），加入 `docker` 组
- 注册 Runner 并配置 systemd 服务

```bash
/home/gitea/runner/bin/initRunner.sh
```

## 2. 安装 SDKMAN（JDK + Maven） & NVM（Node.js + pnpm）

```bash
# 安装 SDKMAN
curl -s "https://get.sdkman.io" | bash

# 安装 NVM
curl -s "https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh" | bash

# SDKMAN 默认写入 .bashrc，Debian 下需迁移到 .profile 以确保 login shell 加载
mv ~/.bashrc ~/.profile

```

## 3. 安装 JDK 25.0.3-oracle & Maven 3.9.8 & Node.js 18 及 pnpm

```bash

# 安装 JDK 和 Maven
sdk install java 25.0.3-oracle
sdk install maven 3.9.8

# 安装 Node.js 18 及 pnpm
nvm install 18
npm install -g pnpm
npm config set registry https://registry.npmmirror.com
pnpm config set registry https://registry.npmmirror.com
```

## 4. 配置 docker buildx 配置文件

编辑 `/etc/docker/buildkitd.toml`，配置国内镜像源：

```toml
[registry."docker.io"]
  mirrors = [
    "docker.1panel.live",
    "docker.nju.edu.cn",
    "docker.mirrors.ustc.edu.cn"
  ]

[registry."127.0.0.1:5000"]
  http = true
```
