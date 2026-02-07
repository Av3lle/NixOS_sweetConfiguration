{
    config,
    lib,
    ...
}:
let
    name = "immich";
    cfgH = config.module.homelab;
    svc = (cfgH.services or {}).${name} or { enable = false; };
in
lib.mkIf svc.enable {
    services.${name} = {
        enable = true;
        host = "127.0.0.1";
        port = svc.port or 2283;
        mediaLocation = svc.mediaLocation;
    };
}
