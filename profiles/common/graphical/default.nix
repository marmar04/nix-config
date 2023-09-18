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
    # themes
    #gradience
    #adw-gtk3
    #catppuccin-kde
    catppuccin-gtk
    catppuccin-kvantum
    papirus-icon-theme
    #fluent-icon-theme
    gnome.adwaita-icon-theme
    # browsers
    firefox-wayland
    #librewolf-wayland
    microsoft-edge
    tor-browser-bundle-bin
    # communication
    joplin-desktop
    localsend
    keepassxc
    thunderbird-wayland
    tdesktop
    pidgin
    calibre
    config.nur.repos.nltch.spotify-adblock
    # download
    persepolis
    transmission-gtk
    czkawka
    # notes
    xournalpp
    # cli
    networkmanagerapplet
    protonvpn-gui
    virt-manager
    # media
    #graphviz
    blender
    kdenlive
    gimp
    #krita
    inkscape
    darktable
    # rawtherapee
    handbrake
    vlc
    mpv
    #freetube
    gsettings-desktop-schemas
    # coding
    zeal
    yabasic
    # utilities
    gparted
    libreoffice-qt
    xmind
    cpu-x
  ];

  programs = {
    # Enabel dconf for gtk theming
    dconf.enable = true;

    # for captive portal (hotel wi-fi)
    captive-browser = {
      enable = true;
      interface = "wlo1";
    };

    # sandboxing apps
    firejail = {
      enable = true;
      wrappedBinaries = {
        google-chrome-stable = {
          executable = "${pkgs.google-chrome}/bin/google-chrome-stable";
          profile = "${pkgs.firejail}/etc/firejail/google-chrome.profile";
          desktop = "${pkgs.google-chrome}/share/applications/google-chrome.desktop";
          extraArgs = [
            "--dbus-user.talk=org.freedesktop.Notifications"
          ];
        };
      };
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
