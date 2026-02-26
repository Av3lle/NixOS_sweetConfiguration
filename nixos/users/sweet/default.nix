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

        desktop = {
            stylix = {
                enable = true;
            };
            wayland = {
                enable = true;
                hyprland.enable = true;
                caelestia-shell.enable = false;
                minimalism.enable = true;
            };
        };
        nixcord.enable = false;
    };
}
