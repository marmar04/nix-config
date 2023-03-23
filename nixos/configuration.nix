# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  programsdb,
  nix-doom-emacs,
  ...
}: {
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware), use something like:
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here.
  ];

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

      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  };

  # FIXME: Add the rest of your current configuration

  nixpkgs = {
    config.permittedInsecurePackages = [
      "python-2.7.18.6"
    ];

    # overlays for packages
    overlays = [
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
    ];
  };

  security = {
    # Disable sudo and enable doas
    # sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [
        {
          users = ["marmar"];
          keepEnv = true;
        }
      ];
    };
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
        pkgs.networkmanager-openvpn
        pkgs.networkmanager-openconnect
      ];
    };
    stevenblack = {
      enable = true;
      block = ["fakenews" "gambling" "porn"];
    };
  };

  systemd = {
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

    power-profiles-daemon.enable = lib.mkForce false;

    # Enable earlyoom
    earlyoom.enable = true;

    geoclue2 = {
      enable = true;
      enable3G = false;
      enableCDMA = true;
    };

    xserver = {
      # Enable X server
      enable = true;

      digimend.enable = true;

      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;

      # Configure keymap in X11
      layout = "us";

      displayManager.gdm.enable = false;
      displayManager.lightdm.enable = false;
    };

    # Have dbus
    dbus.enable = true;

    # Enable printing
    printing = {
      enable = true;
      drivers = [pkgs.hplip];
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

    # Store VS Code auth token
    gnome.gnome-keyring.enable = true;

    # Enable flatpak
    flatpak.enable = true;
  };

  # Fonts
  fonts.fonts = with pkgs; [
    fira-code
    fira
    cooper-hewitt
    ibm-plex
    jetbrains-mono
    fira-code-symbols
    powerline-fonts
    nerdfonts
    font-awesome
    source-code-pro
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs;
  # For doom emacs
    let
      doom-emacs = nix-doom-emacs.packages.${pkgs.system}.default.override {
        doomPrivateDir = ./../dotfiles/config/doom.d;
      };
    in [
      # doom-emacs
      emacs
      clang
      # themes
      catppuccin-kde
      catppuccin-gtk
      papirus-icon-theme
      gnome.adwaita-icon-theme
      colloid-kde
      colloid-gtk-theme
      colloid-icon-theme
      # browsers
      firefox-esr-wayland
      # librewolf-wayland
      google-chrome
      # microsoft-edge-dev
      # communication
      thunderbird-wayland
      tdesktop
      pidgin
      zoom-us
      # download
      persepolis
      transmission-gtk
      czkawka
      # notes
      xournalpp
      # system
      glib
      hplip
      easyeffects
      xsane
      # skanlite
      libimobiledevice
      ifuse
      # editors
      texlive.combined.scheme-basic
      # cli
      dash
      coreutils
      lesspipe
      poppler_utils
      epr
      fortune
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
      neofetch
      htop
      lolcat
      ncdu
      inxi
      tealdeer
      compsize
      winePackages.minimal
      exfat
      networkmanagerapplet
      protonvpn-gui
      # media
      kdenlive
      gimp
      krita
      # inkscape
      darktable
      # rawtherapee
      handbrake
      zathura
      vlc
      mpv
      freetube
      gsettings-desktop-schemas
      # coding
      zeal
      yabasic
      python3Minimal
      # utilities
      # blueman
      gparted
      libreoffice-fresh
      xmind
      freemind
      bottles
      libsForQt5.qtstyleplugin-kvantum
      cpu-x
    ];

  boot = {
    initrd.systemd.enable = true;
    plymouth.enable = true;
  };

  programs = {
    # Enabel dconf for gtk theming
    dconf.enable = true;

    # If want to theme qt with qt5ct
    # qt5ct.enable = true;

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
  };

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  /*
  users.users = {
    # Replace with your username
    # Already in machines subdirectory
    marmar = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      # initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = [ "wheel" "networkmanager" "audio" "scanner" "lp" ];
    };
  };
  */

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.05";
}
