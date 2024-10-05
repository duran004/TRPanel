#!/bin/bash

MYSQL_USER="root"
MYSQL_PASS="123456"

# MySQL'i tamamen kaldıran fonksiyon
purge_mysql() {
  log "${YELLOW}### MySQL tamamen kaldırılıyor... ###${NC}"
  sudo systemctl stop mysql
  sudo apt-get remove --purge mysql-server mysql-client mysql-common mysql-server-core-* mysql-client-core-* -y
  sudo apt-get remove --purge mysql-\* -y
  sudo apt-get autoremove -y
  sudo apt-get autoclean
  sudo rm -rf /etc/mysql /var/lib/mysql /var/log/mysql*
  sudo deluser mysql
  sudo delgroup mysql
}

# MySQL'i yeniden yükleyen fonksiyon
install_mysql() {
  log "${YELLOW}### MySQL yeniden yükleniyor... ###${NC}"
  sudo apt-get update
  sudo apt-get install mysql-server mysql-client -y
}
optimize_mysql_config() {
  log "${YELLOW}### MySQL yapılandırması optimize ediliyor... ###${NC}"

  sudo bash -c 'cat > /etc/mysql/my.cnf' << EOF
[mysqld]
max_connections = 100
innodb_buffer_pool_size = 512M
key_buffer_size = 16M
EOF

  log "${GREEN}### MySQL yapılandırması optimize edildi ###${NC}"
}

# MySQL servisini yeniden başlatan fonksiyon
restart_mysql_service() {
  log "${YELLOW}### MySQL servisi yeniden başlatılıyor... ###${NC}"
  sudo systemctl restart mysql
  if [ $? -ne 0 ]; then
    log "${RED}### MySQL servisi yeniden başlatılamadı ###${NC}"
    exit 1
  fi
}

# MySQL servisini başlatan fonksiyon
start_mysql_service() {
  log "${YELLOW}### MySQL servisi başlatılıyor... ###${NC}"
  sudo systemctl start mysql
  if [ $? -ne 0 ]; then
    log "${RED}### MySQL servisi başlatılamadı ###${NC}"
    exit 1
  fi
}

# MySQL root parolasını değiştiren fonksiyon
set_mysql_root_password() {
  log "${BLUE}### MySQL root parolası ayarlanıyor... ###${NC}"
  sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASS}'; FLUSH PRIVILEGES;"
}

# Ana fonksiyon
main() {
  log "${GREEN} $(figlet -f slant "MySQL Kurulumu") ${NC}"
  purge_mysql
  install_mysql
  optimize_mysql_config
  start_mysql_service
  set_mysql_root_password
  restart_mysql_service
  log "${GREEN}### MySQL kurulumu tamamlandı ###${NC}"
}

main
