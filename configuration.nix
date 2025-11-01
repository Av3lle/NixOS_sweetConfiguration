{
  pc = {
    branch = "stable";
    system = {
      userName = "avelle";
      platform = "x86_64-linux";

      defaultLocale = "ru_RU.UTF-8";
      timeZone = "Europe/Moscow";

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

      timeZone = "Europe/Moscow";

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

      defaultLocale = "ru_RU.UTF-8";
      timeZone = "Europe/Moscow";

      isLaptop = true;
    };
    paths = {
      flakeDir = "/home/avelle/.config/nixos";
    };
  };

}
