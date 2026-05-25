{
    inputs,
    pkgs,
    ...
}:
{
  imports = with inputs; [
    chaotic.nixosModules.nyx-cache
    chaotic.nixosModules.nyx-overlay
    chaotic.nixosModules.nyx-registry
  ];
  
  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.default
    inputs.nix-cachyos-kernel.overlays.pinned
  ];

  environment = {
    systemPackages =
      (with pkgs; [
        home-manager
        busybox
        gnome-disk-utility
        pwvucontrol
        qemu
        (writeShellScriptBin "pavucontrol" ''
          exec pwvucontrol "$@"
        '')
        libreoffice
        ayugram-desktop
        anydesk
        darktable
      ])
      ++

        (with pkgs._unstable; [
          bitwarden-desktop
          telegram-desktop
          winboat
        ])
      ++

        (with pkgs._master; [
          # winboat
        ])
      ++

        (with pkgs._24; [
          # anydesk
        ]);
  };
}
