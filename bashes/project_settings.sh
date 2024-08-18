#!/bin/bash




echo -e "${YELLOW}### Composer Kurulumu ###${NC}"
# Composer'ı indir
curl -sS https://getcomposer.org/installer -o composer-setup.php
# Composer'ı yükle
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
# Composer'ı temizle
php -r "unlink('composer-setup.php');"
# Composer'ı PATH'e ekle
export PATH=$PATH:/usr/local/bin

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
sudo chown www-data:www-data TRPanel/.htaccess
echo -e "${GREEN}### Yetki verildi ###${NC}"


echo -e "${YELLOW}### Composer ile gerekli paketler yükleniyor ###${NC}"
cd TRPanel
composer install
echo -e "${GREEN}### Gerekli paketler yüklendi ###${NC}"


echo -e "${BLUE}Kurulum tamamlandı!${NC}"