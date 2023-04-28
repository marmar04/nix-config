;;; Commentary: Some startup code
;;; PACKAGE LIST
(setq package-archives 
      '(("melpa" . "https://melpa.org/packages/")
        ("elpa" . "https://elpa.gnu.org/packages/")))

;;; BOOTSTRAP USE-PACKAGE
(package-initialize)
(setq use-package-always-ensure t)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))

;; Load path for manually installed packages
(add-to-list 'load-path "~/.config/emacs/lisp/")

;; Set up the modules in ./lisp/
(require 'init-evil)
(require 'init-org)

;;; THEMING
;; Use catppuccin theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'catppuccin t)

;; Don't show the splash screen
(setq inhibit-startup-message t)  ; Comment at end of line!

;; elcord.el
(use-package elcord
  :config
  (setq elcord-use-major-mode-as-main-icon t
        elcord-editor-icon "emacs_icon"
        elcord-idle-message "Lost in the sea of configurability")
  (add-to-list `elcord-boring-buffers-regexp-list "^\\*scratch\\*$")
  (elcord-mode))

;;; MAJOR MODE
;; Nix
(use-package nix-mode
  :mode "\\.nix\\'")

;;; LSP MODE
