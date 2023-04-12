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
        echo "Apache2 no està instal.lat" >>/script/registre.txt
        echo "Apache2 no està instal.lat"
        apt-get -y install apache2 >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "Apache2 instal.lat correctament." >>/script/registre.txt
                echo -e "${VERDE}Apache2 instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}Apache2 instal.lat incorrectament.${NORMAL}"
                exit
        fi
else
        echo "Apache2 ja està instal.lat"
fi

#Instal.lació paquet MariaDB-Server
if [ $(dpkg-query -W -f='${Status}' 'mariadb-server' | grep -c "ok installed") -eq 0 ];then 
# No podem trobar el paquet 'mariadb-server' amb $(dpkg-query -W -f='${Status}' 'mariadb-server'
        echo "MariaDB-Server no està instal.lat" >>/script/registre.txt
        apt-get -y install apache2 >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "MariaDB-Server instal·lat correctament." >>/script/registre.txt
                echo -e "${VERDE}MariaDB-Server instal·lat correctament.${NORMAL}"
        else
                echo -e "${ROJO}Apache2 instal.lat incorrectament.${NORMAL}"
                exit
        fi
else
        echo "MariaDB-Server ja està instal.lat"
fi






# Fi codi
