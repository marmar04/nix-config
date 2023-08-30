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

    gnome = {
      gnome-online-accounts.enable = true;
      # gnome-settings-daemon.enable = true;
      sushi.enable = true;
    };

    power-profiles-daemon.enable = true;

    udev.packages = with pkgs; [gnome.gnome-settings-daemon];
  };

  environment.systemPackages = with pkgs; [
    # themes
    adw-gtk3
    adwaita-qt

    shortwave

    gnome.gnome-tweaks
    gnome.pomodoro
    shotwell
    newsflash
    foliate

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
