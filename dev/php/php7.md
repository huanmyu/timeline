//安装PHP7.0
sudo add-apt-repository ppa:ondrej/php
update-alternatives --set php /usr/bin/php7.0

//安装Apache2
sudo add-apt-repository ppa:ondrej/apache2
sudo apt install apache2
sudo a2enmod php7.0
sudo service apache2 restart
