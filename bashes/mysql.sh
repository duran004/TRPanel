#!/bin/bash

log -e "${GREEN} $(figlet -f slant "MySQL Kurulumu") ${NC}"
MYSQL_USER="root"
MYSQL_PASS="123456"

# MySQL tamamen kaldır
log -e "${YELLOW}### MySQL tamamen kaldırılıyor... ###${NC}"
sudo systemctl stop mysql
sudo apt-get remove --purge mysql-server mysql-client mysql-common mysql-server-core-* mysql-client-core-* -y
sudo apt-get remove --purge mysql-\*
sudo apt-get autoremove -y
sudo apt-get autoclean

# MySQL ile ilgili tüm dosyaları sil
log -e "${YELLOW}### MySQL ile ilgili tüm dosyalar temizleniyor... ###${NC}"
sudo rm -rf /etc/mysql /var/lib/mysql /var/log/mysql*
sudo deluser mysql
sudo delgroup mysql

# MySQL yeniden yükle
log -e "${YELLOW}### MySQL yeniden yükleniyor... ###${NC}"
sudo apt-get update
sudo apt-get install mysql-server mysql-client -y

# Grup ve kullanıcı oluştur
sudo groupadd mysql
sudo useradd -r -g mysql -s /bin/false mysql

# MySQL veri dizinini oluştur ve izinleri ayarla
log -e "${YELLOW}### MySQL veri dizini oluşturuluyor... ###${NC}"
sudo mkdir -p /var/lib/mysql
sudo chown -R mysql:mysql /var/lib/mysql
sudo chmod 750 /var/lib/mysql

# MySQL servisini başlat
log -e "${YELLOW}### MySQL servisi başlatılıyor... ###${NC}"
if ! sudo systemctl start mysql; then
  log -e "${RED}### MySQL servisi başlatılamadı ###${NC}"
  sudo journalctl -xeu mysql.service
  exit 1
fi

# MySQL root parolasını belirle
log -e "${BLUE}### MySQL root parolası ayarlanıyor... ###${NC}"
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASS}'; FLUSH PRIVILEGES;"


log -e "${GREEN}### İşlem tamamlandı ###${NC}"
