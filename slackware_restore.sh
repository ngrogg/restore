#!/usr/bin/bash

# A BASH script used to restore my Slackware system

## Update system and reinstall Slackpkg tools

### Install Slackpkg+
cd ~/Downloads/
echo "Installing Slackpkg+"
#wget http://sourceforge.net/projects/slackpkgplus/files/
#wget https://sourceforge.net/projects/slackpkgplus/files/slackpkg%2B-1.7.0-noarch-10mt.txz/download
#installpkg slackpkg

### Install Sbopkg
echo "Downloading sbopkg"
wget https://github.com/sbopkg/sbopkg/releases/download/0.38.1/sbopkg-0.38.1.tar.gz
installpkg sbopkg-0.38.1.tar.gz

### Configure slackpkg+ and sbopkg 

### Reinstall old software 

## Clone config repo

### Configure vim

### Configure zsh
