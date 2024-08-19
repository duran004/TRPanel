#!/bin/bash

declare -A lang
lang=(
    [root_needed]="Bu projeyi çalıştırmak için root kullanıcısı olmalısınız."
    [have]="mevcut."
    [installed]="yüklendi."
    [not_installed]="yüklenemedi."
    [installing]="yükleniyor..."
    [creating]="oluşturuluyor..."
    [not_created]="oluşturulamadı."
    [deleting]="siliniyor..."
    [deleted]="silindi."
    [not_deleted]="silinemedi."
    [cloning]="kopyalanıyor..."
    [not_cloned]="kopyalanamadı."
    [configured]="ayarlandı."
    [configuring]="ayarlanıyor..."
    [not_configured]="ayarlanamadı."
    [enabled]="etkinleştirildi."
    [enabling]="etkinleştiriliyor..."
    [not_enabled]="etkinleştirilemedi."
    [restarting]="yeniden başlatılıyor..."
    [restarted]="yeniden başlatıldı."
    [not_restarted]="yeniden başlatılamadı."
    [set_mysql_password]="MySQL root parolasını belirleyin"
    [repeat_mysql_password]="MySQL root parolasını tekrar girin"
    [passwords_not_match]="Parolalar eşleşmiyor."
    [checking]="kontrol ediliyor..."
    [php_extensions]="PHP uzantıları"
    [project_permissions]="Proje izinleri"
    [project_permissions_changing]="Proje izinleri değiştiriliyor..."
    [project_permissions_changed]="Proje izinleri değiştirildi."
    [project_permissions_not_changed]="Proje izinleri değiştirilemedi."
    [composer_packages]="Composer paketleri"
    [project_settings]="Proje ayarları"


)