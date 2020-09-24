#!/usr/bin/bash

# A BASH script used to restore my Fedora system

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

## Update system and reinstall software

### Update system
dnf update -y && dnf upgrade -y

### Install repo software 
dnf install zsh git autokey-gtk redshift cmake gcc-c++ make python3-devel python3-SecretStorage python3-crypto python3-cryptography python3-keyring python3-psutil python3-qt5 python3-requests-kerberos speedtest-cli neofetch gimp -y

### Install rpm software

### Enable SNAP store 
dnf install snapd -y
ln -s /var/lib/snapd/snap /snap/

### Install SNAP store software 
snap install google-cloud-sdk --classic

### Install non-repo and non-RPM software 

#### Install Nagstamon
echo "Downloading and installing Nagstamon"
#wget
echo "Nagstamon will still need configured"

#### Install MotionPro
echo "Downloading and installing MotionPro"
cd ~/Downloads
wget https://www.hipaavault.com/ArrayNetworks/MotionPro_Linux_RedHat_x86-64_1.2.3.sh
chmod +x MotionPro_Linux_RedHat_x86-64_1.2.3.sh
bash MotionPro_Linux_RedHat_x86-64_1.2.3.sh
echo "MotionPro will still need configured"

## Clone config repo

### Copy vimrc

### Open vim to trigger installation of plugins 

### Install YouCompleteMe

### Copy ZSHRC file 

## Configure vim wiki and linux academy repo

### Clone vimwiki notes 

#### Create vimwiki directory

#### Copy vimwiki

### Clone linux academy notes repo

#### Copy wikito/wikifrom scripts

#### Add aliases to zshrc

## Restart system for snapd changes to take effect 
