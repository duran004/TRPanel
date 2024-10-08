#!/bin/bash

# Renk kodları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;36m'
NC='\033[0m' # No Color
WHITE_ON_RED='\033[41;37m'

# Log fonksiyonu
log() {
  local date=$(date +"%Y-%m-%d %H:%M:%S")
  local message=$1
  echo -e "${WHITE_ON_RED}${date}${NC} ${message}"
}

project_folder="/var/www/html/TRPanel/bashes"
packages="php-fpm apache2 mysql-server"
default_language="tr"

# Root kullanıcı olup olmadığını kontrol et
check_root_user() {
  if [ "$(id -u)" != "0" ]; then
    log "${RED}This script must be run as root.${NC}"
    exit 1
  fi
}

# Git kurulum kontrolü
check_git_installation() {
  if ! command -v git &> /dev/null; then
    sudo apt update
    sudo apt install -y git
    if ! command -v git &> /dev/null; then 
      log "${RED}Git is not installed.${NC}"
      exit 1
    fi
  fi
}

# Proje dizinini oluşturma ve klonlama işlemleri
setup_project_directory() {
  if [ ! -d "/var/www/html" ]; then
    sudo mkdir -p /var/www/html
    if [ ! -d "/var/www/html" ]; then
      log "${RED}The directory could not be created.${NC}"
      exit 1
    fi
  fi
  cd /var/www/html
  sudo rm -rf TRPanel
  git clone https://github.com/duran004/TRPanel.git TRPanel
  if [ ! -d "/var/www/html/TRPanel" ]; then
    log "${RED}The project could not be cloned.${NC}"
    exit 1
  fi
  cd TRPanel
}

# Dili seçme
choose_language() {
  log "${BLUE}Dil seçin / Choose language (tr/en):${NC}"
  read language
  if [ "$language" == "en" ]; then
    install "lang/en.sh"
  else
    install "lang/tr.sh"
  fi
}

# Install fonksiyonu
install() {
  local script_name=$1
  if [ -f "$project_folder/$script_name" ]; then
    source "$project_folder/$script_name"
    log "${GREEN}$script_name yüklendi.${NC}"
  else
    log "${RED}$script_name bulunamadı.${NC}"
    exit 1
  fi
}

# LAMP kurulum fonksiyonu
install_lamp_stack() {
  log "${YELLOW}LAMP kurulumunu atlamak ister misiniz?${NC}"
  read -p "y/n: " skip_lamp
  install "init.sh"
  if [ "$skip_lamp" == "n" ]; then
    install "apache.sh"
    install "packages.sh"
    install "mysql.sh"
    install "phpmyadmin.sh"
  fi
}

# Main fonksiyonu
main() {
  sudo apt-get install figlet
  log "${GREEN}$(figlet -f slant "TRPanel Kurulumu")${NC}"

  check_root_user        # Root kullanıcı kontrolü
  check_git_installation # Git kurulumu kontrolü
  setup_project_directory # Proje dizini oluşturma ve klonlama
  choose_language         # Dil seçimi
  install_lamp_stack       # LAMP kurulumu (isteğe bağlı)
  install "apache_virtualhost_and_phpfpm_setup.sh"  # Apache VirtualHost ve PHP-FPM kurulumu
  install "project.sh"     # TRPanel Laravel projesi kurulumu
}

main
