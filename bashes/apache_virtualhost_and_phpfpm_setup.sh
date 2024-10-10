
VHOST_CONF_PATH="/etc/apache2/sites-available/trpanel.local.conf"
HOSTS_FILE="/etc/hosts"
SERVER_NAME="trpanel.local"
USER_NAME="trpanel"
FPM_SOCK_PATH="/run/php/php8.3-fpm.trpanel.sock"  # PHP-FPM socket yolu
DOCUMENT_ROOT="/home/trpanel/public_html/TRPanelLaravel/public"
FPM_CONF_PATH="/etc/php/8.3/fpm/pool.d/trpanel.conf"

create_user() {
  log "${YELLOW}Kullanıcı oluşturuluyor: $USER_NAME${NC}"
  # daha önce yüklendiyse php-fpm servisini durdur çalışan süreçleri sonlandır
  sudo systemctl stop php8.3-fpm
  sudo systemctl stop apache2

  # kullanıcıyı sil
  del_user "$USER_NAME"

  # Kullanıcıyı oluştur
  sudo useradd -m "$USER_NAME"
  sudo usermod -a -G www-data "$USER_NAME"
  sudo usermod -aG sudo "$USER_NAME"
  sudo usermod -aG root "$USER_NAME"
  sudo chown -R "$USER_NAME:www-data" /home/"$USER_NAME"
  sudo chmod -R 755 /home/"$USER_NAME"

  # Kullanıcının başarıyla oluşturulup oluşturulmadığını kontrol et
  if [ $? -eq 0 ]; then
    log "${GREEN}Kullanıcı oluşturuldu: $USER_NAME${NC}"
  else
    log "${RED}Kullanıcı oluşturulamadı: $USER_NAME${NC}"
    exit 1
  fi

  # Kullanıcıya ait dizinler oluştur
  sudo -u "$USER_NAME" mkdir -p /home/"$USER_NAME"/public_html/TRPanelLaravel
  sudo -u "$USER_NAME" mkdir -p /home/"$USER_NAME"/logs

  # Kullanıcının sudoers dosyasında şifresiz sudo yetkisi olup olmadığını kontrol et ve yoksa ekle
  if ! sudo grep -q "^$USER_NAME ALL=(ALL) NOPASSWD: ALL" /etc/sudoers; then
    log "${YELLOW}$USER_NAME kullanıcısına sudoers dosyasına şifresiz sudo yetkisi ekleniyor...${NC}"
    echo "$USER_NAME ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers > /dev/null
    log "${GREEN}$USER_NAME kullanıcısına şifresiz sudo yetkisi verildi.${NC}"
  else
    log "${YELLOW}$USER_NAME kullanıcısının zaten şifresiz sudo yetkisi var.${NC}"
  fi

  log "${GREEN}$USER_NAME kullanıcısı root grubuna eklendi ve tam yetki verildi.${NC}"
}

del_user() {
  local USER_NAME=$1
  echo -e "${YELLOW}$USER_NAME kullanıcısı siliniyor...${NC}"

  # Kullanıcıya ait tüm süreçleri zorla sonlandır
  echo -e "${YELLOW}Kullanıcıya ait süreçler zorla sonlandırılıyor: $USER_NAME${NC}"
  sudo pkill -9 -u "$USER_NAME"

  # Hala çalışan süreç olup olmadığını kontrol et
  if ps -u "$USER_NAME" > /dev/null 2>&1; then
    echo -e "${RED}$USER_NAME kullanıcısına ait süreçler hala çalışıyor. Tekrar sonlandırılıyor...${NC}"
    sudo kill -9 $(ps -u "$USER_NAME" -o pid=)
  else
    echo -e "${GREEN}$USER_NAME kullanıcısına ait tüm süreçler başarıyla sonlandırıldı.${NC}"
  fi

  # PHP-FPM havuz dosyasını sil
  local FPM_POOL_FILE="/etc/php/8.3/fpm/pool.d/${USER_NAME}.conf"
  if [ -f "$FPM_POOL_FILE" ]; then
    echo -e "${YELLOW}PHP-FPM havuz dosyası siliniyor: $FPM_POOL_FILE${NC}"
    sudo rm -f "$FPM_POOL_FILE"
  else
    echo -e "${YELLOW}PHP-FPM havuz dosyası bulunamadı: $FPM_POOL_FILE${NC}"
  fi



  # Kullanıcıyı ve ev dizinini sil
  echo -e "${YELLOW}Kullanıcı ve ev dizini siliniyor: $USER_NAME${NC}"
  sudo deluser --remove-home "$USER_NAME"

  # Kullanıcı grubunu sil
  echo -e "${YELLOW}Kullanıcı grubu siliniyor: $USER_NAME${NC}"
  sudo delgroup "$USER_NAME"

  # Kullanıcıya ait kalıntı dosyaları ve günlükleri temizle
  echo -e "${YELLOW}Kullanıcıya ait kalıntı dosyaları temizleniyor...${NC}"
  sudo find / -user "$USER_NAME" -exec sudo rm -rf {} \; 2>/dev/null

  echo -e "${GREEN}$USER_NAME kullanıcısı ve ilgili dosyalar başarıyla silindi.${NC}"
}


# Virtual host yapılandırma dosyasını oluştur
create_virtualhost() {
  log "${YELLOW}Virtual host dosyası PHP-FPM ile oluşturuluyor...${NC}"
  
  sudo bash -c "cat > $VHOST_CONF_PATH" <<EOF
<VirtualHost *:80>
    ServerName $SERVER_NAME
    DocumentRoot $DOCUMENT_ROOT

    <Directory $DOCUMENT_ROOT>
        AllowOverride All
        Require all granted
    </Directory>

    <FilesMatch \.php$>
        SetHandler "proxy:unix:$FPM_SOCK_PATH|fcgi://localhost/"
    </FilesMatch>

    ErrorLog \${APACHE_LOG_DIR}/trpanel_error.log
    CustomLog \${APACHE_LOG_DIR}/trpanel_access.log combined
</VirtualHost>
EOF

  log "${GREEN}Virtual host dosyası oluşturuldu: $VHOST_CONF_PATH${NC}"
}

# /etc/hosts dosyasına giriş ekle
update_hosts_file() {
  if ! grep -q "$SERVER_NAME" $HOSTS_FILE; then
    log "${YELLOW}/etc/hosts dosyasına giriş ekleniyor...${NC}"
    echo "127.0.0.1 $SERVER_NAME" | sudo tee -a $HOSTS_FILE
    log "${GREEN}/etc/hosts dosyasına giriş eklendi.${NC}"
  else
    log "${YELLOW}/etc/hosts dosyasında $SERVER_NAME zaten mevcut.${NC}"
  fi
}

# Apache modüllerini etkinleştir ve virtual host'u etkinleştir
enable_virtualhost() {
  log "${YELLOW}Apache ayarları etkinleştiriliyor...${NC}"

  # Mod rewrite etkinleştir
  sudo a2enmod rewrite
  sudo a2enmod proxy_fcgi setenvif

  # Virtual host'u etkinleştir
  sudo a2ensite trpanel.local.conf

  log "${GREEN}Apache ayarları etkinleştirildi.${NC}"
}

# Apache'yi yeniden başlat
restart_apache() {
  log "${YELLOW}Apache yeniden başlatılıyor...${NC}"
  sudo systemctl restart apache2

  if [ $? -eq 0 ]; then
    log "${GREEN}Apache başarıyla yeniden başlatıldı.${NC}"
  else
    log "${RED}Apache yeniden başlatılamadı.${NC}"
    exit 1
  fi
}
# Kullanıcıya özel PHP-FPM havuzu oluştur
create_php_fpm_pool() {
  log "${YELLOW}PHP-FPM havuzu oluşturuluyor: trpanel${NC}"

  sudo bash -c "cat > $FPM_CONF_PATH" <<EOF
[trpanel]
user =trpanel
group = www-data
listen = $FPM_SOCK_PATH
listen.owner =trpanel
listen.group = www-data
listen.mode = 0660
pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
php_admin_value[session.save_path] = /home/trpanel/sessions
php_admin_value[upload_tmp_dir] = /home/trpanel/tmp
php_admin_value[error_log] = /home/trpanel/logs/php-error.log
php_admin_flag[log_errors] = on
EOF
  if [ $? -eq 0 ]; then
    log "${GREEN}PHP-FPM havuzu oluşturuldu: $FPM_CONF_PATH${NC}"
  else
    log "${RED}PHP-FPM havuzu oluşturulamadı: $FPM_CONF_PATH${NC}"
    exit 1
  fi
}

# PHP-FPM servisini yeniden başlat
restart_php_fpm() {
  log "${YELLOW}PHP-FPM yeniden başlatılıyor...${NC}"
  sudo systemctl restart php8.3-fpm

  if [ $? -eq 0 ]; then
    log "${GREEN}PHP-FPM başarıyla yeniden başlatıldı.${NC}"
  else
    log "${RED}PHP-FPM yeniden başlatılamadı.${NC}"
    exit 1
  fi
}
user_permission() {
  #$USER_NAME /etc/php/8.3/ içindeki tüm klasörlere yetki ver
  sudo chown -R "$USER_NAME:www-data" /etc/php/8.3/
  sudo chown -R "$USER_NAME:www-data" /home/"$USER_NAME"
  sudo chown -R "$USER_NAME:www-data" /etc/apache2/sites-available/
  sudo chmod -R 755 /home/"$USER_NAME"
  sudo chmod -R 755 /etc/php/8.3/
  sudo chmod -R 755 /etc/apache2/sites-available/
  sudo a2enmod proxy_fcgi setenvif
  sudo a2enmod rewrite
  sudo systemctl restart apache2

}
main() {
  create_user
  create_virtualhost
  update_hosts_file
  enable_virtualhost
  create_php_fpm_pool
  user_permission
  restart_php_fpm
  restart_apache

  log "${GREEN}PHP-FPM ile Virtual host yapılandırması tamamlandı.${NC}"
}

main