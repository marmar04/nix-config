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
  # imports = [ nix-doom-emacs.hmModule ];

  environment = {
    systemPackages = with pkgs; [
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
      alejandra
      astyle
      python311Packages.black

      # vim with extensions
      (vim-full.customize {
        name = "vim";

        vimrcConfig.customRC = ''
          set number
          colorscheme catppuccin_mocha
          autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE

          autocmd FileType nix :packadd vim-nix
          autocmd FileType yuck :packadd yuck-vim
        '';

        vimrcConfig.packages.vim = with pkgs.vimPlugins {
          # Loaded on launch
          start = [YouCompleteMe vimsence catppuccin-vim];

          # Will only be loaded on :packadd
          opt = [vim-nix yuck-vim];
        };
      })

      (vscode-with-extensions.override {
	vscodeExtensions = with vscode-extensions; [
          dracula-theme.theme-dracula
	  bbenoist.nix
          asvetliakov.vscode-neovim
          yzhang.markdown-all-in-one
          ms-vsliveshare.vsliveshare
	  ms-python.python
	  ms-azuretools.vscode-docker
	  ms-vscode-remote.remote-ssh
	] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          # example of adding an extension that's not in the nix repository
	  {
	    name = "remote-ssh-edit";
	    publisher = "ms-vscode-remote";
	    version = "0.47.2";
	    sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
	  }
	];
      })
    ];

    variables = {
      EDITOR = "vim";
      VISUAL = "vim";
      BROWSER = "w3m";
    };
  };

  systemd.user.services.emacs = {
    Unit = {
      After = ["graphical-session-pre.target"];
      PartOf = ["graphical-session.target"];
    };

    Install.WantedBy = lib.mkForce ["graphical-session.target"];
  };

  services = {
    emacs = {
      enable = true;
    };
  };
}
