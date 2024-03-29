#!/bin/bash
clear
# Amb netegem el terminal

# Declaració dels diferents colors
NORMAL='\033[0;35m' 
VERDE='\033[0;36m'    # Color Base
ROJO='\033[0;33m'       # Color Vermell  
ROJOBK='\e[41m'         # Fons Vermell
On_Purple='\033[45m'    # Fons Lila

# PART PROFESSOR
echo "Introdueix Nom + El Primer Cognom:"
read nom
clear
VERSIO=$(lsb_release -d | grep "Description" | cut -d ' ' -f2-4)
DATA_IN=$(head -1 /var/log/installer/syslog | cut -c 1-12)
DATA_FI=$(tail -1 /var/log/installer/syslog | cut -c 1-12)
RAM=$(vmstat -s -S M | grep "total memory" | cut -c 1-16)
HDD=$(df -h -t ext4 | awk ‘{pront $2}’ | sort -k 2 | head -1)
echo "[*] Nom Alumne: ${nom}"
echo "[*] La versió de Linux és: $VERSIO"
echo "[*] Inici de la instal·lació: $DATA_IN";
echo "[*] Final de la instal·lació: $DATA_FI";
echo "[*] Característiques (RAM / HDD): $RAM / $HDD"
echo
echo "+---------------------------------------------+"

# a)
# Col·locar la IP estàtic
# nano /etc/network/interfaces
# iface enp0s3 inet static
#	address 192.168.31.10
#	gateway 192.168.31.1

# Col·locar el DNS
# nano /etc/resolv.conf
#	nameserver 192.168.31.1

# b)
mkdir /var/logs
mkdir /var/logs/registres
mkdir /var/logs/registres/install
touch /var/logs/registres/install/errors.log

#c)
cat /etc/network/interfaces

# PART 0 - COMPROVAR QUE SOM L'USUARI ROOT I ACTUALITZACIÓ REPOSITORIS ################################################################################
echo -e "${On_Purple}SCRIPT AUTOMÀTIC PER INSTAL·LAR EL SERVIDOR GLPI${NORMAL}"
#Comprovació de l’usuari
#Aquest condicional utilitza la comanda “whoami”, serveix per identificar l’usuari actual
#Compara la variable si es == a “root” en cas afirmatiu escriu “Ets root.” i en cas negatiu et diu que no ho ets i surt de l’script
if [ $(whoami) == "root" ]; then
        echo -e "${VERDE}Ets root.${NORMAL}"
        # Color verd
else
        echo -e "${ROJO}No ets root.${NORMAL}"
        # Color vermell
        echo -e "${ROJOBK}No tens permisos per executar aquest script, només pots ser executat per l'usuari root.${NORMAL}"
        # Fons vermell
        # Exit fa que sortim de l'script.
        exit
fi

# Creació del document registre.txt
mkdir /script 2>/dev/null
touch /script/registre.txt 2>/dev/null

# Actualització dels repositoris
apt-get update >/dev/null 2>&1
if [ $? -eq 0 ]; then
        echo "Repositoris de Linux actualitzats correctament." >>/var/logs/registres/install/errors.log
        echo -e "${VERDE}Repositoris de Linux actualitzats correctament.${NORMAL}"
else
        echo -e "${ROJO}No s'han pogut actualitzat els repositoris de Linux, potser no tens internet.${NORMAL}" >>/var/logs/registres/install/errors.log
        echo -e "${ROJO}No s'han pogut actualitzat els repositoris de Linux, potser no tens internet.${NORMAL}"
        exit
fi


# PART 1 - PAQUET LAMP ################################################################################
#Instal.lació paquet Apache2
if [ $(dpkg-query -W -f='${Status}' 'apache2' 2>/dev/null | grep -c "ok installed") -eq 0 ];then
# Si no trobem Apache2, avisem que no està instal·lat
        echo "Apache2 no està instal·lat." >>/script/registre.txt
        echo "Apache2 no està instal·lat."
        apt-get -y install apache2 >/dev/null 2>&1
        if [ $? -eq 0 ]; then
                echo "Apache2 instal.lat correctament." >>//var/logs/registres/install/errors.log
                echo -e "${VERDE}Apache2 instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}Apache2 no s'ha instal·lat.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}Apache2 ja està instal.lat.${NORMAL}"
fi

#Instal.lació paquet MariaDB-Server
if [ $(dpkg-query -W -f='${Status}' 'mariadb-server' 2>/dev/null | grep -c "ok installed") -eq 0 ];then 
        echo "MariaDB-Server no està instal·lat" >>/script/registre.txt
        echo "MariaDB-Server no està instal·lat"
        apt-get -y install mariadb-server >/dev/null 2>&1
        if [ $? -eq 0 ]; then
                echo "MariaDB-Server instal·lat correctament." >>/var/logs/registres/install/errors.log
                echo -e "${VERDE}MariaDB-Server instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}MariaDB-Server no s'ha instal·lat.${NORMAL}" >>//var/logs/registres/install/errors.log
                echo -e "${ROJO}MariaDB-Server no s'ha instal·lat.${NORMAL}"
                exit
        fi
else
       echo -e "${VERDE}MariaDB-Server ja està instal·lat.${NORMAL}" >>/var/logs/registres/install/errors.log
       echo -e "${VERDE}MariaDB-Server ja està instal·lat.${NORMAL}"
fi

#Instal.lació paquet PHP
if [ $(dpkg-query -W -f='${Status}' 'php' 2>/dev/null | grep -c "ok installed") -eq 0 ];then
# Si no trobem PHP, avisem que no està instal·lat
        echo "PHP no està instal·lat." >>/script/registre.txt
        echo "PHP no està instal·lat."
        apt-get -y install php >/dev/null 2>&1
        if [ $? -eq 0 ]; then
                echo "PHP instal·lat correctament." >>/var/logs/registres/install/errors.log
                echo -e "${VERDE}PHP instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}PHP no s'ha instal·lat.${NORMAL}" >>//var/logs/registres/install/errors.log
                echo -e "${ROJO}PHP no s'ha instal·lat.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}PHP ja està instal·lat.${NORMAL}" >>/var/logs/registres/install/errors.log
        echo -e "${VERDE}PHP ja està instal·lat.${NORMAL}"
fi

#Instal.lació paquet PHP-MySQL
if [ $(dpkg-query -W -f='${Status}' 'php-mysql' 2>/dev/null | grep -c "ok installed") -eq 0 ];then
# No podem trobar el paquet 'php-mysql' amb $(dpkg-query -W -f='${Status}' 'mariadb-server'
# Si no trobem PHP-MYSQL, avisem que no està instal·lat
        echo "PHP-MySQL no està instal·lat." >>/var/logs/registres/install/errors.log
        echo "PHP-MySQL no està instal·lat."
# Com que no podem comprovar si està instal·lat o no PHP-MySQL, l'instal·larem i si no hi ha errors, 
# voldrar dir que s'ha instal·lat encara que podria ja estar instal·lat abans.
        apt-get -y install php-mysql >/dev/null 2>&1
        if [ $? -eq 0 ]; then
                echo "PHP-MySQL instal·lat correctament." >>/var/logs/registres/install/errors.log
                echo -e "${VERDE}PHP-MySQL instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}PHP-MySQL no s'ha instal·lat.${NORMAL}" >>/var/logs/registres/install/errors.log
                echo -e "${ROJO}PHP-MySQL no s'ha instal·lat.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}PHP-MySQL ja està instal·lat.${NORMAL}" >>/var/logs/registres/install/errors.log
        echo -e "${VERDE}PHP-MySQL ja està instal·lat.${NORMAL}"
fi

# PART 2 - BASE DE DADES ################################################################################
#Comprovem si la base de dades GLPI existeix
dbname="glpi"
if [ -d "/var/lib/mysql/$dbname" ]; then
        echo -e "${VERDE}La base de dades glpi existeix.${NORMAL}" >>/var/logs/registres/install/errors.log
	echo -e "${VERDE}La base de dades glpi existeix.${NORMAL}"
else
        echo -e "La base de dades no existeix."
        mysql -u root -e "CREATE DATABASE glpi;"
        mysql -u root -e "CREATE USER 'glpi'@'localhost' IDENTIFIED BY 'glpi';"
        mysql -u root -e "GRANT ALL PRIVILEGES ON glpi.* TO 'glpi'@'localhost';"
        mysql -u root -e "FLUSH PRIVILEGES;"
        mysql -u root -e "exit"
        # Tornem a comprovar si existeix per assegurar-nos que s'ha creat.
        if [ -d "/var/lib/mysql/$dbname" ]; then
                echo -e "${VERDE}La base de dades glpi s'ha creat correctament.${NORMAL}" >>/var/logs/registres/install/errors.log
		echo -e "${VERDE}La base de dades glpi s'ha creat correctament.${NORMAL}"
        else
                echo -e "${ROJO}Malauradament, la base de dades no s'ha creat correctament.${NORMAL}" >>/var/logs/registres/install/errors.log
		echo -e "${ROJO}Malauradament, la base de dades no s'ha creat correctament.${NORMAL}"
                exit
        fi
fi

# PART 3 - DEPENDÈNCIES DE PHP ################################################################################
# Repositoris de PHP lsb-release, apt-transport-https i ca-certificate
apt -y install lsb-release apt-transport-https ca-certificates >/dev/null 2>&1
if [ $? -eq 0 ]; then
        echo "Repositoris de PHP lsb-release, apt-transport-https i ca-certificates instal·lats correctament." >>/var/logs/registres/install/errors.log
        echo -e "${VERDE}Repositoris de PHP lsb-release, apt-transport-https i ca-certificates instal·lats correctament.${NORMAL}"
else
        echo -e "${ROJO}Repositoris de PHP lsb-release, apt-transport-https i ca-certificates no instal·lats correctament.${NORMAL}" >>/var/logs/registres/install/errors.log
        echo -e "${ROJO}Repositoris de PHP lsb-release, apt-transport-https i ca-certificates no instal·lats correctament.${NORMAL}"
        exit
fi

# Paquet apt.gpg de PHP
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg >/dev/null 2>&1
if [ $? -eq 0 ]; then
        echo "Paquet apt.gpg de PHP instal·lat correctament." >>/var/logs/registres/install/errors.log
        echo -e "${VERDE}Paquet apt.gpg de PHP instal·lat correctament.${NORMAL}"
else
        echo -e "${ROJO}Paquet apt.gpg de PHP no instal·lat correctament.${NORMAL}" >>/var/logs/registres/install/errors.log
        echo -e "${ROJO}Paquet apt.gpg de PHP no instal·lat correctament.${NORMAL}"
        exit
fi

# Llistats de paquets de PHP
echo "deb https://packages.sury.org/php/ $( lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list >/dev/null 2>&1
if [ $? -eq 0 ]; then
        echo "Llistat de paquets de PHP actualitzats." >>/var/logs/registres/install/errors.log
        echo -e "${VERDE}Llistat de paquets de PHP actualitzats.${NORMAL}"
else
        echo -e "${ROJO}Llistat de paquets de PHP no actualitzats.${NORMAL}" >>/var/logs/registres/install/errors.log
        echo -e "${ROJO}Llistat de paquets de PHP no actualitzats.${NORMAL}"
        exit
fi

# Actualització dels repositoris
apt-get update >/dev/null 2>&1
if [ $? -eq 0 ]; then
        echo "Repositoris de Linux actualitzats correctament." >>/var/logs/registres/install/errors.log
        echo -e "${VERDE}Repositoris de Linux actualitzats correctament.${NORMAL}"
else
        echo -e "${ROJO}No s'han pogut actualitzat els repositoris de Linux, potser no tens internet.${NORMAL}" >>/var/logs/registres/install/errors.log
        echo -e "${ROJO}No s'han pogut actualitzat els repositoris de Linux, potser no tens internet.${NORMAL}"
        exit
fi

# Instal·lar php7.4
if [ $(dpkg-query -W -f='${Status}' 'php7.4' 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
        echo "PHP 7.4 no està instal·lat." >>/script/registre.txt
        echo "PHP 7.4 no està instal·lat."
        apt-get -y install php7.4 >/dev/null 2>&1
        if [ $? -eq 0 ]; then
                echo "Instal·lació correcta de PHP 7.4." >>/var/logs/registres/install/errors.log
                echo -e "${VERDE}Instal·lació correcta de PHP 7.4.${NORMAL}"
        else
                echo -e "${ROJO}Instal·lació errònea de PHP 7.4.${NORMAL}" >>/var/logs/registres/install/errors.log
                echo -e "${ROJO}Instal·lació errònea de PHP 7.4.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}PHP7.4 ja està instal·lat.${NORMAL}" >>/var/logs/registres/install/errors.log
        echo -e "${VERDE}PHP7.4 ja està instal·lat.${NORMAL}"
fi

# Instal·lació del paquet php7.4-mysql
if [ $(dpkg-query -W -f='${Status}' 'php7.4-mysql' 2>/dev/null | grep -c "ok installed") -eq 0 ];then
        echo "PHP 7.4 MySQL no està instal·lat." >>/script/registre.txt
        echo "PHP 7.4 MySQL no està instal·lat."
        apt-get -y install php7.4-mysql >/dev/null 2>&1
        if [ $? -eq 0 ]; then
                echo "PHP 7.4 MySQL instal·lat correctament." >>/var/logs/registres/install/errors.log
                echo -e "${VERDE}PHP 7.4 MySQL instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}PHP 7.4 MySQL no s'ha instal·lat.${NORMAL}" >>/var/logs/registres/install/errors.log
                echo -e "${ROJO}PHP 7.4 MySQL no s'ha instal·lat.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}PHP 7.4 MySQL ja està instal·lat.${NORMAL}" >>/var/logs/registres/install/errors.log
        echo -e "${VERDE}PHP 7.4 MySQL ja està instal·lat.${NORMAL}"
fi

# Instal·lació del paquet php7.4-dom
#if [ $(dpkg-query -W -f='${Status}' 'php7.4-dom' 2>/dev/null | grep -c "ok installed") -eq 0 ];then
#        echo "PHP 7.4 dom no està instal·lat." >>/script/registre.txt
#        echo "PHP 7.4 dom no està instal·lat."
        apt-get -y install php7.4-dom >/dev/null 2>&1
        if [ $? -eq 0 ]; then
                echo "Paquet php7.4-dom instal·lat correctament." >>/var/logs/registres/install/errors.log
                echo -e "${VERDE}Paquet php7.4-dom instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}El paquet php7.4-dom no s'ha instal·lat correctament.${NORMAL}" >>/var/logs/registres/install/errors.log
                echo -e "${ROJO}El paquet php7.4-dom no s'ha instal·lat correctament.${NORMAL}"
                exit
        fi
#else
#        echo -e "${VERDE}El paquet php7.4-dom ja està instal·lat.${NORMAL}" >>/script/registre.txt
#        echo -e "${VERDE}El paquet php7.4-dom ja està instal·lat.${NORMAL}"
#fi

# Instal·lació del paquet php7.4-simplexml
#if [ $(dpkg-query -W -f='${Status}' 'php7.4-simplexml' 2>/dev/null | grep -c "ok installed") -eq 0 ];then
#        echo "PHP 7.4 simplexml no està instal·lat." >>/script/registre.txt
#        echo "PHP 7.4 simplexml no està instal·lat."
        apt-get -y install php7.4-simplexml >/dev/null 2>&1
        if [ $? -eq 0 ]; then
                echo "Paquet php7.4-simplexml instal·lat correctament." >>/var/logs/registres/install/errors.log
                echo -e "${VERDE}Paquet php7.4-simplexml instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}php7.4-simplexml no s'ha instal·lat.${NORMAL}" >>/var/logs/registres/install/errors.log
                echo -e "${ROJO}php7.4-simplexml no s'ha instal·lat.${NORMAL}"
                exit
        fi
#else
#        echo -e "${VERDE}El paquet php7.4-simplexml ja està instal·lat.${NORMAL}" >>/script/registre.txt
#        echo -e "${VERDE}El paquet php7.4-simplexml ja està instal·lat.${NORMAL}"
#fi

# Instal·lació del paquet php7.4-curl
if [ $(dpkg-query -W -f='${Status}' 'php7.4-curl' 2>/dev/null | grep -c "ok installed") -eq 0 ];then
        echo "PHP 7.4 curl no està instal·lat." >>/script/registre.txt
        echo "PHP 7.4 curl no està instal·lat."
        apt-get -y install php7.4-curl >/dev/null 2>&1
        if [ $? -eq 0 ]; then
                echo "Paquet php7.4-curl instal·lat correctament." >>/var/logs/registres/install/errors.log
                echo -e "${VERDE}Paquet php7.4-curl instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}El paquet php7.4-curl no s'ha instal·lat.${NORMAL}" >>/var/logs/registres/install/errors.log
                echo -e "${ROJO}php7.4-curl no s'ha instal·lat.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}El paquet php7.4-curl ja està instal·lat.${NORMAL}" >>/var/logs/registres/install/errors.log
        echo -e "${VERDE}El paquet php7.4-curl ja està instal·lat.${NORMAL}"
fi

# Instal·lació del paquet php7.4-gd
if [ $(dpkg-query -W -f='${Status}' 'php7.4-gd' 2>/dev/null | grep -c "ok installed") -eq 0 ];then
        echo "PHP 7.4 gd no està instal·lat." >>/script/registre.txt
        echo "PHP 7.4 gd no està instal·lat."
        apt-get -y install php7.4-gd >/dev/null 2>&1
        if [ $? -eq 0 ]; then
                echo "Paquet php7.4-gd instal·lat correctament." >>/var/logs/registres/install/errors.log
                echo -e "${VERDE}Paquet php7.4-gd instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}El paquet php7.4-gd no s'ha instal·lat correctament.${NORMAL}" >>/var/logs/registres/install/errors.log
                echo -e "${ROJO}El paquet php7.4-gd no s'ha instal·lat correctament.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}El paquet php7.4-gd ja està instal·lat.${NORMAL}" >>/var/logs/registres/install/errors.log
        echo -e "${VERDE}El paquet php7.4-gd ja està instal·lat.${NORMAL}"
fi

# Instal·lació del paquet php7.4-intl
if [ $(dpkg-query -W -f='${Status}' 'php7.4-intl' 2>/dev/null | grep -c "ok installed") -eq 0 ];then
        echo "PHP 7.4 intl no està instal·lat." >>/script/registre.txt
        echo "PHP 7.4 intl no està instal·lat."
        apt-get -y install php7.4-intl >/dev/null 2>&1
        if [ $? -eq 0 ]; then
                echo "Paquet php7.4-intl instal·lat correctament." >>/var/logs/registres/install/errors.log
                echo -e "${VERDE}Paquet php7.4-intl instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}El paquet php7.4-intl no s'ha instal·lat correctament.${NORMAL}" >>/var/logs/registres/install/errors.log
                echo -e "${ROJO}El paquet php7.4-intl no s'ha instal·lat correctament.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}El paquet php7.4-intl ja està instal·lat.${NORMAL}" >>/var/logs/registres/install/errors.log
        echo -e "${VERDE}El paquet php7.4-intl ja està instal·lat.${NORMAL}"
fi

# Instal·lació del paquet php7.4-ldap
if [ $(dpkg-query -W -f='${Status}' 'php7.4-ldap' 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
        echo "PHP 7.4 ldap no està instal·lat." >>/var/logs/registres/install/errors.log
        echo "PHP 7.4 ldap no està instal·lat."
        apt-get -y install php7.4-ldap >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "Paquet php7.4-ldap instal·lat correctament." >>/var/logs/registres/install/errors.log
                echo -e "${VERDE}Paquet php7.4-ldap instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}El paquet php7.4-ldap no s'ha instal·lat correctament.${NORMAL}" >>/var/logs/registres/install/errors.log
                echo -e "${ROJO}El paquet php7.4-ldap no s'ha instal·lat correctament.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}El paquet php7.4-ldap ja està instal·lat.${NORMAL}" >>/var/logs/registres/install/errors.log
        echo -e "${VERDE}El paquet php7.4-ldap ja està instal·lat.${NORMAL}"
fi

# Instal·lació del paquet php7.4-zip
if [ $(dpkg-query -W -f='${Status}' 'php7.4-zip' 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
        echo "PHP 7.4 zip no està instal·lat." >>/var/logs/registres/install/errors.log
        echo "PHP 7.4 zip no està instal·lat."
        apt-get -y install php7.4-zip >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "Paquet php7.4-zip instal·lat correctament." >>/var/logs/registres/install/errors.log
                echo -e "${VERDE}Paquet php7.4-zip instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}El paquet hp7.4-zip no s'ha instal·lat correctament.${NORMAL}" >>/var/logs/registres/install/errors.log
                echo -e "${ROJO}El paquet php7.4-zip no s'ha instal·lat correctament.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}El paquet php7.4-zip ja està instal·lat.${NORMAL}" >>/var/logs/registres/install/errors.log
        echo -e "${VERDE}El paquet php7.4-zip ja està instal·lat.${NORMAL}"
fi

# Instal·lació del paquet php7.4-bz2
if [ $(dpkg-query -W -f='${Status}' 'php7.4-bz2' 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
        echo "PHP 7.4 bz2 no està instal·lat." >>/script/registre.txt
        echo "PHP 7.4 bz2 no està instal·lat."
        apt-get -y install php7.4-bz2 >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "Paquet php7.4-bz2 instal·lat correctament." >>/var/logs/registres/install/errors.log
                echo -e "${VERDE}Paquet php7.4-bz2 instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}El paquet php7.4-bz2 no s'ha instal·lat correctament.${NORMAL}" >>/var/logs/registres/install/errors.log
                echo -e "${ROJO}El paquet php7.4-bz2 no s'ha instal·lat correctament.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}El paquet php7.4-bz2 ja està instal·lat.${NORMAL}"
fi

# Instal·lació del paquet php7.4-mbstring
if [ $(dpkg-query -W -f='${Status}' 'php7.4-mbstring' 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
        echo "PHP 7.4 mbstring no està instal·lat." >>/script/registre.txt
        echo "PHP 7.4 mbstring no està instal·lat."
        apt-get -y install php7.4-mbstring >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "Paquet php7.4-mbstring instal·lat correctament." >>/var/logs/registres/install/errors.log
                echo -e "${VERDE}Paquet php7.4-mbstring instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}El paquet php7.4-mbstring no s'ha instal·lat.${NORMAL}" >>/var/logs/registres/install/errors.log
                echo -e "${ROJO}El paquet php7.4-mbstring no s'ha instal·lat.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}El paquet php7.4-mbstring ja està instal·lat.${NORMAL}" >>/var/logs/registres/install/errors.log
        echo -e "${VERDE}El paquet php7.4-mbstring ja està instal·lat.${NORMAL}"
fi

# Instal·lació del paquet php7.4-imagick
if [ $(dpkg-query -W -f='${Status}' 'php7.4-imagick' 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
        echo "PHP 7.4 imagick no està instal·lat." >>/var/logs/registres/install/errors.log
        echo "PHP 7.4 imagick no està instal·lat."
        apt-get -y install php7.4-imagick >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "Paquet php7.4-imagick instal·lat correctament." >>/var/logs/registres/install/errors.log
                echo -e "${VERDE}Paquet php7.4-imagick instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}El paquet php7.4-imagick no s'ha instal·lat correctament.${NORMAL}" >>/var/logs/registres/install/errors.log
                echo -e "${ROJO}El paquet php7.4-imagick no s'ha instal·lat correctament.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}El paquet php7.4-imagick ja està instal·lat.${NORMAL}" >>/var/logs/registres/install/errors.log
        echo -e "${VERDE}El paquet php7.4-imagick ja està instal·lat.${NORMAL}"
fi

# Les funciones a2dismod y a2enmod no funcionen quan actualitzem els repositoris per instal·lar PHP7.4 (Si la màquina té interfície gràfica)
# Deshabilitar PHP 7.3
a2dismod php7.3 >/dev/null 2>&1
if [ $? -eq 0 ];then
        echo "PHP 7.3 deshabilitat correctament." >>/var/logs/registres/install/errors.log
        echo -e "${VERDE}PHP 7.3 deshabilitat correctament.${NORMAL}"
else
        echo -e "${ROJO}PHP 7.3 no s'ha pogut deshabilitar correctament.${NORMAL}" >>/var/logs/registres/install/errors.log
        echo -e "${ROJO}PHP 7.3 no s'ha pogut deshabilitar correctament.${NORMAL}"
        exit
fi

# Habilitar PHP 7.4
a2enmod php7.4 >/dev/null 2>&1
if [ $? -eq 0 ];then
        echo "PHP 7.4 habilitat correctament." >>/var/logs/registres/install/errors.log
        echo -e "${VERDE}PHP 7.4 habilitat correctament.${NORMAL}"
else
        echo -e "${ROJO}PHP 7.4 no s'ha pogut habilitar correctament.${NORMAL}" >>/var/logs/registres/install/errors.log
        echo -e "${ROJO}PHP 7.4 no s'ha pogut habilitar correctament.${NORMAL}"
        exit
fi

# Comprovar PHP 7.4
#valor=$(php --version | grep -c "PHP 7.4")
#if [ $valor -eq 0 ]; then
#        echo -e "${ROJO}La versió de PHP que s'està utilitzant no és la 7.4.${NORMAL}" >>/script/registre.txt
#        echo -e "${ROJO}La versió de PHP que s'està utilitzant no és la 7.4.${NORMAL}"
#        exit
#else
#        echo -e "${VERDE}La versió de PHP que s'està utilitzant és la 7.4.${NORMAL}" >>/script/registre.txt
#        echo -e "${VERDE}La versió de PHP que s'està utilitzant és la 7.4.${NORMAL}"
#fi

# PART 5 - DESCÀRREGA DE GLPI ################################################################################
# Creació del directori on descarregarem Roundcube
mkdir /opt 2>/dev/null
cd /opt/ 2>/dev/null
rm -r glpi* 2>/dev/null

# Descarregar l'arxiu de GLPI
wget https://github.com/glpi-project/glpi/releases/download/10.0.5/glpi-10.0.5.tgz >/dev/null 2>&1           
if [ $? -eq 0 ];then
        echo "Arxiu d'instal·lació de GLPI descarregat correctament." >>/var/logs/registres/install/errors.log
        echo -e "${VERDE}Arxiu d'instal·lació de GLPI descarregat correctament.${NORMAL}"
else
        echo  "L'arxiu de Glpi no s'ha pogut descarregar.">>/var/logs/registres/install/errors.log
        echo -e "${ROJO}L'arxiu de GLPI no s'ha pogut descarregar.${NORMAL}"
        exit
fi

# Decomprimir l'arxiu de GLPI
tar -xvzf glpi-10.0.5.tgz >/dev/null 2>&1
if [ $? -eq 0 ]; then
        echo "Arxiu d'instal·lació de GLPI descomprimit correctament." >>/var/logs/registres/install/errors.log
        echo -e "${VERDE}Arxiu d'instal·lació de GLPI descomprimit correctament.${NORMAL}"
else
        echo  "L'arxiu de GLPI no s'ha pogut descomprimir.">>/var/logs/registres/install/errors.log
        echo -e "${ROJO}L'arxiu de GLPI no s'ha pogut descomprimir.${NORMAL}"
        exit
fi

# PART 6 - CANVI DE PERMISOS ################################################################################
# Esborrar contingut al directori html
rm -r /var/www/html/* 2>/dev/null
if [ $? -eq 0 ]; then
	echo -e "${VERDE}Eliminació correcte.${NORMAL}"
	echo "Eliminació correcte." >>/var/logs/registres/install/errors.log
else

	echo -e "${ROJO}Error al eliminar.${NORMAL}"
	echo "Eliminació incorrecte." >>/var/logs/registres/install/errors.log
	exit
fi

# Moure el contingut de GLPI al directori html
mv glpi/ /var/www/html/ 2>/dev/null
if [ $? -eq 0 ];then
        echo "Contigut de GLPI mogut al directori html correctament." >>/var/logs/registres/install/errors.log
        echo -e "${VERDE}Contigut de GLPI mogut al directori html correctament.${NORMAL}"
else
        echo  "El contigut de GLPI no s'ha mogut al directori html correctament.">>/var/logs/registres/install/errors.log
        echo -e "${ROJO}El contigut de GLPI no s'ha mogut al directori html correctament.${NORMAL}"
        exit
fi

# Assignar permisos a www-data
chown -R www-data:www-data /var/www/ 2>/dev/null
if [ $? -eq 0 ];then
        echo "Permisos assignats a www-data correctament." >>/var/logs/registres/install/errors.log
        echo -e "${VERDE}Permisos assignats a www-data correctament.${NORMAL}"
else
        echo  "Els permisos no s'han assignat a www-data correctament.">>/var/logs/registres/install/errors.log
        echo -e "${ROJO}Els permisos no s'han assignat a www-data correctament.${NORMAL}"
        exit
fi

# Assignar permisos a tot el directori html
chmod -R 755 /var/www/ 2>/dev/null
if [ $? -eq 0 ];then
        echo "Permisos assignats a tot el directori correctament." >>/var/logs/registres/install/errors.log
        echo -e "${VERDE}Permisos assignats a tot el directori  correctament.${NORMAL}"
else
        echo  "No s'han assignat els permisos al directori  correctament.">>/var/logs/registres/install/errors.log
        echo -e "${ROJO}No s'han assignat els permisos al directori correctament.${NORMAL}"
        exit
fi

# Reinicar Apache2
systemctl restart apache2
if [ $? -eq 0 ];then
        echo "Apache reiniciat correctament." >>/var/logs/registres/install/errors.log
        echo -e "${VERDE}Apache reiniciat correctament.${NORMAL}"
        echo -e "${On_Purple}PER ACCEDIR A GLPI: http://127.0.0.1:8888/glpi/install/install.php AL NAVEGADOR${NORMAL}"
else
        echo  "Apache no reiniciat correctament.">>/var/logs/registres/install/errors.log
        echo -e "${ROJO}Apache no reiniciat correctament.${NORMAL}"
        exit
fi
