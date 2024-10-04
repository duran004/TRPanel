#!/bin/bash

# Gerekli paketleri yükle
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

# Global uzantıları devre dışı bırakma
disable_global_extensions() {
  sudo mv /etc/php/8.3/fpm/conf.d/20-mbstring.ini /etc/php/8.3/fpm/conf.d/20-mbstring.ini.disabled
  sudo mv /etc/php/8.3/fpm/conf.d/20-redis.ini /etc/php/8.3/fpm/conf.d/20-redis.ini.disabled
}

# php.ini dosyasını düzenleme
edit_php_ini() {
  sudo sed -i 's/;disable_functions =/disable_functions = exec,passthru,shell_exec,system,proc_open,popen,curl_exec,curl_multi_exec,parse_ini_file,show_source/g' /etc/php/8.3/fpm/php.ini
}

# Ana fonksiyon
main() {
  install_packages
  install_php_extensions
  disable_global_extensions
  edit_php_ini
}

main
