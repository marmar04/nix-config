;;; Commentary: Some startup code
;;; PACKAGE LIST
;;(setq package-archives 
;;      '(("melpa" . "https://melpa.org/packages/")
;;        ("elpa" . "https://elpa.gnu.org/packages/")))

;;; BOOTSTRAP USE-PACKAGE
(package-initialize)
(setq use-package-always-ensure t)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))

;; Load path for manually installed packages
;;(add-to-list 'load-path "~/.config/emacs/lisp/")

;; Set up the modules in ./lisp/
;;(require 'init-evil)
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

;;(require 'init-org)
;; This will copy & paste from doom emacs a _lot_
;; Just some startup code for now
(use-package org-journal)

;;(require 'init-company)
;; Provide drop-down completion.
(use-package company
  :ensure t
  :defer t
  :custom
  ;; Search other buffers with the same modes for completion instead of
  ;; searching all other buffers.
  (company-dabbrev-other-buffers t)
  (company-dabbrev-code-other-buffers t)

  ;; M-<num> to select an option according to its number.
  (company-show-numbers t)

  ;; Only 2 letters required for completion to activate.
  (company-minimum-prefix-length 3)

  ;; Do not downcase completions by default.
  (company-dabbrev-downcase nil)

  ;; Even if I write something with the wrong case,
  ;; provide the correct casing.
  (company-dabbrev-ignore-case t)

  ;; company completion wait
  (company-idle-delay 0.2)

  ;; No company-mode in shell & eshell
  (company-global-modes '(not eshell-mode shell-mode))
  ;; Use company with text and programming modes.
    :hook ((text-mode . company-mode)
           (prog-mode . company-mode)))

;;(require 'init-general)
(use-package general)

;; * Global Keybindings
;; `general-define-key' acts like `evil-define-key' when :states is specified
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (general-define-key           ;;
;;  :states 'motion              ;;
;;  ;; swap ; and :              ;;
;;   ";" 'evil-ex                ;;
;;   ":" 'evil-repeat-find-char) ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; * Mode Keybindings
(general-define-key
 :states 'normal
 :keymaps 'emacs-lisp-mode-map
 ;; or xref equivalent
 "K" 'elisp-slime-nav-describe-elisp-thing-at-point)
;; `general-def' can be used instead for `evil-define-key'-like syntax
(general-def 'normal emacs-lisp-mode-map
  "K" 'elisp-slime-nav-describe-elisp-thing-at-point)

;; * Prefix Keybindings
;; :prefix can be used to prevent redundant specification of prefix keys
;; again, variables are not necessary and likely not useful if you are only
;; using a definer created with `general-create-definer' for the prefixes
;; (defconst my-leader "SPC")
;; (defconst my-local-leader "SPC m")

(general-create-definer my-leader-def
  ;; :prefix my-leader
  :prefix "SPC")

(general-create-definer my-local-leader-def
  ;; :prefix my-local-leader
  :prefix "SPC m")

;; ** Global Keybindings
(my-leader-def
  :keymaps 'normal
  ;; bind "SPC a"
  "a" 'org-agenda
  "b" 'counsel-bookmark
  "c" 'org-capture)
;; `general-create-definer' creates wrappers around `general-def', so
;; `evil-global-set-key'-like syntax is also supported
(my-leader-def 'normal
  "a" 'org-agenda
  "b" 'counsel-bookmark
  "c" 'org-capture)

;; to prevent your leader keybindings from ever being overridden (e.g. an evil
;; package may bind "SPC"), use :keymaps 'override
(my-leader-def
  :states 'normal
  :keymaps 'override
  "a" 'org-agenda)
;; or
(my-leader-def 'normal 'override
  "a" 'org-agenda)

;; ** Mode Keybindings
(my-local-leader-def
  :states 'normal
  :keymaps 'org-mode-map
  "y" 'org-store-link
  "p" 'org-insert-link
  ;; ...
  )
;; `general-create-definer' creates wrappers around `general-def', so
;; `evil-define-key'-like syntax is also supported
(my-local-leader-def 'normal org-mode-map
  "y" 'org-store-link
  "p" 'org-insert-link
  ;; ...
  )

;; * Settings
;; change evil's search module after evil has been loaded (`setq' will not work)
(general-setq evil-search-module 'evil-search)

;;; LSP
(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (python-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; optionally
(use-package lsp-ui :commands lsp-ui-mode)
;; if you are helm user
(use-package helm-lsp :commands helm-lsp-workspace-symbol)
;; if you are ivy user
;;(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
;;(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
(use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; optional if you want which-key integration
(use-package which-key
    :config
    (which-key-mode))

;;; THEMING
;; Use catppuccin theme
(use-package catppuccin-theme)
;;(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'catppuccin :no-confirm)
(setq catppuccin-flavor 'mocha)
(catppuccin-reload)

;;; SETTINGS
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
  (setq backup-directory-alist '((".*" . "~/.Trash"))) ; Sets the backup files to be made in ~/.Trash
  (save-place-mode 1)                          ; Save cursor position
  (show-paren-mode t)	                       ; Visually indicates pair of matching parentheses
  (electric-pair-mode)                         ; Auto-pairing of braces and parentheses for easier time programming
  (delete-selection-mode t)                    ; Start writing straight after deletion
  (setq read-process-output-max (* 1024 1024)) ; Increase the amount of data which Emacs reads from the process
  (tool-bar-mode -1)                           ; Removes toolbar for both graphical and terminal sessions
  (menu-bar-mode -1)                           ; Removes the menu bar for graphical and terminal sessions
  (global-hl-line-mode 1))                     ; Highlight the current line to make it more visible

;; smartparens
;(use-package smartparens
;  :init (require 'smartparens-config))

;; elcord.el
(use-package elcord
  :config
  (setq elcord-use-major-mode-as-main-icon t
        elcord-editor-icon "emacs_icon"
        elcord-idle-message "Lost in the sea of configurability")
  (add-to-list `elcord-boring-buffers-regexp-list "^\\*scratch\\*$")
  (elcord-mode -1))

;;; MAJOR MODE
;; Nix
(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'"
  :init (setq tab-width 2))

;; Yaml
(use-package yaml-mode
  :ensure t
  :mode "\\.yml\\'")

;; Markdown
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))
