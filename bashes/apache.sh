#!/bin/bash
log -e "${GREEN} $(figlet -f slant "Apache2 Kurulumu") ${NC}"
# Apache2 yükle
log -e "${YELLOW}### Apache2 ${lang[installing]} ###${NC}"
sudo apt-get install apache2 -y
# Apache2 yüklü mü kontrol et
if ! dpkg -l | grep -q apache2; then
  log -e "${RED}Apache2 ${lang[not_installed]}.${NC}"
  exit 1
else
  log -e "${GREEN}Apache2 ${lang[installed]}.${NC}"
fi
# Apache'nin ayarlarını değiştir
log -e "${YELLOW}### Apache ${lang[configuring]} ###${NC}"
if [ -f /etc/apache2/apache2.conf ]; then
  sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
  log -e "${GREEN}### Apache ${lang[configured]} ###${NC}"
else
  log -e "${RED}### Apache ${lang[not_configured]} ###${NC}"
  exit 1
fi

# Apache'nin mod_rewrite modülünü etkinleştir
log -e "${YELLOW}### Mod_Rewrite ${lang[enabling]} ###${NC}"
if a2enmod rewrite; then
  log -e "${GREEN}### Mod_Rewrite ${lang[enabled]} ###${NC}"
else
  log -e "${RED}### Mod_Rewrite ${lang[not_enabled]} ###${NC}"
  exit 1
fi

# Apache  servislerini kontrol et
log -e "${YELLOW}### Apache ${lang[enabling]} ###${NC}"
if ! service apache2 status > /dev/null 2>&1; then
  log -e "${YELLOW}### Apache ${lang[enabling]} ###${NC}"
  if ! service apache2 start; then
    log -e "${RED}### Apache ${lang[not_enabled]} ###${NC}"
    exit 1
  fi
else
  log -e "${GREEN}### Apache ${lang[enabled]} ###${NC}"
fi


# Apache'yi yeniden başlat
log -e "${YELLOW}### Apache ${lang[restarting]} ###${NC}"
if ! sudo systemctl restart apache2; then
  log -e "${RED}### Apache ${lang[not_restarted]} ###${NC}"
  exit 1
fi

log -e "${GREEN}### Apache  ${lang[restarted]} ###${NC}"
log -e "${GREEN}### ${lang[completed]} ###${NC}"