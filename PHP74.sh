#!/bin/bash
#Instal.lació paquet PHP
if [ $(dpkg-query -W -f='${Status}' 'php' | grep -c "ok installed") -eq 0 ];then
# Si no trobem PHP, avisem que no està instal·lat
        echo "PHP no està instal·lat." >>/script/registre.txt
        echo "PHP no està instal·lat."
        apt-get -y install php >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "PHP instal·lat correctament." >>/script/registre.txt
                echo -e "${VERDE}PHP instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}PHP no s'ha instal·lat.${NORMAL}" >>/script/registre.txt
                echo -e "${ROJO}PHP no s'ha instal·lat.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}PHP ja està instal·lat.${NORMAL}"
fi

#Instal.lació paquet PHP-MySQL
# if [ $(dpkg-query -W -f='${Status}' 'php-mysql' | grep -c "ok installed") -eq 0 ];then
# No podem trobar el paquet 'php-mysql' amb $(dpkg-query -W -f='${Status}' 'mariadb-server'
# Si no trobem PHP-MYSQL, avisem que no està instal·lat
#       echo "PHP-MySQL no està instal·lat." >>/script/registre.txt
# Com que no podem comprovar si està instal·lat o no PHP-MySQL, l'instal·larem i si no hi ha errors, 
# voldrar dir que s'ha instal·lat encara que podria ja estar instal·lat abans.
        apt-get -y install php-mysql >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "PHP-MySQL instal·lat correctament." >>/script/registre.txt
                echo -e "${VERDE}PHP-MySQL instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}PHP-MySQL no s'ha instal·lat.${NORMAL}" >>/script/registre.txt
                echo -e "${ROJO}PHP-MySQL no s'ha instal·lat.${NORMAL}"
                exit
        fi

apt -y install lsb-release apt-transport-https ca-certificates >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "Instl.lant actualització de php" >>/script/registre.txt
                echo -e "${VERDE}Instl.lant actualització de php.${NORMAL}"
        else
                echo -e "${ROJO}ERROR d'actualització.${NORMAL}" >>/script/registre.txt
                echo -e "${ROJO}ERROR d'actualització.${NORMAL}"
                exit
        fi
        
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "Procesant actualització de php" >>/script/registre.txt
                echo -e "${VERDE}Procesant actualització de php.${NORMAL}"
        else
                echo -e "${ROJO}ERROR d'actualització 1.${NORMAL}" >>/script/registre.txt
                echo -e "${ROJO}ERROR d'actualització 1.${NORMAL}"
                exit
        fi

echo “deb https://packages.sury.org/php/ $( lsb_release -sc) main” | tee /etc/apt/sources.list.d/php.list >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "Comprovant actualització de php" >>/script/registre.txt
                echo -e "${VERDE}Comprovant actualització de php.${NORMAL}"
        else
                echo -e "${ROJO}ERROR d'actualització 2.${NORMAL}" >>/script/registre.txt
                echo -e "${ROJO}ERROR d'actualització 2.${NORMAL}"
                exit
        fi
        
#apt-get update
#apt-get install php7.4
#a2dismod php7.3
#a2enmod php7.4
