# Set Base Image PHP Version FPM
FROM php:8.1-fpm

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
CMD service nginx start && php-fpm