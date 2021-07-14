#!/usr/bin/bash

# A BASH script to set up a LAMP stack, admin user, and basic WordPress install
# Must be run as root
# Must be run on a CentOS box

## Verification checks
echo "Checking some things first"

### Check if running as root 
if [ "$EUID" -ne 0 ]
	then echo "Please run as root"
	    exit
else
	echo "Script running as root!"
fi

echo "Pre-flight all clear"
echo "Creating LAMP stack"
echo "Press Control + C to quit at any time"

## Linux settings
### Create a non-root user and grant them admin rights
### Get username
echo "Creating non-root user"
echo "Enter a username:"
read username

### Create User with username
echo "This will create username $username"
adduser $username

### Set a user password
echo "Enter a password for $username"
passwd $username

### Add user to wheel group
echo "Adding user to wheel admin group"
usermod -aG wheel $username

### Install software
### Enable extended CentOS repository
echo "Enabling epel-release repo"
yum install epel-release

### Apply updates first 
echo "Updating and upgrading server"
yum update -y && yum upgrade -y

### Install software
echo "Installing LAMP specific software"
yum install php-mysqlnd firewalld httpd vim mariadb mariadb-server php mlocate certbot python-certbot-apache curl wget openssl yum-cron -y

### Enable/start yum-cron
echo "Configuring auto-update"
systemctl enable yum-cron
systemctl start yum-cron

### Edit yum-cron-hourly.conf
sed -i 's/update_cmd = default/update_cmd = security/g' /etc/yum/yum-cron-hourly.conf
sed -i 's/apply_updates = no/apply_updates = yes/g' /etc/yum/yum-cron-hourly.conf

### Enable software to restart on reboot
echo "Enabling software to restart if server reboots"
systemctl enable httpd
systemctl enable mariadb
systemctl enable firewalld

### Activate software 
echo "Starting services"
systemctl start httpd
systemctl start mariadb
systemctl start firewalld

### Update locate command db
echo "Updating locate database"
updatedb

### Configuring firewall
### ports 80, 443, and 3306
echo "Configuring firewall for http, https and MySQL traffic"
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --permanent --add-port=3306/tcp

## Configure MySQL
echo "Configuring MariaDB, please follow the prompts"
mysql_secure_installation

### Create a MySQL database
echo "Please enter the database name you'd like to use"
read databaseName
echo "Please enter the password you used to configure MySQL"
read rootPass
echo "Creating database"
mysql --user=root --password="$rootpass" -e "CREATE DATABASE $databaseName"

## PHP
echo "Outputting PHP information"
php -r 'phpinfo();'

## WordPress + Apache
### Enter site name
echo "Starting WordPress configuration"
echo "Enter name of site 'i.e. domain.com', do NOT add www"
read siteName
mkdir /var/www/$siteName

### Download WordPress + move it into place
echo "Installing WordPress"
wget https://wordpress.org/latest.zip
unzip latest.zip
mv wordpress/* /var/www/$siteName
rm -rf wordpress

### Configure WordPress database (wp-config)
cp /var/www/$siteName/wp-config-sample.php /var/www/$siteName/wp-config.php
echo "Configuring database name"
sed -i 's/database_name_here/$databaseName/g' /var/www/$siteName/wp-config.php

echo "Creating non-root database user"
pass=$(date +%s | sha256sum | base64 | head -c 32 ; echo)
mysql --user=root --password="$rootpass" -e "CREATE USER 'wp_user'@'localhost' IDENTIFIED BY $pass"
mysql --user=root --password="$rootpass" -e "GRANT ALL ON $databaseName.* to 'wp_user@'localhost' IDENTIFIED BY $pass"
mysql --user=root --password="$rootpass" -e "FLUSH PRIVILEGES"

echo "Configuring database user"
sed -i 's/username_here/wp_user/g' /var/www/$siteName/wp-config.php

echo "Configuring database password"
sed -i 's/password_here/$pass/g' /var/www/$siteName/wp-config.php

### Configure virtualhost
echo "Configuring Apache Virtualhost"
cp example.com.conf /etc/httpd/conf.d/"$siteName".conf
sed -i 's/example.com/$siteName/g' /etc/httpd/conf.d/"$siteName".conf

### Provision SSL
echo "Provisioning SSL"
certbot -d $siteName -d www."$siteName"

echo "Added renewal to cron weekly"
echo "#\!$(which bash)" >> /etc/cron.weekly/ssl_renewal.sh
echo "certbot --apache renew" >> /etc/cron.weekly/ssl_renewal.sh
chmod 775 /etc/cron.weekly/ssl_renewal.sh
