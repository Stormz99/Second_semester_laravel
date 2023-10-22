#!/bin/bash
echo -e "\n\nUpdating and upgrading\n"
sudo apt update && sudo apt upgrade -y < /dev/null
sudo apt-get install apache2 -y < /dev/null
sudo apt -get install mysql-server -y < /dev/null
echo -e "\n\nUpdate and upgrade successful\n"

echo -e "\n\nUpdating Apt Packages and upgrading latest patches\n"
sudo apt update -y < /dev/null
sudo apt install -y wget git apache2 curl < dev/null
echo -e "\n\nUpdate done!\n"

echo -e "\n\nInstalling Apache\n"
sudo apt install apache2 -y < /dev/null
echo -e "\n\nApache installed\n"

echo -e "\n\nInstalling PHP\n"
sudo add-apt-repository ppa:ondrej/php < /dev/null
sudo apt update < dev/null
sudo apt-get install libapache2-mod-php php-common php-xml php-mysql php-gd php-mbstring php-tokenizer php-json php-bcmath php-curl php-zip unzip -y
sudo sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/8.2/apache2/php.ini
sudo systemctl restart apache2 < dev/null
echo -e "\n\nPHP successfully installed\n"

echo -e "\n\nInstalling Composer\n"
sudo apt-get update < dev/null
sudo apt install curl -y
curl -sS https://getcomposer.org/installer | php 
sudo mv composer.phar /usr/local/bin/composer
composer --version < /dev/null
echo -e "\n\nComposer successfully ran\n"

echo -e "\n\nApache Configuration\n"
cat << EOF > /etc/apache2/sites-available/laravel.conf
<VirtualHost *:80>
 ServerAdmin ijiolaabiodun7@gmail.com
 ServerName 192.168.20.14            
 DocumentRoot /var/www/html/laravel/public
 
 <Directory /var/www/html/laravel/public>
 Options Indexes Multiviews FollowSymlinks
 AllowOverride All
 Require all granted
 </Directory>
 
 ErrorLog ${APACHE_LOG_DIR}/error.log
 CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

sudo a2enmod rewrite

sudo a2ensite laravel.conf

sudo systemctl restart apache2

echo -e "\n\nInstalling Laravel from Github\n"
mkdir /var/www/html/laravel && cd /var/www/html/laravel
cd /var/www/html/laravel git clone https://github.com/laravel/laravel /var/www/html/laravel
cd /var/www/html/laravel && composer install --no dev < /dev/null
sudo chown -R www-data:www-data /var/www/html/laravel
echo -e "\n\nLaravel successfully installed from Github repo\n"

echo -e "\n\nSetting file permissions\n"
sudo chmod -R 775 /var/www/html/laravel
sudo chmod -R 775 /var/www/html/laravel/storage
sudo chmod -R 775 /var/www/html/laravel/bootstrap/cache

echo -e "\n\nCreating a .env file in Laravel\n"
cd /var/www/html/laravel && cp .env.example .env
php artisan key:generate
echo -e "\n\nThe .env file successfully created\n"

##########################################################################
echo "Creating MYSQL user and database"
pass=$2
if [ -z "$2" ]; then
   PASS=`openssl rand -base64 8`
fi

mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE $1;
CREATE USER '$1'@'localhost' IDENTIFIED BY '$PASS';
GRANT ALL PRIVILEGES ON $1.* TO '$1'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "MYSQL credentials"
echo "Username:  $1"
echo "Database:  $1"
echo "Password:  $PASS"
#######################################################################


#######################################################################
#FOR KEY GENERATE AND MIGRATE COMMAND FOR PHP
#######################################################################
sudo sed -i 's/DB_DATABASE=laravel/DB_DATABASE=ijiola/' /var/www/html/laravel/.env
sudo sed -i 's/DB_USERNAME=root/DB_USERNAME=ijiola/'  /var/www/html/laravel/.env
sudo sed -i 's/DB_PASSWORD=/DB_PASSWORD=ijiola' /var/www/html/laravel/.env

php artisan config:cache

cd /var/www/html/laravel && php artisan migrate



