# Still a work in progress
{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
# Editors
{
  environment.systemPackages = with pkgs; [
    ycmd

    # Language servers
    nil
    nodejs
    go
    rust-analyzer
    nodePackages.npm
    jdk17_headless
    python310Packages.jedi
    python310Packages.jedi-language-server
    python39Packages.python-lsp-server
    jupyter
    php
    sqlite

    # Formatters
    astyle
    python311Packages.black

    # vim with extensions
    (vim-full.customize {
      name = "vim";

      vimrcConfig.customRC = ''
        set number
        colorscheme catppuccin_mocha
        autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE
      '';

      vimrcConfig.packages.vim = with pkgs.vimPlugins; {
        # Loaded on launch
        start = [vim-nix yuck-vim YouCompleteMe vimsence catppuccin-vim];

        # Will only be loaded on :packadd
        # opt = [vim-nix yuck-vim];
      };
    })
  ];
}
