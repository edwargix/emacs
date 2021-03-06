;;; setup-lisp --- Setup lisp-related packages

;;; Commentary:

;; This sets up lisp-related packages, regardless of dialect

;;; Code:


(use-package elisp-slime-nav
  :ensure t
  :config
  (progn
    (dolist (map `(,emacs-lisp-mode-map
                   ;; ,ielm-map
                   ,lisp-interaction-mode-map))
      (with-eval-after-load 'evil
        (evil-define-key 'normal map (kbd "M-.") 'elisp-slime-nav-find-elisp-thing-at-point)
        (evil-define-key 'normal map (kbd "M-[") 'pop-tag-mark)
        (evil-define-key 'normal map (kbd "M-?") 'elisp-slime-nav-describe-elisp-thing-at-point)))))


(use-package auto-compile
  :ensure t
  :defer t
  :init
  (progn
    (setq auto-compile-display-buffer nil
          auto-compile-use-mode-line nil)
    (add-hook 'emacs-lisp-mode-hook 'auto-compile-mode)))


(use-package slime
  :ensure t
  :init
  (progn
    (slime-setup)
    (setq slime-contribs '(slime-scratch))
    (setq inferior-lisp-program "sbcl")))


(use-package common-lisp-snippets
  :ensure t
  :after yasnippet)


(provide 'setup-lisp)
;;; setup-lisp.el ends here
