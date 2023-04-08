# Restore

## Overview
A series of BASH scripts used to restore my various computers. <br>
Feel free to download them and customize them for your own needs. <br>

## Scripts
* **centos_lamp.sh**, A BASH script to create a generic LAMP stack on RPM based distros.
When run as root the script creates an Admin user, enables the EPEL repo, installs Apache, MariaDB, PHP
and tools used by the system. During execution Services are enabled, and the firewall is configured.
Finally, the script creates an empty MariaDB database with the name provided by the user. <br>
PENDING: This script will be refactored for Rocky Linux.
* **debian_lamp.sh***, a BASH script to create a LAMP stack on Deb based distros. <br>
Guide from (here)[https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mariadb-php-lamp-stack-on-debian-10]<br>
* **fedora_restore.sh**, a script to configure a Fedora system based on changes I typically make. <br>
* **ubuntu_restore.sh**, A script to configure an Ubuntu system based on changes I typically make.<br>

## Scrapped
Scripts or files I no longer intend to review or maintain <br>
The following scripts can be considered scrrapped: <br>
* **manjaro_restore.sh**, an in progress script used to restore my Manjaro system. <br>
* **slackware_restore.sh**, a script to restore my Slackware system <br>
* **fedora_restore_non_root.sh**, a mark two version of my Fedora script <br>
