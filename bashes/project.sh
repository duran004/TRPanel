#!/bin/bash

log "${GREEN} $(figlet -f slant "Proje Kurulumu") ${NC}"

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
    if ! composer install --no-interaction; then
        log "${RED}Composer bağımlılıkları yüklenirken hata oluştu!${NC}"
        exit 1
    fi

    # NPM bağımlılıklarını yükle
    if ! npm install -y; then
        log "${RED}NPM bağımlılıkları yüklenirken hata oluştu!${NC}"
        exit 1
    fi

    # Vite ile build işlemi
    if ! npm run build -y; then
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
    install_trpanel              # TRPanel klonla
    install_dependencies         # Bağımlılıkları yükler
    setup_laravel                # Laravel setup işlemlerini yapar
    #start_laravel_server         # Laravel sunucusunu başlatır
}

main  # Main fonksiyonunu çağır
