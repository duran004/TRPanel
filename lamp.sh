#!/bin/bash

# Debug: Çalıştırılan komutları ve değişkenleri yazdır
set -x

# Renk kodları
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Git yoksa yükle
if ! dpkg -l | grep -q git; then
  apt update
  apt install -y git
  echo -e "${GREEN}git yüklendi.${NC}"
else
  echo -e "${GREEN}git zaten yüklü.${NC}"
fi

# Dizin yoksa oluştur
if [ ! -d "/var/www/html" ]; then
  mkdir -p /var/www/html
fi
cd /var/www/html

# Proje dizini varsa sil
rm -rf TRPanel

# Git reposunu klonla
git clone https://github.com/duran004/TRPanel.git
cd TRPanel

# Alt scripti çalıştır
source bashes/init.sh
