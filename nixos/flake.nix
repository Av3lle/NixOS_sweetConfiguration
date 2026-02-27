{
  description = "~sweet lib";

  inputs = {
    # repositories
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-prev.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # hardware
    ucodenix = {
      url = "github:e-tho/ucodenix";
      # inputs.nixpkgs.follows = "nixpkgs-current";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      # inputs.nixpkgs.follows = "nixpkgs-current";
    };

    # system
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    stylix = {
      url = "github:danth/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    # caelestia-shell.url = "github:caelestia-dots/shell/578cd3666edd5315c1e9356c40be6b43635e26ce";
    caelestia-shell.url = "github:caelestia-dots/shell";
    # noctalia.url = "github:noctalia-dev/noctalia-shell";

    # programs
    nvf = {
      url = "github:NotAShelf/nvf";
      # inputs.nixpkgs.follows = "current";
    };

    nixcord.url = "github:kaylorben/nixcord";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    lsfg-vk-flake = {
      url = "github:pabloaul/lsfg-vk-flake/main";
      # inputs.nixpkgs.follows = "_current";
    };
  };

  outputs = args: import ./lib args;
}
