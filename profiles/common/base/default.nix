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

    inputs.nh.nixosModules.default

    inputs.nur.nixosModules.nur

    # You can also split up your configuration and import pieces of it here.
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      # outputs.overlays.additions
      # outputs.overlays.modifications
      # outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })

      (self: super: {
        colloid-gtk-theme = super.colloid-gtk-theme.override {
          themeVariants = ["green"];
          colorVariants = ["dark"];
          sizeVariants = ["compact"];
          tweaks = ["rimless" "black"];
        };
      })

      (self: super: {
        catppuccin-gtk = super.catppuccin-gtk.override {
          accents = ["green"];
          size = "compact";
          tweaks = ["rimless"];
          variant = "mocha";
        };
      })

      (self: super: {
        catppuccin-kvantum = super.catppuccin-kvantum.override {
          accent = "Green";
          variant = "Mocha";
        };
      })

      # fluent icon theme
      (self: super: {
        fluent-icon-theme = super.fluent-icon-theme.override {
          roundedIcons = true;
          blackPanelIcons = true;
          colorVariants = ["green"];
        };
      })
    ];

    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      permittedInsecurePackages = [
        "python-2.7.18.6"
      ];
    };
  };

  # configure nh (nix helper)
  nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };

  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  security = {
    polkit.enable = true;
  };

  # zram configuration
  zramSwap = {
    enable = true;
    # priority = 10;
  };

  networking = {
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
        networkmanager-openconnect
      ];
    };
    # Blocklists of websites
    stevenblack = {
      enable = true;
      block = ["fakenews" "gambling" "porn"];
    };
  };

  systemd = {
    # make startup time faster
    services.NetworkManager-wait-online.enable = false;
    tmpfiles = {
      rules = [
        "L+ /lib/${builtins.baseNameOf pkgs.stdenv.cc.bintools.dynamicLinker} - - - - ${pkgs.stdenv.cc.bintools.dynamicLinker}"
        "L+ /lib64 - - - - /lib"
      ];
    };
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
    # For maximum power saving, may not be the most convenient
    # powertop.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Asia/Kuala_Lumpur";

  location.provider = "geoclue2";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    # font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  hardware = {
    opengl.enable = true;
    sane = {
      enable = true;
      extraBackends = [pkgs.hplipWithPlugin];
    };

    # Enable bluetooth support
    bluetooth.enable = true;

    # Disable pulseaudio
    pulseaudio.enable = lib.mkForce false;

    # Enable opentabletdriver
    # opentabletdriver.enable = true;
  };

  # Enable services
  services = {
    kmscon = {
      enable = true;
    };

    usbmuxd.enable = true;

    thermald.enable = true;

    power-profiles-daemon.enable = lib.mkDefault false;

    upower = {
      enable = true;
    };

    # Enable earlyoom
    earlyoom.enable = true;

    geoclue2 = {
      enable = true;
      enable3G = false;
      enableCDMA = true;
    };

    xserver = {
      # Enable X server
      enable = lib.mkDefault false;

      # digimend.enable = true;

      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;

      # Configure keymap in X11
      layout = "us";

      displayManager.gdm.enable = lib.mkDefault false;
      displayManager.lightdm.enable = lib.mkDefault false;
    };

    # Have dbus
    dbus.enable = true;

    # Enable printing
    printing = {
      enable = true;
      allowFrom = ["all"];
      drivers = with pkgs; [hplip];
    };

    # Enable sound with pipewire
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # for security credentials
    gnome.gnome-keyring.enable = true;
  };

  # Fonts
  fonts = {
    fontDir.enable = true;

    fonts = with pkgs; [
      corefonts
      #liberation_ttf
      fira-code
      fira
      fira-code-symbols
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly" "JetBrainsMono"];})
      source-code-pro
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # emacs
    clang
    # system
    bucklespring-libinput
    glib
    hplip
    easyeffects
    xsane
    # skanlite
    libimobiledevice
    ifuse
    # cli
    alsa-utils
    dash
    coreutils
    lesspipe
    poppler_utils
    epr
    gnuplot
    fortune
    ispell
    curl
    wget
    nnn
    w3m
    termusic
    pandoc
    tuir
    cht-sh
    moc
    ytfzf
    unzip
    killall
    fd
    ripgrep
    spotdl
    nix-du
    neofetch
    htop
    lolcat
    ncdu
    inxi
    tealdeer
    compsize
    winePackages.minimal
    exfat
    # coding
    zeal
    yabasic
  ];

  boot = {
    initrd.systemd.enable = true;
    plymouth.enable = true;

    tmp.cleanOnBoot = true;
  };

  programs = {
    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      customPaneNavigationAndResize = true;
    };

    command-not-found.dbPath = "/etc/programs.sqlite";
  };

  # List environment variables:

  # Enable wayland on firefox
  environment = {
    # Dash is just an example, you can use whatever you want
    binsh = "${pkgs.dash}/bin/dash";
    shells = with pkgs; [fish bash zsh];

    pathsToLink = ["/share/zsh"];

    etc = {
      "programs.sqlite".source = programsdb.packages.${pkgs.system}.programs-sqlite;
    };

    shellAliases = {
      yt-embed-sub = "yt-dlp -f bestvideo+bestaudio --embed-subs --write-auto-sub";
      yt-best-quality = "yt-dlp -f bestvideo+bestaudio";
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.05";
}
