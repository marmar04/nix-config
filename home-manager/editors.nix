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
    inputs.neovim-flake.homeManagerModules.default
  ];

  # Sets up the variables so that vim is the default editor
  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  home.packages = with pkgs; [
    ycmd

    # Language servers
    nodejs
    inputs.nil.packages.${pkgs.system}.nil
    rust-analyzer
    nodePackages.npm
    ccls
    haskell-language-server
    nodePackages.pyright
    python310Packages.jedi
    python310Packages.jedi-language-server
    # For doom emacs latex integration
    texlive.combined.scheme-medium
    jupyter
    php
    sqlite

    # Formatters
    astyle
    python311Packages.black
  ];

  services = {
    emacs = {
      enable = true;
    };
  };

  programs = {
    # neovim
    neovim = {
      enable = true;
      # package = pkgs.neovim-nightly;
      extraConfig = ''
        ${builtins.readFile ./../dotfiles/config/nvim/init.vim}
        lua << EOF
        ${builtins.readFile ./../dotfiles/config/nvim/init.lua}
      '';
      plugins = with pkgs.vimPlugins; [
        vim-addon-nix
        nvim-lspconfig
        nvim-cmp
        cmp-buffer
        cmp-path
        cmp-spell
        # (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
        nvim-treesitter.withAllGrammars
        # nvim-treesitter
        cmp-treesitter
        orgmode
        onedark-nvim
        catppuccin-nvim
        neoformat
        vim-nix
        cmp-nvim-lsp
        barbar-nvim
        nvim-web-devicons
        vim-airline
        vim-ccls
        vim-airline-themes
        nvim-autopairs
        neorg
        vim-markdown
        rust-tools-nvim
        lspkind-nvim
      ];
      extraPackages = with pkgs; [
        gcc
        vimPlugins.packer-nvim
        ripgrep
        fd
        nodePackages.pyright
        nodePackages.eslint
        ccls
      ];
    };

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
      enable = true;
    };

    # Visual Studio Code
    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        dracula-theme.theme-dracula
        asvetliakov.vscode-neovim
        yzhang.markdown-all-in-one
        ms-vsliveshare.vsliveshare
        bbenoist.nix
        # ms-pyright.pyright
        ms-python.python
        ms-vscode.cpptools
        ms-vscode-remote.remote-ssh
        ms-toolsai.jupyter
        jnoortheen.nix-ide
        kamadorueda.alejandra
      ];
      /*
      userSettings = {
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = lib.getExe pkgs.nil;
        # "nix.formatterPath" = lib.getExe pkgs.alejandra;
        "alejandra.program" = lib.getExe pkgs.alejandra;
        "[nix]" = {
          # appears to be buggy at the moment
          "editor.stickyScroll.enabled" = false;
        };
        "vscode-neovim.neovimExecutablePaths.linux" = "/etc/profiles/per-user/marmar/bin/nvim";
      };
      */
    };
  };
  # xdg.configFile."nvim/coc-settings.json".text = builtins.readFile ./../../dotfiles/config/my-coc-settings.json;

  # Symlink for {,doom-}emacs configuration
  xdg.configFile = {
    /*
    "emacs" = {
      recursive = true;
      source = ./../dotfiles/config/emacs;
    };
    */

    "doom" = {
      recursive = true;
      source = ./../dotfiles/config/doom;
    };
  };

  # For the doom command
  home.shellAliases = {
    doom = "/home/marmar/.config/emacs/bin/doom";
  };
}
