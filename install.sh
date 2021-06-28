#!/bin/bash
#Visual stuff
function print_warning {
  COLOR_YELLOW='\033[1;33m'
  COLOR_NC='\033[0m'
  echo ""
  echo -e "* ${COLOR_YELLOW}WARNING${COLOR_NC}: $1"
  echo ""
}

function print_error {
  COLOR_RED='\033[0;31m'
  COLOR_NC='\033[0m'

  echo ""
  echo -e "* ${COLOR_RED}ERROR${COLOR_NC}: $1"
  echo ""
}

COLOR_CYAN=''
RESET=''
bold=$(tput bold)
italic=$(tput italic)
normal=$(tput sgr0)

#Install required packages
REQUIRED_PKG="nodejs"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  sudo apt-get --yes install $REQUIRED_PKG 
fi

rebuild_panel()
{
  clear
  echo "${bold}############################################################################${normal}"
  echo "* ${bold}Starting to rebuild!${RESET}"
  yarn build:production
  clear
  install_done
}
install_done()
{
  echo "${bold}#################################################${normal}"
  echo "${bold}The Theme ${theme_name} has been installed!"
  echo "${bold}Just open the panel and you are good to go!" 
  echo "${bold}Thank You for using BetterCtyl."
  echo "${bold}#################################################${normal}"
}

install_dracula()
{
  if [[ "$CONFIRM_DRACULA" =~ [Yy] ]] 
  then
     theme_name="Dracula"
     clear
     echo "${bold}############################################################################${normal}"
     echo "* ${bold}Starting installation...${RESET}"
     echo "* ${bold}Installing Yarn...${RESET}"
     echo " "
     npm i -g yarn
     clear
     echo "${bold}############################################################################${normal}"
     echo "* ${bold}Going to pterodactyl directory...${RESET}"
     echo " "
     cd /var/www/pterodactyl
     echo "* ${bold}Installing required modules...${RESET}"
     echo " "
     yarn install && yarn add @emotion/react
     clear
     echo "${bold}############################################################################${normal}"
     echo "* ${bold}Installing CSS...${RESET}"
     if [ "$draculaInstall" -eq 1 ] 
     then
       echo "* ${bold}Installing User Interface...${RESET}"
       cd resources/
       touch scripts/main.css
       echo "@import url('https://lellisv2.github.io/Ptero-Themes-v1/latest/Dracula/user.css');" >> scripts/main.css
       cd scripts/
       rm -rf index.tsx
       wget https://raw.githubusercontent.com/pernydev/betterctyl/main/files/index.tsx
       cd ../..
     elif [ "$draculaInstall" -eq 2 ] 
     then
       echo "* ${bold}Installing Admin panel...${RESET}"
       cd resources/views/layouts/
       rm -rf admin.blade.php
       wget https://raw.githubusercontent.com/pernydev/betterctyl/main/files/admin.blade.php
       cd ..
       echo "* ${bold}Installing Admin panel...${RESET}"
     elif [ "$draculaInstall" -eq 3 ] 
     then
       cd resources/views/layouts/
       rm -rf admin.blade.php
       wget https://raw.githubusercontent.com/pernydev/betterctyl/main/files/admin.blade.php
       cd ../../..
       cd resources/
       touch scripts/main.css
       echo "@import url('https://lellisv2.github.io/Ptero-Themes-v1/latest/Dracula/user.css');" >> scripts/main.css
       cd scripts/
       rm -rf index.tsx
       wget https://raw.githubusercontent.com/pernydev/betterctyl/main/files/index.tsx
       cd ../..
       echo "* ${bold}Installing User Interface...${RESET}"
       cd resources/
       touch scripts/main.css
       echo "@import url('https://lellisv2.github.io/Ptero-Themes-v1/latest/Dracula/user.css');" >> scripts/main.css
       cd scripts/
       rm -rf index.tsx
       wget https://raw.githubusercontent.com/pernydev/betterctyl/main/files/index.tsx
       cd ../..
     else
       print_error "${bold}Unknown package! (${draculaInstall})${RESET}"
       choose_template
     fi
     php artisan view:clear
     php artisan cache:clear
     clear
     echo "${bold}#################################################${normal}"
     echo "* ${bold}Packages installed!${RESET}"
     echo "* ${bold}The following theme is now avalible: Dracula${RESET}"
     echo "${bold}#################################################${normal}"
     echo -n "* Do you want to rebuild the panel? (y/N): "
     read -r rebuild
     if [[ "$rebuild" =~ [Yy] ]]
     then
       rebuild_panel
     fi
  fi
}

if [ $EUID -ne 0 ]; then
  echo "* This script must be executed with root privileges (sudo)." 1>&2
  exit 1
fi

if ! [ -x "$(command -v curl)" ]; then
  echo "* curl is required in order for this script to work."
  exit 1
fi

choose_template()
{
  echo -n "* Wich theme package do you want to install? (Number): "
  read -r template
  if [ "$template" -eq 1 ] 
  then
    echo "${bold}#########################################${normal}"
    echo "* What package do you want to install?"
    echo "* [1] User Interface"
    echo "* [2] Admin area"
    echo "* [3] User Interface and Admin area"
    echo "${bold}#########################################${normal}"
    echo -n "* Wich package do you want to install? (Number): "
    read -r draculaInstall
    echo -n "* Do you really want to continue? (y/N): "
    read -r CONFIRM_DRACULA
    install_dracula
  else
   choose_template
fi
}

main_menu()
{
  echo " "
  echo "* ${bold}BetterCtyl Script (Version: Stable)${normal}"
  echo "*"
  echo "* Copyright (C) 2021, Mineton <support@mineton.co>"
  echo "* https://github.com/pernydev/betterctyl"
  echo "*"
  echo "* This script is made with <3 by Mineton Team."
  echo "* This script is not associated with the official Pterodactyl Panel."
  echo "*"
  echo "* ${bold}What would you like to do?${normal}"
  echo "* [1] Install a theme"
  echo "* [2] Install a module (Under construcion)"
  echo ""
  echo "* [3] Uninstall a theme. ${italic}(Under construcion)${normal}"
  echo "* [4] Uninstall a module. ${italic}(Under construcion)${normal}"

}

# On script run
main_menu
