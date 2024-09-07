#!/bin/bash
echo -e "${GREEN}### project_settings.sh ###${NC}"

#npm kur
echo -e "${YELLOW}### Npm ${lang[installing]} ###${NC}"
sudo apt install -y npm
echo -e "${GREEN}### Npm ${lang[installed]} ###${NC}"


echo -e "${YELLOW}### Composer ${lang[installing]} ###${NC}"
# Composer'ı indir
curl -sS https://getcomposer.org/installer -o composer-setup.php
# Composer'ı yükle
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
# Composer'ı temizle
php -r "unlink('composer-setup.php');"
# Composer'ı PATH'e ekle
export PATH=$PATH:/usr/local/bin

echo -e "${GREEN}### Composer ${lang[installed]} ###${NC}"

# gitden projey çek /var/www/html dizinine
cd /var/www/html
git clone https://github.com/duran004/TRPanel-Laravel.git Laravel

# Proje dizinine yetki ver
echo -e "${BLUE} ${lang[project_permissions_changing]}...${NC}"
git config --global --add safe.directory /var/www/html/Laravel
chown -R www-data:www-data Laravel
chmod -R 755 Laravel
# sudo chown www-data:www-data TRPanel/.htaccess
echo -e "${GREEN}### ${lang[project_permissions_changed]} ###${NC}"

cd /var/www/html/Laravel
composer install
npm run dev
php artisan key:generate
php artisan migrate
php artisan db:seed
php artisan storage:link
php artisan serve

echo -e "${GREEN}###  ${lang[composer_packages]} ${lang[installed]} ###${NC}"



echo -e "${GREEN}### ${lang[completed]} ###${NC}"
