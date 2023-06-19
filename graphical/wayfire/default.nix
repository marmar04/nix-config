{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hyprland.nixosModules.default

    ./../common/wlroots
  ];

  home-manager.sharedModules = [
    ./home-wayfire.nix
    ./home-waybar.nix
  ];

  services = {
    # To start up tuigreet and set it up to start up hyprland after loging in
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd wayfire";
          user = "greeter";
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    # eww-wayland

    wayfire

    wcm

    bc
    findutils
    jaq
    tesseract
    libnotify
    hyprpicker
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
