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

;;;             _ _   _              _     _           _ _
;;;   _____   _(_) | | | _____ _   _| |__ (_)_ __   __| (_)_ __   __ _ ___
;;;  / _ \ \ / / | | | |/ / _ \ | | | '_ \| | '_ \ / _` | | '_ \ / _` / __|
;;; |  __/\ V /| | | |   <  __/ |_| | |_) | | | | | (_| | | | | | (_| \__ \
;;;  \___| \_/ |_|_| |_|\_\___|\__, |_.__/|_|_| |_|\__,_|_|_| |_|\__, |___/
;;;                            |___/                             |___/

;;; UNDO
;; Vim style undo not needed for emacs 28
(use-package undo-fu)

;;; Vim Bindings
(use-package bind-key
  :ensure t
  :config
  (add-to-list 'same-window-buffer-names "*Personal Keybindings*"))

(use-package evil
  :demand t
  :bind (("<escape>" . keyboard-escape-quit))
  :init
  ;; allows for using cgn
  ;; (setq evil-search-module 'evil-search)
  (setq evil-want-keybinding nil)
  ;; no vim insert bindings
  (setq evil-undo-system 'undo-fu)
  (evil-mode 1))

;;; Vim Bindings Everywhere else
(use-package evil-collection
  :after evil
  :config
  (setq evil-want-integration t)
  (evil-collection-init))

;(use-package general
;  :after evil
;  :config
;  ())

;;(require 'init-org)
;; This will copy & paste from doom emacs a _lot_
;; Just some startup code for now
(use-package org-journal)

;;;              _                                  _      _
;;;   __ _ _   _| |_ ___   ___ ___  _ __ ___  _ __ | | ___| |_ ___
;;;  / _` | | | | __/ _ \ / __/ _ \| '_ ` _ \| '_ \| |/ _ \ __/ _ \
;;; | (_| | |_| | || (_) | (_| (_) | | | | | | |_) | |  __/ ||  __/
;;;  \__,_|\__,_|\__\___/ \___\___/|_| |_| |_| .__/|_|\___|\__\___|
;;;                                          |_|
;;; autocomplete

;; Set up helm completion framework
(use-package helm
  :ensure t
  :config
  (setq helm-split-window-in-side-p         t   ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t   ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t   ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8   ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t))

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

;; eshell-toggle
(use-package eshell-toggle
  :custom
  (eshell-toggle-size-fraction 3)
  (eshell-toggle-use-projectile-root t)
  (eshell-toggle-run-command nil)
  (eshell-toggle-init-function #'eshell-toggle-init-ansi-term)
  :bind
  ("s-`" . eshell-toggle))

;; which-key
(use-package which-key
  :init
    (which-key-mode 1)
  :config
  (setq which-key-side-window-location 'bottom
	  which-key-sort-order #'which-key-key-order-alpha
	  which-key-sort-uppercase-first nil
	  which-key-add-column-padding 1
	  which-key-max-display-columns nil
	  which-key-min-display-lines 6
	  which-key-side-window-slot -10
	  which-key-side-window-max-height 0.25
	  which-key-idle-delay 0.8
	  which-key-max-description-length 25
	  which-key-allow-imprecise-window-fit t
	  which-key-separator " → " ))

;;;           _   _   _
;;;  ___  ___| |_| |_(_)_ __   __ _ ___
;;; / __|/ _ \ __| __| | '_ \ / _` / __|
;;; \__ \  __/ |_| |_| | | | | (_| \__ \
;;; |___/\___|\__|\__|_|_| |_|\__, |___/
;;;                           |___/

;;; THEMING
;; Use catppuccin theme
(use-package catppuccin-theme
  :config
  (load-theme 'catppuccin :no-confirm)
  (setq catppuccin-flavor 'mocha)
  (catppuccin-reload))

;;; SETTINGS
(use-package emacs
  :init
  ;; <OPTIONAL> Setting my favorite fonts here. You can replace "Roboto" with your favorite font.
  ;; You can also also adjust the size of the font with the "height" here under.
  (set-face-attribute 'default nil :family "JetBrainsMono Nerd Font" :height 120 :weight 'regular)
  (set-face-attribute 'fixed-pitch nil :family "JetBrainsMono Nerd Font" :height 120 :weight 'medium)
  (set-face-attribute 'variable-pitch nil :family "Cantarell" :height 120 :weight 'medium)
  :config
  (setq-default cursor-type 'bar)              ; Line-style cursor similar to other text editors
  (setq inhibit-startup-screen t)              ; Disable startup screen (the welcome to Emacs message)
  (setq initial-scratch-message "")	       ; Make *scratch* buffer blank
  (setq-default frame-title-format '("%b"))    ; Make window title the buffer name
  (setq confirm-kill-processes nil)            ; Stop confirming the killing of processes
  (setq use-short-answers t)	               ; y-or-n-p makes answering questions faster
  (setq backup-directory-alist '((".*" . "~/.local/share/Trash/files"))) ; Sets the backup files in the trashbin
  (save-place-mode 1)                          ; Save cursor position
  (show-paren-mode t)	                       ; Visually indicates pair of matching parentheses
  ;(electric-pair-mode)                         ; Auto-pairing of braces and parentheses for easier time programming
  (delete-selection-mode t)                    ; Start writing straight after deletion
  (setq read-process-output-max (* 1024 1024)) ; Increase the amount of data which Emacs reads from the process
  (tool-bar-mode -1)                           ; Removes toolbar for both graphical and terminal sessions
  (menu-bar-mode -1)                           ; Removes the menu bar for graphical and terminal sessions
  (scroll-bar-mode -1)                         ; Disable scrollbar
  (global-hl-line-mode 1)                      ; Highlight the current line to make it more visible
  (setq mouse-wheel-scroll-amount '(1 ((shift) . 1)) ; one line at a time
	mouse-wheel-progressive-speed nil      ; don't accelerate scrolling
	mouse-wheel-follow-mouse 't            ; scroll window under mouse
	scroll-step 1)                        ; keyboard scroll one line at a time
  ;; keep things out of ~/.emacs.d/
  (setq user-emacs-directory (expand-file-name "~/.cache/emacs/")
	url-history-file (expand-file-name "url/history" user-emacs-directory))
  ;; Startup
  (setq gc-cons-threshold (* 50 1000 1000))
  ;; fullscreen
  (set-frame-parameter (selected-frame) 'fullscreen 'maximized)
  (add-to-list 'default-frame-alist '(fullscreen . maximized)))

;; Profile emacs startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "*** Emacs loaded in %s seconds with %d garbage collections."
                     (emacs-init-time "%.2f")
                     gcs-done)))

(use-package no-littering)

;; smartparens
(use-package smartparens-mode
  :ensure smartparens  ;; install the package
  :hook (prog-mode text-mode markdown-mode nix-mode web-mode cc-mode org latex) ;; add `smartparens-mode` to these hooks
  :config
  ;; load default config
  (require 'smartparens-config))

;; zen mode
(use-package zen-mode)

;; elcord.el
;(use-package elcord
;  :config
;  (setq elcord-use-major-mode-as-main-icon t
;        elcord-editor-icon "emacs_icon"
;        elcord-idle-message "Lost in the sea of configurability")
;  (add-to-list `elcord-boring-buffers-regexp-list "^\\*scratch\\*$")
;  (elcord-mode -1))

;; Read ePub files
(use-package nov
  :init
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

;;;                   _                                  _
;;;  _ __ ___   __ _ (_) ___  _ __   _ __ ___   ___   __| | ___  ___
;;; | '_ ` _ \ / _` || |/ _ \| '__| | '_ ` _ \ / _ \ / _` |/ _ \/ __|
;;; | | | | | | (_| || | (_) | |    | | | | | | (_) | (_| |  __/\__ \
;;; |_| |_| |_|\__,_|/ |\___/|_|    |_| |_| |_|\___/ \__,_|\___||___/
;;;                |__/

;; snippets
(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode t)
  (define-key yas-minor-mode-map (kbd "M-z") 'yas-expand))
(use-package yasnippet-snippets)

;; Nix
(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'"
  :init (setq tab-width 2))

;; web (php, html, css)
(use-package web-mode
  :ensure t
  :mode ("\\.php\\'" "\\.html\\'" "\\.css\\'")
  :init (setq tab-width 4))

;; Yaml
(use-package yaml-mode
  :ensure t
  :mode "\\.yml\\'")

;; Markdown
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))
