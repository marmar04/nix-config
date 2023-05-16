{
  cfg,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.hyprland.nixosModules.default];

  home-manager.sharedModules = [
    ./home-hyprland.nix
    ./home-waybar.nix
  ];

  services = {
    # To start up tuigreet and set it up to start up hyprland after loging in
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      nvidiaPatches = true;
    };
  };

  fonts.fonts = with pkgs; [
    jost
    material-symbols
  ];

  environment.systemPackages = with pkgs; [
    # eww-wayland

    /*
    bc
    blueberry
    dunst
    findutils
    gnome.gnome-control-center
    gnused
    gojq
    imagemagick
    jaq
    procps
    socat
    */

    inputs.anyrun.packages.${pkgs.system}.anyrun
    tesseract
    libnotify
    gtklock
    udev
    util-linux
    wlogout
  ];

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.

  services = {
    dbus.enable = true;
    # to make gtklock work
    gnome.at-spi2-core.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    # extraPortals = [pkgs.xdg-desktop-portal-hyprland];
  };
}
