#!/bin/bash
echo "### phpmyadmin.sh ###"

# Kullanıcı adı ve şifreyi ayarla
read -p "phpMyAdmin kullanıcı adını girin (varsayılan: duran): " DB_USER
DB_USER=${DB_USER:-duran}  # Kullanıcı adı girilmezse duran kullanılır

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

# MySQL kullanıcısının mevcut olup olmadığını kontrol et ve şifreyi güncelle
echo "MySQL kullanıcı ayarları yapılıyor..."
sudo mysql -u root <<EOF
-- Kullanıcı varsa şifresini günceller, yoksa oluşturur
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
-- Kullanıcının şifresini ve kimlik doğrulama yöntemini günceller
ALTER USER '${DB_USER}'@'localhost' IDENTIFIED WITH mysql_native_password BY '${DB_PASS}';
-- Kullanıcıya tüm veritabanları için tüm yetkileri verir
GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'localhost' WITH GRANT OPTION;
-- Yetkileri güncelle
FLUSH PRIVILEGES;
EOF

# phpMyAdmin kuruluysa yeniden kurulum yapmadan devam et
if dpkg -l | grep -q phpmyadmin; then
    echo "phpMyAdmin zaten yüklü."
else
    echo "phpMyAdmin yükleniyor..."
    sudo apt-get update
    echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | sudo debconf-set-selections
    echo "phpmyadmin phpmyadmin/mysql/admin-pass password ${DB_PASS}" | sudo debconf-set-selections
    echo "phpmyadmin phpmyadmin/mysql/app-pass password ${DB_PASS}" | sudo debconf-set-selections
    sudo apt-get install phpmyadmin -y
fi

# phpMyAdmin'i Apache'e ekle
if [ ! -f /etc/apache2/conf-available/phpmyadmin.conf ]; then
    echo "Apache yapılandırılıyor..."
    sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
    sudo a2enconf phpmyadmin
fi

# MySQL kimlik doğrulama ayarları
echo "MySQL kimlik doğrulama ayarları değiştiriliyor..."
sudo mysql -u root <<EOF
ALTER USER '${DB_USER}'@'localhost' IDENTIFIED WITH mysql_native_password BY '${DB_PASS}';
FLUSH PRIVILEGES;
EOF

# Apache'yi yeniden başlat
echo "Apache yeniden başlatılıyor..."
sudo service apache2 restart

echo "Kurulum tamamlandı."


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
