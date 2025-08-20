#Utiliser une image php officielle avec Apache
FROM php:8.2-apache

#Installer les dépendances et bibliothèques
RUN apt-get update && apt-get install -y && apt-get install -y --no-install-recommandeds \
    libzip-dev \
    unzip \
    && docker-php-ext-install pdo pdo-mysql zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

#Activer le mod_rewrite d'apache pour les URLs
RUN a2enmod mod_rewrite

#Installer Composer
COPY --from=composer:latest /user/bin/composer /usr/bin/composer

#Définir le répertoir de travail
WORKDIR /var/www/html

#Copier les fichiers de dépendances et les installer
COPY composer.json composer.lock ./
RUN composer install --no-interaction --no-plugins --no-scripts --prefer-dist

#Copier les reste du code de l'appli
COPY . .

#Executer le dump de l'autoloader de composer (performances)
RUN composer dump-autoloader --optimize

#Changer propriétaire des fichiers afin de donner le droit au serveur d'écrire dans les fichiers (Ex: logs)
RUN mkdir -p storage/logs && \
    chown -R www-data:www-data /var/www/html/storage