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

  # Set your username
  home = {
    username = "marmar";
    homeDirectory = "/home/marmar";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [
  #   git
  # ];

  # Enable home-manager and git
  # programs.home-manager.enable = true;
  # programs.git.enable = true;
  programs = {
    # Enable home-manager and git
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "Muhammad Ameer Rafiqi";
      userEmail = "m.ameerrafiqi@gmail.com";
    };

    bat = {
      enable = true;
    };

    yt-dlp = {
      enable = true;
      settings = {
        prefer-free-formats = true;
        write-subs = true;
        sponsorblock-mark = "all";
        write-description = true;
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

    btop = {
      enable = true;
      settings = {
        color_theme = "everforest-dark-hard";
        theme_background = false;
        proc_tree = true;
      };
    };

    newsboat = {
      enable = true;
    };
  };

  # For linking the files in config folder
  xdg = {
    configFile = {
      "zathura" = {
        recursive = true;
        source = ./../dotfiles/config/zathura;
      };
      # All the wallpapers that you might want to use
      "wallpaper" = {
        recursive = true;
        source = ./../dotfiles/config/wallpaper;
      };
      "alacritty" = {
        recursive = true;
        source = ./../dotfiles/config/alacritty;
      };
    };
  };

  home = {
    file = {
      # elinks
      ".elinks/elinks.conf" = {
        source = ./../dotfiles/config/elinks.conf;
      };
    };

    shellAliases = {
      "journal" = "nvim $(date -v-1d '+%d-%m-%Y').md";
      "iphone-pre-mount" = "idevicepair validate";
      "iphone-mount" = "mkdir ~/iphone && ifuse ~/iphone";
      "iphone-unmount" = "fusermount -u ~/iphone && rmdir ~/iphone";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
}
