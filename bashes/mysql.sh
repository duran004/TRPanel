#!/bin/bash
echo -e "${GREEN}### mysql_settings.sh ###${NC}"
# MySQL yükle
echo -e "${YELLOW}### MySQL ${lang[installing]} ###${NC}"
sudo apt-get install mysql-server mysql-client -y
# MySQL yüklü mü kontrol et
if ! service mysql status > /dev/null 2>&1; then
  echo -e "${YELLOW}### MySQL ${lang[enabling]} ###${NC}"
  #durdur
  if ! service mysql stop; then
    echo -e "${RED}### MySQL ${lang[not_enabled]} ###${NC}"
    exit 1
  fi
  if ! service mysql start; then
    echo -e "${RED}### MySQL ${lang[not_enabled]} ###${NC}"
    exit 1
  fi
else
  echo -e "${GREEN}### MySQL ${lang[enabled]} ###${NC}"
fi
# MySQL root parolasını belirle
if [ ! -f /var/lib/mysql/ibdata1 ]; then
  echo -e "${BLUE}MySQL ${lang[set_mysql_password]}...${NC}"
  read -s mysql_root_password
  echo -e "${BLUE}MySQL ${lang[repeat_mysql_password]}...${NC}"
  read -s mysql_root_password_repeat

  # Parolaların eşleşip eşleşmediğini kontrol et
  if [ "$mysql_root_password" != "$mysql_root_password_repeat" ]; then
    echo -e "${RED} ${lang[passwords_not_match]}${NC}"
    exit 1
  fi

  # MySQL root parolasını ayarla
  echo "mysql-server mysql-server/root_password password $mysql_root_password" | debconf-set-selections
  echo "mysql-server mysql-server/root_password_again password $mysql_root_password" | debconf-set-selections
fi
echo -e "${GREEN}### ${lang[completed]} ###${NC}"
