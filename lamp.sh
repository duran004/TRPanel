#!/bin/bash

# PHP, Apache, MySQL ve Git'i yüklemek için gerekli paket isimleri
packages="php apache2 mysql-server git"

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
echo -e "${YELLOW}### LAMP Kurulumu ###${NC}"
# Paketleri güncelle
apt update

# Paketler yüklü değilse yükle
for package in $packages; do
  if ! dpkg -l | grep -q $package; then
    apt install -y $package
  fi
done
echo -e "${GREEN}### LAMP Kurulumu Bitti ###${NC}"

# MySQL root parolasını belirle
if [ ! -f /var/lib/mysql/ibdata1 ]; then
  echo -e "${BLUE}MySQL root parolası belirleyin:${NC}"
  read -s mysql_root_password
  echo -e "${BLUE}MySQL root parolasını tekrar girin:${NC}"
  read -s mysql_root_password_repeat

  # Parolaların eşleşip eşleşmediğini kontrol et
  if [ "$mysql_root_password" != "$mysql_root_password_repeat" ]; then
    echo -e "${RED}Parolalar eşleşmiyor. Lütfen tekrar deneyin.${NC}"
    exit 1
  fi

  # MySQL root parolasını ayarla
  echo "mysql-server mysql-server/root_password password $mysql_root_password" | debconf-set-selections
  echo "mysql-server mysql-server/root_password_again password $mysql_root_password" | debconf-set-selections
fi
# PHP'nin MySQL eklentisini yükle
echo -e "${YELLOW}### PHP MySQL eklentisi yükleniyor ###${NC}"
apt install -y php-mysql php-curl php-gd php-intl php-json php-mbstring php-xml php-zip
echo -e "${GREEN}### PHP MySQL eklentisi yüklendi ###${NC}"

# Apache'nin mod_rewrite modülünü etkinleştir
a2enmod rewrite

# Servisleri başlat
service apache2 start
service mysql start

echo -e "${GREEN}### Apache ve MySQL başlatıldı ###${NC}"

echo -e "${YELLOW}### Composer Kurulumu ###${NC}"
# Composer'ı indir
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
echo -e "${GREEN}### Composer Kurulumu Bitti ###${NC}"

# gitden projey çek /var/www/html dizinine
cd /var/www/html
echo -e "${YELLOW}### Proje çekiliyor ###${NC}"
#varsa sil
rm -rf TRPanel
git clone https://github.com/duran004/TRPanel.git
git config --global --add safe.directory /var/www/html/TRPanel
echo -e "${GREEN}### Proje çekildi ###${NC}"
# Proje dizinine yetki ver
chown -R www-data:www-data TRPanel
chmod -R 755 TRPanel
echo -e "${GREEN}### Yetki verildi ###${NC}"

echo -e "${YELLOW}### Composer ile gerekli paketler yükleniyor ###${NC}"
cd TRPanel
composer install
echo -e "${GREEN}### Gerekli paketler yüklendi ###${NC}"


echo -e "${BLUE}Kurulum tamamlandı!${NC}"