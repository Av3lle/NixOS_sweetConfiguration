{ _imports, inputs, lib, ... }: {
    imports = [
        ./packages.nix
        inputs.nvf.homeManagerModules.default
        # inputs.dankMaterialShell.homeModules.dankMaterialShell.default
        # inputs.illogical-flake.homeManagerModules.default
    ];

    # home.sessionVariables.QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";
    # home.sessionVariables.QT_STYLE_OVERRIDE = lib.mkForce "kvantum";

    # programs.dankMaterialShell.enable = true;
    # programs.illogical-impulse = {
        # enable = true;
    # };
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
