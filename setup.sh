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
project_folder="/var/www/html/TRPanel/bashes"
packages="php apache2 mysql-server"
default_language="tr"
sudo apt-get install figlet
log "${GREEN}$(figlet -f slant "TRPanel Kurulumu")${NC}"


# Root kullanıcı olup olmadığını kontrol et
if [ "$(id -u)" != "0" ]; then
    log "${RED}This script must be run as root.${NC}"
  exit 1
fi



# Git'in kurulumunu kontrol et
if ! command -v git &> /dev/null; then
    sudo apt update
    sudo apt install -y git
    if ! command -v git &> /dev/null; then 
        log "${RED}Git is not installed.${NC}"
        exit 1
    fi
fi

# Dizin yoksa oluştur
if [ ! -d "/var/www/html" ]; then
  sudo mkdir -p /var/www/html
  if [ ! -d "/var/www/html" ]; then
    log "${RED}The directory could not be created.${NC}"
    exit 1
    fi
fi
cd /var/www/html

# Proje dizini varsa sil
sudo rm -rf TRPanel

# Git reposunu klonla

git clone https://github.com/duran004/TRPanel.git TRPanel
if [ ! -d "/var/www/html/TRPanel" ]; then
    log "${RED}The project could not be cloned.${NC}"
  exit 1
fi
cd TRPanel

# Dili sor
log "${BLUE}Dil seçin / Choose language (tr/en):${NC}"
read language
if [ "$language" == "en" ]; then
  source "$project_folder/lang/en.sh"
else
  source "$project_folder/lang/tr.sh"
fi

# lampı kurmayı atlamak için sor
log "${YELLOW}LAMP kurulumunu atlamak ister misiniz?${NC}"
read -p "y/n: " skip_lamp
source "$project_folder/init.sh"
if [ "$skip_lamp" == "n" ]; then
source "$project_folder/apache.sh"
source "$project_folder/php.sh"
source "$project_folder/packages.sh"
source "$project_folder/mysql.sh"
source "$project_folder/phpmyadmin.sh"
fi
source "$project_folder/project.sh"