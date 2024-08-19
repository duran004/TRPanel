#!/bin/bash


# Renk kodları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
project_folder="/var/www/html/TRPanel/bashes"
packages="php apache2 mysql-server"
default_language="tr"
# Dili sor
echo -e "${BLUE}Dil seçin / Choose language (tr/en):${NC}"
read language
if [ "$language" == "en" ]; then
  source "$project_folder/lang/en.sh"
else
  source "$project_folder/lang/tr.sh"
fi


# Root kullanıcı olup olmadığını kontrol et
if [ "$(id -u)" != "0" ]; then
  echo -e "${RED}${lang[root_needed]}${NC}"
  exit 1
fi


# Git'in kurulumunu kontrol et
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}### Git ${lang[installing]} ###${NC}"
    sudo apt update
    sudo apt install -y git
    if ! command -v git &> /dev/null; then 
        echo -e "${RED}Git ${lang[not_installed]}.${NC}"
        exit 1
    else
        echo -e "${GREEN}Git ${lang[installed]}.${NC}"
    fi
else
    echo -e "${GREEN}Git ${lang[have]}.${NC}"
fi

# Dizin yoksa oluştur
if [ ! -d "/var/www/html" ]; then
  echo -e "${GREEN}/var/www/html ${lang[creating]}...${NC}"
  sudo mkdir -p /var/www/html
  if [ ! -d "/var/www/html" ]; then
    echo -e "${RED}/var/www/html ${lang[not_created]}.${NC}"
    exit 1
    fi
fi
cd /var/www/html

# Proje dizini varsa sil
echo -e "${GREEN}TRPanel ${lang[deleting]}...${NC}"
sudo rm -rf TRPanel

# Git reposunu klonla
echo -e "${GREEN}Git ${lang[cloning]}...${NC}"
git clone https://github.com/duran004/TRPanel.git
if [ ! -d "/var/www/html/TRPanel" ]; then
  echo -e "${RED}TRPanel ${lang[not_cloned]}.${NC}"
  exit 1
fi
cd TRPanel

source "$project_folder/init.sh"
source "$project_folder/apache.sh"
source "$project_folder/php.sh"
source "$project_folder/packages.sh"
source "$project_folder/mysql.sh"
source "$project_folder/project.sh"