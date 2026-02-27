{
    self,
    inputs,
    config,
    systemConfig,
    pkgs,
    ...
}:
{
    imports = [
        inputs.sops-nix.nixosModules.sops
    ];
    environment.systemPackages = [ pkgs.sops ];
    sops = {
        defaultSopsFile = "${self}/secrets/secrets.yaml";
        defaultSopsFormat = "yaml";

        age.keyFile = "/var/lib/sops/age/keys.txt";

        secrets."pc/user/password" = {
            neededForUsers = true;
            # owner = config.users.users.${config.pc.username}.name;
            owner = config.users.users.${systemConfig.userName}.name;
        };

        secrets."pc/root/password" = {
            neededForUsers = true;
            owner = config.users.users.root.name;
        };       
    };
}
