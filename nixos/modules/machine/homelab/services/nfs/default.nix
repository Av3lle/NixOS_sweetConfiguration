{
    config,
    lib,
    ...
}:
let
    name = "nfs";
    cfgH = config.module.homelab;
    svc = (cfgH.services or {}).${name} or { enable = false; };
in
lib.mkIf svc.enable {
    networking.firewall.allowedTCPPorts = [ 2049 ];

    services.${name}.server = {
        enable = true;
        exports = ''
            ${svc.mediaLocation} ${svc.allowedIp}(rw,sync,no_subtree_check,wdelay,no_root_squash,all_squash)
        '';
    };
}
