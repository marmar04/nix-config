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

  # Fonts
  fonts = {
    packages = with pkgs; [
      # emoji support
      noto-fonts-color-emoji
      jetbrains-mono
      # for japanese characters
      noto-fonts-cjk-sans
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # to run beamng.drive linux executable
    (let base = appimageTools.defaultFhsEnvArgs; in
     buildFHSEnv (base // {
        name = "fhs";
        profile = "export FHS=1";
        runScript = "bash";
        targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [pkgs.pkg-config];
        extraOutputsToInstall = ["dev"];
    }))
    appimage-run
    android-tools
    winetricks
    wine64Packages.waylandFull
    bottles
    # themes
    papirus-icon-theme
    adwaita-icon-theme
    # llama.cpp frontend to play with small local ai models
    jan
    # browsers
    (chromium.override {
      commandLineArgs = [
        "--enable-features=VaapiVideoDecodeLinuxGL"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
      ];
    })
    tor-browser
    # communication
    keepassxc
    thunderbird
    signal-desktop
    telegram-desktop
    calibre
    # download
    persepolis
    handbrake
    czkawka
    # notes
    joplin-desktop
    xournalpp
    sioyek
    # cli
    networkmanagerapplet
    steam-run
    gamescope
    # media
    #blender
    kdePackages.kdenlive
    gimp
    krita
    inkscape
    darktable
    # rawtherapee
    #freetube
    gsettings-desktop-schemas
    # coding
    zeal
    # utilities
    gparted
    libreoffice-qt6
  ];

  programs = {
    # Enabel dconf for gtk theming
    dconf.enable = true;

    # Run unpatched dynamic libraries
    nix-ld.enable = true;

    firefox = {
      enable = true;
      package = pkgs.firefox;
      #package = (pkgs.firefox-wayland.override {extraNativeMessagingHosts = [pasff-host];});
      #package = pkgs.firefox-wayland.overrideAttrs (self: {
      #  desktopItem = self.desktopItem.override (self: {
      #    exec = "env DRI_PRIME=1 ${self.exec}";
      #  });
      #});
    };

    chromium = {
      enable = true;

      extraOpts = {
        # enable manifest v2 extension support
	      "ExtensionManifestV2Availability" = 2;
      };

      extensions = [
        #"cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
        #"gcbommkclmclpchllfjekcdonpmejbdp" # https everywhere
        "ddkjiahejlhfcafbddmgiahcphecmpfh" # ublock origin lite
        "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # privacy badger
        "ldpochfccmkkmhdbclfhpagapcfdljkj" # decentraleyes
        "nngceckbapebfimnlniiiahkandclblb" # bitwarden
        "mdjildafknihdffpkfmmpnpoiajfjnjd" # consent o matic
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
