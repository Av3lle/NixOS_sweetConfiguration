{ inputs, pkgs,  ... }: {
    imports = with inputs; [
        chaotic.nixosModules.nyx-cache
        chaotic.nixosModules.nyx-overlay
        chaotic.nixosModules.nyx-registry
    ];
  
    environment= {
        systemPackages = (with pkgs; [
            home-manager
            greetd.tuigreet
            gnome-disk-utility
            libreoffice
        ]) ++

        (with pkgs._unstable; [
            bitwarden
            ayugram-desktop
        ]) ++

        (with pkgs._24; [
            anydesk
        ]);
    };
}
