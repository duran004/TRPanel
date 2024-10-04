#!/bin/bash

# Gerekli LAMP paketlerini yükle
install_packages() {
  log "${YELLOW}### LAMP kuruluyor ###${NC}"
  packages="php-fpm apache2 mysql-server php-mysql php-gd php-xml php-zip"
  for package in $packages; do
      sudo apt install -y $package
      log "${GREEN}$package yüklendi.${NC}"
  done
}

# PHP uzantılarını yükle
install_php_extensions() {
  log "${YELLOW}### PHP uzantıları yükleniyor ###${NC}"
  php_packages="php8.3-fpm php-curl php-mbstring php-json"
  for php_package in $php_packages; do
    sudo apt install -y $php_package
    log "${GREEN}$php_package yüklendi.${NC}"
  done
}

# Composer'ı yükle
install_composer() {
  log "${YELLOW}### Composer yükleniyor ###${NC}"
  curl -sS https://getcomposer.org/installer -o composer-setup.php
  sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
  log "${GREEN}Composer yüklendi.${NC}"
}

# NPM'i yükle
install_npm() {
  log "${YELLOW}### Node.js ve NPM yükleniyor ###${NC}"
  sudo apt install -y nodejs npm
  log "${GREEN}Node.js ve NPM yüklendi.${NC}"
}

# Global uzantıları devre dışı bırakma
disable_global_extensions() {
  log "${YELLOW}### Global PHP uzantıları devre dışı bırakılıyor ###${NC}"
  sudo mv /etc/php/8.3/fpm/conf.d/20-mbstring.ini /etc/php/8.3/fpm/conf.d/20-mbstring.ini.disabled
  sudo mv /etc/php/8.3/fpm/conf.d/20-redis.ini /etc/php/8.3/fpm/conf.d/20-redis.ini.disabled
  log "${GREEN}Global PHP uzantıları devre dışı bırakıldı.${NC}"
}

# php.ini dosyasını düzenleme
edit_php_ini() {
  log "${YELLOW}### php.ini dosyası düzenleniyor ###${NC}"
  sudo sed -i 's/;disable_functions =/disable_functions = exec,passthru,shell_exec,system,proc_open,popen,curl_exec,curl_multi_exec,parse_ini_file,show_source/g' /etc/php/8.3/fpm/php.ini
  log "${GREEN}php.ini dosyası düzenlendi.${NC}"
}

# Ana fonksiyon
main() {
  install_packages               # LAMP paketlerini yükler
  install_php_extensions         # PHP uzantılarını yükler
  install_composer               # Composer'ı yükler
  install_npm                    # Node.js ve NPM'i yükler
  disable_global_extensions      # Global PHP uzantılarını devre dışı bırakır
  edit_php_ini                   # php.ini dosyasını düzenler
}

main
