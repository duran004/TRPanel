#!/bin/bash
echo "### phpmyadmin.sh ###"

# Kullanıcı adı ve şifreyi ayarla
DB_USER="root"    # phpMyAdmin veritabanı kullanıcı adı
DB_PASS="123" # phpMyAdmin veritabanı şifresi

# phpMyAdmin yükle
echo "### phpMyAdmin yükleniyor ###"
sudo apt-get install phpmyadmin -y

# phpMyAdmin yüklü mü kontrol et
if [ ! -f /etc/phpmyadmin/config.inc.php ]; then
  echo "### phpMyAdmin yüklenemedi ###"
  exit 1
else
  echo "### phpMyAdmin yüklendi ###"
fi

# phpMyAdmin'i Apache'e ekle
echo "### phpMyAdmin Apache'e ekleniyor ###"
sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
sudo a2enconf phpmyadmin

# Apache'yi yeniden başlat
echo "### Apache yeniden başlatılıyor ###"
sudo service apache2 restart

# phpMyAdmin'e erişim izni ver
echo "### phpMyAdmin erişim izni veriliyor ###"
sudo sed -i "s/   Allow from None/    Allow from All/g" /etc/phpmyadmin/apache.conf

# Apache'yi yeniden başlat
echo "### Apache yeniden başlatılıyor ###"
sudo service apache2 restart

# phpMyAdmin için veritabanı yapılandırması
echo "### phpMyAdmin veritabanı yapılandırması yapılıyor ###"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password ${DB_PASS}"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password ${DB_PASS}"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/reconfig-root-password password ${DB_PASS}"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-user string ${DB_USER}"

# phpMyAdmin yapılandırmasını güncelle
echo "### phpMyAdmin yapılandırması güncelleniyor ###"
sudo dpkg-reconfigure phpmyadmin

# MySQL root kullanıcısının kimlik doğrulama eklentisini 'auth_socket'tan 'mysql_native_password'a değiştir
echo "### MySQL root kimlik doğrulama yöntemi değiştiriliyor ###"
sudo mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${DB_PASS}';
FLUSH PRIVILEGES;
EOF

echo "### phpMyAdmin kurulumu tamamlandı ###"
