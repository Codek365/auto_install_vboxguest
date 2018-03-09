STEP:
1. You must set share folder on virtual machine:
- Right click on VM -> setting -> share folder -> click new -> done!
-  you should remember the name of share folder, i usualy named it "WWW-SHARE"

2. Start VM and Insert Guest Addition CDs:
- On menu -> device -> Insert Guest Addition CDs

3. login to VM change to root user:
- type command:
$ mount /dev/cdrom /mnt
$ cd /mnt
$ yum -y install kernel-devel-$(uname -r) kernel-core-$(uname -r) gcc dkms make bzip2 perl
$ ./VBoxLinuxAdditions.run
$ reboot

4. Now we mount the VM Share Folder (Folder on Windows) with VM Folder (on Linux)
- run command:
$ sudo mount -t vboxsf -o uid=1000,gid=1000 WWW-SHARE /var/www/html
$ sudo su
$ echo "mount -t vboxsf -o uid=1000,gid=1000 WWW-SHARE /var/www/html" >> /etc/rc.local 
$ sudo chmod +x /etc/rc.d/rc.local

# WWW-SHARE -> VM Share Folder (Folder on Windows)
# /var/www/html -> VM Folder (on Linux) 
# run command: $ man mount 
# understand more about mount command

5. Install LAMP of LEMP
- Install Apache2.4 run command: 

- Install Mariadb: 
$ sudo yum -y install mariadb-server mariadb && \
sudo mysql_secure_installation && \
sudo systemctl start mariadb.service && \
sudo systemctl enable mariadb.service

- Install php 7:
$ sudo yum clean all && \
sudo yum -y update && \
sudo yum -y install centos-release-scl.noarch && \
sudo yum -y install yum-utils && \
sudo yum-config-manager --enable remi-php71 && \
sudo yum -y install php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo php-mbstring php-dom  && \
sudo firewall-cmd --permanent --add-port=80/tcp && \
sudo firewall-cmd --permanent --add-port=443/tcp && \
sudo firewall-cmd --reload && \
sudo systemctl start httpd && \
sudo systemctl enable httpd

 
$ sudo vi /etc/httpd/conf/httpd.conf

- add first line:

	<FilesMatch \.php$>
	        SetHandler application/x-httpd-php
	</FilesMatch>



- save end exit

- Install Composer:

$ sudo yum -y update && \
 cd /tmp && \
 sudo curl -sS https://getcomposer.org/installer | php && \
 mv composer.phar /usr/local/bin/composer 


6. Setup apache:
-  Enable permision for public access from IP
$ sudo setenforce 0

$ sudo vi /etc/conf/httpd.conf

- search: IncludeOptional conf.d/*.conf 
- change to: IncludeOptional conf.d/vhost.conf 

$ sudo vi /etc/conf.d/vhost.conf

- add: 
	<VirtualHost *:80>
	    ServerName localhost
	    DocumentRoot /var/www/html/public/
	</VirtualHost>
	# please shipt it safe because the php won't run if you remove it from vhost.conf
	<Directory "/var/www/html/public/>
	    DirectoryIndex index.html index.php
	    AllowOverride All
	</Directory>

