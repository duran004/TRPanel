
VHOST_CONF_PATH="/etc/apache2/sites-available/trpanel.local.conf"
HOSTS_FILE="/etc/hosts"
SERVER_NAME="trpanel.local"
USER_NAME="trpanel"
FPM_SOCK_PATH="/run/php/php8.3-fpm.trpanel.sock"  # PHP-FPM socket yolu
DOCUMENT_ROOT="/home/trpanel/public_html/TRPanelLaravel/public"



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
php_admin_value[open_basedir] = /home/trpanel:/tmp
php_admin_value[session.save_path] = /home/trpanel/sessions
php_admin_value[upload_tmp_dir] = /home/trpanel/tmp
php_admin_value[error_log] = /home/trpanel/logs/php-error.log
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[log_errors] = on
EOF

  log "${GREEN}PHP-FPM havuzu oluşturuldu: $FPM_CONF_PATH${NC}"
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
main() {
  create_virtualhost
  update_hosts_file
  enable_virtualhost
  create_php_fpm_pool
  restart_php_fpm
  restart_apache

  log "${GREEN}PHP-FPM ile Virtual host yapılandırması tamamlandı.${NC}"
}

main