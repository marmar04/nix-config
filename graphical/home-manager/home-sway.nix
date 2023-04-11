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

  #  wayland.windowManager.sway = {
  #    enable = true;
  #    config = {
  #      assign = {};
  #      colors = {
  #        focused = {
  #          background = "#285577";
  #          border = "#4c7899";
  #          childBorder = "#285577";
  #          indicator = "#2e9ef4";
  #          text = "#ffffff";
  #        };
  #      };
  #    };
  #  };

  #  programs = {
  #    swayidle = {
  #      enable = true;
  #      timeouts = [
  #        { timeout = 180; command = "${pkgs.swaylock-effects}/bin/swaylock -f --clock -i ~/.config/wallpaper/end_cred2.png"; }
  #        { timeout = 300; command = "${pkgs.sway}/bin/swaymsg 'output * power off'"; resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * power on'"; }
  #      ];
  #      events = [
  #        { event = "before-sleep"; command = "${pkgs.swaylock-effects}/bin/swaylock -f --clock -i ~/.config/wallpaper/end_cred3.png"; }
  #        # { event = "lock"; command = "lock"; }
  #      ];
  #    };
  #  };

  # For linking the files in config folder
  xdg = {
    configFile = {
      "sway" = {
        recursive = true;
        source = ./../../dotfiles/config/sway;
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
}
