#!/usr/bin/bash

# A BASH script used to restore my Slackware system
# This script is designed to run on Slackware 14.2 

## Check if running as root
if [ "$EUID" -ne 0 ]
	then echo "Please run as root"
	    exit
else
	echo "Script running as root!"
fi

echo "Pre-flight all clear"
echo "Creating LAMP stack"
echo "Press Control + C to quit at any time"

## Reinstall old software 

## Configure Slackpkg mirror

## Update system and reinstall Slackpkg tools
slackpkg update gpg
slackpkg update; slackpkg install-new; slackpkg upgrade-all

### Install Slackpkg+
cd ~/Downloads/
echo "Installing Slackpkg+"
wget https://pilotfiber.dl.sourceforge.net/project/slackpkgplus/slackpkg%2B-1.7.0-noarch-10mt.txz
installpkg slackpkg+-1.7.0-noarch-10mt.txz

### Install Sbopkg
echo "Downloading sbopkg"
wget https://github.com/sbopkg/sbopkg/releases/download/0.38.1/sbopkg-0.38.1.tar.gz
installpkg sbopkg-0.38.1.tar.gz

### Configure slackpkg+ and sbopkg 

### Reinstall old software 

## Clone config repo

### Configure vim

### Configure zsh
