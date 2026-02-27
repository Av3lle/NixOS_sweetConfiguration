{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [ mdadm smartmontools ];
    systemd.services.mdmonitor.enable = false;

    boot.swraid = {
        enable = true;
        mdadmConf = ''
            ARRAY /dev/md127 metadata=1.2 UUID=40a29b28:e62623f0:28d14358:0fdcf817
        '';
    };
    
    fileSystems."/mnt/files" = {
        device = "/dev/md127";
        fsType = "ext4";
        options = [ "defaults" "noatime" ];
   };
}
