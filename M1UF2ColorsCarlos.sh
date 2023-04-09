#!/bin/bash
clear
# Amb netegem el terminal

# Colors lletres
BLANCO='\e[0m'
NEGRO='\e[30m'
ROJO='\e[31m'
ROJOCLARO='\e[1;31m'
VERDE='\e[32m'
VERDECLARO='\e[1;32m'
MARRON='\e[33m'
AZUL='\e[34m'
AZULCLARO='\e[1;34m'
PURPURA='\e[35m'
PURPURACLARO='\e[1;35m'
CIAN='\e[36m'
GRIS='\e[37m'
GRISCLARO='\e[1;30m'
AMARILLO='\e[1;33m'
LILA='\e[1;36m'

# Colores de fondo
NEGROBK='\e[40m'
ROJOBK='\e[41m'
VERDEBK='\e[42m'
MARRONBK='\e[43m'
AZULBK='\e[44m'
PURPURABK='\e[45m'
CIANBK='\e[46m'
GRISBK='\e[47m'


#Comprovació de l’usuari
#Aquest condicional utilitza la comanda “whoami”, serveix per identificar l’usuari actual
#Compara la variable si es == a “root” en cas afirmatiu escriu “Ets root.” i en cas negatiu et diu que no ho ets i surt de l’script
if [ $(whoami) == "root" ]; then
        echo -e "${VERDE} Ets root. Tot està bé.${NORMAL}"
        # Color verd
else
        echo "${ROJO} No ets root. Aquest fitxer és condifencial. ${BLANCO}"
        # Color vermell
        echo "${ROJOBK} No tens permisos per executar aquest script, només pots ser executat per l'usuari root. ${BLANCO}"
        # Fons vermell
        # Exit fa que sortim de l'script.
        exit
fi







# Fi codi
