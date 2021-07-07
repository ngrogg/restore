#!/usr/bin/bash

# A BASH script based on my Fedora script
# Similar to Fedora script, but designed for DEB based distros
# TODO
# Change packages names as needed from initial install

## Enter username to configure
### Assign output from bash command to variable
username=$(whoami)
echo "Some configurations are user specific" 
echo "Configuring for user $username"
echo "Ensure this user has sudo access"

### Check for username, confirm if user to use 
echo "Do you want to configure for this user? y/n"
read confirm

if [ "$confirm" == "y" || "$confirm" == "Y" ]; then
	echo "Continue"
else
	echo "Exiting"
	echo "Re-run as user to configure"
	exit
fi

## Update system and reinstall software
echo "Preparing to install Chrome, MotionPro, Nagstamon, Autokey and more"
echo "Do you want to install software? y/n"
read confirm

if [ "$confirm" == "y" || "$confirm" == "Y" ]; then
echo "Installing software"

### Update system
echo "Updating system"
sudo apt update -y && sudo apt upgrade -y

### Install repo software 
#### TODO, add correct file names
echo "Installing essential software"
sudo apt install nagstamon liberation-fonts python3 qt5 zsh git autokey-gtk redshift cmake build-essential make python-dev speedtest-cli neofetch gimp -y

### Install rpm software

#### Download and Install Google Chrome
cd /home/$username/Downloads
echo "Downloading and installing Google Chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

echo "Nagstamon installed earlier"
echo "Nagstamon will still need configured"
sleep 5

### Enable SNAP classic
echo "Installing snap store"
sudo apt install snapd -y
sudo ln -s /var/lib/snapd/snap /snap/

### Install SNAP store software 
echo "Google Cloud SDK"
sudo snap install google-cloud-sdk --classic

### Install non-repo and non-RPM software 
#### Install MotionPro
echo "Downloading and installing MotionPro"
cd /home/$username/Downloads
#### UPDATE URL AND FILENAME ####
wget https://www.hipaavault.com/ArrayNetworks/MotionPro_Linux_Ubuntu_x64_v1.2.7_0608.sh
chmod +x MotionPro_Linux_Ubuntu_x64_v1.2.7_0608.sh
sudo bash MotionPro_Linux_Ubuntu_x64_v1.2.7_0608.sh
echo "MotionPro will still need configured"
echo "Autokey will still need to be configured"
echo "redshift will still need to be configured"

#### If user doesn't want to install software
else
echo "Skipping"
echo "This is not recommended..."
fi


## Clone config repo
echo "Preparing to clone notes, vim configurations and zsh configurations"
echo "Do you want the configurations? y/n"
read confirm

if [ "$confirm" == "y" || "$confirm" == "Y" ]; then
echo "Cloning config repo"
cd /home/$username/Documents/
mkdir gits
cd gits
git clone https://gitlab.com/ngrogg/configs.git

### Copy vimrc and zshrc
echo "Copying vimrc and zshrc config files"
cd configs 
cp Desktop\ Configs/vimrc /home/$username/.vimrc
cp Desktop\ Configs/zshrc /home/$username/.zshrc

else
echo "Initial configuration complete, reboot system to finish configuration"
sleep 5
exit
fi

### Configure zsh
echo "Preparing to configure zsh"
echo "Do you want ZSH installed? y/n"
read confirm

#### Copy config files and edit passwd
if [ "$confirm" == "y" || "$confirm" == "Y" ]; then
zshYes="yes"
echo "Configuring zsh"
echo "Use tab for fuzzy autocomplete"
sleep 5
cd /home/$username
mkdir /home/$username/.zsh/
mkdir /home/$username/.zsh/cache
touch /home/$username/.zsh/cache/history
sed -i "s/\/home\/$username\:\/usr\/bin\/bash/\/home\/$username\:\/usr\/bin\/zsh/g" /etc/passwd

#### Add aliases to zshrc
echo "Adding aliases to zshrc"
if [ "$username" == "ngrogg" ]; then
echo "alias wikitogit='bash ~/.scripts/wikitogit.sh'" >> /home/$username/.zshrc
echo "alias wikifromgit='bash ~/.scripts/wikifromgit.sh'" >> /home/$username/.zshrc
else
echo "alias wikifromgit='bash ~/.scripts/wikifromgit.sh'" >> /home/$username/.zshrc
fi

#### If user doesn't want ZSH
else
echo "Skipping ZSH configuration"
zshYes="no"
fi


### Open vim to trigger installation of plugins 
echo "Preparing to configure vim"
echo "Do you want vim configured? y/n"
read confirm

if [ "$confirm" == "y" || "$confirm" == "Y" ]; then
echo "Configuring Vim"
cd /home/$username
echo "This should install the plugins for vim"
echo "Quit vim after installation finishes"
sleep 5
vim .vimrc

### Install YouCompleteMe
#### Review that section
echo "Installing YouCompleteMe"
cd .vim/plugged/YouCompleteMe/
python3 install.py --clangd-completer

else
echo "Skipping vim configurations"
fi

## Configure vim wiki
echo "Preparing to clone note repo"
echo "Do you want the vimwiki note repo? y/n"
read confirm

if [ "$confirm" == "y" || "$confirm" == "Y" ]; then
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

#### If user didn't take zsh, add alias to bashrc
if [ "$zshYes" == "no" ]; then
echo "Adding alias wikifromgit to update vimwiki from git repo to bashrc"
echo "alias wikifromgit='bash ~/.scripts/wikifromgit.sh'" >> /home/$username/.bashrc
fi

#### If user doesn't want vimwiki configured
else
echo "Skipping vimwiki configuration"
fi

## Prompt for reboot
echo "Initial configuration complete, system needs to be rebooted to finish configuration"
echo "Would you like to reboot? y/n"
read confirm

if [ "$confirm" == "y" || "$confirm" == "Y" ]; then
	sudo reboot
else
	echo "Please reboot when able"
fi
