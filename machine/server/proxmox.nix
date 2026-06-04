{
    inputs,
    lib,
    pkgs,
    ...
}:
{

    imports = [
        inputs.proxmox-nixos.nixosModules.proxmox-ve
    ];    
      
    services.proxmox-ve = {
        enable = true;
        ipAddress = "192.168.1.2";
        bridges = [
            "vmbr0"
            "ISPtoHQRTR"
            "ISPtoBRRTR"
            "HQ"
            "BR"
        ];
    };
    
    networking = {
        useDHCP = false;
        firewall.enable = lib.mkForce false;
        bridges = {
            vmbr0.interfaces = [ "enp6s0" ];
            ISPtoHQRTR.interfaces = [];
            ISPtoBRRTR.interfaces = [];
            HQ = {
                interfaces = [];
            };
            BR = {
                interfaces = [];
            };
        };
        interfaces = {
            vmbr0 = {
                useDHCP = false;
                ipv4.addresses = [{
                    address = "192.168.1.2";
                    prefixLength = 24;
                }];
            enp6s0.useDHCP = false;
        };
    };

systemd.services = {
  "bridge-hq-vlan-aware" = {
    description = "Enable VLAN filtering on HQ bridge";
    after = [ "network-online.target" "bridge-HQ.target" ];
    wants = [ "network-online.target" "bridge-HQ.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "hq-vlan-aware" ''
        echo "Setting up VLAN filtering for HQ..."
        ${pkgs.iproute2}/bin/ip link set HQ type bridge vlan_filtering 1 || echo "Failed to set vlan_filtering"
        ${pkgs.iproute2}/bin/bridge vlan add dev HQ vid 1-4094 || echo "Failed to add VLAN range"
        ${pkgs.iproute2}/bin/bridge vlan show HQ
      '';
    };
  };

  "bridge-br-vlan-aware" = {
    description = "Enable VLAN filtering on BR bridge";
    after = [ "network-online.target" "bridge-BR.target" ];
    wants = [ "network-online.target" "bridge-BR.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "br-vlan-aware" ''
        echo "Setting up VLAN filtering for BR..."
        ${pkgs.iproute2}/bin/ip link set BR type bridge vlan_filtering 1 || echo "Failed to set vlan_filtering"
        ${pkgs.iproute2}/bin/bridge vlan add dev BR vid 1-4094 || echo "Failed to add VLAN range"
        ${pkgs.iproute2}/bin/bridge vlan show BR
      '';
    };
  };
};
    environment.persistence."/persistent".directories = [
        "/var/lib/pve-cluster"
        "/var/tmp"
        "/var/lib/vz"
    ];
    
    services.openssh.settings.AcceptEnv = lib.mkForce "LANG LC_* GIT_PROTOCOL";

    nixpkgs.overlays = [
        inputs.proxmox-nixos.overlays."x86_64-linux"
    ];
    
}
