#!/bin/bash
log "${GREEN} $(figlet -f slant "Apache2 Kurulumu") ${NC}"
# Apache2 yükle
log "${YELLOW}### Apache2 ${lang[installing]} ###${NC}"
sudo apt-get install apache2 -y
# Apache2 yüklü mü kontrol et
if ! dpkg -l | grep -q apache2; then
  log "${RED}Apache2 ${lang[not_installed]}.${NC}"
  exit 1
else
  log "${GREEN}Apache2 ${lang[installed]}.${NC}"
fi
# Apache'nin ayarlarını değiştir
log "${YELLOW}### Apache ${lang[configuring]} ###${NC}"
if [ -f /etc/apache2/apache2.conf ]; then
  sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
  log "${GREEN}### Apache ${lang[configured]} ###${NC}"
else
  log "${RED}### Apache ${lang[not_configured]} ###${NC}"
  exit 1
fi

# Apache'nin mod_rewrite modülünü etkinleştir
log "${YELLOW}### Mod_Rewrite ${lang[enabling]} ###${NC}"
if a2enmod rewrite; then
  log "${GREEN}### Mod_Rewrite ${lang[enabled]} ###${NC}"
else
  log "${RED}### Mod_Rewrite ${lang[not_enabled]} ###${NC}"
  exit 1
fi

# Apache  servislerini kontrol et
log "${YELLOW}### Apache ${lang[enabling]} ###${NC}"
if ! service apache2 status > /dev/null 2>&1; then
  log "${YELLOW}### Apache ${lang[enabling]} ###${NC}"
  if ! service apache2 start; then
    log "${RED}### Apache ${lang[not_enabled]} ###${NC}"
    exit 1
  fi
else
  log "${GREEN}### Apache ${lang[enabled]} ###${NC}"
fi


# Apache'yi yeniden başlat
log "${YELLOW}### Apache ${lang[restarting]} ###${NC}"
if ! sudo systemctl restart apache2; then
  log "${RED}### Apache ${lang[not_restarted]} ###${NC}"
  exit 1
fi

log "${GREEN}### Apache  ${lang[restarted]} ###${NC}"
log "${GREEN}### ${lang[completed]} ###${NC}"