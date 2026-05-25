{
    pathsConfig,
    systemConfig,
    config,
    pkgs,
    lib,
    ...
}:
let
    name = "harmonia";
    cfgH = config.module.homelab;
    svc = (cfgH.services or {}).${name} or { enable = false; };

    bind = if builtins.isInt (svc.port or null) then
        "[::]:${toString svc.port}"
    else
        "[::]:5000";

    services-name = "prebuild-nixos-configs";
    buildAll = pkgs.writeShellScript "prebuild-nixos" ''
        set -euo pipefail
        cd ${pathsConfig.flakeDir}

        echo "=== Flake update ==="
        git pull
        mv flake.lock flake.lock.bak
        nix flake update --commit-lock-file
        git push -u origin sweet

        echo "=== Building PC ==="
        nix build --no-link .#nixosConfigurations.pc.config.system.build.toplevel

        # echo "=== Building server ==="
        # nix build --no-link .#nixosConfigurations.server.config.system.build.toplevel

        echo "=== Done. All paths are now in /nix/store and served by Harmonia ==="
    '';
in
lib.mkIf svc.enable {
    services.harmonia = {
        enable = true;
        signKeyPaths = [
            "${config.sops.secrets."homelab/harmoniaKey".path}"
        ];

        settings = {
            inherit
                bind
                ;
        };
    };

    systemd.services.${services-name} = {
        description = "Pre-build all NixOS configurations";
        path = [
            config.nix.package
            pkgs.git
        ];
        script = "${buildAll}";
        serviceConfig = {
          Type = "oneshot";
          User = "${systemConfig.userName}";
          Nice = -15;
          IOSchedulingClass = "idle";
          TimeoutStartSec = "6h";
        };
    };

    systemd.timers.${services-name} = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "sun";
          RandomizedDelaySec = "45min";
          Persistent = true;
        };
    };
}
