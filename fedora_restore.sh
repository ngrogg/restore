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
echo "Restoring work computer"
echo "Press Control + C to quit at any time"

## Update system and reinstall software

### Update system
echo "Updating system"
dnf update -y && dnf upgrade -y

### Install repo software 
echo "Installing libraries"
dnf install liberation-fonts-1:2.1.0-1.fc32.noarch python3 qt5 zsh git autokey-gtk redshift cmake gcc-c++ make python3-devel python3-SecretStorage python3-crypto python3-cryptography python3-keyring python3-psutil python3-qt5 python3-requests-kerberos speedtest-cli neofetch gimp -y

### Install rpm software

#### Download and Install Google Chrome
echo "Downloading and installing Google Chrome"
cd ~/Downloads
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
rpm -Uhv google-chrome-stable_current_x86_64.rpm

#### Download and Install Nagstamon
echo "Downloading and installing Nagstamon"
wget https://nagstamon.ifw-dresden.de/files/stable/nagstamon-3.4.1.fedora32-1.src.rpm
rpm -Uhv nagstamon-3.4.1.fedora32-1.src.rpm
echo "Nagstamon will still need configured"

### Enable SNAP classic
dnf install snapd -y
ln -s /var/lib/snapd/snap /snap/

### Install SNAP store software 
snap install google-cloud-sdk --classic

### Install non-repo and non-RPM software 
#### Install MotionPro
echo "Downloading and installing MotionPro"
cd ~/Downloads
wget https://www.hipaavault.com/ArrayNetworks/MotionPro_Linux_RedHat_x86-64_1.2.3.sh
chmod +x MotionPro_Linux_RedHat_x86-64_1.2.3.sh
bash MotionPro_Linux_RedHat_x86-64_1.2.3.sh
echo "MotionPro will still need configured"

## Clone config repo
cd
cd ~/Documents/
mkdir gits
cd gits
git clone https://gitlab.com/ngrogg/configs.git

### Copy vimrc and zshrc
cd configs 
cp Desktop\ Configs/vimrc ~/.vimrc
cp Desktop\ Configs/zshrc ~/.zshrc

### Configure zsh
cd
mkdir ~/.zsh/
mkdir ~/.zsh/cache
touch ~/.zsh/cache/history
echo "run 'chsh -s $(which zsh)' after script finishes and system reboots"
sleep 5

### Open vim to trigger installation of plugins 
cd
echo "Quit vim after installation finishes"
sleep 5
vim .vimrc

### Install YouCompleteMe
echo "Installing YouCompleteme"
cd .vim/plugged/YouCompleteMe/
python3 install.py --clangd-completer

## Configure vim wiki and linux academy repo

### Clone vimwiki notes and linux academy notes repo
echo "Cloning notes from git repo"
cd ~/Documents/gits
git clone https://github.com/ngrogg360/notes.git

#### Create vimwiki directory
echo "copying notes to vimwiki directory"
cd 
mkdir vimwiki

#### Copy vimwiki
cp ~/Documents/gits/notes/*.wiki ~/vimwiki

#### Copy wikito/wikifrom scripts
echo "Copying scripts to pull from and push to note repo"
echo "Do not run the push script if you are not ngrogg"
mkdir ~/.scripts
cp ~/Documents/gits/la-notes/backupwiki.sh ~/.scripts/wikitogit.sh
cp ~/Documents/gits/la-notes/restorewiki.sh ~/.scripts/wikifromgit.sh

#### Add aliases to zshrc
echo "Adding aliases to zshrc"
echo "alias wikitogit='bash ~/.scripts/backupwiki.sh'" >> ~/.zshrc
echo "alias wikifromgit='bash ~/.scripts/restorewiki.sh'" >> ~/.zshrc

## Reboot system
echo "Rebooting in 10 seconds, don't forget to run 'chsh -s $(which zsh)'"
reboot
