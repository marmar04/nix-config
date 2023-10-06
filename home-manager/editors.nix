{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
# Editors
{
  imports = [
  ];

  # Sets up the variables so that vim is the default editor
  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  home.packages = with pkgs; [
    ycmd

    # Language servers
    #nodejs
    #rust-analyzer
    #nodePackages.npm
    #ccls
    #haskell-language-server
    #nodePackages.pyright
    #python310Packages.jedi
    #python310Packages.jedi-language-server
    #python311Packages.python-lsp-server
    # For doom emacs latex integration
    texlive.combined.scheme-medium
    jupyter
    php
    sqlite

    # Formatters
    astyle
    #python311Packages.black
  ];

  services = {
    emacs = {
      enable = false;
    };
  };

  programs = {
    # Vim
    vim = {
      enable = true;
      packageConfigurable = pkgs.vim_configurable;
      plugins = with pkgs.vimPlugins; [vim-nix YouCompleteMe vimsence catppuccin-vim yuck-vim];
      extraConfig =
        /*
        vim
        */
        ''
          set number relativenumber
          colorscheme catppuccin_mocha
          set shiftwidth=4
          autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE
        '';
    };

    # astroNvim
    # astronvim.enable = true;

    # Emacs
    emacs = {
      enable = false;
    };
  };

  # Symlink for {,doom-}emacs configuration
  xdg.configFile = {
    /*
    "emacs" = {
      recursive = true;
      source = ./../dotfiles/config/emacs;
    };

    "doom" = {
      recursive = true;
      source = ./../dotfiles/config/doom;
    };
    */
  };
}
