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

      /*
      (self: super: {
        catppuccin-kde = super.catppuccin-kde.override {
          flavour = ["mocha"];
          # accents = ["green"];
        };
      })
      */
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

  security = {
    polkit.enable = true;
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

  # For flatpak
  xdg.portal.enable = true;

  # Fonts
  fonts = {
    fontDir.enable = true;

    fonts = with pkgs; [
      corefonts
      liberation_ttf
      fira-code
      fira
      jetbrains-mono
      fira-code-symbols
      powerline-fonts
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
      font-awesome
      source-code-pro
    ];

    fontconfig.defaultFonts = {
      monospace = ["JetBrains Mono"];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # emacs
    # themes
    gradience
    adw-gtk3
    catppuccin-kde
    catppuccin-gtk
    catppuccin-kvantum
    papirus-icon-theme
    fluent-icon-theme
    gnome.adwaita-icon-theme
    colloid-kde
    colloid-gtk-theme
    colloid-icon-theme
    # browsers
    firefox-wayland
    # librewolf-wayland
    google-chrome
    microsoft-edge
    tor-browser-bundle-bin
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
    bucklespring-libinput
    glib
    hplip
    easyeffects
    xsane
    # cli
    networkmanagerapplet
    protonvpn-gui
    # media
    graphviz
    kdenlive
    gimp
    krita
    # inkscape
    darktable
    # rawtherapee
    handbrake
    vlc
    mpv
    freetube
    gsettings-desktop-schemas
    # coding
    zeal
    yabasic
    # utilities
    gparted
    libreoffice-fresh
    xmind
    freemind
    bottles
    cpu-x
  ];

  programs = {
    # Enabel dconf for gtk theming
    dconf.enable = true;

  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.05";
}
