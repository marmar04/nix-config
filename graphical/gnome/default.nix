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

  environment.systemPackages = (with pkgs; [
    # themes
    adw-gtk3
    adwaita-qt
    gradience

    # gnome circle
    shortwave
    gnome-podcasts
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
    gnome-solanum
    curtail

    # socials
    dino
    tuba
    #fractal-next # leave to compile overnight
  ]) ++
  (with pkgs.gnome; [
    gnome-tweaks
    pomodoro
    polari
    gnome-boxes
    gnome-sudoku
  ]) ++
  (with pkgs.gnomeExtensions; [
    appindicator
    dash-to-panel
    arcmenu
    just-perfection
    rounded-window-corners
    clipboard-indicator
  ]);

  programs = {
    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };
}
