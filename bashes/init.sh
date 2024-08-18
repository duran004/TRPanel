#!/bin/bash

# PHP, Apache, MySQL ve Git'i yüklemek için gerekli paket isimleri
packages="php apache2 mysql-server"

# Renk kodları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Root kullanıcı olup olmadığını kontrol et
if [ "$(id -u)" != "0" ]; then
  echo -e "${RED}Bu komut dosyasını çalıştırmak için root yetkilerine ihtiyacınız var.${NC}"
  exit 1
fi


# Kullanıcıya paketlerin kaldırılmasını isteyip istemediğini sor
echo -e "${RED}Önceden yüklenmiş paketleri kaldırmak ister misiniz? (yes/no)${NC}"
read answer

if [ "$answer" == "yes" ]; then
  echo -e "${RED}### Daha önce yüklenmiş olan paketler kaldırılıyor ###"
  
  # Önceki kurulumları kaldır
  apt remove --purge -y $packages
  apt autoremove -y
  apt autoclean
  
  # MySQL veri dizinini kaldır (isteğe bağlı, tüm verileri siler)
  rm -rf /var/lib/mysql
  rm -rf /etc/mysql
  
  # Apache ve PHP konfigürasyon dosyalarını kaldır (isteğe bağlı, tüm ayarları siler)
  rm -rf /etc/apache2
  rm -rf /etc/php

  echo -e "${GREEN}### Paketler kaldırıldı, sistem temizlendi ###${NC}"
  
else
  echo -e "${YELLOW}### Paketler kaldırılmadı, mevcut kurulum devam ediyor ###${NC}"
fi



