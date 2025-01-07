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

    inputs.nur.modules.nixos.default

    inputs.home-manager.nixosModules.home-manager

    # You can also split up your configuration and import pieces of it here.
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
      noto-fonts-cjk-sans
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    appimage-run
    android-tools
    winetricks
    wine64Packages.waylandFull
    bottles
    # themes
    #gradience
    #adw-gtk3
    papirus-icon-theme
    adwaita-icon-theme
    # browsers
    #firefox-wayland
    (chromium.override {
      commandLineArgs = [
        "--enable-features=VaapiVideoDecodeLinuxGL"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
      ];
    })
    #ladybird
    tor-browser
    # communication
    #localsend
    keepassxc
    thunderbird
    logseq
    #tdesktop
    #calibre
    #config.nur.repos.nltch.spotify-adblock
    # download
    persepolis
    transmission_4-gtk
    czkawka
    # notes
    xournalpp
    sioyek
    # cli
    networkmanagerapplet
    steam-run
    gamescope
    # media
    #graphviz
    #blender
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
    libreoffice-qt
    xmind
    cpu-x
  ];

  programs = {
    # Enabel dconf for gtk theming
    dconf.enable = true;

    # Run unpatched dynamic libraries
    nix-ld.enable = true;

    firefox = {
      enable = true;
      package = pkgs.firefox-wayland;
      #package = (pkgs.firefox-wayland.override {extraNativeMessagingHosts = [pasff-host];});
      #package = pkgs.firefox-wayland.overrideAttrs (self: {
      #  desktopItem = self.desktopItem.override (self: {
      #    exec = "env DRI_PRIME=1 ${self.exec}";
      #  });
      #});
    };

    chromium = {
      enable = true;

      #plasmaBrowserIntegrationPackage = pkgs.kdePackages.plasma-browser-integration;
      extensions = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
        "gcbommkclmclpchllfjekcdonpmejbdp" # https everywhere
        "eimadpbcbfnmbkopoojfekhnkhdbieeh" # dark reader
      ];
    };

    # for captive portal (hotel wi-fi)
    captive-browser = {
      enable = true;
      package = pkgs.chromium;
      interface = "wlo1";
      browser = lib.concatStringsSep " " [
        ''env XDG_CONFIG_HOME="$PREV_CONFIG_HOME"''
        ''${pkgs.chromium}/bin/chromium''
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
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
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
