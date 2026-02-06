{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "minimalism";
  cfg = config.module.desktop.wayland.${name};
in
with lib; {
  options.module.desktop.wayland.${name} = {
    enable = mkEnableOption "Enable module";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.anyrun
      pkgs.swww
    ];

    programs.ashell = {
      enable = true;
      systemd.enable = true;

      settings = {
        modules = {
          left = [ "Workspaces" ];
          right = [ "Tray" "Clock" "Settings" ];
        };
      };
    };
  };
}
