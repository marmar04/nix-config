{hyprland, ...}: {
  cfg,
  lib,
  pkgs,
  ...
}: let
  hyprland-startup = pkgs.writeTextFile {
    name = "hyprland-startup";
    destination = "/bin/hyprland-startup";
    executable = true;
    text = ''
      #!/bin/sh

      cd ~

      export _JAVA_AWT_WM_NONREPARENTING=1
      export XCURSOR_SIZE=24
      # for nvidia
      export LIBVA_DRIVER_NAME=nvidia
      export XDG_SESSION_TYPE=wayland
      export GBM_BACKEND=nvidia-drm
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export WLR_NO_HARDWARE_CURSORS=1

      exec Hyprland
    '';
  };
in {
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
      nvidiaPatches = true;
    };
  };

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  /*
  * services.dbus.enable = true;
  * xdg.portal = {
  *   enable = true;
  *   wlr.enable = true;
  *   # gtk portal needed to make gtk apps happy
  *   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  * };
  */
}
