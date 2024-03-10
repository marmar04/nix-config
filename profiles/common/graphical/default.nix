# This is the base config that every system should have installed
{programsdb, ...}: {
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware), use something like:

    ./../base

    inputs.nur.nixosModules.nur

    inputs.home-manager.nixosModules.home-manager

    # You can also split up your configuration and import pieces of it here.
  ];

  home-manager.sharedModules = [
    {
      home.file.".local/share/icons/hicolor/16x16/apps/google-chrome.png".source = "${pkgs.google-chrome}/share/icons/hicolor/16x16/apps/google-chrome.png";
      home.file.".local/share/icons/hicolor/24x24/apps/google-chrome.png".source = "${pkgs.google-chrome}/share/icons/hicolor/24x24/apps/google-chrome.png";
      home.file.".local/share/icons/hicolor/32x32/apps/google-chrome.png".source = "${pkgs.google-chrome}/share/icons/hicolor/32x32/apps/google-chrome.png";
      home.file.".local/share/icons/hicolor/48x48/apps/google-chrome.png".source = "${pkgs.google-chrome}/share/icons/hicolor/48x48/apps/google-chrome.png";
      home.file.".local/share/icons/hicolor/64x64/apps/google-chrome.png".source = "${pkgs.google-chrome}/share/icons/hicolor/64x64/apps/google-chrome.png";
      home.file.".local/share/icons/hicolor/128x128/apps/google-chrome.png".source = "${pkgs.google-chrome}/share/icons/hicolor/128x128/apps/google-chrome.png";
      home.file.".local/share/icons/hicolor/256x256/apps/google-chrome.png".source = "${pkgs.google-chrome}/share/icons/hicolor/256x256/apps/google-chrome.png";
    }
  ];

  # Enable services
  services = {
    # Enable flatpak
    flatpak.enable = true;
  };

  # For flatpak
  system.fsPackages = [pkgs.bindfs];
  fileSystems = let
    mkRoSymBind = path: {
      device = path;
      fsType = "fuse.bindfs";
      options = ["ro" "resolve-symlinks" "x-gvfs-hide"];
    };
    aggregatedFonts = pkgs.buildEnv {
      name = "system-fonts";
      paths = config.fonts.packages;
      pathsToLink = ["/share/fonts"];
    };
  in {
    # Create an FHS mount to support flatpak host icons/fonts
    "/usr/share/icons" = mkRoSymBind (config.system.path + "/share/icons");
    "/usr/share/fonts" = mkRoSymBind (aggregatedFonts + "/share/fonts");
  };

  # Fonts
  fonts = {
    packages = with pkgs; [
      # emoji support
      noto-fonts-emoji

      jetbrains-mono

      # for japanese characters
      noto-fonts-cjk
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    appimage-run
    winetricks
    winePackages.waylandFull
    # games
    #vinegar
    lutris
    katawa-shoujo
    rigsofrods
    freeciv_qt
    # themes
    #gradience
    #adw-gtk3
    papirus-icon-theme
    gnome.adwaita-icon-theme
    # browsers
    firefox-wayland
    ungoogled-chromium
    ladybird
    tor-browser
    # communication
    #localsend
    keepassxc
    thunderbird
    tdesktop
    calibre
    #config.nur.repos.nltch.spotify-adblock
    # download
    persepolis
    transmission-gtk
    czkawka
    # notes
    xournalpp
    sioyek
    # cli
    networkmanagerapplet
    # media
    #graphviz
    blender
    kdenlive
    gimp
    krita
    inkscape
    darktable
    # rawtherapee
    mpv
    #freetube
    gsettings-desktop-schemas
    # coding
    zeal
    # utilities
    gparted
    libreoffice-fresh
    xmind
    cpu-x
  ];

  programs = {
    # Enabel dconf for gtk theming
    dconf.enable = true;

    # Run unpatched dynamic libraries
    nix-ld.enable = true;

    #chromium = {
    #  enable = true;
    #  plasmaBrowserIntegrationPackage = pkgs.kdePackages.plasma-browser-integration;
    #  extensions = [
    #    "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
    #    "gcbommkclmclpchllfjekcdonpmejbdp" # https everywhere
    #  ];
    #};

    # for captive portal (hotel wi-fi)
    captive-browser = {
      enable = true;
      interface = "wlo1";
      browser = lib.concatStringsSep " " [
        ''env XDG_CONFIG_HOME="$PREV_CONFIG_HOME"''
        ''${pkgs.ungoogled-chromium}/bin/chromium''
        ''--user-data-dir=''${XDG_DATA_HOME:-$HOME/.local/share}/chromium-captive''
        ''--proxy-server="socks5://$PROXY"''
        ''--host-resolver-rules="MAP * ~NOTFOUND , EXCLUDE localhost"''
        ''--no-first-run''
        ''--new-window''
        ''--incognito''
        ''-no-default-browser-check''
        ''http://cache.nixos.org/''
      ];
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
  };

  environment = {
    etc = {
      "programs.sqlite".source = programsdb.packages.${pkgs.system}.programs-sqlite;
    };
  };

  # qt theming
  qt = {
    enable = true;
    platformTheme = lib.mkDefault "qt5ct";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.05";
}
