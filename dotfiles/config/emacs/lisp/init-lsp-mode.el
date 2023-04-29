;; Setting up lsp-mode
(use-package lsp-mode
  :ensure t
  :defer t
  :defines (lsp-keymap-prefix lsp-mode-map)
  :init
  (setq lsp-keymap-prefix "C-c l")

  :custom
  ;; Read the documentation for those variable with `C-h v'.
  ;; This reduces the visual bloat that LSP sometimes generate.
  (lsp-eldoc-enable-hover nil)
  (lsp-signature-auto-activate nil)
  (lsp-completion-enable t)

  :hook ((lsp-mode . lsp-enable-which-key-integration))

  :commands (lsp lsp-deferred))
