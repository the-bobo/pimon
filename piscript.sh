#!/bin/bash
# installs monitor mode etc
# on Raspberry Pi 3 Model B
# also installs BriarIDS
# also installs brcmfmac driver

# make sure you setup internet
# first

### best to do this headless, 
### RAM is a luxury
# ctrl+alt+f1 kills x
# if that doesn't work
# open a terminal and type
# pkill x
# then log back in (pi/raspberry)
# and do ctrl+alt+f1

# broken wireless usb keyboard
# after apt-get dist-upgrade
# might be fixed by
# dropping template xorg.conf
# to /etc/X11
# /usr/share/doc/xserver-xorg-video-intel/xorg.conf
# this lets you continue to use the -intel driver

####
# warning
####
echo "You should already have internet setup and be running headless (no desktop)"
read -p "Are you sure you want to proceed? [Y/n]" choice
case "$choice" in 
	y|Y ) echo "yes" && choice="y";;
	n|N ) echo "no" && choice="n";;
esac

if [ "$choice"!="y" ]
then
	echo "No detected, exiting"
	exit 1
fi

####
# setup
####

# sudo rpi-update
# updated to rpi-4.9.y for me
# we should not do this, is bleeding edge
# sudo apt-get install -reinstall raspberrypi-bootloader
# and a reboot will revert to stable kernel

echo "entering setup"

if [ ! -a bootflag.txt ]
then
	echo '0' > bootflag.txt
fi

sudo apt-get update
sudo apt-get dist-upgrade -y
# should take about 15-20min
# should reboot after this
# to load updated kernel

while IFS='' read -r line || [[ -n "$line" ]]; do
	if [ "$line" == "0" ]
	then
		echo "1" > bootflag.txt
		sudo reboot
	fi
done

sudo apt-get install pciutils -y
# gives us lspci command
# e.g. lspci -nn

sudo apt-get install hwinfo -y
# gives us hwinfo command

sudo apt-get install lshw -y
# gives us lshw command
# e.g. lshw -C network

sudo apt-get install tcpdump -y

sudo apt-get install aircrack-ng -y
# to get airodump-ng (alt to tcpdump)

####
# manual backups
####

$backupdir = "./brcm-backups/"

if [ ! -d $backupdir ]
then
	mkdir ./brcm-backups
	sudo cp -a /lib/firmware/brcm/. ./brcm-backups/
	echo "backup directory made"
fi

if [ -d $backupdir ]
then
	echo "backup directory already exists"
	echo "not overwriting"
fi

####
# nexmon
####

sudo apt install raspberrypi-kernel-headers git libgmp3-dev gawk
# git and gawk already installed 
# on my machine by this point
# apt install should just no-op them

git clone https://github.com/seemoo-lab/nexmon.git

cd nexmon

source setup_env.sh

make

cd patches/bcm43438/7_45_41_26/nexmon/

make

make backup-firmware

make install-firmware

cd utilities/nexutil/

make && make install

# apt-get remove wpasupplicant
# this step is optional
# may break things

echo "run nexutil to see commands"
