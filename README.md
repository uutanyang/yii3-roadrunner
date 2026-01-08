# Yii3 + RoadRunner Docker 项目

基于 Docker Compose 的 Yii3 框架全栈开发环境，集成了 RoadRunner 高性能应用服务器、PostgreSQL 数据库、Redis 缓存、MinIO 对象存储和 NATS 消息队列。

## 项目特性

- 🚀 **高性能**: 使用 RoadRunner 作为应用服务器，支持 PHP 协程和常驻进程
- 🐘 **Yii3 框架**: 基于 PHP 8.1+ 的现代化 PHP 框架
- 🗄️ **PostgreSQL 15**: 可靠的关系型数据库
- ⚡ **Redis 7**: 高性能缓存和会话存储
- 📦 **MinIO**: S3 兼容的对象存储服务
- 📨 **NATS**: 轻量级消息队列和 JetStream 持久化存储
- 🔧 **一键部署**: 通过 Docker Compose 快速启动完整技术栈
- 📝 **配置分离**: 支持多环境配置管理

## 技术栈

| 服务 | 版本 | 端口 | 说明 |
|------|------|------|------|
| Yii3 + RoadRunner | PHP 8.2 | 8080 | 应用服务器 |
| PostgreSQL | 15-alpine | 5432 | 关系型数据库 |
| Redis | 7-alpine | 6379 | 缓存服务 |
| MinIO | latest | 9000/9001 | 对象存储 API/Web UI |
| NATS | 2.10-alpine | 4222/8222/6222 | 消息队列 |

## 快速开始

### 前置要求

- Docker Engine 20.10+
- Docker Compose 2.0+

### 安装步骤

1. **克隆或下载项目**

```bash
git clone <your-repo-url>
cd yii3-roadrunner
```

2. **配置环境变量**

```bash
# 复制生产环境配置模板
cp .env.prod .env

# 编辑 .env 文件，修改数据库密码等敏感信息
nano .env
```

**重要提示**: 生产环境请务必修改以下配置项：
- `DB_PASSWORD` - 数据库密码
- `MINIO_ACCESS_KEY` - MinIO 访问密钥
- `MINIO_SECRET_KEY` - MinIO 密钥
- `REDIS_PASSWORD` - Redis 密码（可选）

3. **启动所有服务**

```bash
# 启动所有容器
docker-compose up -d

# 查看容器状态
docker-compose ps

# 查看应用日志
docker-compose logs -f yii3-app
```

4. **验证服务**

```bash
# 检查 Yii3 应用
curl http://localhost:8080

# 检查 PostgreSQL
docker exec -it yii3-postgres psql -U yii3 -d yii3 -c "SELECT version();"

# 检查 Redis
docker exec -it yii3-redis redis-cli ping

# 检查 NATS
curl http://localhost:8222/varz
```

## 服务访问

| 服务 | 访问地址 | 凭据 |
|------|----------|------|
| Yii3 应用 | http://localhost:8080 | - |
| MinIO Web UI | http://localhost:9001 | 见 .env 配置 |
| NATS 监控 | http://localhost:8222 | - |
| PostgreSQL | localhost:5432 | 见 .env 配置 |
| Redis | localhost:6379 | 见 .env 配置 |
| NATS | localhost:4222 | - |

## 目录结构

```
yii3-roadrunner/
├── .env.prod                 # 生产环境配置模板
├── .rr.yaml                 # RoadRunner 配置文件
├── Dockerfile               # Yii3 应用镜像构建文件
├── docker-compose.yml       # Docker Compose 编排文件
├── composer.json            # PHP 依赖配置
├── src/                     # 应用源代码
│   └── ...
├── public/                  # Web 公开目录
│   └── index.php
├── tests/                   # 测试代码
│   └── ...
└── README.md               # 项目说明文档
```

## 常用命令

### 容器管理

```bash
# 启动所有服务
docker-compose up -d

# 停止所有服务
docker-compose down

# 停止并删除所有数据
docker-compose down -v

# 重启某个服务
docker-compose restart yii3-app

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f [service-name]

# 进入容器
docker exec -it yii3-app /bin/bash
```

### 应用管理

```bash
# 安装 Composer 依赖
docker-compose exec yii3-app composer install

# 更新依赖
docker-compose exec yii3-app composer update

# 运行数据库迁移
docker-compose exec yii3-app php yii migrate

# 运行测试
docker-compose exec yii3-app vendor/bin/phpunit
```

### 数据库操作

```bash
# 连接到 PostgreSQL
docker exec -it yii3-postgres psql -U yii3 -d yii3

# 备份数据库
docker exec yii3-postgres pg_dump -U yii3 yii3 > backup.sql

# 恢复数据库
docker exec -i yii3-postgres psql -U yii3 yii3 < backup.sql
```

### Redis 操作

```bash
# 连接到 Redis
docker exec -it yii3-redis redis-cli

# 如果设置了密码
docker exec -it yii3-redis redis-cli -a your_password

# 查看所有键
docker exec yii3-redis redis-cli KEYS "*"
```

### MinIO 操作

```bash
# 使用 MinIO 客户端
docker run --rm -it --network yii3-network minio/mc alias set myminio http://minio:9000 minioadmin minioadmin

# 列出 bucket
docker run --rm --network yii3-network minio/mc ls myminio/

# 上传文件
docker run --rm --network yii3-network minio/mc cp localfile.txt myminio/yii3-uploads/
```

## 环境配置说明

### 应用配置

```bash
APP_ENV=production              # 应用环境: production, development, testing
APP_DEBUG=false                 # 调试模式
APP_HTTP_PORT=8080             # HTTP 服务端口
```

### 数据库配置

```bash
DB_HOST=postgres               # 数据库主机
DB_PORT=5432                   # 数据库端口
DB_NAME=yii3                   # 数据库名
DB_USER=yii3                   # 数据库用户
DB_PASSWORD=your_password      # 数据库密码
```

### Redis 配置

```bash
REDIS_HOST=redis               # Redis 主机
REDIS_PORT=6379               # Redis 端口
REDIS_PASSWORD=               # Redis 密码
REDIS_DB=0                    # Redis 数据库编号
```

### MinIO 配置

```bash
MINIO_ENDPOINT=minio:9000      # MinIO 端点
MINIO_ACCESS_KEY=minioadmin    # 访问密钥
MINIO_SECRET_KEY=minioadmin    # 密钥
MINIO_BUCKET=yii3-uploads      # 存储桶名称
MINIO_USE_SSL=false            # 是否使用 SSL
```

### NATS 配置

```bash
NATS_URL=nats://nats:4222      # NATS 连接地址
NATS_STREAM_NAME=yii3-stream    # Stream 名称
NATS_CONSUMER_NAME=yii3-consumer # Consumer 名称
```

## 多环境配置

### 开发环境

```bash
# 创建开发环境配置
cp .env.prod .env.dev

# 修改环境变量为开发模式
# APP_ENV=development
# APP_DEBUG=true

# 使用开发环境配置启动
docker-compose --env-file .env.dev up -d
```

### 测试环境

```bash
# 创建测试环境配置
cp .env.prod .env.test

# 修改环境变量为测试模式
# APP_ENV=testing
# APP_DEBUG=true

# 使用测试环境配置启动
docker-compose --env-file .env.test up -d
```

## 故障排查

### 服务无法启动

1. **检查端口冲突**
```bash
# 查看端口占用
lsof -i :8080
lsof -i :5432
lsof -i :6379
```

2. **查看详细日志**
```bash
docker-compose logs [service-name]
```

3. **检查资源使用**
```bash
docker stats
```

### 数据库连接失败

- 确认 PostgreSQL 容器已启动
- 检查 `.env` 文件中的数据库配置
- 验证数据库密码是否正确

### MinIO 无法访问

- 确认 MinIO 容器健康状态: `docker-compose ps`
- 检查防火墙设置
- 验证 `.env` 文件中的密钥配置

### RoadRunner 启动失败

- 检查 `.rr.yaml` 配置文件
- 查看 RoadRunner 日志: `docker-compose logs yii3-app`
- 确认 PHP 版本和扩展是否正确

## 性能优化

### RoadRunner 配置优化

在 `.rr.yaml` 中调整 worker 数量：

```yaml
http:
  pool:
    num_workers: 8  # 根据 CPU 核心数调整
    max_jobs: 1000
```

### PostgreSQL 优化

在 `docker-compose.yml` 中添加 PostgreSQL 配置：

```yaml
postgres:
  command: postgres -c shared_buffers=256MB -c max_connections=200
```

### Redis 优化

在 `docker-compose.yml` 中调整 Redis 配置：

```yaml
redis:
  command: redis-server --maxmemory 512mb --maxmemory-policy allkeys-lru
```

## 数据持久化

所有服务的数据都通过 Docker volumes 持久化：

```bash
# 查看所有 volumes
docker volume ls | grep yii3

# 备份 volume
docker run --rm -v yii3-postgres-data:/data -v $(pwd):/backup alpine tar czf /backup/postgres-backup.tar.gz -C /data .

# 恢复 volume
docker run --rm -v yii3-postgres-data:/data -v $(pwd):/backup alpine tar xzf /backup/postgres-backup.tar.gz -C /data
```

## 安全建议

1. **密码管理**
   - 永远不要使用默认密码
   - 使用强密码（至少 16 位，包含大小写字母、数字和特殊字符）
   - 定期轮换密码

2. **网络安全**
   - 生产环境不要暴露所有端口到宿主机
   - 使用防火墙限制访问
   - 启用 HTTPS/TLS

3. **配置文件**
   - 不要将 `.env` 文件提交到版本控制
   - 使用 `.gitignore` 忽略敏感文件

4. **容器安全**
   - 定期更新镜像版本
   - 使用非 root 用户运行应用
   - 限制容器资源使用

## 扩展服务

### 添加 phpMyAdmin

在 `docker-compose.yml` 中添加：

```yaml
phpmyadmin:
  image: phpmyadmin:latest
  container_name: yii3-phpmyadmin
  ports:
    - "8081:80"
  environment:
    - PMA_HOST=postgres
    - PMA_USER=${DB_USER}
    - PMA_PASSWORD=${DB_PASSWORD}
  depends_on:
    - postgres
  networks:
    - yii3-network
```

### 添加 Redis Commander

```yaml
redis-commander:
  image: rediscommander/redis-commander:latest
  container_name: yii3-redis-commander
  ports:
    - "8082:8081"
  environment:
    - REDIS_HOSTS=local:redis:6379
  depends_on:
    - redis
  networks:
    - yii3-network
```

## 资源链接

- [Yii3 框架](https://www.yiiframework.com/)
- [RoadRunner 文档](https://roadrunner.dev/)
- [PostgreSQL 文档](https://www.postgresql.org/docs/)
- [Redis 文档](https://redis.io/documentation)
- [MinIO 文档](https://min.io/docs/minio/linux/index.html)
- [NATS 文档](https://docs.nats.io/)

## 许可证

BSD-3-Clause

## 贡献

欢迎提交 Issue 和 Pull Request！

## 联系方式

如有问题，请通过以下方式联系：
- 提交 Issue
- 发送邮件

---

**最后更新**: 2026-01-08
