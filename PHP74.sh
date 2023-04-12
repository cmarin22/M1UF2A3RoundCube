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
if [ $(dpkg-query -W -f='${Status}' 'php-mysql' | grep -c "ok installed") -eq 0 ];then
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
else
        echo -e "${VERDE}PHP-MySQL ja està instal·lat.${NORMAL}"
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
        
apt-get update >/dev/null 2>&1
if [ $(dpkg-query -W -f='${Status}' 'php7.4' | grep -c "ok installed") -eq 0 ];then
apt-get -y install php7.4 >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "Instal.lant la versio 7.4 de php" >>/script/registre.txt
                echo -e "${VERDE}Instal.lant la versio 7.4 de php.${NORMAL}"
        else
                echo -e "${ROJO}ERROR d'actualització 3.${NORMAL}" >>/script/registre.txt
                echo -e "${ROJO}ERROR d'actualització 3.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}PHP7.4 ja està instal·lat.${NORMAL}"
fi
a2dismod php7.3
        if [ $? -eq 0 ];then
                echo "Deshabilitant la versio 7.3 de php" >>/script/registre.txt
                echo -e "${VERDE}Desabilitant la versio 7.3 de php.${NORMAL}"
        else
                echo -e "${ROJO}ERROR d'actualització 4.${NORMAL}" >>/script/registre.txt
                echo -e "${ROJO}ERROR d'actualització 4.${NORMAL}"
                exit
        fi
a2enmod php7.4
        if [ $? -eq 0 ];then
                echo "Habilitant la versio 7.4 de php" >>/script/registre.txt
                echo -e "${VERDE}Habilitant la versio 7.4 de php.${NORMAL}"
        else
                echo -e "${ROJO}ERROR d'actualització 5.${NORMAL}" >>/script/registre.txt
                echo -e "${ROJO}ERROR d'actualització 5.${NORMAL}"
                exit
        fi
        
if [ $(dpkg-query -W -f='${Status}' 'php7.4-mysql' | grep -c "ok installed") -eq 0 ];then
        apt-get -y install php-mysql >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "PHP-MySQL instal·lat correctament." >>/script/registre.txt
                echo -e "${VERDE}PHP-MySQL instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}PHP-MySQL no s'ha instal·lat.${NORMAL}" >>/script/registre.txt
                echo -e "${ROJO}PHP-MySQL no s'ha instal·lat.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}PHP7.4-MySQL ja està instal·lat.${NORMAL}"
fi

#------ Instal.lacio paquets

if [ $(dpkg-query -W -f='${Status}' 'php7.4-dom' | grep -c "ok installed") -eq 0 ];then
        apt-get -y install php7.4-dom >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "php7.4-dom instal·lat correctament." >>/script/registre.txt
                echo -e "${VERDE}php7.4-dom instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}php7.4-dom no s'ha instal·lat.${NORMAL}" >>/script/registre.txt
                echo -e "${ROJO}php7.4-dom no s'ha instal·lat.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}php7.4-dom ja està instal·lat.${NORMAL}"
fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-simplexml' | grep -c "ok installed") -eq 0 ];then
        apt-get -y install php7.4-simplexml >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "php7.4-simplexml instal·lat correctament." >>/script/registre.txt
                echo -e "${VERDE}php7.4-simplexml instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}php7.4-simplexml no s'ha instal·lat.${NORMAL}" >>/script/registre.txt
                echo -e "${ROJO}php7.4-simplexml no s'ha instal·lat.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}php7.4-simplexml ja està instal·lat.${NORMAL}"
fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-curl' | grep -c "ok installed") -eq 0 ];then
        apt-get -y install php7.4-curl >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "php7.4-curl instal·lat correctament." >>/script/registre.txt
                echo -e "${VERDE}php7.4-curl instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}php7.4-curl no s'ha instal·lat.${NORMAL}" >>/script/registre.txt
                echo -e "${ROJO}php7.4-curl no s'ha instal·lat.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}php7.4-curl ja està instal·lat.${NORMAL}"
fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-gd' | grep -c "ok installed") -eq 0 ];then
        apt-get -y install php7.4-gd >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "php7.4-gd instal·lat correctament." >>/script/registre.txt
                echo -e "${VERDE}php7.4-gd instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}php7.4-gd no s'ha instal·lat.${NORMAL}" >>/script/registre.txt
                echo -e "${ROJO}php7.4-gd no s'ha instal·lat.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}php7.4-gd ja està instal·lat.${NORMAL}"
fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-intl' | grep -c "ok installed") -eq 0 ];then
        apt-get -y install php7.4-intl >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "php7.4-intl instal·lat correctament." >>/script/registre.txt
                echo -e "${VERDE}php7.4-intl instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}php7.4-intl no s'ha instal·lat.${NORMAL}" >>/script/registre.txt
                echo -e "${ROJO}php7.4-intl no s'ha instal·lat.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}php7.4-intl ja està instal·lat.${NORMAL}"
fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-ldap' | grep -c "ok installed") -eq 0 ];then
        apt-get -y install php7.4-ldap >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "php7.4-ldap instal·lat correctament." >>/script/registre.txt
                echo -e "${VERDE}php7.4-ldap instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}php7.4-ldap no s'ha instal·lat.${NORMAL}" >>/script/registre.txt
                echo -e "${ROJO}php7.4-ldap no s'ha instal·lat.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}php7.4-ldap ja està instal·lat.${NORMAL}"
fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-zip' | grep -c "ok installed") -eq 0 ];then
        apt-get -y install php7.4-zip >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "php7.4-zip instal·lat correctament." >>/script/registre.txt
                echo -e "${VERDE}php7.4-zip instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}php7.4-zip no s'ha instal·lat.${NORMAL}" >>/script/registre.txt
                echo -e "${ROJO}php7.4-zip no s'ha instal·lat.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}php7.4-zip ja està instal·lat.${NORMAL}"
fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-bz2' | grep -c "ok installed") -eq 0 ];then
        apt-get -y install php7.4-bz2 >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "php7.4-bz2 instal·lat correctament." >>/script/registre.txt
                echo -e "${VERDE}php7.4-bz2 instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}php7.4-bz2 no s'ha instal·lat.${NORMAL}" >>/script/registre.txt
                echo -e "${ROJO}php7.4-bz2 no s'ha instal·lat.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}php7.4-bz2 ja està instal·lat.${NORMAL}"
fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-mbstring' | grep -c "ok installed") -eq 0 ];then
        apt-get -y install php7.4-mbstring >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "php7.4-mbstring instal·lat correctament." >>/script/registre.txt
                echo -e "${VERDE}php7.4-mbstring instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}php7.4-mbstring no s'ha instal·lat.${NORMAL}" >>/script/registre.txt
                echo -e "${ROJO}php7.4-mbstring no s'ha instal·lat.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}php7.4-mbstring ja està instal·lat.${NORMAL}"
fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-imagick' | grep -c "ok installed") -eq 0 ];then
        apt-get -y install php7.4-imagick >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "php7.4-imagick instal·lat correctament." >>/script/registre.txt
                echo -e "${VERDE}php7.4-imagick instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}php7.4-imagick no s'ha instal·lat.${NORMAL}" >>/script/registre.txt
                echo -e "${ROJO}php7.4-imagick no s'ha instal·lat.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}php7.4-imagick ja està instal·lat.${NORMAL}"
fi


#systemctl restart apache2

