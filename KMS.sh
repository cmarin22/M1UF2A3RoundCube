#!/bin/bash
clear
# Amb netegem el terminal

# Declaració dels diferents colors
NORMAL='\e[0m'          # Color Base
ROJO='\e[31m'           # Color Vermell  
VERDE='\e[32m'          # Color Verd
ROJOBK='\e[41m'         # Fons Vermell
On_Purple='\033[45m'    # Fons Lila

# PART 0 - COMPROVAR QUE SOM L'USUARI ROOT + ACTUALITZAR REPOSITORIS ################################################################################
echo -e "${On_Purple}SCRIPT AUTOMÀTIC PER INSTAL·LAR EL SERVIDOR KMS${NORMAL}"
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
/script/registre.txt 2>/dev/null

# Actualització dels repositoris
apt-get update >/dev/null 2>&1
if [ $? -eq 0 ]; then
        echo "Repositoris de Linux actualitzats correctament." >>/script/registre.txt
        echo -e "${VERDE}Repositoris de Linux actualitzats correctament.${NORMAL}"
else
        echo -e "${ROJO}No s'han pogut actualitzat els repositoris de Linux, potser no tens internet.${NORMAL}" >>/script/registre.txt
        echo -e "${ROJO}No s'han pogut actualitzat els repositoris de Linux, potser no tens internet.${NORMAL}"
        exit
fi

# Descarregar l'arxiu de Roundcube
wget https://github.com/SystemRage/py-kms/archive/refs/heads/master.zip >/dev/null 2>&1           
if [ $? -eq 0 ];then
        echo "Arxiu d'instal·lació de KMS descarregat correctament." >>/script/registre.txt
        echo -e "${VERDE}Arxiu d'instal·lació de KMS descarregat correctament.${NORMAL}"
else
        echo  "L'arxiu de KMS no s'ha pogut descarregar.">>/script/registre.txt
        echo -e "${ROJO}L'arxiu de KMS no s'ha pogut descarregar.${NORMAL}"
        exit
fi

# Descomprimir l'arxiu
apt-get install unzip >/dev/null 2>&1
unzip master.zip >/dev/null 2>&1

#Crear el directori de KMS
mkdir /srv/kms/ >/dev/null 2>&1
mv py-kms-master/* /srv/kms

#Instal·lació pyhton
apt-get install python3-tk >/dev/null 2>&1
apt-get install python3-pip >/dev/null 2&1 
if [ $? -eq 0 ]; then
        echo "Instal·lació de Pyhton instal·lat correctament." >>/script/registre.txt
        echo -e "${VERDE}Instal·lació de Pyhton instal·lat correctament.${NORMAL}"
else
        echo -e "${ROJO}Instal·lació de Pyhton no instal·lat correctament.${NORMAL}" >>/script/registre.txt
        echo -e "${ROJO}Instal·lació de Pyhton no instal·lat correctament.${NORMAL}"
        exit
fi

#Instal·lació net-tools
apt-get install net-tools >/dev/null 2>&1
if [ $? -eq 0 ]; then
        echo "Instal·lació de net-tools instal·lat correctament." >>/script/registre.txt
        echo -e "${VERDE}Instal·lació de net-tools instal·lat correctament.${NORMAL}"
else
        echo -e "${ROJO}Instal·lació de net-tools no instal·lat correctament.${NORMAL}" >>/script/registre.txt
        echo -e "${ROJO}Instal·lació de net-tools no instal·lat correctament.${NORMAL}"
        exit
fi

#Execució servei kms
cd /srv/kms/py-kms
pyhton3 pykms_Server.py >/dev/null 2>&1
if [ $? -eq 0 ]; then
        echo "Instal·lació de KMS instal·lat correctament." >>/script/registre.txt
        echo -e "${VERDE}Instal·lació de KMS instal·lat correctament.${NORMAL}"
else
        echo -e "${ROJO}Instal·lació de KMS no instal·lat correctament.${NORMAL}" >>/script/registre.txt
        echo -e "${ROJO}Instal·lació de KMS no instal·lat correctament.${NORMAL}"
        exit
fi

#Automatización
tee /etc/systemd/system/kms.service <<EOF
[Unit]
After=network.target
[Service]
ExecStart=/usr/bin/python3 /srv/kms/py-kms/pykms_Server.py
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload >/dev/null 2>&1
systemctl start kms.service >/dev/null 2>&1
systemctl enable kms.service >/dev/null 2>&1
if [ $? -eq 0 ];then
        echo "KMS reiniciat correctament." >>/script/registre.txt
        echo -e "${VERDE}Apache reiniciat correctament.${NORMAL}"
        echo -e "${On_Purple}Instal·lació KMS fet${NORMAL}"
else
        echo  "KMS no reiniciat correctament.">>/script/registre.txt
        echo -e "${ROJO}KMS no reiniciat correctament.${NORMAL}"
        exit
fi

ss -putona

