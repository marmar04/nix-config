;; Set catppuccin theme
(setq doom-theme 'catppuccin)

;; Set up jetbrains mono as default font
(setq doom-font (font-spec :family "JetBrainsMono" :size 12 :weight 'light)
      doom-variable-pitch-font (font-spec :family "JetBrainsMono" :size 13)
      doom-unicode-font (font-spec :family "JetBrainsMono")
      doom-big-font (font-spec :family "JetBrainsMono" :size 24))

;; Start up writegood-mode
(require 'writegood-mode)
(global-set-key "\C-cg" 'writegood-mode)
