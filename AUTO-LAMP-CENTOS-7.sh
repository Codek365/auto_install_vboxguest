#!/bin/bash

echo "Start Install Mysql & Httpd"
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'

sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
sudo yum -y update
sudo yum -y install mariadb-server mariadb && 
#sudo mysql_secure_installation
sudo systemctl start mariadb.service 
sudo systemctl enable mariadb.service
sudo yum -y install httpd



echo "Start Install PHP"
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'



sudo yum -y clean all 
sudo rm -rf /var/cache/yum
sudo yum -y update

sudo yum -y install yum-utils && sudo yum-config-manager --enable remi-php71 && \
sudo yum -y install php71w php71w-mcrypt php71w-cli php71w-gd php71w-curl php71w-mysql php71w-ldap php71w-zip php71w-fileinfo php71w-mbstring php71w-xml




sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --reload
sudo systemctl start httpd
sudo systemctl enable httpd
sudo setenforce 0



echo "Start Config Apache"
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'


if [ ! -d /etc/httpd/conf.d/vhost.conf ]; then
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
	<Directory "/var/www/html/public/">
		DirectoryIndex index.html index.php
		AllowOverride All
	</Directory>' >> /etc/httpd/conf.d/vhost.conf
	sudo chmod +x /etc/rc.d/rc.local

	sudo service httpd restart
	echo "Done!"
	sleep 1
fi
sudo setenforce 0

echo "Install Composer"
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'
sudo yum -y update 
sudo yum -y install wget
cd /tmp && \
sudo curl -sS https://getcomposer.org/installer | php 
sudo mv composer.phar /usr/bin/composer && \
sudo chmod +x /usr/bin/composer
# echo "Start Config"