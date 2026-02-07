{
    config,
    lib,
    ...
}:
let   
    name = "grafana";
    cfgH = config.module.homelab;
    svc = (cfgH.services or {}).${name} or { enable = false; };
in
lib.mkIf svc.enable {
    services.${name} = {
        enable = true;
        provision.enable = true;
        settings.server.http_port = svc.port or 3001;
    };
}

