#!/bin/bash

echo -e "${GREEN}### apache_settings.sh ###${NC}"

# Apache'nin ayarlarını değiştir
echo -e "${YELLOW}### Apache ayarları değiştiriliyor ###${NC}"
if [ -f /etc/apache2/apache2.conf ]; then
  sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
  echo -e "${GREEN}### Apache ayarları değiştirildi ###${NC}"
else
  echo -e "${RED}### Apache konfigürasyon dosyası bulunamadı ###${NC}"
  exit 1
fi

# Apache'nin mod_rewrite modülünü etkinleştir
echo -e "${YELLOW}### Mod_Rewrite modülü etkinleştiriliyor ###${NC}"
if a2enmod rewrite; then
  echo -e "${GREEN}### Mod_Rewrite etkinleştirildi ###${NC}"
else
  echo -e "${RED}### Mod_Rewrite etkinleştirilemedi ###${NC}"
  exit 1
fi

# Apache ve MySQL servislerini kontrol et
echo -e "${YELLOW}### Apache ve MySQL servisleri başlatılıyor ###${NC}"

if ! service apache2 status > /dev/null 2>&1; then
  echo -e "${YELLOW}### Apache servisi başlatılmıyor, başlatılıyor... ###${NC}"
  if ! service apache2 start; then
    echo -e "${RED}### Apache servisi başlatılamadı ###${NC}"
    exit 1
  fi
else
  echo -e "${GREEN}### Apache servisi zaten çalışıyor ###${NC}"
fi

if ! service mysql status > /dev/null 2>&1; then
  echo -e "${YELLOW}### MySQL servisi başlatılmıyor, başlatılıyor... ###${NC}"
  if ! service mysql start; then
    echo -e "${RED}### MySQL servisi başlatılamadı ###${NC}"
    exit 1
  fi
else
  echo -e "${GREEN}### MySQL servisi zaten çalışıyor ###${NC}"
fi

# Apache'yi yeniden başlat
echo -e "${YELLOW}### Apache servisi yeniden başlatılıyor ###${NC}"
if ! sudo systemctl restart apache2; then
  echo -e "${RED}### Apache servisi yeniden başlatılamadı ###${NC}"
  exit 1
fi

echo -e "${GREEN}### Apache ve MySQL başlatıldı ###${NC}"
