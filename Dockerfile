FROM yiisoftware/yii-php:8.3-fpm-nginx

# 安装必要的扩展
RUN set -e \
    && docker-php-ext-install pdo pdo_pgsql pgsql bcmath opcache \
    && rm -rf /var/lib/apt/lists/*

# 安装 Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 安装 RoadRunner (使用固定版本和 HTTPS)
RUN set -e \
    && ROADRUNNER_VERSION="2023.3.6" \
    && curl -fsSL "https://github.com/roadrunner-server/roadrunner/releases/download/v${ROADRUNNER_VERSION}/roadrunner-linux-amd64" -o /tmp/rr \
    && curl -fsSL "https://github.com/roadrunner-server/roadrunner/releases/download/v${ROADRUNNER_VERSION}/roadrunner-linux-amd64.sha256" -o /tmp/rr.sha256 \
    && cd /tmp \
    && echo "$(cat rr.sha256)  rr" | sha256sum -c - \
    && chmod +x /tmp/rr \
    && mv /tmp/rr /usr/local/bin/rr \
    && /usr/local/bin/rr --version \
    && rm -f /tmp/rr /tmp/rr.sha256

# 设置工作目录
WORKDIR /app

# 复制 composer 文件
COPY composer.json composer.lock* ./

# 安装依赖
RUN composer install --no-scripts --no-autoloader --prefer-dist

# 复制应用代码
COPY . .

# 生成 autoloader
RUN composer dump-autoload --optimize

# 暴露端口
EXPOSE 8080

# 启动 RoadRunner
CMD ["rr", "serve"]
