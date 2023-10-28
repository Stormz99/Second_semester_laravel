Project requirement:
1. Virtualbox 
2. Vagrant
 
LARAVEL
Laravel, often referred to as "The PHP Framework for Web Artisans," is truly a masterpiece in the world of web development. It's not just a framework; it's an elegant and sophisticated symphony of code that simplifies the complexities of building modern web applications.
Laravel brings joy to developers with its clean and expressive syntax, making code both readable and enjoyable to work on. It pampers developers with a plethora of built-in tools and features, from the powerful Eloquent ORM for database interactions to an intuitive Blade templating engine for crafting beautiful views.
This framework excels in crafting elegant and maintainable code, making it a favorite choice for both beginners and seasoned developers. Laravel's community support, along with its extensive documentation, ensures that every challenge is met with a helping hand.

LAMP STACK
Linux (Operating System): In this context, Linux serves as the operating system for your server. It provides the foundation for all other components of the stack to operate. Linux is a robust and stable operating system choice for web servers.

Apache (Web Server): Apache is a widely used open-source web server. It listens for incoming web requests and serves web pages and other content to users' browsers. In the context of Laravel, Apache is responsible for receiving HTTP requests and routing them to the Laravel application for processing.

MySQL (Database): MySQL is a popular open-source relational database management system. It is used to store, retrieve, and manage the application's data. Laravel can communicate with the MySQL database to perform operations like storing user data, content, and more.

PHP (Scripting Language): PHP is a server-side scripting language. Laravel is written in PHP and it runs on the server. PHP is responsible for processing user requests, interacting with the database, and generating dynamic web pages. Laravel leverages PHP to build web applications and manage web routes, controllers, views, and models.

ANSIBLE
Ansible, often described as a "simple, yet powerful" open-source automation tool, is a true game-changer in the world of IT operations and infrastructure management. This elegant and efficient automation platform provides a wide range of capabilities that simplify complex tasks, enhance productivity, and promote consistency across systems and networks.

Project explianation:
The Project is orchestrated around creating two Ubuntu virtual machines using Vagrant which are Master and Slave virtual machines which using the LAMP infrastructure (Linux, Apache, mySQL and PHP), installing Laravel, as well as using an Ansible playbook to execute the bash script on the Slave node and verify that the PHP application is accessible through the VM's IP address (a screenshot provided for the Ansible playbook) and also creating a cron job to check the server's uptime every 12 am.

Default configuration on Slave and Master machine:
The Slave and Master machine has a memory of 1024MB and uses 2 C.P.U from the host machine total RAM.

Create Vagrantfile from the master_slave.sh script:
The script begins by generating a Vagrantfile, which is a configuration file for defining the virtual machine environment. It configures two virtual machines: "master" and "slave."

Slave machine specification:
1. Slave machine configuration: The Slave machine has an host name of "slave" with an image name of "ubuntu/focal64". It uses a private network with a constant internet protocol address (ip address) of '192.168.20.14'.
2. Slave machine configuration: The slave machine on booting for the first time does a system update and upgrade. This is to allow the system to be at optimal performance. The system also install sshpass which function is to provide password automation for ssh login. The system also install system password authentication from "no" to "yes" which serves as a means of ensuring security to the slave machine in order to checkmate the 'Confidentiality' rule. The slave machine also restarts the systemctl ssh service.

Master machine information:
1. Master machine specification: The Master machine has an host name of "master" with an image name of "ubuntu/focal64". It uses a private network with a constant internet protocol address (ip address) of '192.168.20.15'.
2. Master machine configuration: The master machine on booting for the first time does a system update and upgrade. This is to allow the system to be at optimal performance. The system also install sshpass which function is to provide password automation for ssh login. The system also install system password authentication from "no" to "yes" which serves as a means of ensuring security to the master machine in order to checkmate the 'Confidentiality' rule. The master machine also restarts the systemctl ssh service.

Installation of LAMP stack on the Master machine:
1. Updating and upgrading:
```ruby
sudo apt update && sudo apt upgrade -y < /dev/null
sudo apt-get install apache2 -y < /dev/null
sudo apt-get install mysql-server -y < /dev/nullcurl
```
2. Updating Apt Packages and upgrading latest patches:
```ruby
sudo apt update -y < /dev/null
sudo apt install -y wget git apache2 curl < /dev/null
```
3. Installing Apache:
```ruby
sudo apt install apache2 -y < /dev/null
```
4. Installing PHP and removing bad habits:
```ruby
sudo add-apt-repository ppa:ondrej/php -y < /dev/null
sudo apt update -y < /dev/null
sudo apt-get install libapache2-mod-php php-common php-xml php-mysql php-gd php-mbstring php-tokenizer php-json php-bcmath php-curl php-zip unzip -y
sudo sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/8.2/apache2/php.ini
sudo systemctl restart apache2
```

5. Installing PHP:
```ruby
sudo apt-get update -y < /dev/null
sudo apt install curl -y < /dev/null
sudo apt install -y git < /dev/null
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
export COMPOSER_ALLOW_SUPERUSER=1
```

After installing the required dependencies, a prompt "LAMP Installation Completed" should be displayed. This confirms that a LAMP stack was installed on the Master machine. The apache server is going to be restarted after successful installation. 

Installation of Laravel on Master machine:
1. Setting the laravel.config file in the Master machine
2. Installing Composer:
```ruby
sudo apt-get update -y < /dev/null
sudo apt install curl -y < /dev/null
sudo apt install -y git < /dev/null
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
export COMPOSER_ALLOW_SUPERUSER=1
composer --version < /dev/null
```
3. Restarting the laravel.conf file:
```ruby
sudo a2enmod rewrite
sudo a2ensite laravel.conf
sudo systemctl restart apache2
```

4. Installing Laravel from Github: A directory is created called "/var/www/html/laravel" and the directory is entered. Laravel is downloaded from Github to the directory. The following command is ran to successfully carry out the command:
```ruby
rm -rf /var/www/html/laravel
mkdir -p /var/www/html/laravel
git clone https://github.com/laravel/laravel /var/www/html/laravel
cd /var/www/html/laravel && composer install --no-dev < /dev/null
sudo chown -R www-data:www-data /var/www/html/laravelv
```
4. Setting Laravel permissions: 
```ruby
sudo chown -R www-data:www-data /var/www/html/laravel
```
5. Setting file permissions:
```ruby
sudo chmod -R 775 /var/www/html/laravel/storage
sudo chmod -R 775 /var/www/html/laravel/bootstrap/cache
```
6. Creating a .env file in Laravel:
```ruby
cd /var/www/html/laravel && cp .env.example .env
cd /var/www/html/laravel && php artisan key:generate
```
7. Generating PHP Artisan key:
```ruby
php /var/www/html/laravel/artisan key:generate
```
8. Setting up MySQL database:
```
using the following database variables
```ruby
DB_DATABASE="ijiola_db"
DB_USERNAME="abiodun"
DB_PASSWORD="ijiola"
```
9. Updating .env file with MySQL credentials
```ruby
sed -i "s/DB_DATABASE=.*/DB_DATABASE=$DB_NAME/" /var/www/html/laravel/.env
sed -i "s/DB_USERNAME=.*/DB_USERNAME=$DB_USER/" /var/www/html/laravel/.env
sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=$DB_PASS/" /var/www/html/laravel/.env
```
11. Running Laravel migrations:
```ruby
cd /var/www/html/laravel && php artisan migrate
```

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
The image for the master master
![Laravel-image](<Markdown/Screenshot 2023-10-27 at 12.12.59 PM.png>)

The ansible playbook
![ansibile-playbook](https://file%252B.vscode-resource.vscode-cdn.net/Users/mac/Desktop/exam/Markdown/Screenshot%25202023-10-27%2520at%25204.58.05%2520PM.png?version%253D1698451185386)

The image from the master machine
![slave](https://file%252B.vscode-resource.vscode-cdn.net/Users/mac/Desktop/exam/Markdown/Screenshot%25202023-10-27%2520at%25204.57.25%2520PM.png?version%253D1698451258494)