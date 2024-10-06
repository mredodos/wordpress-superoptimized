# Dockerfile for WordPress-SuperOptimized with Nginx + Varnish, PHP 8.2
# Redis is not included, it will be managed as an external service

# Base image for WordPress with PHP 8.2
FROM wordpress:6.6.2-php8.2-fpm

# Install dependencies and tools
RUN apt-get update && apt-get install -y \
    nginx \
    varnish \
    curl \
    wget \
    git \
    unzip \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libzip-dev \
    zstd \
    lz4 \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd zip pdo pdo_mysql opcache \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && pecl install igbinary msgpack \
    && docker-php-ext-enable igbinary msgpack \
    && rm -rf /var/lib/apt/lists/*

# Install Relay PHP extension for Redis (alternative to phpredis, more performant)
RUN curl -fsSL https://builds.r2.relay.so/v0.6.3/relay-v0.6.3-php8.2-debian-x86-64.tar.gz | tar xvz -C /tmp \
    && mv /tmp/relay-v0.6.3-php8.2-debian-x86-64/relay-pkg.so $(php-config --extension-dir)/relay.so \
    && sed -i "s/00000000-0000-0000-0000-000000000000/$(cat /proc/sys/kernel/random/uuid)/" $(php-config --extension-dir)/relay.so \
    && docker-php-ext-enable relay \
    && cp /tmp/relay-v0.6.3-php8.2-debian-x86-64/relay.ini /usr/local/etc/php/conf.d/

# Set up Nginx
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

# Set up Varnish
COPY ./varnish/default.vcl /etc/varnish/default.vcl

# Set up persistent volumes
VOLUME ["/var/www/html", "/var/www/html/wp-content/plugins", "/var/www/html/wp-content/themes"]

# Copy optimized php.ini configuration
COPY ./config/php.ini /usr/local/etc/php/php.ini

# Copy start script and set permissions
COPY ./scripts/start.sh /start.sh
RUN chmod +x /start.sh

# Create a non-root user
RUN useradd -ms /bin/bash wordpressuser
USER wordpressuser

# Start services
CMD ["/start.sh"]
