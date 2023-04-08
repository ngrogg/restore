#!/usr/bin/bash

# A BASH script to create a Debian LAMP stack
# Must be run as root
# Must be run on a Debian box

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
echo "Creating Debian LAMP stack"
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
#TODO Hide password
passwd $username

### Add user to wheel group
echo "Adding user to wheel admin group"
usermod -aG wheel $username

## Install software
### Make sure system is up to date
apt update -y && apt upgrade -y
apt install ufw apache2 mariadb-server php libapache2-mod-php php-mysql

## Configure firewall
#TODO Why is 'in' erroring out?
ufw allow OpenSSH
ufw enable
ufw allow in "WWW Full"

## Apache
## MariaDB
echo "Configuring MariaDB"
mysql_secure_installation

### Create MariaDB database
#TODO

### Grant priveliges
#TODO

### Flush priveliges
#TODO

## PHP
#TODO
