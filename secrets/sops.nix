{
    self,
    lib,
    inputs,
    config,
    systemConfig,
    pkgs,
    ...
}:
let
    conf = config.users.users;
in
{
    imports = [
        inputs.sops-nix.nixosModules.sops
    ];
    environment.systemPackages = [ pkgs.sops ];
    sops = {
        defaultSopsFile = "${self}/.secrets.yaml";
        defaultSopsFormat = "yaml";

        age.keyFile = "/var/lib/sops/age/keys.txt";


        secrets = {
            "pc/user/password" = {
                neededForUsers = true;
                owner = conf.${systemConfig.userName}.name;
                mode = "0440";
            };

            "pc/root/password" = {
                neededForUsers = true;
                owner = conf.root.name;
                mode = "0440";
            };       
        } //
        lib.optionalAttrs (config.services.traefik.enable) {
            "homelab/privateKeySSL" = {
                owner = conf.traefik.name;
                group = conf.traefik.group;
                mode = "0440";
            };
        } //
        lib.optionalAttrs (config.services.harmonia.enable) {
            "homelab/harmoniaKey" = {
                owner = conf.harmonia.name;
                group = conf.harmonia.group;
                mode = "0440";
            };
        };
    };
}
