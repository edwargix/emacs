;;; Change frame title
(setq frame-title-format "emacs")

;;; Font
(set-frame-font
 (font-spec
  :name "Source Code Pro"
  :size 13
  :weight 'normal
  :width 'normal)
 nil t)

;;; Disable menu bar
(menu-bar-mode 0)

;;; Disable scroll bar
(scroll-bar-mode 0)

;;; Disable tool bar
(tool-bar-mode 0)

;;; Turn off cursor blinking
(blink-cursor-mode 0)

;;; Show column number next to line number in mode line
(column-number-mode)

;;; Highlight parentheses
(show-paren-mode)

;;; Winner mode: allows for undoing and redoing of windoow configurations
;;; C-c <left> : undo
;;; C-c <right>: redo
(winner-mode t)

;;; Allow easily switching windows with Shift-{left,right,up.down}
(windmove-default-keybindings)

;;; Include package
(require 'package)

;;; Add melpa archives
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
		    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

;;; Load and activate lisp packages
(package-initialize)

;;; fetch the list of available packages
(unless package-archive-contents
  (package-refresh-contents))

;;; Install use-package for easy package configuration
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;;; Custom themes
;; Default theme
(unless (package-installed-p 'monokai-theme)
  (package-install 'monokai-theme))
(load-theme 'monokai t nil)
;; Alternate theme (bright)
(unless (package-installed-p 'leuven-theme)
  (package-install 'leuven-theme))
(load-theme 'leuven t t)

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

;;; Company (complete anything) mode
(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode))

;;; Quickhelp (documentation lookup) for company
(use-package company-quickhelp
  :ensure t
  :after company
  :config
  (setq company-quickhelp-idle-delay 1)
  (company-quickhelp-mode 1))

;;; company backend for C/C++ headers
(use-package company-c-headers
  :ensure t
  :defer t
  :init
  (add-to-list 'company-backends 'company-c-headers))

;;; Helm: incremental completion and selection narrowing framework
(use-package helm
  :ensure t
  :bind
  (("M-x" . helm-M-x)
   ("C-x r b" . helm-filtered-bookmarks)
   ("C-x C-f" . helm-find-files))
  :config
  (progn
    (require 'helm-config)
    (when (executable-find "curl")
      (setq helm-net-prefer-curl t))
    (add-hook 'helm-after-initialize-hook
	      ;; hide the cursor in helm buffers
	      (lambda ()
		(with-helm-buffer
		  (setq cursor-in-non-selected-windows nil))))
    (define-key helm-map (kbd "C-j") 'helm-next-line)
    (define-key helm-map (kbd "C-k") 'helm-previous-line)
    (define-key helm-map (kbd "C-h") 'helm-next-source)
    (define-key helm-map (kbd "C-S-h") 'describe-key)
    (define-key helm-map (kbd "C-l") (kbd "RET"))
    (define-key helm-map [escape] 'helm-keyboard-quit)
    (helm-mode 1)
    (dolist (keymap (list helm-find-files-map helm-read-file-map))
      (define-key keymap (kbd "C-l") 'helm-execute-persistent-action)
      (define-key keymap (kbd "C-h") 'helm-find-files-up-one-level)
      (define-key keymap (kbd "C-S-h") 'describe-key))))

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
    (load-file "~/org/agenda/setup.el")
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

(use-package projectile
  :ensure t
  :config
  (projectile-mode))

(use-package helm-projectile
  :ensure t
  :after projectile
  :config
  (paradox-enable)
  (helm-projectile-on))


;;; mu4e email client
(load-file "~/scripts/setup_mu4e.el")


(use-package ess
  :ensure t)

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
