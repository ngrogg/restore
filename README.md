# Restore

## Overview
A series of BASH scripts used to restore my various computers. <br>
Feel free to download them and make them your own. <br>

## Scripts 
**generic_LAMP.sh**, a first attempt at a BASH script to create a generic LAMP stack on CentOS 8. 
When run as root the script creates an Admin user, enables the EPEL repo, installs Apache, MariaDB, PHP 
and tools used by the system. During execution Services are enabled, and the firewall is configured. 
Finally, the script creates an empty MariaDB database with the name provided by the user. 