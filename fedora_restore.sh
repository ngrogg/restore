#!/usr/bin/bash

# A BASH script used to restore my Fedora system
## TODO
# Resolve section issues
# Resolve permission issues
## zsh
## vim 
## vimwiki
## gits

## Check if running as root
if [ "$EUID" -ne 0 ]
	then echo "Please run as root"
	    exit
else
	echo "Script running as root!"
	echo "This is good!"
fi

echo "Pre-flight all clear"
echo "Creating LAMP stack"
echo "Press Control + C to quit at any time"

## Enter username to configure
echo "Some configurations are user specific" 
echo "Enter a username to configure:"
read username

## Update system and reinstall software
### Update system
echo "Updating system"
dnf update -y && dnf upgrade -y

### Install repo software 
echo "Installing essential software"
dnf install liberation-fonts-1:2.1.0-1.fc32.noarch python3 qt5 zsh git autokey-gtk redshift cmake gcc-c++ make python3-devel python3-SecretStorage python3-crypto python3-cryptography python3-keyring python3-psutil python3-qt5 python3-requests-kerberos speedtest-cli neofetch gimp -y

### Install rpm software

#### Download and Install Google Chrome
cd /home/$username/Downloads
echo "Downloading and installing Google Chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
rpm -Uhv google-chrome-stable_current_x86_64.rpm

#### Download and Install Nagstamon
echo "Downloading and installing Nagstamon"
wget https://nagstamon.ifw-dresden.de/files/stable/nagstamon-3.4.1.fedora32-1.src.rpm
rpm -Uhv nagstamon-3.4.1.fedora32-1.src.rpm
echo "Nagstamon will still need configured"

### Enable SNAP classic
echo "Installing snap store"
dnf install snapd -y
ln -s /var/lib/snapd/snap /snap/

### Install SNAP store software 
echo "Google Cloud SDK"
snap install google-cloud-sdk --classic

### Install non-repo and non-RPM software 
#### Install MotionPro
echo "Downloading and installing MotionPro"
cd /home/$username/Downloads
wget https://www.hipaavault.com/ArrayNetworks/MotionPro_Linux_RedHat_x86-64_1.2.3.sh
chmod +x MotionPro_Linux_RedHat_x86-64_1.2.3.sh
bash MotionPro_Linux_RedHat_x86-64_1.2.3.sh
echo "MotionPro will still need configured"

## Clone config repo
### Permissions
echo "Cloning config repo"
cd /home/$username/Documents/
mkdir gits
cd gits
git clone https://gitlab.com/ngrogg/configs.git

### Copy vimrc and zshrc
echo "Copying vimrc and zshrc"
cd configs 
cp Desktop\ Configs/vimrc /home/$username/.vimrc
cp Desktop\ Configs/zshrc /home/$username/.zshrc

### Configure zsh
#### Review this section
echo "Configuring zsh"
echo "Use tab for fuzzy autocomplete"
sleep 5
cd /home/$username
mkdir /home/$username/.zsh/
mkdir /home/$username/.zsh/cache
touch /home/$username/.zsh/cache/history
sed -i "s/\/home\/$username\:\/usr\/bin\/bash/\/home\/$username\:\/usr\/bin\/zsh/g" /etc/passwd

### Open vim to trigger installation of plugins 
#### Review that section
cd /home/$username
echo "Quit vim after installation finishes"
sleep 5
vim .vimrc

### Install YouCompleteMe
#### Review that section
echo "Installing YouCompleteMe"
cd .vim/plugged/YouCompleteMe/
python3 install.py --clangd-completer

## Configure vim wiki and linux academy repo

### Clone vimwiki notes repo
#### Permissions
echo "Cloning notes from git repo"
cd /home/$username/Documents/gits
git clone https://github.com/ngrogg360/notes.git

#### Create vimwiki directory
cd /home/$username
mkdir vimwiki

#### Copy vimwiki
echo "Copying vimwiki"
echo "Access vimwiki by opening vi and pressing \ w w"
sleep 5
cp /home/$username/Documents/gits/notes/*.wiki ~/vimwiki

#### Copy wikito/wikifrom scripts
echo "Copying scripts from configs"
mkdir /home/$username/.scripts
if [ "$username" == "ngrogg" ]; then
	cp /home/$username/Documents/gits/notes/backupwiki.sh /home/$username/.scripts/wikitogit.sh
	cp /home/$username/Documents/gits/notes/restorewiki.sh /home/$username/.scripts/wikifromgit.sh
else
	cp /home/$username/Documents/gits/notes/restorewiki.sh /home/$username/.scripts/wikifromgit.sh
fi

#### Add aliases to zshrc
echo "Adding aliases to zshrc"
if [ "$username" == "ngrogg" ]; then
	echo "alias wikitogit='bash ~/.scripts/wikitogit.sh'" >> /home/$username/.zshrc
	echo "alias wikifromgit='bash ~/.scripts/wikifromgit.sh'" >> /home/$username/.zshrc
else
	echo "alias wikifromgit='bash ~/.scripts/wikifromgit.sh'" >> /home/$username/.zshrc
fi

## Reboot system
echo "Intial configuration complete, system will reboot in 5 seconds"
sleep 5
reboot
