# Restore

## Overview
A series of BASH scripts used to restore my various computers. <br>
Feel free to download them and make them your own. <br>

## Scripts 
**centos_lamp.sh**, a first attempt at a BASH script to create a generic LAMP stack on CentOS 8. 
When run as root the script creates an Admin user, enables the EPEL repo, installs Apache, MariaDB, PHP 
and tools used by the system. During execution Services are enabled, and the firewall is configured. 
Finally, the script creates an empty MariaDB database with the name provided by the user. <br>
**debian_lamp.sh***, a first attempt to create a LAMP stack on Debian. <br>
Guide from (here)[https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mariadb-php-lamp-stack-on-debian-10]<br>
**manjaro_restore.sh**, an in progress script used to restore my Manjaro system. <br>
**slackware_restore.sh**, a script to restore my Slackware system <br>
**fedora_restore.sh**, a script to restore my Fedora system <br>
**fedora_restore_non_root.sh**, a mark two version of my Fedora script <br>
**ubuntu_restore.sh**, A version of my Fedora script for Ubuntu <br>
