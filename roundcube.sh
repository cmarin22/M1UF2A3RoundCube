#!/bin/bash
clear
# Amb netegem el terminal

# Declaració dels diferents colors
NORMAL = '\e[0m'
ROJO = '\e[31m'
VERDE = '\e[32m'
ROJOBK = '\e[41m'


#Comprovació de l’usuari
#Aquest condicional utilitza la comanda “whoami”, serveix per identificar l’usuari actual
#Compara la variable si es == a “root” en cas afirmatiu escriu “Ets root.” i en cas negatiu et diu que no ho ets i surt de l’script
if [ $(whoami) == "root" ]; then


        echo -e "${VERDE} Ets root. ${NORMAL} "
        # Color verd


else


        echo "${ROJO}No ets root. ${NORMAL} "
        # Color vermell
        echo "${ROJOBK}No tens permisos per executar aquest script, només pots ser executat per l'usuari root.${NORMAL}"
        # Fons vermell
        # Exit fa que sortim de l'script.
        exit


fi


#Instal.lació paquet Apache2
if [ $(dpkg-query -W -f='${Status}' 'apache2' | grep -c "ok installed") -eq 0 ];then 
        echo "Apache2 no està instal.lat" >/script/registre.txt
        apt-get -y install apache2 >/dev/null 2>&1
        if [ $? -eq 0 ];then
                echo "Apache2 instal.lat correctament." >>/script/registre.txt
                echo "Apache2 instal.lat correctament."
        else
                echo "Apache2 instal.lat incorrectament."
        fi
else
        echo "Apache2 està instal.lat"
fi






# Fi codi
