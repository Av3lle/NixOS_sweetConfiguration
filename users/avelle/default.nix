{
    inputs,
    pathsConfig,
    # pkgs,
    ...
}:
{
    imports = [
        ./packages.nix
    ];
       
    module = {
        fish.enable = true;
        kitty.enable = true;
        helix.enable = true;
        fastfetch.enable = true;
        zenBrowser = {
            enable = true;
            downloadDir = "/mnt/data/downloads";
        };
        desktop = {
            stylix = {
                enable = true;
            };
            wayland = {
                enable = true;
                hyprland.enable = true;
                noctalia-shell = {
                    enable = true;
                    wal2base16 = true;
                };
            };
        };
        nixcord.enable = true;
    };
}
