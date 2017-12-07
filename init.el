
(add-to-list 'load-path "~/.emacs.d/lisp")

(require 'setup-packages)
(require 'setup-appearance)
(require 'setup-dev)
(require 'setup-helm)

;;; Winner mode: allows for undoing and redoing of windoow configurations
;;; C-c <left> : undo
;;; C-c <right>: redo
(winner-mode t)

;;; Allow easily switching windows with Shift-{left,right,up.down}
(windmove-default-keybindings)

;;; Don't make backup files
(setq make-backup-files nil)

;;; Markdown mode
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
		 ("\\.md\\'" . markdown-mode)
		 ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;;; Evil (extensible vi layer)
(use-package evil
  :init
  (setq evil-want-C-u-scroll t)
  :ensure t
  :config
  (progn
	(evil-define-key 'motion help-mode-map (kbd "<tab>") 'forward-button)
	(evil-define-key 'motion help-mode-map (kbd "S-<tab>") 'backward-button)
	(define-key evil-ex-map "b " 'helm-mini)
	(define-key evil-ex-map "e " 'helm-find-files)
	(add-hook 'with-editor-mode-hook 'evil-insert-state)
	(evil-mode 1)))
(use-package evil-surround
  :ensure t
  :after evil
  :config
  (progn
	(global-evil-surround-mode 1)))

;;; Magit: a Git Porcelain inside Emacs
(use-package magit
  :ensure t
  :bind
  (("C-x g" . magit-status)
   ("C-x M-g" . magit-dispatch-popup)))

;;; Evil keybindings for magit
(use-package evil-magit
  :after evil
  :ensure t)

;;; Syntax/error checking for GNU Emacs
(use-package flycheck
  :ensure t
  :init
  (progn
	(global-flycheck-mode)
	(evil-define-key 'normal
	  flycheck-error-list-mode-map (kbd "q") 'quit-window)))

;;; Quickhelp (documentation lookup) for company
(use-package company-quickhelp
  :ensure t
  :after company
  :config
  (progn
	(setq company-quickhelp-idle-delay 1)
	(company-quickhelp-mode 1)))

;;; company backend for C/C++ headers
(use-package company-c-headers
  :ensure t
  :defer t
  :init
  (add-to-list 'company-backends 'company-c-headers))

;;; Yasnippet: yet another snippet extension
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

;;; Setup duckduckgo search engine
(use-package engine-mode
  :ensure t
  :config
  (defengine duckduckgo
	"https://duckduckgo.com/?q=%s"
	:keybinding "d")
  (engine-mode))

;;; Org mode for keeping notes, todo lists, planning, and fast
;;; documenting
(use-package org
  :init
  (progn
	(load-file "~/org/setup.el")
	(unless (package-installed-p 'org-plus-contrib)
	  (package-install 'org-plus-contrib))
	(setq org-default-notes-file "~/notes.org"
		  org-return-follows-link t
		  org-read-date-force-compatible-dates nil))
  :bind
  (("C-c a" . org-agenda)
   ("C-c c" . org-capture)
   ("C-c b" . org-iswitchb)))

;;; UTF-8 bullets for org-mode
(use-package org-bullets
  :ensure t
  :defer t
  :after org
  :config
  (progn
	(add-hook 'org-mode-hook 'org-bullets-mode)))

;;; Evil keybindings for org
(use-package evil-org
  :init
  (progn
	(add-hook 'org-mode-hook 'evil-org-mode)
	(add-hook 'evil-org-mode-hook
			  (lambda ()
				(evil-org-set-key-theme)
				(evil-define-key 'normal
				  evil-org-mode-map
				  (kbd "<return>")
				  'evil-org-return))))
  :ensure t
  :after org)

;;; Paradox: a modern package menu
(use-package paradox
  :ensure t
  :config
  (paradox-enable))



;;; mu4e email client
(load-file "~/scripts/setup_mu4e.el")


(use-package ess
  :ensure t)


(use-package tex
  :ensure auctex)


;;; Install local user packages
(dolist (d (file-expand-wildcards "~/.local/share/emacs/site-lisp/*"))
  (add-to-list 'load-path d t))
(add-to-list 'Info-directory-list "~/.local/share/info/")

;;; Start Emacs Daemon
(unless (server-running-p)
  (server-start))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(initial-buffer-choice "~/.emacs.d/init.el")
 '(initial-scratch-message "")
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
