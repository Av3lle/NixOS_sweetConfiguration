#!/usr/bin/env bash
set -euo pipefail

# Проверяем, что скрипт запущен от root
if [ "$(id -u)" -ne 0 ]; then
  echo "Пожалуйста, запустите этот скрипт с правами root (sudo)!" >&2
  exit 1
fi

# Это путь по которому находится сам скрипт
DIR="$(dirname "$(readlink -f "$0")")"

# Предупреждение в начале 
pretty_print() {
    local text="Перед установкой создайте желаемого хоста в '$DIR/hosts/' и создайте к нему атрибут
с удобным названием в файле '$DIR/outputs.nix', который в дальнейшем будет использоваться для ребилда системы,
а также создайте disko конфигурацию в каталоге '$DIR/disko/'"
    
    # Цвета и стили
    local RED='\033[0;31m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[1;33m'
    local BLUE='\033[0;34m'
    local MAGENTA='\033[0;35m'
    local CYAN='\033[0;36m'
    local NC='\033[0m' # No Color
    local BOLD='\033[1m'
    local UNDERLINE='\033[4m'
    
    # Разделительная линия
    local line="============================================================"
    
    echo -e "${YELLOW}${line}${NC}"
    echo -e "${BOLD}${BLUE}Инструкция:${NC}"
    echo -e ""
    echo -e "${GREEN}${text}${NC}"
    echo -e "${YELLOW}${line}${NC}"
}
pretty_print 

# Функция для запроса пути
ask_host_dir() {
  while true; do
    read -p "Введите имя хоста, который указан в $DIR/hosts/: " HOST_DIR
    if [ -d "$DIR/hosts/$HOST_DIR" ]; then
      break
    else
      echo "Ошибка: Хост '$HOST_DIR' не найден!" >&2
      echo "Пожалуйста, укажите существующего хоста." >&2
    fi
  done
}

# Функция для запроса пути к disko конфигу
ask_disko_conf() {
  while true; do
    read -p "Введите название файла для disko, который указан в $DIR/disko/: " DISKO_CONF
    if [ -f "$DIR/disko/$DISKO_CONF" ]; then
      break
    else
      echo "Ошибка: Данный файл '$DIR/disko/$DISKO_CONF' не найден!" >&2
      echo "Пожалуйста, укажите существующую конфигурацию disko." >&2
    fi
  done
}

check_attribute_exists() {
    local attr_name="$1"
    grep -q "nixosConfigurations.*=.*{" "$DIR/outputs.nix" && \
    grep -q "^[[:space:]]*${attr_name}[[:space:]]*=" "$DIR/outputs.nix"
}

get_valid_attribute() {
    while true; do
        read -p "Введите имя атрибута из outputs.nix: " attr_name        
        if check_attribute_exists "$attr_name"; then
            break
        else
            echo "Атрибут '$attr_name' отсутствует в outputs.nix" >&2
            echo "Пожалуйста, укажите существующий атрибут." >&2
        fi
    done
}

# Установка
install_nixos() {
  # Устанавливаем disko и создаем разделы
  echo "Создаем разделы с помощью disko..."
  nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
  --mode disko $DIR/disko/$DISKO_CONF

  # Монтируем разделы
  # mount /dev/disk/by-partlabel/root /mnt
  # mkdir -p /mnt/boot
  # mount /dev/disk/by-partlabel/boot /mnt/boot

  # Генерируем hardware-configuration.nix
  echo "Генерируем hardware-configuration.nix..."
  nixos-generate-config --root /mnt
  
  echo "Копируем hardware-configuration.nix в $DIR/hosts/$HOST_DIR..."
  cp /mnt/etc/nixos/hardware-configuration.nix "$DIR/hosts/$HOST_DIR/"

  echo "Копирование содержимого текущей папки в /mnt/etc/nixos/"
  rm -rf /mnt/etc/nixos/*
  cp -r $DIR/* /mnt/etc/nixos/

  echo "Начинаем установку NixOS из flake..."
  nixos-install --flake "/mnt/etc/nixos#$attr_name"
  
}

ask_disko_conf
get_valid_attribute
ask_host_dir
install_nixos

echo "Установка завершена! Перезагрузите систему."
