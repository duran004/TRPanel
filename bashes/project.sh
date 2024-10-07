#!/bin/bash

log "${GREEN} $(figlet -f slant "Proje Kurulumu") ${NC}"
create_user() {
  log "${YELLOW}Kullanıcı oluşturuluyor: $USER_NAME${NC}"
  if id "$USER_NAME" &>/dev/null; then
    log "${RED}Kullanıcı zaten var: $USER_NAME atlanıyor${NC}"
    del_user $USER_NAME
  fi
  sudo useradd -m $USER_NAME
  sudo usermod -a -G www-data $USER_NAME
  sudo usermod -aG sudo $USER_NAME
  sudo chown -R $USER_NAME:www-data /home/$USER_NAME
  sudo chmod -R 755 /home/$USER_NAME
  #check if user is created
  if [ $? -eq 0 ]; then
    log "${GREEN}Kullanıcı oluşturuldu: $USER_NAME${NC}"
  else
    log "${RED}Kullanıcı oluşturulamadı: $USER_NAME${NC}"
    exit 1
  fi
  # Kullanıcıya ait dizinler oluştur
  sudo -u $USER_NAME mkdir -p /home/$USER_NAME/public_html/TRPanelLaravel
  sudo -u $USER_NAME mkdir -p /home/$USER_NAME/logs
}
del_user() {
  local USER_NAME=$1

  # Kullanıcının sistemde olup olmadığını kontrol et
  if id "$USER_NAME" &>/dev/null; then
    echo -e "${YELLOW}$USER_NAME kullanıcısı siliniyor...${NC}"
    
    # PHP-FPM havuz dosyasını sil
    local FPM_POOL_FILE="/etc/php/8.3/fpm/pool.d/${USER_NAME}.conf"
    if [ -f "$FPM_POOL_FILE" ]; then
      echo -e "${YELLOW}PHP-FPM havuz dosyası siliniyor: $FPM_POOL_FILE${NC}"
      sudo rm -f "$FPM_POOL_FILE"
    else
      echo -e "${YELLOW}PHP-FPM havuz dosyası bulunamadı: $FPM_POOL_FILE${NC}"
    fi

    # PHP-FPM servisini yeniden başlat
    echo -e "${YELLOW}PHP-FPM servisi yeniden başlatılıyor...${NC}"
    sudo systemctl restart php8.3-fpm

    # Kullanıcıyı ve ev dizinini sil
    echo -e "${YELLOW}Kullanıcı ve ev dizini siliniyor: $USER_NAME${NC}"
    sudo deluser --remove-home "$USER_NAME"

    # Kullanıcı grubunu sil
    echo -e "${YELLOW}Kullanıcı grubu siliniyor: $USER_NAME${NC}"
    sudo delgroup "$USER_NAME"

    echo -e "${GREEN}$USER_NAME kullanıcısı ve ilgili dosyalar başarıyla silindi.${NC}"
  else
    echo -e "${RED}$USER_NAME kullanıcısı bulunamadı.${NC}"
  fi
}
install_trpanel() {
  log "${YELLOW}TRPanel klonlanıyor...${NC}"
  if [ -d "/home/$USER_NAME/public_html/TRPanelLaravel" ]; then
    log "${RED}TRPanel zaten var: /home/$USER_NAME/public_html/TRPanelLaravel siliniyor${NC}"
    sudo rm -rf /home/$USER_NAME/public_html/TRPanelLaravel
    if [ $? -eq 0 ]; then
      log "${GREEN}TRPanel başarıyla silindi.${NC}"
    else
      log "${RED}TRPanel silinemedi.${NC}"
      exit 1
    fi
  fi
  sudo -u $USER_NAME git clone https://github.com/duran004/TRPanel-Laravel.git /home/$USER_NAME/public_html/TRPanelLaravel
    if [ $? -eq 0 ]; then
        log "${GREEN}TRPanel başarıyla klonlandı.${NC}"
    else
        log "${RED}TRPanel klonlanamadı.${NC}"
        exit 1
    fi
}
# Proje bağımlılıklarını yükleyen fonksiyon
install_dependencies() {
    log "${YELLOW}### Proje bağımlılıkları yükleniyor... ###${NC}"

    cd /home/trpanel/public_html/TRPanelLaravel || { log "${RED}Proje dizini bulunamadı!${NC}"; exit 1; }

    # Composer bağımlılıklarını yükle
    if ! composer install; then
        log "${RED}Composer bağımlılıkları yüklenirken hata oluştu!${NC}"
        exit 1
    fi

    # NPM bağımlılıklarını yükle
    if ! npm install; then
        log "${RED}NPM bağımlılıkları yüklenirken hata oluştu!${NC}"
        exit 1
    fi

    # Vite ile build işlemi
    if ! npm run build; then
        log "${RED}Vite build işlemi başarısız oldu!${NC}"
        exit 1
    fi

    log "${GREEN}### Proje bağımlılıkları başarıyla yüklendi ###${NC}"
}

# Laravel Projesini başlatan fonksiyon
setup_laravel() {
    log "${YELLOW}### Laravel setup işlemleri yapılıyor... ###${NC}"

    # .env dosyasını oluştur
    if ! cp .env.example .env; then
        log "${RED}.env dosyası oluşturulamadı!${NC}"
        exit 1
    fi

    # Uygulama anahtarını oluştur
    if ! php artisan key:generate; then
        log "${RED}Laravel uygulama anahtarı oluşturulamadı!${NC}"
        exit 1
    fi

    # Veritabanı migrasyonlarını çalıştır
    if ! php artisan migrate; then
        log "${RED}Veritabanı migrasyonları başarısız!${NC}"
        exit 1
    fi

    # Veritabanına seed ekle
    if ! php artisan db:seed; then
        log "${RED}Veritabanı seed işlemi başarısız!${NC}"
        exit 1
    fi

    # Storage link oluştur
    if ! php artisan storage:link; then
        log "${RED}Storage link oluşturulamadı!${NC}"
        exit 1
    fi

    log "${GREEN}### Laravel setup işlemleri tamamlandı ###${NC}"
}

# Laravel Sunucusunu başlatan fonksiyon
start_laravel_server() {
    log "${YELLOW}### Laravel sunucusu başlatılıyor... ###${NC}"

    if ! php artisan serve --host=0.0.0.0 --port=8000; then
        log "${RED}Laravel sunucusu başlatılamadı!${NC}"
        exit 1
    fi

    log "${GREEN}### Laravel sunucusu başarıyla başlatıldı ###${NC}"
}

# Ana fonksiyon (Main)
main() {
    create_user                  # Kullanıcı oluştur
    install_trpanel              # TRPanel klonla
    install_dependencies         # Bağımlılıkları yükler
    setup_laravel                # Laravel setup işlemlerini yapar
    #start_laravel_server         # Laravel sunucusunu başlatır
}

main  # Main fonksiyonunu çağır
