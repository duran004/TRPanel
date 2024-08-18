#!/bin/bash

# Debug: Çalıştırılan komutları ve değişkenleri yazdır
set -x

# Renk kodları
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Git yoksa yükle
if ! dpkg -l | grep -q git; then
  echo -e "${YELLOW}### Git yükleniyor ###${NC}"
  sudo apt update
  sudo apt install -y git

  # Git'in kurulumunu kontrol et
  if ! command -v git &> /dev/null; then
      echo -e "${RED}Git yüklenemedi.${NC}"
      exit 1
  else
      echo -e "${GREEN}Git yüklendi.${NC}"
  fi

else
  echo -e "${GREEN}git zaten yüklü.${NC}"
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

# Alt scripti çalıştır
if [ -f "bashes/init.sh" ]; then
  echo -e "${GREEN}bashes/init.sh çalıştırılıyor...${NC}"
  source bashes/init.sh
else
  echo -e "${RED}bashes/init.sh dosyası bulunamadı.${NC}"
fi
