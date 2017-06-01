;;
;; Set up custom file
;;
(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))


;;
;; Configure backup files
;;
(setq backup-directory-alist `(("." . (getenv "EMACS_BACKUP_DIR"))))
(let ((week (* 60 60 24 7))
      (current (float-time (current-time))))
  (dolist (file (directory-files (getenv "EMACS_BACKUP_DIR") t))
    (when (and (backup-file-name-p file)
	       (> (- current (float-time (fifth (file-attributes file))))
		  week))
      (message "Deleting old backup file: %s" file)
      (delete-file file))))


;;
;; Disable the GUI bars
;;
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)


;;
;; Package manager boilerplate
;;
(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(setq use-package-always-ensure t)


;;
;; Packages
;;

;; These variables need to be set before evil is required
(setq evil-want-C-u-scroll t) ; Corrects C-u scrolling
(setq evil-want-C-i-jump nil) ; Corrects TAB to handle indentation

(use-package evil-leader
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader "<SPC>"))

(use-package evil
  :config
  (evil-mode t))

(use-package ivy
  :init
  (setq ivy-use-virtual-buffers t)
  :config
  (ivy-mode 1))

(use-package projectile
  :config
  (projectile-mode t))

(use-package counsel-projectile
  :config
  (counsel-projectile-on))

(defun neotree-project-dir ()
  "Open NeoTree using the git root."
  (interactive)
  (neotree-toggle)
  (let ((project-dir (projectile-project-root))
  		(file-name (buffer-file-name)))
  	(if project-dir
  	  (if (neo-global--window-exists-p)
  	  	(progn
  	  	  (neotree-dir project-dir)
  	  	  (neotree-find file-name)))
  	  (message "Could not find git project root."))))

(use-package neotree
  :commands (neotree-enter neotree-hide neotree-toggle)
  :config
  (setq neo-theme 'ascii)
  :init
  (evil-leader/set-key "f" 'neotree-project-dir)
  (evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
  (evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)
  (evil-define-key 'normal neotree-mode-map (kbd "SPC") 'neotree-enter)
  (evil-define-key 'normal neotree-mode-map (kbd "TAB") 'neotree-enter))

(use-package smart-tabs-mode
  :init
  (smart-tabs-insinuate 'c 'c++))


;;
;; Indentation
;;
(defun init-indent (width tabs-flag)
  (setq indent-tabs-mode tabs-flag)
  (setq c-basic-offset width
  		tab-width width)
  (c-set-style "linux"))

(add-hook 'c-mode-hook   (lambda () (init-indent 4 t)))
(add-hook 'c++-mode-hook (lambda () (init-indent 4 t)))


;;
;; Themes
;;
(use-package ample-theme
  :defer t
  :init
  (load-theme 'ample-light t))

(use-package monokai-theme
  :disabled
  :defer t
  :init
  (load-theme 'monokai t))
