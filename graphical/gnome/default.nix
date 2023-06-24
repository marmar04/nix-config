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
