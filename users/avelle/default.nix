{ _imports, inputs, ... }: {
    imports = [ ./packages.nix inputs.nvf.homeManagerModules.default ];

    programs.nvf = {
        enable = true;
        # lazy.plugins = {
            # languages.nix.enable = true;
        # };  ;
    settings.vim = {
        viAlias = true;
        vimAlias = true;
    };
    };
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
                caelestia-shell.enable = true;
            };
        };
        nixcord.enable = true;
    };
}
