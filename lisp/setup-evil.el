;;; setup-evil --- Setup evil

;;; Commentary:

;; Setup evil mode to my liking

;;; Code:


;;; Evil (extensible vi layer)
(use-package evil
  :ensure t
  :init
  (progn
	(setq evil-want-C-u-scroll t))
  :config
  (progn
	(require 'evil)
	(evil-define-key 'motion help-mode-map (kbd "<tab>") 'forward-button)
	(evil-define-key 'motion help-mode-map (kbd "S-<tab>") 'backward-button)
	(define-key evil-ex-map "b " 'helm-mini)
	(define-key evil-ex-map "e " 'helm-find-files)
	(add-hook 'with-editor-mode-hook 'evil-insert-state)
	(evil-mode 1)))


;;; Easily surround text
(use-package evil-surround
  :ensure t
  :after evil
  :config
  (progn
	(global-evil-surround-mode 1)))


;;; Evil keybindings for magit
(use-package evil-magit
  :after evil
  :ensure t)


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


(provide 'setup-evil)
;;; setup-evil.el ends here