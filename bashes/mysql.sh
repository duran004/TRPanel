#!/bin/bash
echo -e "${GREEN}### mysql_settings.sh ###${NC}"
MYSQL_PASS="123456"
# MySQL tamamen kaldır
echo -e "${YELLOW}### MySQL tamamen kaldırılıyor... ###${NC}"
sudo systemctl stop mysql
sudo apt-get remove --purge mysql-server mysql-client mysql-common mysql-server-core-* mysql-client-core-* -y
sudo apt-get autoremove -y
sudo apt-get autoclean

# MySQL ile ilgili tüm dosyaları sil
echo -e "${YELLOW}### MySQL ile ilgili tüm dosyalar temizleniyor... ###${NC}"
sudo rm -rf /etc/mysql /var/lib/mysql /var/log/mysql* /var/log/mysql*
sudo deluser mysql
sudo delgroup mysql

# MySQL yeniden yükle
echo -e "${YELLOW}### MySQL yeniden yükleniyor... ###${NC}"
sudo apt-get update
sudo apt-get install mysql-server mysql-client -y

# MySQL servisini başlat
echo -e "${YELLOW}### MySQL servisi başlatılıyor... ###${NC}"
if ! sudo systemctl start mysql; then
  echo -e "${RED}### MySQL servisi başlatılamadı ###${NC}"
  exit 1
fi

# MySQL root parolasını belirle
if [ ! -f /var/lib/mysql/ibdata1 ]; then
  # echo -e "${BLUE}MySQL root parolasını belirleyin...${NC}"
  # read -sp "MySQL root şifresi: " mysql_root_password
  # echo
  # read -sp "MySQL root şifresi tekrar: " mysql_root_password_repeat
  # echo

  # # Parolaların eşleşip eşleşmediğini kontrol et
  # if [ "$mysql_root_password" != "$mysql_root_password_repeat" ]; then
  #   echo -e "${RED}Şifreler eşleşmiyor, lütfen tekrar deneyin.${NC}"
  #   exit 1
  # fi

  # MySQL root parolasını ayarla
  sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASS}'; FLUSH PRIVILEGES;"
fi

echo -e "${GREEN}### İşlem tamamlandı ###${NC}"
