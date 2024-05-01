#!/bin/bash

# PHP, Apache, MySQL ve Git'i yüklemek için gerekli paket isimleri
packages="php apache2 mysql-server git"

# Root kullanıcı olup olmadığını kontrol et
if [ "$(id -u)" != "0" ]; then
  echo "Bu komut dosyasını çalıştırmak için root yetkilerine ihtiyacınız var."
  exit 1
fi

# Paketleri güncelle
apt update

# Paketleri yükle
apt install -y $packages

# MySQL ayarlarını yapılandır
# Örnek olarak, root kullanıcısına parola belirleme
# Bu adımı manuel olarak yapmak daha güvenlidir
#mysql_secure_installation

# Servisleri başlat
service apache2 start
service mysql start

echo "Kurulum tamamlandı!"
