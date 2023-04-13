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

    # inputs.neovim-flake.nixosModules.default

    # Feel free to split up your configuration and import pieces of it here.
  ];

  # Enable home-manager and git
  # programs.home-manager.enable = true;
  # programs.git.enable = true;
  programs = {
    alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
        window.opacity = 0.8;
        mouse.hide_when_typing = false;
      };
    };

    foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          term = "xterm-256color";

          font = "JetBrainsMono:size=11";
          dpi-aware = "yes";
        };

        mouse = {
          hide-when-typing = "yes";
        };
      };
    };

    bash = {
      enable = true;
      bashrcExtra = ''
        # Add any bashrc lines here
        bind '"\e[A":history-search-backward'
        bind '"\e[B":history-search-forward'
      '';
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      historySubstringSearch.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = ["tmux"];
        theme = "robbyrussell";
      };
    };

    starship = {
      enable = true;
    };
  };
}
