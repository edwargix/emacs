(require 'package)

;;; Add melpa archive
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
		    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))

;;; Add org archive
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

;;; Load and activate lisp packages
(package-initialize)

;;; Fetch the list of available packages
(unless package-archive-contents
  (package-refresh-contents))

;;; Install use-package for easy package configuration
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
