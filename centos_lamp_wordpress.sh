#!/usr/bin/bash

# A BASH script to set up a LAMP stack, admin user, and basic WordPress install
# Must be run as root
# Must be run on a CentOS box

# TO DO
## Configure yum-cron-hourly
## Configure


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
yum install php-mysqlnd firewalld httpd vim mariadb mariadb-server php mlocate -y

### Install/configure yum-cron
echo "Installing system specific software"
yum install yum-cron -y

### Enable/start yum-cron
systemctl enable yum-cron
systemctl start yum-cron

### Edit yum-cron-hourly.conf
#sed -i 's/update_cmd = security/update_cmd = security/g' /etc/yum/yum-cron-hourly.conf
#sed -i 's/apply_updates = no/apply_updates = yes/g' /etc/yum/yum-cron-hourly.conf

### Configure installed software 
echo "Configuring installed software"

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
### Create sample php webpage
echo "<?php phpinfo(); ?>" >> /var/www/html/phpinfo.php

## WordPress 
### Download WordPress
### Configure WordPress database (wp-config)
### Configure virtualhost
