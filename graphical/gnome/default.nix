{
  cfg,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager.sharedModules = [
    ./settings.nix
  ];

  services = {
    xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };

      desktopManager.gnome.enable = true;
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
    dino
    tuba

    # extensions
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-panel
    gnomeExtensions.arcmenu
    gnomeExtensions.just-perfection
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
