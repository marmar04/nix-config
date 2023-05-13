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
        }; #%s/\([0-9a-fA-F]\{6\}\)/"\1";/g
        colors = {
          foreground = "D3C6AA"; # Text
          background = "3a515d"; # Base
          regular0 = "45475a"; # Surface 1
          regular1 = "e67e80"; # red
          regular2 = "a7c080"; # green
          regular3 = "dbb7cf"; # yellow
          regular4 = "7fbbb3"; # blue
          regular5 = "d699b6"; # pink
          regular6 = "83c092"; # teal
          regular7 = "bac2de"; # Subtext 1
          bright0 = "585b70"; # Surface 2
          bright1 = "f85552"; # red
          bright2 = "8da101"; # green
          bright3 = "dfa000"; # yellow
          bright4 = "3a94c5"; # blue
          bright5 = "df69ba"; # pink
          bright6 = "35a77c"; # teal
          bright7 = "a6adc8"; # Subtext 0
        };
      };
    };

    bash = {
      enable = true;
      bashrcExtra = ''
        # Add any bashrc lines here
        bind '"\e[A":history-search-backward'
        bind '"\e[B":history-search-forward'

        eval "$(direnv hook zsh)"

        nixify() {
          if [ ! -e ./.envrc ]; then
            echo "use nix" > .envrc
            direnv allow
          fi
          if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
            cat > default.nix <<'EOF'
        with import <nixpkgs> {};
        mkShell {
          nativeBuildInputs = [
            bashInteractive
          ];
        }
        EOF
            ${EDITOR:-vim} default.nix
          fi
        }
        flakify() {
          if [ ! -e flake.nix ]; then
            nix flake new -t github:nix-community/nix-direnv .
          elif [ ! -e .envrc ]; then
            echo "use flake" > .envrc
            direnv allow
          fi
          ${EDITOR:-vim} flake.nix
        }
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
      initExtra = ''
        eval "$(direnv hook zsh)"

        nixify() {
          if [ ! -e ./.envrc ]; then
            echo "use nix" > .envrc
            direnv allow
          fi
          if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
            cat > default.nix <<'EOF'
        with import <nixpkgs> {};
        mkShell {
          nativeBuildInputs = [
            bashInteractive
          ];
        }
        EOF
            ${EDITOR:-vim} default.nix
          fi
        }
        flakify() {
          if [ ! -e flake.nix ]; then
            nix flake new -t github:nix-community/nix-direnv .
          elif [ ! -e .envrc ]; then
            echo "use flake" > .envrc
            direnv allow
          fi
          ${EDITOR:-vim} flake.nix
        }
      '';
    };

    starship = {
      enable = true;
    };
  };
}
