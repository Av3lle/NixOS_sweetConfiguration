{ inputs, pkgs, pkgs-unstable, pkgs-prev, ... }: {
    imports = with inputs; [
        chaotic.nixosModules.nyx-cache
        chaotic.nixosModules.nyx-overlay
        chaotic.nixosModules.nyx-registry
    ];
  
    environment = {
        systemPackages = (with pkgs; [
            inxi
            git
            greetd.tuigreet
            p7zip
            rar
            gnutar
            zip
            nixos-icons
            xz
            glxinfo
            home-manager
            gzip
            ntfs3g
            gawk
        ]) ++
        
        (with pkgs-unstable; [
            helix
            bitwarden
        ]) ++
        
        (with pkgs-prev; [
            
        ]);
    };
}
