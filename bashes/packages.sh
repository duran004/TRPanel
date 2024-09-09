#!/bin/bash
log "${GREEN} $(figlet -f slant "Paketler") ${NC}"
# Paketleri güncelle
sudo apt update

check_packages="git openssh-client"
for check_package in $check_packages; do
  if dpkg -l | grep -q $check_package; then
    log "${GREEN}$check_package ${lang[installed]}.${NC}"
  else
    log "${RED}$check_package ${lang[not_installed]}.${NC}"
  fi
done

log "${YELLOW}### LAMP ${lang[installing]} ###${NC}"


# Paketler yüklü değilse yükle
for package in $packages; do
#   if ! dpkg -l | grep -q $package; then
    sudo apt install -y $package
    log "${GREEN}$package ${lang[installed]}.${NC}"
#   fi
done

#curl yükle
log "${YELLOW}### Curl ${lang[installing]} ###${NC}"
sudo apt-get install curl -y
#path ekle
export PATH=$PATH:/usr/local/bin
# curl yüklü mü kontrol et
log "${YELLOW}### Curl ${lang[checking]} ###${NC}"
which curl
if [ $? -eq 0 ]; then
  log "${GREEN}curl ${lang[installed]}.${NC}"
else
  log "${RED}curl ${lang[not_installed]}.${NC}"
  exit 1
fi

log "${GREEN}### LAMP ${lang[installed]} ###${NC}"

# PHP paketlerini yükle
log "${YELLOW}###  ${lang[php_extensions]} ${lang[installing]} ###${NC}"
sudo apt-get install libapache2-mod-php8.3 -y
php_packages="php8.3-common php8.3-fpm php-mysql php-curl php-gd php-intl php-json php-mbstring php-xml php-zip"
for php_package in $php_packages; do
  sudo apt install -y $php_package
  if ! dpkg -l | grep -q $php_package; then
    log "${RED}$php_package ${lang[not_installed]}.${NC}"
    exit 1
  fi
  log "${GREEN}$php_package ${lang[installed]}.${NC}"
done
log "${GREEN}### ${lang[php_extensions]} ${lang[installed]} ###${NC}"

#/etc/php/8.3/fpm/php.ini dosyasını aç ve disable_functions düzenle
log "${YELLOW}### ${lang[php_ini]} ${lang[editing]} ###${NC}"
sudo sed -i 's/;disable_functions =/disable_functions =  = exec,passthru,shell_exec,system,proc_open,popen,curl_exec,curl_multi_exec,parse_ini_file,show_source/g' /etc/php/8.3/fpm/php.ini
log "${GREEN}### ${lang[php_ini]} ${lang[edited]} ###${NC}"

sudo apt install libapache2-mod-fcgid
sudo a2enmod proxy_fcgi setenvif


log "${GREEN}### ${lang[completed]} ###${NC}"