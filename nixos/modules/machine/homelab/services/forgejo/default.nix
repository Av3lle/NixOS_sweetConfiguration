{
    config,
    lib,
    ...
}:
let
    name = "forgejo";
    cfgH = config.module.homelab;
    svc = (cfgH.services or {}).${name} or { enable = false; };
in

lib.mkIf svc.enable {
    services.${name} = {
        enable = true;
        database.type = "postgres";
        lfs.enable = true;
        settings = {
            server = {
                HTTP_ADDR = "127.0.0.1";
                HTTP_PORT = svc.port or 3000;
                ROOT_URL = "https://${svc.subdomain}.${cfgH.domain}/";
            };
            service.DISABLE_REGISTRATION = true; 
            actions = {
                ENABLED = true;
                DEFAULT_ACTIONS_URL = "github";
            };
        };
    };
}
