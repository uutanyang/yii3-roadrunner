# 使用 PHP 8.3 CLI (因为 RoadRunner 运行在 CLI 模式下)
FROM php:8.3-cli-alpine

# 安装系统依赖
RUN apk add --no-cache \
    postgresql-libs \
    libzip-dev \
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

# 安装 RoadRunner
# 这里下载最新版，你可以锁定版本号以保证稳定性
RUN curl -sSfL https://github.com/spiral/roadrunner/releases/download/v3.0.0/roadrunner-linux-amd64 -o /usr/local/bin/rr && \
    chmod +x /usr/local/bin/rr

# 设置工作目录
WORKDIR /app

# 默认命令（会被 docker-compose 中的 command 覆盖，或者由 .rr.yaml 决定）
CMD ["rr", "serve", "-d", "-c", ".rr.yaml"]
