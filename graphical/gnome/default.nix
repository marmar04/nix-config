{
  cfg,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.xremap.nixosModules.default];
  services = {
    xserver = {
      displayManager.gdm = {
        enable = lib.mkForce true;
        wayland = true;
      };

      desktopManager.gnome.enable = true;
    };

    gnome = {
      gnome-online-accounts.enable = true;
      # gnome-settings-daemon.enable = true;
      sushi.enable = true;
    };

    power-profiles-daemon = lib.mkForce true;

    udev.packages = with pkgs; [gnome.gnome-settings-daemon];
  };

  environment.systemPackages = with pkgs; [
    # themes
    adw-gtk3
    adwaita-qt

    /*
    gsound
    libgda6
    */
    foliate

    gnome.gnome-tweaks
    gnome.pomodoro
    shotwell
    newsflash

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
