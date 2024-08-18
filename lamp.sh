#!/bin/bash


# Renk kodları
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color



# Git'in kurulumunu kontrol et
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}### Git yükleniyor ###${NC}"
    sudo apt update
    sudo apt install -y git
    if ! command -v git &> /dev/null; then 
        echo -e "${RED}Git yüklenemedi.${NC}"
        exit 1
    else
        echo -e "${GREEN}Git yüklendi.${NC}"
    fi
else
    echo -e "${GREEN}Git zaten yüklü.${NC}"
fi

# Dizin yoksa oluştur
if [ ! -d "/var/www/html" ]; then
  echo -e "${GREEN}/var/www/html dizini oluşturuluyor...${NC}"
  sudo mkdir -p /var/www/html
fi
cd /var/www/html

# Proje dizini varsa sil
echo -e "${GREEN}TRPanel dizini siliniyor...${NC}"
sudo rm -rf TRPanel

# Git reposunu klonla
echo -e "${GREEN}Git reposu klonlanıyor...${NC}"
git clone https://github.com/duran004/TRPanel.git
cd TRPanel

source /bashes/init.sh
