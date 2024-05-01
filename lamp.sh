#!/bin/bash

# PHP, Apache, MySQL ve Git'i yüklemek için gerekli paket isimleri
packages="php apache2 mysql-server git"


# Root kullanıcı olup olmadığını kontrol et
if [ "$(id -u)" != "0" ]; then
  echo "Bu komut dosyasını çalıştırmak için root yetkilerine ihtiyacınız var."
  exit 1
fi
echo "### LAMP Kurulumu ###"
# Paketleri güncelle
apt update

# Paketler yüklü değilse yükle
for package in $packages; do
  if ! dpkg -l | grep -q $package; then
    apt install -y $package
  fi
done
echo "### LAMP Kurulumu Bitti ###"

# MySQL için root parolası belirle
echo "MySQL root parolası belirleyin:"
read -s mysql_root_password
echo "MySQL root parolasını tekrar girin:"
read -s mysql_root_password_repeat

# Parolaların eşleşip eşleşmediğini kontrol et
if [ "$mysql_root_password" != "$mysql_root_password_repeat" ]; then
  echo "Parolalar eşleşmiyor. Lütfen tekrar deneyin."
  exit 1
fi

# MySQL root parolasını ayarla
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$mysql_root_password';"

# PHP'nin MySQL eklentisini yükle
apt install -y php-mysql php-curl php-gd php-intl php-json php-mbstring php-xml php-zip

# Apache'nin mod_rewrite modülünü etkinleştir
a2enmod rewrite

# Servisleri başlat
service apache2 start
service mysql start
echo "### Apache ve MySQL başlatıldı ###"

# gitden projey çek /var/www/html dizinine
cd /var/www/html
git clone https://github.com/duran004/TRPanel.git
echo "### Proje çekildi ###"

echo "Kurulum tamamlandı!"
