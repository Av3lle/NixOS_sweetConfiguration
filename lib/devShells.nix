{ pkgs, ... }: with pkgs; let
    mk = packages: mkShell {
        shellHook = ''exec fish'';
        inherit packages;
    };
in {
    nix = mk [
      nixfmt-rfc-style
      nix-init
      cachix
    ];

    python = mk [
        python3
        python3Packages.pip
        python3Packages.virtualenv
        ruff
    ];

    rust = mk [
        rustc
        cargo
        rustfmt
        clippy
        rust-analyzer
    ];

    cpp = mk [
        gcc
        gnumake
        cmake
        clang-tools
        gdb
    ];

    
}
