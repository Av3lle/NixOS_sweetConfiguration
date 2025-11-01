{
    description = "~sweet lib";
  
    inputs = {
        # repositories
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
        nixpkgs-prev.url = "github:nixos/nixpkgs/nixos-24.11";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
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
            url = "github:nix-community/home-manager/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs-stable";
        };
        stylix = {
            url = "github:danth/stylix/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs-stable";
        };
        caelestia-shell.url = "github:caelestia-dots/shell";

        # programs
        nvf = {
          url = "github:NotAShelf/nvf";
          # inputs.nixpkgs.follows = "current";
        };
        zapret = {
            url = "github:mctrxw/nix-zapret-presets";
            # inputs.nixpkgs.follows = "nixpkgs";
        };
        nekoflake.url = "github:s0me1newithhand7s/nekoflake";
        nixcord.url = "github:kaylorben/nixcord";
        zen-browser.url = "github:0xc000022070/zen-browser-flake";
        lsfg-vk-flake = {
            url = "github:pabloaul/lsfg-vk-flake/main";
            # inputs.nixpkgs.follows = "_current";
        };
    };

    outputs = args: import ./lib args;
}
