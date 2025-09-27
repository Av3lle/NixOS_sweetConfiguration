{
    pc = {
        system = {
            userName = "avelle";
            platform = "x86_64-linux";
        };
        paths = {
            flakeDir = "/home/avelle/.config/nixos";
        };
    };

    server = {
        system = {
            hostName = "nixos-server";
            userName = "avelle";
            platform = "x86_64-linux";

            isServer = true;
        };
        paths = {
            flakeDir = "/home/avelle/.config/nixos";
        };
    };

    laptop = {
        system = {
            hostName = "nixos-laptop";
            userName = "avelle";
            version = "25.05";
            platform = "x86_64-linux";

            isLaptop = true;
        };
        paths = {
            flakeDir = "/home/avelle/.config/nixos";
        };
    };
    
}
