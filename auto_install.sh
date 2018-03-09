#!/bin/bash
echo "Mount cd" 
sleep 5
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'
mount /dev/cdrom /mnt
cd /mnt

echo "Start Install VBoxLinuxAdditions"
sleep 5

yum -y install kernel-devel-$(uname -r) kernel-core-$(uname -r) gcc dkms make bzip2 perl
./VBoxLinuxAdditions.run
reboot
