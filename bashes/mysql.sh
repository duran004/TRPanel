#!/bin/bash
echo -e "${GREEN}### mysql_settings.sh ###${NC}"
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

