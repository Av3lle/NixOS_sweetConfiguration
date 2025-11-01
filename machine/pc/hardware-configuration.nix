{ config, lib, modulesPath, pkgs, ... }:

{

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  # boot.kernelModules = [ "kvm-amd" "" ];
  # boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [ "nfs" ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/ceb560ab-f86d-4371-9a71-d0466abcdf29";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/C9E1-1589";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  
  # fileSystems."/mnt/disk" = {
  #     device = "/dev/disk/by-uuid/bdf1a818-f1ee-4d2c-82a5-092137ea04a3";
  #     fsType = "ext4";
  #     options = [ 
  #       "nofail"
  #       "users" 
  #       "x-gvfs-show"
  #       "noatime"
  #       "async"
  #       "user"
  #       "suid"
  #       "exec"
  #       "auto"
  #       "dev"
  #       "rw"
  #     ];
  # };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/e3acc4c6-a166-48d0-8bbb-1124bb98be05"; }
    ];

  fileSystems."/mnt/nfs" = {
    device = "192.168.1.2:/mnt/files/nfs";
    fsType = "nfs";
    options = [
      # "noauto"
      "x-systemd.idle-timeout=600"
      "users"
      "suid"
      "x-gvfs-show"
    ];
  };
  
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # hardware.cpu.amd.updateMicrocode = lib.mkDefault (
    # lib.attrByPath [ "hardware" "enableRedistributableFirmware" ] false config
  # );

  # Явно добавьте пакет, если updateMicrocode включено (для coherence в старых ветках)
  # hardware.cpu.amd.microcodePackage = lib.mkIf config.hardware.cpu.amd.updateMicrocode pkgs.microcode-amd;
  
}
