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
# 下载并解压指定版本
RUN set -e \
    && ROADRUNNER_VERSION="2025.1.6" \
    && apk add --no-cache tar \
    && curl -fsSL "https://github.com/roadrunner-server/roadrunner/releases/download/v${ROADRUNNER_VERSION}/roadrunner-v${ROADRUNNER_VERSION}-linux-amd64.tar.gz" -o /tmp/rr.tar.gz \
    && tar -xzf /tmp/rr.tar.gz -C /tmp \
    && chmod +x /tmp/rr \
    && mv /tmp/rr /usr/local/bin/rr \
    && /usr/local/bin/rr --version \
    && rm -f /tmp/rr.tar.gz

# 设置工作目录
WORKDIR /app

# 默认命令（会被 docker-compose 中的 command 覆盖，或者由 .rr.yaml 决定）
CMD ["rr", "serve", "-d", "-c", ".rr.yaml"]
