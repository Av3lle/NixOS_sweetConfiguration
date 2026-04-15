{
    inputs,
    lib,
    # pkgs,
    ...
}:
{
    imports = [
        ./packages.nix
        # inputs.dms.homeModules.dank-material-shell
   ];

  #   programs.dank-material-shell = {
  #      enable = true;
  #      dgop.package = pkgs._unstable.dgop;
  #      # inputs.dgop.packages.${pkgs.system}.default;
  #        systemd = {
  #   enable = true;             # Systemd service for auto-start
  #   restartIfChanged = true;   # Auto-restart dms.service when dank-material-shell changes
  # };
    # };
   
    module = {
        fish.enable = true;
        kitty.enable = true;
        helix.enable = true;
        fastfetch.enable = true;
        zenBrowser = {
            enable = true;
            downloadDir = "/mnt/data/downloads";
        };
        desktop = {
            stylix = {
                enable = true;
            };
            wayland = {
                enable = true;
                hyprland.enable = true;
                caelestia-shell.enable = true;
            };
        };
        nixcord.enable = true;
    };
}
