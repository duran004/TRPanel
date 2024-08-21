#!/bin/bash
echo "### phpmyadmin.sh ###"

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

# MySQL root kullanıcısının kimlik doğrulama eklentisini 'auth_socket'tan 'mysql_native_password'a değiştir
echo "### MySQL root kimlik doğrulama yöntemi değiştiriliyor ###"
sudo mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'YeniSifre';
FLUSH PRIVILEGES;
EOF

echo -e "${GREEN}### ${lang[completed]} ###${NC}"
