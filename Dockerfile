# Set Base Image PHP Version FPM
FROM php:8.2-fpm

# Install Php Dependecies
# Update package lists
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo_mysql mysqli zip opcache

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set PHP ini settings
RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memory-limit.ini

# Set timezone
RUN ln -snf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime && echo "Asia/Jakarta" > /etc/timezone


# Install Nginx In Php Docker Images
RUN apt-get update && apt-get install -y nginx

# Set Nginx Default Configuration (Don't Change This Config)
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
RUN cp /etc/nginx/sites-available/default /etc/nginx/conf.d/default.conf

# Restart Configuration Nginx
RUN service nginx restart

# Export Port 80 Nginx Http
EXPOSE 80

# Start nginx and php-fpm Service
ENTRYPOINT service nginx start && php-fpm