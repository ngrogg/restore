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

### Install software 

### Enable SNAP store 

### Install SNAP store software 

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
