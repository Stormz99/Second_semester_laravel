Project requirement:
1. Virtualbox 
2. Vagrant

Project explianation:
The Project is orchestrated around creating two Ubuntu virtual machines using Vagrant which are Master and Slave virtual machines which using the LAMP infrastructure (Linux, Apache, mySQL and PHP), installing Laravel, as well as using an Ansible playbook to execute the bash script on the Slave node and verify that the PHP application is accessible through the VM's IP address (a screenshot provided for the Ansible playbook) and also creating a cron job to check the server's uptime every 12 am.

Default configuration on Slave and Master machine:
The Slave and Master machine has a memory of 1024MB and uses 2 C.P.U from the host machine total RAM.

Slave machine information:
1. Slave machine specification: The Slave machine has an host name of "slave" with an image name of "ubuntu/focal64". It uses a private network with a constant internet protocol address (ip address) of '192.168.68'.
2. Slave machine configuration: The slave machine on booting for the first time does a system update and upgrade. This is to allow the system to be at optimal performance. The system also install sshpass which function is to provide password automation for ssh login. The system also install system password authentication from "no" to "yes" which serves as a means of ensuring security to the slave machine in order to checkmate the 'Confidentiality' rule. The slave machine also restarts the systemctl ssh service.

Master machine information:
1. Master machine specification: The Master machine has an host name of "master" with an image name of "ubuntu/focal64". It uses a private network with a constant internet protocol address (ip address) of '192.168.67'.
2. Master machine configuration: The master machine on booting for the first time does a system update and upgrade. This is to allow the system to be at optimal performance. The system also install sshpass which function is to provide password automation for ssh login. The system also install system password authentication from "no" to "yes" which serves as a means of ensuring security to the master machine in order to checkmate the 'Confidentiality' rule. The master machine also restarts the systemctl ssh service.

Installation of LAMP stack on the Master machine:
1. Updating Apt Packages and upgrading latest patches:
```ruby
sudo apt update -y
sudo apt install -y wget git apache2 curl
```
2. Installing Apache:
```ruby
sudo apt install apache2 -y
```
3. Configuring firewall rule (UFW):
```ruby
sudo apt install ufw -y
sudo ufw allow in "Apache"
sudo ufw allow OpenSSH
sudo ufw allow WWW
sudo ufw allow 'WWW Full'
sudo ufw allow 80
sudo ufw allow 22
sudo ufw allow 443
sudo ufw enable
```
4. Installing MySQL
```ruby
sudo apt install mysql-server -y
```

5. Removing Bad habits from MySQL:
```ruby
sudo mysql_secure_installation
```
6. Installing software-properties-common:
```ruby
sudo apt install software-properties-common
```
7. Installing PHP:
```ruby
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install -y php8.2 php8.2-mysql libapache2-mod-php8.2
```
8. Configuring php.ini file using bash scripting. 

9. Restarting Apache server:
```ruby
sudo systemctl restart apache2
```

After installing the required dependencies, a prompt "LAMP Installation Completed" should be displayed. This confirms that a LAMP stack was installed on both the Slave and Master machine. The apache server is going to be restarted after successful installation. 

Installation of Laravel on Master machine:
1. Setting the laravel.config file in the Master machine
2. Installing Composer:
```ruby
curl -sS https://getcomposer.org/installer | php 
sudo mv composer.phar /usr/local/bin/composer
```
3. Installing Laravel from Github: A directory is created called "/var/www/html/laravel" and the directory is entered. Laravel is downloaded from Github to the directory. The following command is ran to successfully carry out the command:
```ruby
sudo chown -R vagrant:vagrant /var/www/html/laravel
cd /var/www/html/laravel && git clone https://github.com/laravel/laravel.git
composer install --no-dev
```
4. Setting Laravel permissions: 
```ruby
sudo chown -R www-data:www-data /var/www/html/laravel
```
5. Setting file permissions:
```ruby
sudo chmod -R 775 /var/www/html/laravel
sudo chmod -R 775 /var/www/html/laravel/storage
sudo chmod -R 775 /var/www/html/laravel/bootstrap/cache
```
6. Creating a .env file in Laravel:
```ruby
cp /var/www/html/laravel/.env.example /var/www/html/laravel/.env
```
7. Generating PHP Artisan key:
```ruby
php /var/www/html/laravel/artisan key:generate
```
8. Setting up MySQL database:
```ruby
mysql -u root -p'ijiola' -e "CREATE DATABASE ijiola_db;"
mysql -u root -p'ijiola' -e "GRANT ALL PRIVILEGES ON ijiola_db.* TO 'abiodun'@'localhost';"
mysql -u root -p'ijiola' -e "FLUSH PRIVILEGES;"
```
using the following database variables
```ruby
DB_DATABASE="ijiola_db"
DB_USERNAME="abiodun"
DB_PASSWORD="ijiola"
```

9. Creating a .env file using bash scripting:

10. Setting configuration of PHP Artisan to cache:
```ruby
/var/www/html/laravel && php artisan config:cache
```
11. Migrating the PHP Artisan database:
```ruby
cd /var/www/html/laravel && php artisan migrate
```
12. Reloading Apache to configure Laravel:
```ruby
sudo a2enmod rewrite
sudo a2ensite laravel.conf
```
13. Installing NGINX load balancer:
```ruby
sudo apt-get install nginx
```
14. Reloading Apache service:
sudo service apache2 restart

The Master machine should now be automated using laravel. This can be accessed using the Master machine I.P address 

Running the project: To run the project, the scripts must be executable. To do this, kindly follow these processes;
1. Open your terminal. This can either be Visual studio code terminal, Terminal (for Mac users), or Gitbash.
2. Make the code executable by using the following command:
```ruby
chmod +x master_slave.sh
chmod +x lamp.sh
chmod +x laravel.sh
```
3. Then input this command:
```ruby
./master_slave.sh
```
4. Wait until everything runs till the end.
<span style="color: red;">NOTE!</span>: Make sure you have a very strong internet connection.

Using Ansible playbook:
1. To execute the bash script on the Slave node and verify that the PHP application is accessible through the VM's IP address  <span style="color: yellow;">192.168.20.15</span>





2. Creating a Cron job to check the server's uptime every 12 A.M
An automated Ansible playbook is created to perform a Cron job to check the server uptime every 12 A.M using ansible built in module <span style="color: red;">ansible.builtin.cron</span>. The playbook having the following information:
1. <span style="color: blue;">Name: Server's uptime every 12 A.M</span>
2. <span style="color: blue;">State: present</span> 
3. <span style="color: blue;">Hour: 12 A.M</span>
4. <span style="color: blue;">Day: Daily</span>
5. <span style="color: blue;">Month: Monthly</span>
6. <span style="color: blue;">Weekday: Everyday</span>
7. <span style="color: blue;">Job: Perform a server uptime every 12 A.M</span>

#Images of the project