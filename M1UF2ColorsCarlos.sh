#!/bin/bash
clear
# Amb netegem el terminal

# Color obtinguts a: https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux

# Reset 
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White

#Comprovació de l’usuari
#Aquest condicional utilitza la comanda “whoami”, serveix per identificar l’usuari actual
#Compara la variable si es == a “root” en cas afirmatiu escriu “Ets root.” i en cas negatiu et diu que no ho ets i surt de l’script
if [ $(whoami) == "root" ]; then
        echo -e "${Red}ETS. TOT ESTÀ BÉ.${White}"
        # Color verd
else
        echo "${On_Yellow}${Red}NO ETS ROOT. AQUEST FITXER ÉS CONFIDENCIAL.${White}${On_Black}"
        # Fons groc, color vermell
        echo "${On_IPurple}${Red}SI US PLAU, AVISA A L'ADMINISTRADOR QUE HI HA UNA ESCLETXA DE SEGURETAT.${White}${On_IBlack}"
        # Fons vermell
        # Exit fa que sortim de l'script.
        exit
fi
echo -e "${IBlue}                XX                                  XX        XX                              XX     XX       XX                                               ${IBlack}"
echo -e "${IBlue}                XX                                XXXXXX    XXXXXX                          XXXXXX   XX                                                        ${IBlack}"
echo -e "${IBlue}           XXXXXXX XXXXXXXX    XXXXXXXX  XXXXXXXX   XX        XX     XX  XXXX XX       XX     XX     XXXXXXX  XX  XXXXXXX                                      ${IBlack}"
echo -e "${IBlue}          XX    XX XX    XX    XX     XX XX    XX   XX        XX     XXXX      XX     XX      XX     XX    XX XX XX                                            ${IBlack}"
echo -e "${IBlue}          XX    XX XX    XX    XX     XX XX    XX   XX        XX     XXX        XX   XX       XX     XX    XX XX  XXXXXXX                                      ${IBlack}"
echo -e "${IBlue}          XX    XX XX    XX    XX     XX XX    XX   XX        XX     XX          XX XX        XX     XX    XX XX        XX                                     ${IBlack}"
echo -e "${IBlue}           XXXXXXX XXXXXXXX    XX     XX XXXXXXXX   XXXXXX    XXXXXX XX           XXX         XXXXXX XX    XX XX  XXXXXXX                                      ${IBlack}"
echo -e "${IBlue}                                                                                  XXX                                                                          ${IBlack}"
echo -e "${IBlue}                                                                                  XXX                                                                          ${IBlack}" 
echo -e "${On_IPurple}                                                                                                                                                       ${On_IBlack}"
echo -e "${IRed}                      XX        XX                                     XX                                                                                       ${IBlack}"
echo -e "${IRed}                    XXXXXX      XX                                     XX                                                                                       ${IBlack}"
echo -e "${IRed}            XXXXXX    XX        XXXXXXX  XXXXXXXX XXXXXXXX XXXXXXXX    XX                                                                                       ${IBlack}"
echo -e "${IRed}                 XX   XX        XX    XX XX    XX XX XX XX XX    XX    XX                                                                                       ${IBlack}"
echo -e "${IRed}            XXXXXXX   XX        XX    XX XX    XX XX XX XX XXXXXXXX    XX                                                                                       ${IBlack}"
echo -e "${IRed}           XX    XX   XX        XX    XX XX    XX XX XX XX XX          XX                                                                                       ${IBlack}"
echo -e "${IRed}            XXXXXXX   XXXXXX    XX    XX XXXXXXXX XX XX XX XXXXXXXX    XX                                                                                       ${IBlack}"
echo -e "${IRed}                                                                                                                                                                ${IBlack}"
echo -e "${IRed}                                                                       XX                                                                                       ${IBlack}"
echo -e "${On_IPurple}                                                                                                                                                       ${On_IBlack}"
echo -e "${BIGreen}GRÀCIES A STACKOVERFLOW PELS COLORS.${On_Black}"
echo -e "${BIGreen}Colors disponibles a: https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux.${On_Black}"



# Fi codi
