;;; setup-keys --- Setup keys

;;; Commentary:

;; Setup keybindings to my liking

;;; Code:


;;; Evil (extensible vi layer)
(use-package evil
  :ensure t
  :init
  (progn
    (setq evil-want-C-u-scroll t
          evil-want-integration nil
          evil-want-keybinding nil)) ; needed by evil-collection
  :config
  (progn
    (require 'evil)
    (define-key evil-ex-map "b " 'helm-mini)
    (define-key evil-ex-map "e " 'helm-find-files)
    (add-hook 'with-editor-mode-hook 'evil-insert-state)
    (evil-global-set-key 'normal (kbd "SPC") mode-specific-map)
    (evil-global-set-key 'motion (kbd "SPC") mode-specific-map)
    (evil-global-set-key 'normal (kbd "SPC u") 'universal-argument)
    (evil-global-set-key 'motion (kbd "SPC u") 'universal-argument)
    (evil-mode 1)))


(setq scroll-step 1
      delete-selection-mode 1)


(use-package evil-collection
  :ensure t
  :after evil
  :init
  (evil-collection-init))


;;; Easily surround text
(use-package evil-surround
  :ensure t
  :after evil
  :config
  (progn
    (global-evil-surround-mode 1)))


;;; Evil keybindings for magit
(use-package evil-magit
  :after (evil magit)
  :ensure t)


;;; Evil keybindings for org
(use-package evil-org
  :ensure t
  :after (evil org)
  :config
  (progn
    (add-hook 'org-mode-hook 'evil-org-mode)
    (add-hook 'evil-org-mode-hook
              (lambda ()
                (evil-org-set-key-theme)))))


;;; I don't always know where my frames are, and I want a way to kill
;;; Emacs 100% of the time
(global-set-key (kbd "C-x C-c") 'save-buffers-kill-emacs)
(global-set-key (kbd "<f9>") (lambda () (interactive)
                               (kill-buffer)
                               (delete-window)))
(global-set-key (kbd "<f12>") (lambda ()
                                ;; lambda needed to kill current buffer
                                (interactive)
                                (kill-buffer)))


(use-package evil-matchit
  :ensure t
  :init
  (progn
    (add-hook 'python-mode-hook 'turn-on-evil-matchit-mode)))


;;; Function keys
(global-set-key (kbd "<f5>") (lambda ()
                               (interactive)
                               (setq-local compilation-read-command nil)
                               (call-interactively 'compile)))
(global-set-key (kbd "<f6>") #'shell)
(global-set-key (kbd "<f7>") #'eshell)
(global-set-key (kbd "<f8>") (lambda ()
                               (interactive)
                               (switch-to-buffer "*scratch*")))


(provide 'setup-keys)
;;; setup-keys.el ends here
