#!/usr/bin/bash

# A script used to restore a Manjaro system

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

### Update system
echo "Updating system"
pacman -Syu

### Install software
echo "Installing old software"
pacman -Syu vim arandr simplescreenrecorder openshot virtualbox dosbox ppsspp dolphin-emu pcsx2 cmake linux58-virtualbox-host-modules unrar

## Configure Snapd
echo "Configuring Snapd"

### Install snapd and enable it
pacman -Syu snapd
systemctl enable --now snapd.socket
ln -s /var/lib/snapd/snap /snap

###  Install snap software
snap install snapd
snap install mc-installer

## Restore config files 
echo "Restoring the system config files"
cd ~/Documents/gits
git clone https://gitlab.com/ngrogg/configs.git
cd

### Configure vim
echo "Configuring VIM"

#### Copy vimrc
cp ~/Documents/gits/configs/Desktop Configs/vimrc ~/.vimrc

#### Configure plugged
vim 
cd
cd .vim/plugged/YouCompleteMe
python3 install.py --clangd-completer

### Configure zsh
echo "Configuring ZSH" 

#### Create folders for history file
mkdir ~/.zsh
mkdir ~/.zsh/cache/
touch ~/.zsh/cache/history

#### Copy zshrc
cp ~/Documents/gits/configs/Desktop Configs/zshrc ~/.zshrc

## Restart for changes to take effect
reboot
