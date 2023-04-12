#apt -y install lsb-release apt-transport-https ca-certificates
#wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
#echo “deb https://packages.sury.org/php/ $( lsb_release -sc) main” | tee
/etc/apt/sources.list.d/php.list
#apt-get update
#apt-get install php7.4
#a2dismod php7.3
#a2enmod php7.4
