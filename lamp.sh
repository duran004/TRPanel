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


# MySQL root parolasını belirle
if [ ! -f /var/lib/mysql/ibdata1 ]; then
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
  echo "mysql-server mysql-server/root_password password $mysql_root_password" | debconf-set-selections
  echo "mysql-server mysql-server/root_password_again password $mysql_root_password" | debconf-set-selections
fi
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
echo "### Proje çekiliyor ###"
#varsa sil
rm -rf TRPanel
git clone https://github.com/duran004/TRPanel.git
git config --global --add safe.directory /var/www/html/TRPanel
echo "### Proje çekildi ###"
# Proje dizinine yetki ver
chown -R www-data:www-data TRPanel
chmod -R 755 TRPanel
echo "### Yetki verildi ###"


echo "Kurulum tamamlandı!"
