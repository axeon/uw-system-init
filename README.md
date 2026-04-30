# uw-system-init

UniWeb 微服务平台一键部署工具。通过交互式向导自动完成系统依赖安装、配置生成、镜像拉取和容器编排，在裸机服务器上快速搭建完整的 UniWeb 运行环境。

## 功能特性

- **一键安装** — 一行命令完成全部部署，自动克隆仓库并启动向导
- **交互式组件选择** — 通过 whiptail 菜单按需勾选要安装的服务，不装不需要的东西
- **自动配置生成** — 自动检测本机 IP，随机生成安全密码，输出 `uniweb-system.config` 统一管理
- **占位符模板引擎** — 配置文件中的 `#{KEY}` 占位符在部署时自动替换为实际值
- **本地 Registry 中转** — 内置 Docker Registry，所有镜像从上游拉取后推到本地仓库，离线可复用
- **从机部署支持** — 主机部署完成后可自动将服务扩展到从机节点

## 支持的组件

| 分类 | 组件 |
|------|------|
| **基础设施** | MySQL 8.4 · Redis 8 · RabbitMQ 4 · Elasticsearch 8 + Kibana · Nacos 2.3 · MinIO |
| **UniWeb 微服务** | Gateway · Auth Center · Task Center · Ops Center · Gateway Center · AI Center · MyDB Center · MyDB Proxy · TinyURL Center · Notify Center |
| **UniWeb 前端** | Root PC UI · Ops PC UI · Admin PC UI |
| **SaaS 服务** | SaaS Base · SaaS Finance · SaaS PC UI |
| **开发工具** | Gitea · Nexus3 · Code Center · Mihomo 代理 |

## 快速开始

### 前置要求

- 一台 **Ubuntu** 服务器（推荐 20.04+）
- **root** 权限
- 服务器可访问外网（拉取镜像）

### 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/axeon/uw-system-init/main/install.sh | sudo bash
```

指定分支：

```bash
curl -fsSL https://raw.githubusercontent.com/axeon/uw-system-init/main/install.sh | sudo bash -s -- --branch v1.0
```

### 手动安装

```bash
git clone https://github.com/axeon/uw-system-init.git
cd uw-system-init
chmod +x setup.sh script/*.sh script/**/*.sh
sudo ./setup.sh
```

## 部署流程

安装向导依次执行以下阶段：

```
阶段 1  安装系统依赖 (apt-get)
  ↓
阶段 2  配置生成（系统名 / IP / 密码 → uniweb-system.config）
  ↓
阶段 3  配置应用（替换 initHome / initData 中的 #{KEY} 占位符）
  ↓
阶段 4  交互式选择安装组件（whiptail 多选菜单）
  ↓
阶段 5  按需分发文件到目标目录
  ↓
执行    Docker → Registry → 拉取镜像 → MySQL → 导入数据库 → 基础服务 → 微服务 → 前端 → SaaS → 开发服务
```

## 目录结构

```
uw-system-init/
├── install.sh                  # 远程安装入口（curl | bash）
├── setup.sh                    # 主部署脚本（向导流程）
├── uniweb-registry.config      # 镜像版本配置
├── initData/                   # 数据库初始化 SQL
│   ├── initNacos.sql
│   ├── initAuthCenter.sql
│   ├── initGatewayCenter.sql
│   └── ...
├── initHome/                   # 组件配置文件模板
│   ├── mysql3308/conf/
│   ├── redis6380/conf/
│   ├── es9200/config/
│   ├── nacos8848/conf/
│   ├── gitea/
│   ├── mihomo/
│   └── ...
└── script/                     # 独立启停脚本
    ├── common.sh               # 共享基础函数
    ├── startMydbMysql3308.sh
    ├── startRedis6380.sh
    ├── startNacos8848.sh
    └── ...
```

## 配置文件

| 文件 | 说明 |
|------|------|
| `uniweb-system.config` | 部署实例信息（IP、密码、连接串），由向导自动生成 |
| `uniweb-registry.config` | 镜像版本配置（仓库地址、各组件镜像 tag） |

所有密码在配置生成阶段随机创建，配置文件权限为 `600`。

## 独立管理服务

部署完成后，每个组件都有独立的启停脚本，位于 `/root/uniweb/script/`：

```bash
# 启动单个服务
bash /root/uniweb/script/startRedis6380.sh

# 启动 Nacos
bash /root/uniweb/script/startNacos8848.sh
```

所有脚本通过 `common.sh` 共享 Docker 运行参数（时区、host 网络、自动重启）。

## 镜像搬运

项目内置镜像搬运脚本，用于从上游仓库拉取并推送到本地 Registry：

```bash
# 搬运单个镜像
bash script/tagPullImage.sh <镜像名>

# 搬运所有镜像
bash script/tagPullAllImage.sh
```

## License

MIT
