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

;;; THEMING
;; Use catppuccin theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'catppuccin t)

;; Don't show the splash screen
(setq inhibit-startup-message t)  ; Comment at end of line!

;;; UNDO
;; Vim style undo not needed for emacs 28
(use-package undo-fu)

;;; Vim Bindings
(use-package evil
  :demand t
  :bind (("<escape>" . keyboard-escape-quit))
  :init
  ;; allows for using cgn
  ;; (setq evil-search-module 'evil-search)
  (setq evil-want-keybinding nil)
  ;; no vim insert bindings
  (setq evil-undo-system 'undo-fu)
  :config
  (evil-mode 1))

;;; Vim Bindings Everywhere else
(use-package evil-collection
  :after evil
  :config
  (setq evil-want-integration t)
  (evil-collection-init))

(use-package elcord
  :config
  (setq elcord-use-major-mode-as-main-icon t
        elcord-editor-icon "emacs_icon"
        elcord-idle-message "Lost in the sea of configurability")
  (add-to-list `elcord-boring-buffers-regexp-list "^\\*scratch\\*$")
  (elcord-mode))
