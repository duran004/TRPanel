#!/bin/bash
echo -e "${GREEN} $(figlet -f slant "Init") ${NC}"
DEBUG_MODE=false
#debug mode açılsın mı? diye sor
echo -e "${YELLOW}### ${lang[debug_mode]} ###${NC}"
read -p "y/n: " debug_mode
if [ "$debug_mode" == "y" ]; then
  DEBUG_MODE=true
  set -x
else
  DEBUG_MODE=false
  set +x
fi



