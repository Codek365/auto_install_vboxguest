#### ENV LIST:
- Centos version: CentOS Linux release 7.4.1708 (Core)
- Apachce version: Apache/2.4.6 (CentOS) | 
- Php version: PHP 7.1.14  (Package php71w)
- Larvarel version: 5.3
- Virtual box version: 5.1.24r117012
- List of plug-in of PHP and apache in centos ( if possible): 
	+ php-mcrypt
	+ php-cli
	+ php-gd
	+ php-curl
	+ php-mysql
	+ php-ldap
	+ php-zip
	+ php-fileinfo
	+ php-mbstring
- Database: mariadb-server mariadb

#### Setup ENV AUTO

Access to server (CentOS):

```bash
git clone https://bitbucket.org/ibs_khoa_nguyen/auto_install_vboxguest.git
cd auto_install_vboxguest
sudo sh auto_install.sh
```

After server reboot, access to server again:

```bash
cd auto_install_vboxguest
    sudo sh AUTO-LAMP-CENTOS-7.sh
```

#### 1. You must set share folder on virtual machine:

- Right click on VM -> setting -> share folder -> click new -> done!
-  you should remember the name of share folder, i usualy named it "WWW-SHARE"

#### 2. Start VM and Insert Guest Addition CDs:

- On menu -> device -> Insert Guest Addition CDs or Right click on VM -> setting -> stograte -> controller IDE -> choose image VBoxGuestAdditions.iso

#### 3. login to VM change to root user:

- type command:
```bash
mount /dev/cdrom /mnt
cd /mnt
yum -y install kernel-devel-$(uname -r) kernel-core-$(uname -r) gcc dkms make bzip2 perl
./VBoxLinuxAdditions.run
```

#### 4. Now we mount the VM Share Folder (Folder on Windows) with VM Folder (on Linux):

- run command:
```bash
sudo mkdir /var/www
sudo mkdir /var/www/html
sudo mount -t vboxsf -o uid=1000,gid=1000 WWW-SHARE /var/www/html
sudo su
echo "mount -t vboxsf -o uid=1000,gid=1000 WWW-SHARE /var/www/html" >> /etc/rc.local
sudo chmod +x /etc/rc.d/rc.local
sudo reboot
```
 - ***WWW-SHARE*** -> VM Share Folder (Folder on Windows)
 - ***/var/www/html*** -> VM Folder (on Linux)
 - run command: ` man mount`

 - Read more about mount command

#### 5. Install LAMP of LEMP

- Install Mariadb & Httpd:

```bash
sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
sudo yum -y update
sudo yum -y install mariadb-server mariadb && 
sudo systemctl start mariadb.service 
sudo systemctl enable mariadb.service
sudo yum -y install httpd
```
- If you want to custom mariadb:

```bash
sudo mysql_secure_installation
```
- Install php 7:

```bash
sudo yum -y clean all
sudo rm -rf /var/cache/yum
sudo yum -y update
sudo yum -y install yum-utils && sudo yum-config-manager --enable remi-php71
sudo yum -y install php71w php71w-mcrypt php71w-cli php71w-gd php71w-curl php71w-mysql php71w-ldap php71w-zip php71w-fileinfo php71w-mbstring php71w-xml
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --reload
sudo systemctl start httpd
sudo systemctl enable httpd
sudo setenforce 0
```

- Edit config httpd file:

```bash
sudo vi /etc/httpd/conf/httpd.conf
```

- add first line:
```bash
<FilesMatch \.php$>
        SetHandler application/x-httpd-php
</FilesMatch>
```

- save end exit

#### 6. Setup apache:

-  Enable permision for public access from IP:

```bash
sudo setenforce 0
sudo vi /etc/conf/httpd.conf
```

- search: IncludeOptional conf.d/*.conf 
- change to: IncludeOptional conf.d/vhost.conf

```bash
sudo vi /etc/conf.d/vhost.conf
```
- add:

```bash
<VirtualHost *:80>
    ServerName localhost
    DocumentRoot /var/www/html/public/
</VirtualHost>
<Directory "/var/www/html/public/">
    DirectoryIndex index.html index.php
    AllowOverride All
</Directory>
```
- Install Composer:

```bash
sudo yum -y update
cd /tmp
sudo curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
```
