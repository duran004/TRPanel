#!/bin/bash
echo -e "${GREEN}### apache_settings.sh ###${NC}"
# Apache2 yükle
echo -e "${YELLOW}### Apache2 ${lang[installing]} ###${NC}"
sudo apt-get install apache2 -y
# Apache2 yüklü mü kontrol et
if ! dpkg -l | grep -q apache2; then
  echo -e "${RED}Apache2 ${lang[not_installed]}.${NC}"
  exit 1
else
  echo -e "${GREEN}Apache2 ${lang[installed]}.${NC}"
fi
# Apache'nin ayarlarını değiştir
echo -e "${YELLOW}### Apache ${lang[configuring]} ###${NC}"
if [ -f /etc/apache2/apache2.conf ]; then
  sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
  echo -e "${GREEN}### Apache ${lang[configured]} ###${NC}"
else
  echo -e "${RED}### Apache ${lang[not_configured]} ###${NC}"
  exit 1
fi

# Apache'nin mod_rewrite modülünü etkinleştir
echo -e "${YELLOW}### Mod_Rewrite ${lang[enabling]} ###${NC}"
if a2enmod rewrite; then
  echo -e "${GREEN}### Mod_Rewrite ${lang[enabled]} ###${NC}"
else
  echo -e "${RED}### Mod_Rewrite ${lang[not_enabled]} ###${NC}"
  exit 1
fi

# Apache ve MySQL servislerini kontrol et
echo -e "${YELLOW}### Apache & MySQL ${lang[enabling]} ###${NC}"
if ! service apache2 status > /dev/null 2>&1; then
  echo -e "${YELLOW}### Apache ${lang[enabling]} ###${NC}"
  if ! service apache2 start; then
    echo -e "${RED}### Apache ${lang[not_enabled]} ###${NC}"
    exit 1
  fi
else
  echo -e "${GREEN}### Apache ${lang[enabled]} ###${NC}"
fi

if ! service mysql status > /dev/null 2>&1; then
  echo -e "${YELLOW}### MySQL ${lang[enabling]} ###${NC}"
  if ! service mysql start; then
    echo -e "${RED}### MySQL ${lang[not_enabled]} ###${NC}"
    exit 1
  fi
else
  echo -e "${GREEN}### MySQL ${lang[enabled]} ###${NC}"
fi

# Apache'yi yeniden başlat
echo -e "${YELLOW}### Apache ${lang[restarting]} ###${NC}"
if ! sudo systemctl restart apache2; then
  echo -e "${RED}### Apache ${lang[not_restarted]} ###${NC}"
  exit 1
fi

echo -e "${GREEN}### Apache & MySQL ${lang[restarted]} ###${NC}"
