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
    inputs.plasma-manager.homeManagerModules.plasma-manager

    # Feel free to split up your configuration and import pieces of it here.
    ./plasma-home.nix
  ];

  # Set your username
  home = {
    username = "marmar";
    homeDirectory = "/home/marmar";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    zeal # for language documentation
  ];

  # Enable home-manager and git
  # programs.home-manager.enable = true;
  # programs.git.enable = true;
  programs = {
    bat = {
      enable = true;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
}
