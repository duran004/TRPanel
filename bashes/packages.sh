#!/bin/bash
echo -e "${GREEN}### packages.sh ###${NC}"
echo -e "${YELLOW}### git ve openssh kontrol ediliyor ###${NC}"
# Paketleri güncelle
sudo apt update

check_packages="git openssh-client"
for check_package in $check_packages; do
  if dpkg -l | grep -q $check_package; then
    echo -e "${GREEN}$check_package paketi yüklü.${NC}"
  else
    echo -e "${RED}$check_package paketi yüklü değil veya kaldırıldı.${NC}"
  fi
done

echo -e "${YELLOW}### LAMP Kurulumu ###${NC}"


# Paketler yüklü değilse yükle
for package in $packages; do
#   if ! dpkg -l | grep -q $package; then
    sudo apt install -y $package
    echo -e "${GREEN}$package yüklendi.${NC}"
#   fi
done

#curl yükle
echo -e "${YELLOW}### Curl yükleniyor ###${NC}"
sudo apt-get install curl
#path ekle
export PATH=$PATH:/usr/local/bin
# curl yüklü mü kontrol et
echo -e "${YELLOW}Checking if curl is installed...${NC}"
which curl
if [ $? -eq 0 ]; then
  echo -e "${GREEN}curl is installed.${NC}"
else
  echo -e "${RED}curl is not installed.${NC}"
  exit 1
fi

echo -e "${GREEN}### LAMP Kurulumu Bitti ###${NC}"

# PHP paketlerini yükle
echo -e "${YELLOW}###  PHP paketleri yükleniyor ###${NC}"
php_packages="php-mysql php-curl php-gd php-intl php-json php-mbstring php-xml php-zip php8.3-common"
for php_package in $php_packages; do
  sudo apt install -y $php_package
  if ! dpkg -l | grep -q $php_package; then
    echo -e "${RED}$php_package yüklenemedi.${NC}"
    exit 1
  fi
  echo -e "${GREEN}$php_package yüklendi.${NC}"
done
echo -e "${GREEN}### PHP eklentileri yüklendi ###${NC}"

