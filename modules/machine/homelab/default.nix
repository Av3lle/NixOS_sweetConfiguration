{ config, lib, self, ... }: let
    inherit (lib) mkEnableOption mkOption mkIf;
    inherit (lib.types) str attrs;
    
    name = "homelab";
    cfg = config.module.${name};
in {
    options.module.${name} = {
        enable = mkEnableOption "Enable module";

        domain = mkOption {
            description = "domain name";
            type = str;
            default = "server.com";
        };

        sslCert = mkOption {
            description = "path to ssl cert";
            type = attrs;
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
    };
}
