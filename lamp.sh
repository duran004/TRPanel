#!/bin/bash
# Dizin yoksa oluştur
if [ ! -d "/var/www/html" ]; then
  mkdir -p /var/www/html
fi
cd /var/www/html
# Proje dizini varsa sil
rm -rf TRPanel
# Git yoksa yükle
if ! dpkg -l | grep -q git; then
  apt install -y git
fi
git clone https://github.com/duran004/TRPanel.git
cd TRPanel
source bashes/init.sh