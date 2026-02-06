{
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
                caelestia-shell.enable = true;
            };
        };
        nixcord.enable = true;
    };
}
