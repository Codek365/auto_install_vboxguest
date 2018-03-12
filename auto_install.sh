#!/bin/bash
echo "Mount cd" 
sleep 5
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'
sudo mount /dev/cdrom /mnt
cd /mnt

echo "Start Install VBoxLinuxAdditions"
sleep 5

sudo yum -y install kernel-devel-$(uname -r) kernel-core-$(uname -r) gcc dkms make bzip2 perl
./VBoxLinuxAdditions.run

echo "Start Mount VMs Folder"

echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'



if [ ! -d /var/www ]; then
    sudo mkdir  /var/www
	sudo mkdir /var/www/html
fi


sudo mount -t vboxsf -o uid=1000,gid=1000 WWW-SHARE /var/www/html

echo "mount -t vboxsf -o uid=1000,gid=1000 WWW-SHARE /var/www/html" >> /etc/rc.local 
sudo chmod +x /etc/rc.d/rc.local

echo "Reboot!"

echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'

sudo reboot
