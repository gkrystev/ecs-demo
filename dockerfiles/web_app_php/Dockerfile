FROM php:7.2-apache

# Update and install all reuired PHP extesions
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pcntl 
RUN docker-php-ext-install sockets
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

RUN apt-get update && \
    apt-get -y install git libz-dev libtidy-dev && \
    docker-php-ext-install tidy && \
    docker-php-ext-install zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# PHP Configuration required for PHP SDK
RUN touch /usr/local/etc/php/conf.d/memory.ini \
    && echo "memory_limit = 1024M;" >> /usr/local/etc/php/conf.d/memory.ini

RUN touch /usr/local/etc/php/conf.d/phar.ini \
    && echo "phar.readonly = Off;" >> /usr/local/etc/php/conf.d/phar.ini

RUN echo "xdebug.mode = coverage;" >> /usr/local/etc/php/php.ini
RUN echo "include_path = .:/usr/local/lib/php:/aws-sdk-php;" >> /usr/local/etc/php/php.ini

RUN cd / && \
    git clone https://github.com/aws/aws-sdk-php.git

RUN cd /aws-sdk-php && \
    composer install && \
    make build  

# Copy custom MySQL file, required for enable-cleartext-plugin (IAM Auth)
COPY etc/my.cnf /etc/my.cnf

# Copy latest AWS certificate bundle, flow SSL connection to the database
ADD https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem /etc/ssl/certs/aws-global-bundle.pem
RUN chmod a+r /etc/ssl/certs/aws-global-bundle.pem

# Copy website PHP files
COPY src/ /var/www/html/

