#!/bin/bash

# Apache kurulumunu gerçekleştir
install_apache() {
  log "${YELLOW}### Apache kuruluyor ###${NC}"
  sudo apt-get install apache2 -y
}

# Apache yapılandırmasını düzenle
configure_apache() {
  log "${YELLOW}### Apache yapılandırması yapılıyor ###${NC}"
  sudo sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
  sudo a2enmod rewrite
}

# VirtualHost oluşturma
create_virtualhost() {
  log "${YELLOW}### VirtualHost yapılandırması ###${NC}"
  echo "<VirtualHost *:80>
      ServerName $TRPANEL_USER.local
      DocumentRoot /home/$TRPANEL_USER/public_html

      <Directory /home/$TRPANEL_USER/public_html>
          AllowOverride All
          Require all granted
      </Directory>

      <FilesMatch \.php$>
          SetHandler \"proxy:unix:/run/php/php8.3-fpm-$TRPANEL_USER.sock|fcgi://localhost\"
      </FilesMatch>

      ErrorLog ${APACHE_LOG_DIR}/$TRPANEL_USER_error.log
      CustomLog ${APACHE_LOG_DIR}/$TRPANEL_USER_access.log combined
  </VirtualHost>" | sudo tee /etc/apache2/sites-available/$TRPANEL_USER.conf

  sudo a2ensite $TRPANEL_USER.conf
}

# Apache yeniden başlatma
restart_apache() {
  log "${YELLOW}### Apache yeniden başlatılıyor ###${NC}"
  sudo systemctl restart apache2
}

# Ana fonksiyon
main() {
  install_apache
  configure_apache
  create_virtualhost
  restart_apache
}

main
