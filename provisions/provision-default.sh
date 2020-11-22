#!/usr/bin/env bash

Update () {
    echo "-- Update packages --"
    sudo apt-get update
    sudo apt-get upgrade
}

Update

echo "-- Prepare configuration for MySQL --"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"

echo "-- Install tools and helpers --"
sudo apt-get install -y --force-yes python-software-properties vim htop curl git npm build-essential libssl-dev

echo "-- Install PPA's --"
sudo add-apt-repository ppa:ondrej/php
sudo add-apt-repository ppa:chris-lea/redis-server
Update

echo "-- Install NodeJS --"
curl -sL https://deb.nodesource.com/setup_15.x | sudo -E bash -

echo "-- Install packages --"
sudo apt-get install -y --force-yes apache2 mysql-server-5.7 git-core nodejs rabbitmq-server redis-server
sudo apt-get install -y --force-yes php7.1-common php7.1-dev php7.1-json php7.1-opcache php7.1-cli libapache2-mod-php7.1
sudo apt-get install -y --force-yes php7.1 php7.1-mysql php7.1-fpm php7.1-curl php7.1-gd php7.1-mcrypt php7.1-mbstring
sudo apt-get install -y --force-yes php7.1-bcmath php7.1-zip
Update

echo "-- Creating virtual hosts --"
sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf
rm -rf /var/www/html
ln -fs /vagrant/public /var/www/html

echo "-- Configure PHP &Apache --"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/apache2/php.ini


echo "-- Restart Apache --"
sudo service apache2 restart

echo "-- Install Composer --"
curl -s https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

echo "-- Setup databases --"
mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION; FLUSH PRIVILEGES;"
mysql -uroot -proot -e "CREATE DATABASE my_database";

echo "-- Provionsing Complete --"