#!/usr/bin/env bash

wallpaper=$1
convert_image=$(nix eval --raw nixpkgs#imagemagick.outPath)/bin/convert

wal -i $wallpaper -n;
hellwal -i $wallpaper;
export wall=$(cat ~/.cache/wal/wal)
echo $wall > ~/.config/nixos/users/avelle/themes/wallpaper.txt
killall .waybar-wrapped; waybar &

# pywalfox update
# cp $wall ~/.mozilla/firefox/3v44ty0w.avelle1/chrome/wallpaper.png
$convert_image -resize 600x300 $wall ~/.cache/wal/image.jpg
# sh pywal-discord -p ~/.config/vesktop/themes -d
# bash wal-telegram --wal -g --restart
/nix/store/k2c7ifjb4lwr6cm9j6yxkslhwm5qkrfd-wal-telegram/bin/wal-telegram --wal -g --restart
# rebuild hm
# home-manager switch --impure --flake ${config.dir}#avelle
