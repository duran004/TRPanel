#!/bin/bash
echo "### phpmyadmin.sh ###"

# Kullanıcı adı ve şifreyi ayarla
read -p "phpMyAdmin kullanıcı adını girin (varsayılan: root): " DB_USER
DB_USER=${DB_USER:-root}  # Kullanıcı adı girilmezse root kullanılır

# Şifreyi al
read -sp "phpMyAdmin şifresi: " DB_PASS
echo
read -sp "phpMyAdmin şifresi tekrar: " DB_PASS2
echo

# Şifreler uyuşmuyor mu?
if [ "$DB_PASS" != "$DB_PASS2" ]; then
  echo "Şifreler uyuşmuyor, lütfen tekrar deneyin."
  exit 1
fi

echo "### Kullanıcı: ${DB_USER} ###"

# Var olan phpMyAdmin'i tamamen kaldır
echo "phpMyAdmin kaldırılıyor..."
sudo apt-get remove --purge phpmyadmin -y
sudo apt-get autoremove -y
sudo apt-get autoclean

# Eski phpMyAdmin yapılandırma dosyalarını sil
sudo rm -rf /etc/phpmyadmin
sudo rm -rf /usr/share/phpmyadmin

# MySQL kullanıcı ayarları
echo "MySQL kullanıcı ayarları güncelleniyor..."
sudo mysql -u root <<EOF
-- Kullanıcı varsa şifresini günceller, yoksa oluşturur
DROP USER IF EXISTS '${DB_USER}'@'localhost';
CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
ALTER USER '${DB_USER}'@'localhost' IDENTIFIED WITH mysql_native_password BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# phpMyAdmin temiz bir kurulum yap
echo "phpMyAdmin yeniden yükleniyor..."
sudo apt-get update
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password ${DB_PASS}" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password ${DB_PASS}" | sudo debconf-set-selections
sudo apt-get install phpmyadmin -y

# phpMyAdmin'i Apache'e ekle
if [ ! -f /etc/apache2/conf-available/phpmyadmin.conf ]; then
    echo "Apache yapılandırılıyor..."
    sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
    sudo a2enconf phpmyadmin
fi

# Apache'yi yeniden başlat
echo "Apache yeniden başlatılıyor..."
sudo service apache2 restart



# Örnek veritabanı oluştur
echo "Veritabanı ve tablo oluşturuluyor..."
sudo mysql -u ${DB_USER} -p${DB_PASS} <<EOF
CREATE DATABASE IF NOT EXISTS trpanel;
USE trpanel;
CREATE TABLE IF NOT EXISTS test (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255));
INSERT INTO test (name) VALUES ('Duran Can Yılmaz');
INSERT INTO test (name) VALUES ('test');
EOF

echo "Kurulum tamamlandı."
