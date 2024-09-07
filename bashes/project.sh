#!/bin/bash
log "${GREEN} $(figlet -f slant "Proje Kurulumu") ${NC}"

#npm kur
log "${YELLOW}### Npm ${lang[installing]} ###${NC}"
sudo apt install -y npm
log "${GREEN}### Npm ${lang[installed]} ###${NC}"
# vite kur
log "${YELLOW}### Vite ${lang[installing]} ###${NC}"
npm install -g create-vite
log "${GREEN}### Vite ${lang[installed]} ###${NC}"


# Composer'ı indir
log "${YELLOW}### Composer ${lang[installing]} ###${NC}"
curl -sS https://getcomposer.org/installer -o composer-setup.php
# Composer'ı yükle
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
# Composer'ı temizle
php -r "unlink('composer-setup.php');"
# Composer'ı PATH'e ekle
export PATH=$PATH:/usr/local/bin
log "${GREEN}### Composer ${lang[installed]} ###${NC}"

# gitden projey çek /var/www/html dizinine
cd /var/www/html
# varsa sil
sudo rm -rf TRPanelLaravel
git clone https://github.com/duran004/TRPanel-Laravel.git TRPanelLaravel

# Proje dizinine yetki ver
log "${BLUE} ${lang[project_permissions_changing]}...${NC}"
git config --global --add safe.directory /var/www/html/TRPanelLaravel
chown -R www-data:www-data TRPanelLaravel
chmod -R 755 TRPanelLaravel

sudo chown -R $USER:www-data storage
sudo chown -R $USER:www-data bootstrap/cache
sudo chmod -R 775 storage
sudo chmod -R 775 bootstrap/cache
sudo chown -R $USER:$USER /var/www/html/TRPanelLaravel

# sudo chown www-data:www-data TRPanel/.htaccess
log "${GREEN}### ${lang[project_permissions_changed]} ###${NC}"
cd /var/www/html/TRPanelLaravel
#.env.example dosyasını .env olarak kopyala
cp .env.example .env
composer install
npm run build
php artisan key:generate
php artisan migrate
php artisan db:seed
php artisan storage:link
php artisan serve --host=0.0.0.0 --port=8000

log "${GREEN}###  ${lang[composer_packages]} ${lang[installed]} ###${NC}"



log "${GREEN}### ${lang[completed]} ###${NC}"
