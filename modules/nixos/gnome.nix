# Module to enable the plasma session
{ cfg, lib, pkgs, ... }: {

  services = {
    xserver = {
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };

      # displayManager.defaultSession = "plasmawayland";

      desktopManager.gnome = {
        enable = true;
      };
    };

    gnome = {
      gnome-online-accounts.enable = true;
      # gnome-settings-daemon.enable = true;
      sushi.enable = true;
    };

    udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
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
