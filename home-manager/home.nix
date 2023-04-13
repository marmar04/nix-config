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

    ./terminal.nix

    # Feel free to split up your configuration and import pieces of it here.
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      # outputs.overlays.additions
      # outputs.overlays.modifications
      # outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

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
