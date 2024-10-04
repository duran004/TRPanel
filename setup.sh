#!/bin/bash

# Renk kodları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;36m'
NC='\033[0m' # No Color
WHITE_ON_RED='\033[41;37m'
log() {
  local date=$(date +"%Y-%m-%d %H:%M:%S")
  local message=$1
  echo -e "${WHITE_ON_RED}${date}${NC} ${message}"
}

# Kullanıcı adını iste
get_user_input() {
  read -p "Kullanıcı adı girin: " TRPANEL_USER
}

# TRPanel kullanıcısını oluştur ve dizin yapısını hazırla
create_user() {
  log "${YELLOW}### TRPanel kullanıcısı oluşturuluyor ###${NC}"
  sudo useradd -m -s /bin/bash $TRPANEL_USER
  sudo mkdir -p /home/$TRPANEL_USER/public_html
  sudo chown -R $TRPANEL_USER:www-data /home/$TRPANEL_USER
  sudo chmod -R 755 /home/$TRPANEL_USER
}

# Git kurulumu kontrol et ve projeyi klonla
clone_project() {
  log "${YELLOW}### TRPanel projesi klonlanıyor ###${NC}"
  git clone https://github.com/duran004/TRPanel.git /home/$TRPANEL_USER/public_html/TRPanel
  if [ ! -d "/home/$TRPANEL_USER/public_html/TRPanel" ]; then
      log "${RED}Proje klonlanamadı.${NC}"
      exit 1
  fi
}

# Apache ve LAMP kurulumunu atlayıp atlamayacağını sor
skip_lamp_installation() {
  log "${YELLOW}LAMP kurulumunu atlamak ister misiniz? (y/n)${NC}"
  read -p "y/n: " skip_lamp
}

# Ana setup fonksiyonu
main() {
  get_user_input
  create_user
  clone_project

  skip_lamp_installation
  source "/home/$TRPANEL_USER/public_html/TRPanel/bashes/init.sh"

  if [ "$skip_lamp" == "n" ]; then
    source "/home/$TRPANEL_USER/public_html/TRPanel/bashes/apache.sh"
    source "/home/$TRPANEL_USER/public_html/TRPanel/bashes/packages.sh"
    source "/home/$TRPANEL_USER/public_html/TRPanel/bashes/mysql.sh"
    source "/home/$TRPANEL_USER/public_html/TRPanel/bashes/phpmyadmin.sh"
  fi

  source "/home/$TRPANEL_USER/public_html/TRPanel/bashes/project.sh"
}

# Ana fonksiyonu çalıştır
main
