#!/bin/bash


# Debug modunu soran fonksiyon
enable_debug_mode() {
  log "${YELLOW}### Debug modu etkinleştirilsin mi? (y/n) ###${NC}"
  read -p "y/n: " debug_mode
  if [ "$debug_mode" == "y" ]; then
    set -x
    log "${GREEN}### Debug modu aktif ###${NC}"
  else
    set +x
    log "${RED}### Debug modu pasif ###${NC}"
  fi
}

# Ana fonksiyon
main() {
  log "${GREEN} $(figlet -f slant "Init") ${NC}"
  enable_debug_mode
}

main
