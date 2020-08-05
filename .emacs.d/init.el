(require 'package)
 
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
 

(setq package-enable-at-startup nil)
(package-initialize)

;; bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; Font settings
(add-to-list 'default-frame-alist
	     '(font . "FiraCode-12"))

;; Themes
(use-package nord-theme
  :ensure t
  :config
  (add-to-list 'custom-theme-load-path (expand-file-name "~/.emacs.d/themes/"))
  (load-theme 'nord t)
)

;; Mode line 
(use-package powerline
  :ensure t)
(use-package airline-themes
  :ensure t
  :config
  (load-theme 'airline-base16_nord t))
  
;; General configurations

(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)

(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)

(global-hl-line-mode)
;; Load varius mode

;; load evil
(use-package evil
  :ensure t ;; install the evil package if not installed
  :init ;; tweak evil's configuration before loading it
  (setq evil-search-module 'evil-search)
  (setq evil-ex-complete-emacs-commands nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-shift-round nil)
  (setq evil-want-C-u-scroll t)
  :config ;; tweak evil after loading it
  (evil-mode))

;; load lsp mode and languages mode

(use-package omnisharp
  :ensure t
  :hook (csharp-mode-hook . omnisharp-mode)
  )

(use-package lsp-mode
  :ensure t
  :hook (
	 csharp-mode . lsp)
  :commands lsp)
(setq lsp-chsarp-server-install-dir (expand-file-name "~/.emacs.d/.cache/lsp/omnisharp"))

(use-package lsp-ui
  :ensure t)

(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0.3)

  (global-company-mode 1)

  (global-set-key (kbd "C-SPC") 'company-complete))

;; (use-package company-lsp
;;   :ensure t
;;   :requires company
;;   :config
;;   (push 'company-lsp company-backends)
;;   ;; Disable client-side cache because the LSP server does a better job.
;;   (setq company-transformers nil
;;         company-lsp-async t
;;         company-lsp-cache-candidates nil))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (lsp-ui company-lsp lsp-mode use-package spinner nord-theme markdown-mode lv ht f evil dash-functional company airline-themes))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
