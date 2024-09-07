#!/bin/bash
log "${GREEN} $(figlet -f slant "phpMyAdmin Kurulumu") ${NC}"

# Kullanıcı adı ve şifreyi ayarla

log "### Kullanıcı: ${MYSQL_USER} ###"

# Var olan phpMyAdmin'i tamamen kaldır
log "phpMyAdmin kaldırılıyor..."
sudo apt-get remove --purge phpmyadmin -y
sudo apt-get autoremove -y
sudo apt-get autoclean

# Eski phpMyAdmin yapılandırma dosyalarını sil
sudo rm -rf /etc/phpmyadmin
sudo rm -rf /usr/share/phpmyadmin

# MySQL kullanıcı ayarları
log "MySQL kullanıcı ayarları güncelleniyor..."
sudo mysql -u root <<EOF
-- Kullanıcı varsa şifresini günceller, yoksa oluşturur
DROP USER IF EXISTS '${MYSQL_USER}'@'localhost';
CREATE USER '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASS}';
ALTER USER '${MYSQL_USER}'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASS}';
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# phpMyAdmin temiz bir kurulum yap
log "phpMyAdmin yeniden yükleniyor..."
sudo apt-get update
log "phpmyadmin phpmyadmin/dbconfig-install boolean true" | sudo debconf-set-selections
log "phpmyadmin phpmyadmin/mysql/admin-pass password ${MYSQL_PASS}" | sudo debconf-set-selections
log "phpmyadmin phpmyadmin/mysql/app-pass password ${MYSQL_PASS}" | sudo debconf-set-selections
sudo apt-get install phpmyadmin -y

# phpMyAdmin'i Apache'e ekle
if [ ! -f /etc/apache2/conf-available/phpmyadmin.conf ]; then
    log "Apache yapılandırılıyor..."
    sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
    sudo a2enconf phpmyadmin
fi

# Apache'yi yeniden başlat
log "Apache yeniden başlatılıyor..."
sudo service apache2 restart



# Örnek veritabanı oluştur
log "Veritabanı ve tablo oluşturuluyor..."
sudo mysql -u ${MYSQL_USER} -p${MYSQL_PASS} <<EOF
CREATE DATABASE IF NOT EXISTS trpanel;
USE trpanel;
CREATE TABLE IF NOT EXISTS test (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255));
INSERT INTO test (name) VALUES ('Duran Can Yılmaz');
INSERT INTO test (name) VALUES ('test');
EOF

log "Kurulum tamamlandı."
