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
(require 'init-company)
(require 'init-general)

;;; THEMING
;; Use catppuccin theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'catppuccin t)

(use-package emacs
  :init
  ;; <OPTIONAL> Setting my favorite fonts here. You can replace "Roboto" with your favorite font.
  ;; You can also also adjust the size of the font with the "height" here under.
  (set-face-attribute 'default nil :family "JetBrains Mono" :height 120 :weight 'regular)
  (set-face-attribute 'fixed-pitch nil :family "JetBrains Mono" :height 120 :weight 'medium)
  (set-face-attribute 'variable-pitch nil :family "JetBrains Mono" :height 120 :weight 'medium)
  :config
  (setq-default cursor-type 'bar)              ; Line-style cursor similar to other text editors
  (setq inhibit-startup-screen t)              ; Disable startup screen (the welcome to Emacs message)
  (setq initial-scratch-message "")	       ; Make *scratch* buffer blank
  (setq-default frame-title-format '("%b"))    ; Make window title the buffer name
  (setq confirm-kill-processes nil)            ; Stop confirming the killing of processes
  (setq use-short-answers t)	               ; y-or-n-p makes answering questions faster
  (show-paren-mode t)	                       ; Visually indicates pair of matching parentheses
  (delete-selection-mode t)                    ; Start writing straight after deletion
  (setq read-process-output-max (* 1024 1024)) ; Increase the amount of data which Emacs reads from the process
  (global-hl-line-mode 1))                     ; Highlight the current line to make it more visible

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
