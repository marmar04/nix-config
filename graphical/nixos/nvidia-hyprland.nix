{hyprland, ...}: {
  cfg,
  lib,
  pkgs,
  ...
}: {
  programs = {
    hyprland = {
      nvidiaPatches = true;
    };
  };
}
