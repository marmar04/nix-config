{pkgs, ...}: {
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors), use something like:
    # inputs.nix-colors.homeManagerModule

    # Feel free to split up your configuration and import pieces of it here.
  ];

  services = {
    mako = {
      enable = true;
      defaultTimeout = 10000;
      backgroundColor = "#1e1e2e";
      borderColor = "#89b4fa";
      progressColor = "over #313244";
      extraConfig = ''
        [urgency=high]
        border-color=#fab387
      '';
    };
  };

  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };

    iconTheme = {
      # package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };

    theme = {
      name = "Catppuccin-Mocha-Compact-Green-Dark";
    };
  };

  # For linking the files in config folder
  xdg = {
    configFile = {
      "waybar/mocha.css" = {
        source = ./../../../dotfiles/config/waybar/mocha.css;
      };
      "rofi" = {
        recursive = true;
        source = ./../../../dotfiles/config/rofi;
      };
      "tofi" = {
        recursive = true;
        source = ./../../../dotfiles/config/tofi;
      };
      "fuzzel/fuzzel.ini" = {
        source = ./../../../dotfiles/config/fuzzel/fuzzel.ini;
      };
      "Kvantum" = {
        # recursive = true;
        # source = ./../../../dotfiles/config/Kvantum;
        enable = false;
        text = ''
          [General]
          theme=Catppuccin-Mocha-Green
        '';
      };
      "qt5ct" = {
        recursive = true;
        source = ./../../../dotfiles/config/qt5ct;
      };
    };
  };

  home.file = {
    # rofi theme
    ".local/share/rofi" = {
      recursive = true;
      source = ./../../../dotfiles/local/share/rofi;
    };
  };
}
