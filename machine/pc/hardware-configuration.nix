{
    config,
    lib,
    ...
}:
{

    boot = {
        initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
        supportedFilesystems = [ "nfs" "zfs" ];
        zfs = {
            # enabled = true;
            # forceImportRoot = false;
            forceImportAll = true;
        };
        kernelParams = [
            "zfs.zfs_arc_min=4294967296"
            "zfs.zfs_arc_max=8589934592"
        ];
    };
    networking.hostId = "494a290f";
  

    fileSystems = {
        "/boot" = {
            device = "/dev/disk/by-uuid/C9E1-1589";
            fsType = "vfat";
            options = [ "fmask=0022" "dmask=0022" ];
        };

        "/" ={
            device = "/dev/disk/by-uuid/ceb560ab-f86d-4371-9a71-d0466abcdf29";
            fsType = "ext4";
        };

        # HDD (/dev/sdb)
        # $ zfs get recordsize,primarycache,compression,atime,sync data_pool/data
        # NAME            PROPERTY      VALUE           SOURCE
        # data_pool/data  recordsize    16K             local
        # data_pool/data  primarycache  metadata        local
        # data_pool/data  compression   lz4             local
        # data_pool/data  atime         off             local
        # data_pool/data  sync          standard        default
        "/mnt/data" = {
            device = "data_pool/data";
            fsType = "zfs";
            
            neededForBoot = false;
            options = [
                "nofail"
                "users"
                "suid"
                "x-gvfs-show"
            ];
        };

        # HDD (/dev/sdb)
        # $ zfs get recordsize,primarycache,compression,atime,sync data_pool/other
        # NAME             PROPERTY      VALUE           SOURCE
        # data_pool/other  recordsize    64K             local
        # data_pool/other  primarycache  all             local
        # data_pool/other  compression   lz4             local
        # data_pool/other  atime         off             local
        # data_pool/other  sync          disabled        local
        "/mnt/other" = {
            device = "data_pool/other";
            fsType = "zfs";
            
            neededForBoot = false;
            options = [
                "nofail"
                "users"
                "suid"
                "x-gvfs-show"
                "exec"
                "rw"
            ];
        };

        
        "/mnt/nfs" = {
            device = "192.168.1.2:/mnt/files/nfs";
            fsType = "nfs";
            options = [
                "x-systemd.automount"
                "noauto"
                "users"
                "suid"
                "x-gvfs-show"
            ];
        };
    };

    swapDevices = [{
      device = "/dev/disk/by-uuid/e3acc4c6-a166-48d0-8bbb-1124bb98be05";
    }];

    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
