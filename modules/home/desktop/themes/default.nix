{
    config,
    lib,
    inputs,
    pkgs,
    systemConfig,
    ...
}:
let
    inherit (lib)
        mkEnableOption
        mkIf
        ;
    
    name = "stylix";
    cfg = config.module.desktop.${name};

    enableNoctaliaTheme = config.module.desktop.wayland.noctalia-shell.wal2base16;
in {
    imports = [
        inputs.stylix.homeModules.stylix
    ];
    
    options.module.desktop.${name} = {
        enable = mkEnableOption "Enable module";
    };

    config = mkIf cfg.enable {
        stylix = {
            enable = true;
            autoEnable = false;
            base16Scheme = ./base16/classic.yaml;
            
            iconTheme = {
                enable = true;
                package = pkgs.papirus-icon-theme.override { color = "black"; };
                light = "Papirus";
                dark = "Papirus-Dark";
            };        

            cursor = {
                package = pkgs.bibata-cursors;
                name = "Bibata-Modern-Ice";
                size = 24;
            };
        } // lib.optionalAttrs (!enableNoctaliaTheme) {
            targets = {
                gtk.enable = true;
                qt.enable = true;
                helix.enable = true;
                kitty = {
                    enable = true;
                    variant256Colors = true;
                };
            };
        };
        programs.helix = lib.mkMerge [
            (mkIf (!enableNoctaliaTheme) {
                themes.stylix = {
                    "ui.background" = {
                        bg = config.stylix.colors.base00;
                    };
                };
                settings.theme = "stylix";
            })

            (mkIf enableNoctaliaTheme {
                settings.theme = "noctalia";
            })
        ];
        programs.kitty = mkIf enableNoctaliaTheme {
            extraConfig = "include /home/${systemConfig.userName}/.config/kitty/themes/noctalia.conf";
        };
    };
}
