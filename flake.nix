{
    description = "~sweet lib";
  
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
        _prev.url = "github:nixos/nixpkgs/nixos-24.11";
        _unstable.url = "github:nixos/nixpkgs/nixos-unstable";
        chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    
        nur = {
            url = "github:nix-community/NUR";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        ucodenix.url = "github:e-tho/ucodenix";

        sops-nix = {
            url = "github:Mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    
        home-manager = {
            url = "github:nix-community/home-manager/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        stylix = {
            url = "github:danth/stylix/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        matugen.url = "github:/InioX/Matugen";

        caelestia-shell = {
            url = "github:caelestia-dots/shell";
        };

        # caelestia-shell = {
            # url = "github:Av3lle/shell";
            # inputs.nixpkgs.follows = "nixpkgs";
        # };

        nvf = {
          url = "github:NotAShelf/nvf";
          inputs.nixpkgs.follows = "nixpkgs";
        };

        nixcord.url = "github:kaylorben/nixcord";
        
        zen-browser.url = "github:0xc000022070/zen-browser-flake";

        lsfg-vk-flake = {
            url = "github:pabloaul/lsfg-vk-flake/main";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = args: import ./lib args;
}
