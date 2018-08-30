;;
;; Set up custom file
;;
(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))


;;
;; Configure backup files
;;
(let ((backup-dir (getenv "EMACS_BACKUP_DIR"))
      (week (* 60 60 24 7))
      (current (float-time (current-time))))
  (setq backup-directory-alist `(("." . ,backup-dir))))
  ;;(dolist (file (directory-files backup-dir t))
  ;;  (when (and (backup-file-name-p file)
  ;;         (> (- current (float-time (fifth (file-attributes file))))
  ;;  	  week))

  ;;    (message "Deleting old backup file: %s" file)
  ;;   (delete-file file))))


;;
;; Configure GUI
;;
(menu-bar-mode -1)
;(scroll-bar-mode -1)
;(tool-bar-mode -1)
(global-linum-mode)
(column-number-mode)


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

(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t
	auto-package-update-interval 4)
  (auto-package-update-maybe))

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
  (ivy-mode 1)
  (evil-leader/set-key "bb" 'ivy-switch-buffer)
  (evil-leader/set-key "bd" 'kill-this-buffer))

(use-package projectile
  :config
  (projectile-mode t))

(use-package counsel-projectile
  :config
  (counsel-projectile-mode))

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

(use-package go-mode)

(use-package web-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.gotmpl\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.hbs\\'" . web-mode)))
  ;(add-to-list 'auto-mode-alist '("\\.vue\\'" . web-mode)))

(use-package vue-html-mode)
(use-package vue-mode)

(use-package yaml-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode)))


;;
;; Indentation
;;
(defun init-indent (width tabs-flag)
  (setq indent-tabs-mode tabs-flag)
  (setq c-basic-offset width
	css-indent-offset width
	js-indent-level width
	tab-width width
	web-mode-markup-indent-offset width
	web-mode-css-indent-offset width
	web-mode-code-indent-offset width))

(add-hook 'c-mode-hook (lambda ()
			 (c-set-style "linux")
			 (init-indent 4 t)))
(add-hook 'c++-mode-hook (lambda ()
			   (c-set-style "linux")
			   (init-indent 4 t)))
(add-hook 'css-mode-hook (lambda ()
			   (init-indent 4 t)))
(add-hook 'go-mode-hook (lambda ()
			  (init-indent 4 t)))
(add-hook 'js-mode-hook (lambda ()
			  (init-indent 4 t)))
(add-hook 'web-mode-hook (lambda ()
			   (init-indent 4 t)
			   (web-mode-use-tabs)))


;;
;; Themes
;;
(use-package ample-theme
  :disabled
  :defer t
  :init
  (load-theme 'ample t))

(use-package monokai-theme
  :disabled
  :defer t
  :init
  (load-theme 'monokai t))

(use-package zenburn-theme
  :disabled
  :defer t
  :init
  (load-theme 'zenburn t))

(use-package base16-theme
  :disabled
  :defer t
  :init
  (load-theme 'base16-flat t))


;;
;; Misc
;;
(add-hook 'c-mode-common-hook
	  (lambda ()
	    (evil-leader/set-key "o" 'ff-find-other-file)
	    (add-to-list 'write-file-functions 'delete-trailing-whitespace)))

(add-hook 'go-mode-hook
	  (lambda ()
	    (add-hook 'before-save-hook 'gofmt-before-save)))
