{
    config,
    lib,
    self,
    systemConfig,
    ...
}:
let
    name = "homelab";
    cfg = config.module.${name};
in
with lib; {
    options.module.${name} = {
        enable = mkEnableOption "Enable module";

        domain = mkOption {
            description = "domain name";
            type = types.str;
            default = "server.com";
        };

        sslCert = mkOption {
            description = "path to ssl cert";
            type = types.attrs;
            default = {
                sslCertificate = "${self}/secrets/cert.pem";
                sslCertificateKey = "${self}/secrets/cert.key"; 
                forceSSL = true;
            };
        };
    };

    config = mkIf cfg.enable {
        networking.firewall = {
            enable = true;
            allowedTCPPorts = [ 443 80 ];
            allowedUDPPorts = [ 443 80 ];
        };

        services.nginx = {
            enable = true;
            recommendedGzipSettings = true;
            recommendedOptimisation = true;
            recommendedProxySettings = true;
            recommendedTlsSettings = true;
            clientMaxBodySize = "30m";
        };

        virtualisation = {
            containers.enable = true;
            oci-containers.backend = "docker";
            docker.enable = true;
        };

        users.users.${systemConfig.userName}.extraGroups = [ "docker" ];
    };
}
