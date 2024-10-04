#!/bin/bash

# Projeyi klonla ve dizini hazırla
clone_project() {
  log "${YELLOW}### Proje klonlanıyor ###${NC}"
  git clone https://github.com/duran004/TRPanel-Laravel.git /home/$TRPANEL_USER/public_html/TRPanelLaravel
  sudo chown -R $TRPANEL_USER:www-data /home/$TRPANEL_USER/public_html/TRPanelLaravel
  sudo chmod -R 755 /home/$TRPANEL_USER/public_html/TRPanelLaravel
}

# Composer ve NPM ile bağımlılıkları yükle
install_dependencies() {
  cd /home/$TRPANEL_USER/public_html/TRPanelLaravel
  composer install
  npm install
  npm run build
}

# Laravel projeyi yapılandır
setup_laravel() {
  cp .env.example .env
  php artisan key:generate
  php artisan migrate
  php artisan db:seed
  php artisan storage:link
}

# Laravel projesini çalıştır
start_laravel_server() {
  php artisan serve --host=0.0.0.0 --port=8000
}

# Ana fonksiyon
main() {
  clone_project
  install_dependencies
  setup_laravel
  start_laravel_server
}

main
