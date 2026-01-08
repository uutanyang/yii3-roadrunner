FROM yiisoftware/yii3-php:8.2-fpm

# 安装必要的扩展
RUN docker-php-ext-install pdo pdo_pgsql pgsql bcmath opcache

# 安装 Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 安装 RoadRunner
RUN curl -LO https://github.com/roadrunner-server/roadrunner/releases/latest/download/roadrunner-linux-amd64 \
    && chmod +x roadrunner-linux-amd64 \
    && mv roadrunner-linux-amd64 /usr/local/bin/rr

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
