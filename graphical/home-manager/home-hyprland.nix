# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors), use something like:
    # inputs.nix-colors.homeManagerModule

    # Feel free to split up your configuration and import pieces of it here.
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    nvidiaPatches = true;

    recommendedEnvironment = true;
    systemdIntegration = true;
  };

  programs = {
    eww = {
      enable = true;
      package = pkgs.eww-wayland;
      configDir = ./../../dotfiles/config/eww;
    };
  };

  # For linking the files in config folder
  xdg = {
    configFile = {
      "hypr" = {
        recursive = true;
        source = ./../../dotfiles/config/hypr;
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
}
