#!/bin/bash

# Apache'nin ayarlarını değiştir
echo -e "${YELLOW}### Apache ayarları değiştiriliyor ###${NC}"
sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf 
echo -e "${GREEN}### Apache ayarları değiştirildi ###${NC}"


# Apache'nin mod_rewrite modülünü etkinleştir
a2enmod rewrite

# Servisleri başlat
service apache2 start
service mysql start
# Apache'yi yeniden başlat
sudo systemctl restart apache2

echo -e "${GREEN}### Apache ve MySQL başlatıldı ###${NC}"
