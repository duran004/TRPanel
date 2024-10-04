#!/bin/bash


MYSQL_USER="root"
MYSQL_PASS="123456"

# phpMyAdmin'i tamamen kaldıran fonksiyon
purge_phpmyadmin() {
  log "phpMyAdmin kaldırılıyor..."
  sudo apt-get remove --purge phpmyadmin -y
  sudo apt-get autoremove -y
  sudo apt-get autoclean
  sudo rm -rf /etc/phpmyadmin /usr/share/phpmyadmin
}

# phpMyAdmin'i yükleyen fonksiyon
install_phpmyadmin() {
  log "phpMyAdmin yeniden yükleniyor..."
  sudo apt-get update
  echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | sudo debconf-set-selections
  echo "phpmyadmin phpmyadmin/mysql/admin-pass password ${MYSQL_PASS}" | sudo debconf-set-selections
  echo "phpmyadmin phpmyadmin/mysql/app-pass password ${MYSQL_PASS}" | sudo debconf-set-selections
  sudo apt-get install phpmyadmin -y
}

# phpMyAdmin'i Apache'ye bağlayan fonksiyon
configure_apache_for_phpmyadmin() {
  log "Apache yapılandırılıyor..."
  if [ ! -f /etc/apache2/conf-available/phpmyadmin.conf ]; then
    sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
    sudo a2enconf phpmyadmin
  fi
  sudo service apache2 restart
}

# MySQL kullanıcı ayarlarını yapan fonksiyon
setup_mysql_user() {
  log "MySQL kullanıcı ayarları güncelleniyor..."
  sudo mysql -u root <<EOF
DROP USER IF EXISTS '${MYSQL_USER}'@'localhost';
CREATE USER '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASS}';
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
}

# Örnek veritabanı oluşturan fonksiyon
create_sample_database() {
  log "Veritabanı ve tablo oluşturuluyor..."
  sudo mysql -u ${MYSQL_USER} -p${MYSQL_PASS} <<EOF
CREATE DATABASE IF NOT EXISTS trpanel;
USE trpanel;
CREATE TABLE IF NOT EXISTS test (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255));
INSERT INTO test (name) VALUES ('Duran Can Yılmaz');
INSERT INTO test (name) VALUES ('test');
EOF
}

# Ana fonksiyon
main() {
  log "${GREEN} $(figlet -f slant "phpMyAdmin Kurulumu") ${NC}"
  purge_phpmyadmin
  install_phpmyadmin
  configure_apache_for_phpmyadmin
  setup_mysql_user
  create_sample_database
  log "Kurulum tamamlandı."
}

main
