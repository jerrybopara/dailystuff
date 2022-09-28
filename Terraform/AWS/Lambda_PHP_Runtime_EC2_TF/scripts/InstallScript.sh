#!/bin/bash

# Set HostName
sudo yum update -y && sudo yum install autoconf bison gcc gcc-c++ libcurl-devel libxml2-devel -y

## Downloading AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

sudo yum group install 'Development Tools' -y 
sudo yum install perl-core zlib-devel -y
sudo yum install libxml2-devel openssl-devel sqlite-devel curl-devel libpng-devel libwebp-devel libjpeg-devel freetype-devel -y
sudo yum install libzip-devel -y
sudo yum install autoconf bison gcc gcc-c++ libcurl-devel libxml2-devel -y

## OpenSSL
curl -sL http://www.openssl.org/source/openssl-1.0.1k.tar.gz | tar -xvz
cd openssl-1.0.1k
sudo ./config && make && sudo make install

## PHP Installation 
mkdir -p ~/environment/php-7-bin

# Changing Ownership 
sudo chown -R ec2-user:ec2-user /home/ec2-user/environment

curl -sL https://github.com/php/php-src/archive/php-7.3.0.tar.gz | tar -xvz
cd php-src-php-7.3.0
sudo ./buildconf --force
sudo ./configure --prefix=/home/ec2-user/environment/php-7-bin/ --with-openssl=/usr/local/ssl --with-curl --with-zlib --with-openssl --with-freetype --enable-mbstring --with-mysqli --with-pdo-mysql
sudo make && sudo make install

# Changing Ownership 
sudo chown -R ec2-user:ec2-user /home/ec2-user/environment

# Bootstrap - 
cd /home/ec2-user/environment/php-7-bin/
wget https://raw.githubusercontent.com/aws-samples/php-examples-for-aws-lambda/master/0.1-SimplePhpFunction/bootstrap
chmod +x bootstrap

# Composer install 
curl -sS https://getcomposer.org/installer | /home/ec2-user/environment/php-7-bin/bin/php -- --filename=composer.phar
chmod a+x composer.phar
/home/ec2-user/environment/php-7-bin/bin/php composer.phar require guzzlehttp/guzzle 
/home/ec2-user/environment/php-7-bin/bin/php composer.phar require "swiftmailer/swiftmailer:^6.0" 
/home/ec2-user/environment/php-7-bin/bin/php composer.phar require aws/aws-sdk-php
/home/ec2-user/environment/php-7-bin/bin/php composer.phar require phpzip/phpzip

# Finall making runtime & vendor zips for AWS Lambda. 
zip -r runtime.zip lib bin bootstrap
zip -r vendor.zip vendor/