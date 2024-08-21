#!/bin/bash
echo -e "${GREEN}### phpmyadmin.sh ###${NC}"
# phpMyAdmin yükle
echo -e "${YELLOW}### phpMyAdmin ${lang[installing]} ###${NC}"
sudo apt-get install phpmyadmin -y
# phpMyAdmin yüklü mü kontrol et
if [ ! -f /etc/phpmyadmin/config.inc.php ]; then
  echo -e "${RED}### phpMyAdmin ${lang[not_installed]} ###${NC}"
  exit 1
else
  echo -e "${GREEN}### phpMyAdmin ${lang[installed]} ###${NC}"
fi
# phpMyAdmin'i Apache'e ekle
echo -e "${YELLOW}### phpMyAdmin ${lang[adding_to_apache]} ###${NC}"
sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
sudo a2enconf phpmyadmin
# Apache'yi yeniden başlat
echo -e "${YELLOW}### Apache ${lang[restarting]} ###${NC}"
sudo service apache2 restart
# phpMyAdmin'e erişim izni ver
echo -e "${YELLOW}### phpMyAdmin ${lang[granting_access]} ###${NC}"
sudo sed -i "s/   Allow from None/    Allow from All/g" /etc/phpmyadmin/apache.conf
# Apache'yi yeniden başlat
echo -e "${YELLOW}### Apache ${lang[restarting]} ###${NC}"
sudo service apache2 restart
