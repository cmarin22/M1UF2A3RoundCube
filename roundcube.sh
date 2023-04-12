#!/bin/bash
clear
# Amb netegem el terminal

# Declaració dels diferents colors
NORMAL='\e[0m'
ROJO='\e[31m'
VERDE='\e[32m'
ROJOBK='\e[41m'

# PART 0 - COMPROVAR QUE SOM L'USUARI ROOT ################################################################################
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

# PART 1 - PAQUET LAMP ################################################################################
#Instal.lació paquet Apache2
if [ $(dpkg-query -W -f='${Status}' 'apache2' 2>/dev/null | grep -c "ok installed") -eq 0 ];then
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
if [ $(dpkg-query -W -f='${Status}' 'mariadb-server' 2>/dev/null | grep -c "ok installed") -eq 0 ];then 
        echo "MariaDB-Server no està instal·lat" >>/script/registre.txt
        echo "MariaDB-Server no està instal·lat"
        apt-get -y install mariadb-server >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "MariaDB-Server instal·lat correctament." >>/script/registre.txt
                echo -e "${VERDE}MariaDB-Server instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}MariaDB-Server no s'ha instal·lat.${NORMAL}" >>/script/registre.txt
                echo -e "${ROJO}MariaDB-Server no s'ha instal·lat.${NORMAL}"
                exit
        fi
else
       echo -e "${VERDE}MariaDB-Server ja està instal·lat.${NORMAL}" >>/script/registre.txt
       echo -e "${VERDE}MariaDB-Server ja està instal·lat.${NORMAL}"
fi

#Instal.lació paquet PHP
if [ $(dpkg-query -W -f='${Status}' 'php' 2>/dev/null | grep -c "ok installed") -eq 0 ];then
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
        echo -e "${VERDE}PHP ja està instal·lat.${NORMAL}" >>/script/registre.txt
        echo -e "${VERDE}PHP ja està instal·lat.${NORMAL}"
fi

#Instal.lació paquet PHP-MySQL
if [ $(dpkg-query -W -f='${Status}' 'php-mysql' 2>/dev/null | grep -c "ok installed") -eq 0 ];then
# No podem trobar el paquet 'php-mysql' amb $(dpkg-query -W -f='${Status}' 'mariadb-server'
# Si no trobem PHP-MYSQL, avisem que no està instal·lat
        echo "PHP-MySQL no està instal·lat." >>/script/registre.txt
        echo "PHP-MySQL no està instal·lat."
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
        echo -e "${VERDE}PHP-MySQL ja està instal·lat.${NORMAL}" >>/script/registre.txt
        echo -e "${VERDE}PHP-MySQL ja està instal·lat.${NORMAL}"
fi

# PART 2 - BASE DE DADES ################################################################################
#Comprovem si la base de dades roundcube existeix
dbname="roundcube"
if [ -d "/var/lib/mysql/$dbname" ]; then
        echo -e "${VERDE}La base de dades roundcube existeix.${NORMAL}"
else
        echo -e "La base de dades no existeix."
        mysql -u root -e "CREATE DATABASE roundcube;"
        mysql -u root -e "CREATE USER 'roundcube'@'localhost' IDENTIFIED BY 'roundcube';"
        mysql -u root -e "GRANT ALL PRIVILEGES ON moodle .* TO 'roundcube'@'localhost';"
        mysql -u root -e "FLUSH PRIVILEGES;"
        mysql -u root -e "exit"
        # Tornem a comprovar si existeix per assegurar-nos que s'ha creat.
        if [ -d "/var/lib/mysql/$dbname" ]; then
                echo -e "${VERDE}La base de dades roundcube s'ha creat correctament.${NORMAL}"
        else
                echo -e "${ROJO}Malauradament, la base de dades no s'ha creat correctament.${NORMAL}"
                exit
        fi
fi

# PART 3 - DEPENDÈNCIES DE PHP ################################################################################



# PART 4 - DESCÀRREGA DE ROUNDCUBE ################################################################################
#Instalació de Roundcube
mkdir /opt 2>&1
cd /opt/ 2>&1
rm -r roundcubemail* 2>&1
wget https://github.com/roundcube/roundcubemail/releases/download/1.6.1/roundcubemail-1.6.1-complete.tar.gz >/dev/null 2>&1
tar -xvzf roundcubemail-1.6.1-complete.tar.gz>/dev/null 2>&1            
if [ $? -eq 0 ];then
        echo "Arxiu d'instal·lació de Roundcube descarregat correctament." >>/script/registre.txt
        echo -e "${VERDE}Arxiu d'instal·lació de Roundcube descarregat correctament.${NORMAL}"
else
        echo  "L'arxiu de Roundcube no s'ha pogut descarregar.">>/script/registre.txt
        echo -e "${ROJO}L'arxiu de Roundcube no s'ha pogut descarregar.${NORMAL}"
        exit
fi
