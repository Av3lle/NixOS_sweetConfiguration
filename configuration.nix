{
  pc = {
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

      defaultLocale = "ru_RU.UTF-8";
      timeZone = "Europe/Moscow";

      isServer = true;
    };
    paths = {
      flakeDir = "/home/avelle/.config/nixos";
    };
  };

  laptop = {
    branch = "unstable";
    system = {
      hostName = "nixos-laptop";
      userName = "sweet";
      version = "23.11";
      platform = "x86_64-linux";

      defaultLocale = "ru_RU.UTF-8";
      timeZone = "Europe/Moscow";

      isLaptop = true;
    };
    paths = {
      flakeDir = "/home/sweet/.config/nixos";
      # wallpapersDir = 
    };
  };

}
