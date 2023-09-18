{
  cfg,
  lib,
  pkgs,
  inputs,
  ...
}: {
  services = {
    xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };

      desktopManager.gnome.enable = true;
    };

    # remapping keys
    keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = ["*"];
          settings = {
            main = {
              capslock = "overload(control, esc)";
              esc = "capslock";
            };
          };
        };
        #   externalKeyboard = {
        #     ids = [ "1ea7:0907" ];
        #     settings = {
        #       main = {
        #         esc = capslock;
        #       };
        #     };
        #   };
      };
    };

    power-profiles-daemon.enable = true;

    udev.packages = with pkgs; [gnome.gnome-settings-daemon];
  };

  environment.systemPackages = with pkgs; [
    # themes
    adw-gtk3
    adwaita-qt
    gradience

    gnome.gnome-tweaks
    gnome.pomodoro

    # gnome circle
    shortwave
    shotwell
    newsflash
    foliate
    amberol
    blanket
    citations
    dialect
    wike
    junction
    komikku
    mousai
    solanum

    # socials
    gtkcord4
    dino
    fluffychat
    tuba

    # extensions
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-panel
    gnomeExtensions.arcmenu
    gnomeExtensions.rounded-window-corners
    gnomeExtensions.clipboard-indicator
  ];

  programs = {
    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };
}
