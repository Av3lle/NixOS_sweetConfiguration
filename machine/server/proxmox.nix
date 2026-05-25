{
    inputs,
    lib,
    ...
}:
{

    imports = [
        inputs.proxmox-nixos.nixosModules.proxmox-ve
    ];    
      
    services.proxmox-ve = {
        enable = true;
        ipAddress = "192.168.1.2";
    };

    environment.persistence."/persistent".directories = [
        "/var/lib/pve-cluster"
    ];
    
    services.openssh.settings.AcceptEnv = lib.mkForce "LANG LC_* GIT_PROTOCOL";

    nixpkgs.overlays = [
        inputs.proxmox-nixos.overlays."x86_64-linux"
    ];
    
}
