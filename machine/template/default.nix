{ lib, config, pkgs, ... }: let
    disableImport = [ "stylix.nix" ];

    importSystemDirectory = map
        (f: ./system + "/${f}")
        (lib.lists.filter
            (f: lib.strings.hasSuffix ".nix" f && !(builtins.elem f disableImport))
            (builtins.attrNames (builtins.readDir ./system)));
in {
    imports = [
        ./hardware-configuration.nix
    ] ++ importSystemDirectory;

    module = {
        # All modules are located on the path ${self}/modules/...

    };
    
    networking = {
        hostName = "${config.template.hostname}";
        networkmanager.enable = true;
    };

    users = {
        mutableUsers = false;
        users.root = {
            # hashedPasswordFile = config.template.password;
            password = "1234";
        };
        users.${config.template.username} = {
            isNormalUser = true;
            # hashedPasswordFile = config.template.password;
            password = "12345";
            extraGroups  = [ "wheel" "networkmanager" "inputs" ];
            shell = pkgs.fish;
            ignoreShellProgramCheck = true;
        };
    };
}
