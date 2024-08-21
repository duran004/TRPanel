#!/bin/bash
echo "### phpmyadmin.sh ###"

# Kullanıcı adı ve şifreyi ayarla
DB_USER="root"    # phpMyAdmin veritabanı kullanıcı adı sor
DB_PASS="123" # phpMyAdmin veritabanı şifresi
DB_PASS2="123" # phpMyAdmin veritabanı şifresi tekrar
# echo -e "${YELLOW}### phpMyAdmin ${lang[db_user]} ###${NC}"
# read DB_USER
echo -e "${YELLOW}### phpMyAdmin ${lang[db_pass]} ###${NC}"
read DB_PASS
echo -e "${YELLOW}### phpMyAdmin ${lang[db_pass_repeat]} ###${NC}"
read DB_PASS2
if [ "$DB_PASS" != "$DB_PASS2" ]; then
  echo -e "${RED}### ${lang[passwords_not_match]} ###${NC}"
  exit 1
fi
echo -e "${GREEN}### ${DB_USER}:${DB_PASS} ###${NC}"

# phpMyAdmin yükle
echo -e "${YELLOW}### phpMyAdmin ${lang[installing]} ###${NC}"
sudo apt-get install phpmyadmin -y

# phpMyAdmin yüklü mü kontrol et
if [ ! -f /etc/phpmyadmin/config.inc.php ]; then
    echo -e "${RED}### phpMyAdmin ${lang[not_installed]} ###${NC}"
  exit 1
else
    echo -e "${GREEN}### phpMyAdmin ${lang[installed]} ###${NC}"
fi

# phpMyAdmin'i Apache'e ekle
echo -e "${YELLOW}### phpMyAdmin ${lang[configuring]} ###${NC}"
sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
sudo a2enconf phpmyadmin

# Apache'yi yeniden başlat
echo -e "${YELLOW}### Apache ${lang[restarting]} ###${NC}"
sudo service apache2 restart

# phpMyAdmin'e erişim izni ver
echo -e "${YELLOW}### phpMyAdmin ${lang[allowing_access]} ###${NC}"
sudo sed -i "s/   Allow from None/    Allow from All/g" /etc/phpmyadmin/apache.conf

# Apache'yi yeniden başlat
echo -e "${YELLOW}### Apache ${lang[restarting]} ###${NC}"
sudo service apache2 restart

# phpMyAdmin için veritabanı yapılandırması
echo -e "${YELLOW}### phpMyAdmin ${lang[db_configuring]} ###${NC}"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password ${DB_PASS}"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password ${DB_PASS}"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/reconfig-root-password password ${DB_PASS}"
# sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-user string ${DB_USER}"

# phpMyAdmin yapılandırmasını güncelle
echo -e "${YELLOW}### phpMyAdmin ${lang[reconfiguring]} ###${NC}"
sudo dpkg-reconfigure phpmyadmin

# MySQL root kullanıcısının kimlik doğrulama eklentisini 'auth_socket'tan 'mysql_native_password'a değiştir
echo -e "${YELLOW}### MySQL ${lang[changing_auth_plugin]} ###${NC}"
sudo mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${DB_PASS}';
FLUSH PRIVILEGES;
EOF

echo -e "${GREEN}### phpMyAdmin ${lang[completed]} ###${NC}"
