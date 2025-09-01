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
    ./editors.nix
    ./theming.nix

    # Feel free to split up your configuration and import pieces of it here.
  ];

  # Set your username
  home = {
    username = "marmar";
    homeDirectory = "/home/marmar";
  };

  programs = {
    git = {
      enable = true;
      userName = "Muhammad Ameer Rafiqi";
      userEmail = "m.ameerrafiqi@gmail.com";
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    bat = {
      enable = true;
    };

    yt-dlp = {
      enable = true;
      settings = {
        prefer-free-formats = true;
        downloader = "aria2c";
        output = "%(title)s.%(ext)s";
        embed-thumbnail = false;
        write-subs = true;
        write-auto-subs = true;
        sponsorblock-mark = "all";
        sponsorblock-remove = "sponsor";
        write-description = false;
      };
    };

    mpv = {
      enable = true;
      config = {
        fs = "yes";
        ontop = "yes";
        ytdl-raw-options = "sub-lang=\"en\",write-sub=";
        alang = "my,en";
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

  services.syncthing = {
    enable = true;
    overrideDevices = false;
    overrideFolders = false;
  };

  # For linking the files in config folder
  xdg = {
    configFile = {
      # for any config files in ~/.config/"folder_name"
    };
  };

  home = {
    file = {
      # elinks
      ".config/elinks/elinks.conf" = {
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
