# ================================
# Stage 1: Builder
# ================================
FROM php:8.3-fpm AS builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    git curl zip unzip libzip-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Get Composer from its official image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copy only composer files first (smart caching!)
COPY composer.json composer.lock ./

# Install PHP dependencies
RUN composer install \
    --no-dev \
    --no-interaction \
    --optimize-autoloader \
    --no-scripts

# Copy the rest of the app
COPY . .

# ================================
# Stage 2: Release (final image)
# ================================
FROM php:8.3-fpm AS release

# Only runtime dependencies — no build tools
RUN apt-get update && apt-get install -y \
    libzip-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

# Copy ONLY what we need from the builder stage
COPY --from=builder /var/www/html/vendor ./vendor
COPY --from=builder /var/www/html .

# Set correct permissions
RUN chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

EXPOSE 9000
CMD ["php-fpm"]
