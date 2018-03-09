#!/bin/bash
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

sudo setenforce 0

echo "Start Install Apache"
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'

sudo yum -y clean all 
sudo yum -y update
sudo yum -y install centos-release-scl.noarch
sudo yum -y install yum-utils && sudo yum-config-manager --enable remi-php71 
sudo yum -y install php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo php-mbstring php-dom 
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --reload
sudo systemctl start httpd
sudo systemctl enable httpd

echo "Start Install Mysql"
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'

sudo yum -y install mariadb-server mariadb && 
#sudo mysql_secure_installation
sudo systemctl start mariadb.service 
sudo systemctl enable mariadb.service


echo "Start Config Apache"
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'


echo '
<FilesMatch \.php$>	        
	SetHandler application/x-httpd-php	
</FilesMatch>' >> /etc/httpd/conf/httpd.conf
echo 'IncludeOptional conf.d/vhost.conf' >> /etc/httpd/conf/httpd.conf

touch /etc/httpd/conf.d/vhost.conf

echo '
<VirtualHost *:80>
	    ServerName localhost
	    DocumentRoot /var/www/html/public/
</VirtualHost>
<Directory "/var/www/html/public/>
	DirectoryIndex index.html index.php
	AllowOverride All
</Directory>' >> /etc/httpd/conf.d/vhost.conf
 
sudo service httpd restart
echo "Done!"
sleep 1


echo "Install Composer"
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'
sudo yum -y update 
cd /tmp 
sudo curl -sS https://getcomposer.org/installer | php 
mv composer.phar /usr/local/bin/composer 

# echo "Start Config"