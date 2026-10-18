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
| **基础设施** | MySQL 8.4 · Redis 8 · RabbitMQ 4 · Elasticsearch 9 + Kibana · Nacos 2.3 · RustFS |
| **UniWeb 微服务** | Gateway · Auth Center · Task Center · Ops Center · Gateway Center · AI Center · MyDB Center · MyDB Proxy · TinyURL Center · Notify Center |
| **UniWeb 前端** | Root PC UI · Ops PC UI · Admin PC UI |
| **SaaS 服务** | SaaS Base · SaaS Finance · SaaS PC UI |
| **开发工具** | Gitea · Nexus3 · Code Center · Mihomo 代理 |

## 快速开始

### 前置要求
- 服务器最低配置2核8GB内存，推荐4核16GB内存，生产环境建议8核32GB内存以上
- **Debian 12 / Ubuntu 26** 服务器
- **root** 权限
- 服务器可访问外网（拉取镜像）

### 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/axeon/uw-system-init/main/install.sh | sudo bash
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
    ├── init/                   # 组件初始化脚本（可独立重跑，用于重置/重装）
    │   ├── initDocker.sh       # Docker+containerd 安装修复（apt 源/daemon.json）
    │   ├── initRegistry.sh     # 本地 Registry 认证重置 + 启动
    │   ├── initEs.sh           # ES+Kibana（内核参数 + logsdb 索引模板 + Kibana Token）
    │   ├── initMysqlData.sh    # 数据库初始化数据导入
    │   ├── initOpsAgent.sh     # ops-agent 接管
    │   └── ...
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

# 重置/重装 ES+Kibana 组件（内核参数 + 启动 + 索引模板 + Kibana Token，可重复执行）
bash /root/uniweb/script/init/initEs.sh

# Docker 环境修复/重装（已安装且正常时自动跳过）
bash /root/uniweb/script/init/initDocker.sh

# 重置 Registry 认证（修改 REGISTRY_PASSWORD 后重新生成 htpasswd 并 login）
bash /root/uniweb/script/init/initRegistry.sh

# 启动数据组件 agent 节点（注册到 uw-ops-center 领编排任务；规划端口默认 9200/6379/5672，
# 被占时 entrypoint 以规划端口为基数自动协商避让，容器名/hostname 同按规划端口生成）
bash /root/uniweb/script/startUwOpsEs.sh            # Elasticsearch agent（UW_ES_PORT=9200）
bash /root/uniweb/script/startUwOpsRedis.sh         # Redis agent（UW_REDIS_PORT=6379）
bash /root/uniweb/script/startUwOpsRabbit.sh        # RabbitMQ agent（UW_RABBIT_PORT=5672）
# 多实例同机：规划端口参数化起第二个节点（数据目录/容器名随之区分）
UW_ES_PORT=9201 bash /root/uniweb/script/startUwOpsEs.sh
```

所有脚本通过 `common.sh` 共享 Docker 运行参数（时区、host 网络、自动重启）。

## 容器命名与实例身份规范

全平台容器实例命名与身份的单一规范（2026-10-14 定案，四域中间件 / DeployPlan 应用容器 / 演练容器一律适用）。

### 容器命名模板（两形态）

```
容器名 = {镜像短名}-{实例键}
实例键：
  ① 有端口镜像 → 主端口
     主端口 = deploy_ports 以保留键 primary 显式声明的端口名（如 primary=amqp）；
     未声明时回退端口名字典序首名（与 allocatePorts 分配顺序同源，确定性）
  ② 无端口镜像（worker/任务型）→ 实例序号 {ordinal}（同主机同镜像既有容器数+1，查台账）
镜像短名 = image ref 最后一段（去 registry 前缀）
兜底     = 端口分配/序号查询失败 → uw-ops-{containerId}
```

- `--name` 与 `--hostname` 同源注入（start 脚本同一变量）：容器内 `uname -n` 即容器名，
  域 agent 随注册上报（server 行 `report_container_name` 列），center 凭 `(host, containerName)`
  与容器台账（`ops_container_info`）关联——同主机同名容器由 docker 保证唯一。
- **禁令**：hostname 即容器名后，任何代码不得再假设 `uname -n` 是短容器 ID。
- 演练/临时容器一律按模板起名（`uw-ops-{域}-{端口}`），不得使用 drill-xxx 等随意名。

### 实例身份 = ip + port

分布式节点身份不得依赖默认 hostname（容器短 ID，重建即漂移）。身份名必须包含 ip 与 port
两个成分，分隔符依协议域约定（全局一致的是成分规则，不是字面格式）：

| 域 | 身份形态 | 分隔约定 |
|---|---|---|
| RabbitMQ | `rabbit-{port}@{ip}`（erlang 节点名） | `@`（erlang 格式约束） |
| Elasticsearch | `{ip}:{port}`（entrypoint `-Enode.name` 注入） | `:` |
| MySQL MGR | `report_host={ip}` + `report_port={port}` | 协议原生双字段 |
| Redis | 无节点名，server 行 `(host, port)` 二元组 | 双列 |

### 两条容器生命周期链（端口语义差异）

| | 链 A：DeployPlan 应用容器 | 链 B：中间件四域 |
|---|---|---|
| 容器由谁起 | center 下 plan → host agent `docker run` | start 脚本（本仓库）手动起 |
| 端口 | `allocatePorts` 预分配（台账无锁汇总冲突递增） | entrypoint 运行时协商（规划端口被占则整组 +1 平移，粘性落卷） |
| 规划端口 | plan 的 deploy_ports | 脚本参数 `UW_*_PORT`（env 注入容器，兼作协商基数） |
| 台账登记 | plan 预建行（agent 回填 hash/observed） | host agent 全量 docker ps 落 `ops_container_info`（plan_id=-1 行） |
| 失真告警 | 预分配被外部侵占（预留） | agent 上报 plannedPort≠实际端口 → center 发 WARN 告警（`mwagent.port.drift.{域}`） |

链 B 落台账行经域 server 行随注册上报的容器名关联升级：回填 `cluster_id` 与 cluster 行设定的
`deploy_profile`（容器名从"约定"变"登记"）；关联不上的野容器 `deploy_profile` 为空、
`cluster_id=-1`，连续两窗口缺席置 STOP_SUCCESS（行保留审计，不物理删）。

长期终态：中间件容器逐步走链 A 通道（deployRef 八列已备），start 脚本保留为 bootstrap/救援通道。

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
