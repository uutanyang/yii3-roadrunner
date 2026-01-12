# ============================================================
# 多阶段构建：使用 RoadRunner 官方镜像
# ============================================================
FROM ghcr.io/roadrunner-server/roadrunner:2025.1.6 AS roadrunner

# ============================================================
# 主构建阶段：PHP + RoadRunner
# ============================================================
FROM php:8.3-cli-alpine

# 安装系统依赖
RUN apk add --no-cache \
    postgresql-libs \
    libzip-dev \
    libzip \
    curl \
    unzip \
    git

# 安装 PHP 扩展
RUN docker-php-ext-install \
    pdo \
    pdo_pgsql \
    mbstring \
    intl \
    zip \
    opcache

# 安装 Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 从 RoadRunner 官方镜像复制二进制文件
COPY --from=roadrunner /usr/bin/rr /usr/local/bin/rr

# 设置工作目录
WORKDIR /app

# 默认命令（会被 docker-compose 中的 command 覆盖，或者由 .rr.yaml 决定）
CMD ["rr", "serve", "-d", "-c", ".rr.yaml"]
