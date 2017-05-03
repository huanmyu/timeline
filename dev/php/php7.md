//安装PHP7.0
sudo add-apt-repository ppa:ondrej/php
update-alternatives --set php /usr/bin/php7.0

//安装Apache2
sudo add-apt-repository ppa:ondrej/apache2
sudo apt install apache2
sudo a2enmod php7.0
sudo a2enmod proxy_fcgi setenvif
sudo a2enconf php7.0-fpm
sudo a2enmod rewrite
sudo service apache2 restart

#安装Mysql
sudo apt install php7.0-mysql
