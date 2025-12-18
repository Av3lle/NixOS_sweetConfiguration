{ inputs, pkgs, ... }:
{
  imports = with inputs; [
    chaotic.nixosModules.nyx-cache
    chaotic.nixosModules.nyx-overlay
    chaotic.nixosModules.nyx-registry
  ];

  environment = {
    systemPackages =
      (with pkgs; [
        home-manager
        gnome-disk-utility
        pavucontrol
        libreoffice
        ayugram-desktop
      ])
      ++

        (with pkgs._unstable; [
          bitwarden-desktop
          telegram-desktop
        ])
      ++

        (with pkgs._master; [
          winboat
        ])

      ++

        (with pkgs._24; [
          anydesk
        ]);
  };
}
