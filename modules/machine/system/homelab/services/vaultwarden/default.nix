{
    config,
    lib,
    ...
}:
let
    name = "vaultwarden";
    cfgH = config.module.homelab;
    svc = (cfgH.services or {}).${name} or { enable = false; };
in
lib.mkIf svc.enable {
    services.${name} = {
        enable = true;
        dbBackend = "sqlite";
        environmentFile = "/var/lib/${name}/.env";
        config = {
            DOMAIN = "https://${svc.subdomain}.${cfgH.domain}";
            ROCKET_ADDRESS = "127.0.0.1";
            ROCKET_PORT = svc.port or 8222;
            SIGNUPS_ALLOWED = true;
            WEBSOCKET_ENABLED = true;
        };
    }; 
}
