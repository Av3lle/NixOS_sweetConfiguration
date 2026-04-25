{
    config,
    lib,
    pkgs,
    ...
}:
let
    name = "factorio";
    cfgH = config.module.homelab;
    svc = (cfgH.services or {}).${name} or { enable = false; };
in

lib.mkIf svc.enable {
    services.${name} = {
        enable = true;
        openFirewall = true;
        lan = true;
        requireUserVerification = false;

        autosave-interval = 3;

        saveName = "_autosave1";
    };
    
    systemd.services.${name} = {
        preStart = lib.mkAfter ''
          MOD_LIST="/var/lib/${config.services.factorio.stateDirName}/mods/mod-list.json"

          if [ -f "$MOD_LIST" ]; then
            ${pkgs.jq}/bin/jq '
              .mods |= map(
                if .name == "elevated-rails" or .name == "quality" or .name == "space-age"
                then .enabled = false
                else .
                end
              )
            ' "$MOD_LIST" > "$MOD_LIST.tmp" && mv "$MOD_LIST.tmp" "$MOD_LIST"
            chmod 664 "$MOD_LIST"
          else
            echo '{
              "mods": [
                { "name": "base", "enabled": true },
                { "name": "elevated-rails", "enabled": false },
                { "name": "quality", "enabled": false },
                { "name": "space-age", "enabled": false }
              ]
            }' > "$MOD_LIST"
            chmod 664 "$MOD_LIST"
          fi
        '';
      };
}
