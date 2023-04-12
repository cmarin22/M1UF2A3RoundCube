#!/bin/bash
clear
# Amb netegem el terminal

# Declaració dels diferents colors
NORMAL='\e[0m'
ROJO='\e[31m'
VERDE='\e[32m'
ROJOBK='\e[41m'
 
echo "SCRIPT AUTOMÀTIC PER INSTAL·LAR EL SERVIDOR ROUNDCUBE"
#Comprovació de l’usuari
#Aquest condicional utilitza la comanda “whoami”, serveix per identificar l’usuari actual
#Compara la variable si es == a “root” en cas afirmatiu escriu “Ets root.” i en cas negatiu et diu que no ho ets i surt de l’script
if [ $(whoami) == "root" ]; then
        echo -e "${VERDE}Ets root.${NORMAL} "
        # Color verd
else
        echo -e "${ROJO}No ets root.${NORMAL} "
        # Color vermell
        echo -e "${ROJOBK}No tens permisos per executar aquest script, només pots ser executat per l'usuari root.${NORMAL}"
        # Fons vermell
        # Exit fa que sortim de l'script.
        exit
fi

#Instal.lació paquet Apache2
if [ $(dpkg-query -W -f='${Status}' 'apache2' | grep -c "ok installed") -eq 0 ];then
# Si no trobem Apache2, avisem que no està instal·lat
        echo "Apache2 no està instal·lat." >>/script/registre.txt
        echo "Apache2 no està instal·lat."
        apt-get -y install apache2 >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "Apache2 instal.lat correctament." >>/script/registre.txt
                echo -e "${VERDE}Apache2 instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}Apache2 no s'ha instal·lat.${NORMAL}"
                exit
        fi
else
        echo -e "${VERDE}Apache2 ja està instal.lat.${NORMAL}"
fi

#Instal.lació paquet MariaDB-Server
#if [ $(dpkg-query -W -f='${Status}' 'mariadb-server' | grep -c "ok installed") -eq 0 ];then 
# No podem trobar el paquet 'mariadb-server' amb $(dpkg-query -W -f='${Status}' 'mariadb-server'
#        echo "MariaDB-Server no està instal.lat" >>/script/registre.txt
# Com que no podem comprovar si està instal·lat o no MariaDB-Server, l'instal·larem i si no hi ha errors, 
# voldrar dir que s'ha instal·lat encara que podria ja estar instal·lat abans.
        apt-get -y install mariadb-server >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "MariaDB-Server instal·lat correctament." >>/script/registre.txt
                echo -e "${VERDE}MariaDB-Server instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}MariaDB-Server no s'ha instal·lat.${NORMAL}"
                exit
        fi
#else
#       echo "MariaDB-Server ja està instal.lat"
#fi

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
#else
#       echo -e "${VERDE}PHP-MySQL ja està instal·lat.${NORMAL}"
#fi

#Comprovem si la base de dades roundcube existeix
dbname="roundcube"
if [ -d "/var/lib/mysql/$dbname" ]; then
        echo "${VERDE}La base de dades roundcube existeix${NORMAL}"
else
        echo "${ROJO}La base de dades no existeix${NORMAL}"
        mysql -u root -e "CREATE DATABASE roundcube;"
        mysql -u root -e "CREATE USER 'roundcube'@'localhost' IDENTIFIED BY 'roundcube';"
        mysql -u root -e "GRANT ALL PRIVILEGES ON moodle .* TO 'roundcube'@'localhost';"
        mysql -u root -e "FLUSH PRIVILEGES;"
        mysql -u root -e "exit"
        echo "${VERDE}La base de dades roundcube s'ha creat correctament${NORMAL}"
fi


# Fi codi
