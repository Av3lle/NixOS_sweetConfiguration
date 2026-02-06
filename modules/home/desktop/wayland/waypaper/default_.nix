{ config, pkgs, ...}: let
  generatePalette = pkgs.writeShellScriptBin "generate-palette" ''
    # hellwal -i $1 \
      # -f ${config.dir}/home-manager/desktop/themes/hellwall/templates \
      # -o ${config.dir}/home-manager/desktop/themes/hellwal/;

    # export wallPath=$(cat ~/.cache/wal/wal)
    export wallPath=${config.wallpaper}/$1
    
    echo $wallPath > ${config.dir}/home-manager/themes/wallpaper.txt
    killall .waybar-wrapped; waybar &
    
    ${pkgs.imagemagick}/bin/convert -resize 600x300 $wallPath ~/.cache/wal/image.jpg
    /nix/store/k2c7ifjb4lwr6cm9j6yxkslhwm5qkrfd-wal-telegram/bin/wal-telegram --wal -g --restart
  '';
in {
  xdg.configFile."waypaper/config.ini".text = ''
    [Settings]
    language = en
    folder = ${config.dir}/wallpaper
    monitors = All
    wallpaper = ~/.config/waypaper/default.jpeg
    backend = swww
    fill = fill
    sort = name
    color = #26A269
    subfolders = False
    show_hidden = False
    show_gifs_only = False
    post_command = ~/.config/waypaper/wal.sh $wallpaper &
    # post_command = ${generatePalette}/bin/generate-palette $wallpaper &
    number_of_columns = 3
    swww_transition_type = any
    swww_transition_step = 90
    swww_transition_angle = 0
    swww_transition_duration = 2
    swww_transition_fps = 144
    use_xdg_state = False
  '';

  home.file = {
    ".config/waypaper/default.jpeg" = { source = ./default.jpeg; };
    ".config/waypaper/wal.sh" = { source = ./wal.sh; executable = true; };
  };
}
