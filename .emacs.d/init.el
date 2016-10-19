;; in terminal
;; $ cd ~/.emacs.d
;; $ mkdir elisp public_repos conf elpa

(package-initialize)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

;; def add-to-load-path
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))
;; add directories to load-path
(add-to-load-path "elisp" "conf" "public_repos")

;; key-bind settings
(define-key global-map (kbd "C-m") 'newline-and-indent)
(define-key global-map (kbd "C-h") 'backward-delete-char)
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)
(define-key global-map (kbd "C-t") 'other-window)
(define-key global-map (kbd "C-,") 'undo)
;; key-bind using redo+
;;(when (require 'redo+ nil t)
;;  (global-set-key (kbd "C-.") 'redo))
(define-key global-map (kbd "C-c k") 'describe-bindings)
(define-key global-map (kbd "M-y") 'anything-show-kill-ring)
(define-key global-map (kbd "C-x C-f") 'anything-for-files)
(define-key global-map (kbd "C-x x") 'find-file)

;; frame settings
(column-number-mode t) ; under col num
(line-number-mode t) ; under line num
(global-linum-mode t) ; left line num
(size-indication-mode t) ; file size
(display-time-mode t) ; time and date
(setq display-time-day-and-date t)
(setq display-time-24hr-format t)
(setq frame-title-format "%f") ; show full-path on title bar

;; indent settings
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

;; theme settings : color-theme homepage(http://www.nongnu.org/color-theme/)
;; color-theme-6.6.0.tar.gz => ~/.emacs.d/elisp/color-theme-6.6.0
(when (require 'color-theme nil t)
  (color-theme-initialize)
  (color-theme-billw))

;; high light current line and parenthesis
(defface my-hl-line-face
  '((((class color) (background dark))
     (:background "NavyBlue" t))
    (((class color) (background light))
     (:background "LightGoldenrodYellow" t))
    (t (:bold t)))
  "hl-line's my face")
(setq hl-line-face 'my-hl-line-face)
(global-hl-line-mode t)

(setq show-paren-delay 0)
(show-paren-mode t)
(setq show-paren-style 'expression)
(set-face-background 'show-paren-match-face nil)
(set-face-underline-p 'show-paren-match-face "yellow")

;; backup and auto save settings
;; cd ~/.emacs.d; mkdir backups
(add-to-list 'backup-directory-alist
             (cons "." "~/.emacs.d/backups"))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "~/.emacs.d/backups/") t)))
(setq auto-save-timeout 15) ; seconds
(setq auto-save-interval 60) ; key-type interval

;; when #!, save with +x
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)


;; ============================================================
;; Elisp
;; ============================================================

;; auto-install
;; cd ~/.emacs.d/elisp
;; curl -L -O http://www.emacswiki.org/emacs/download/auto-install.el
(when (require 'auto-install nil t)
  (setq auto-install-directory "~/.emacs.d/elisp/")
  (auto-install-update-emacswiki-package-name t)
  (auto-install-compatibility-setup))

;; redo+ settings >> key binds
;;   not provided ???

;; anything
;; https://www.emacswiki.org/emacs/download/WgetSnarfAnything
(when (require 'anything nil t)
  (setq
   anything-idle-delay 0.3
   anything-input-idle-delay 0.2
   anything-candidate-number-limit 100
   anything-quick-update t
   anything-enable-shortcuts 'alphabet)
  (when (require 'anything-config nil t)
    (setq anything-su-or-sudo "sudo"))
  (require 'anything-match-plugin nil t)
  (when (and (executable-find "cmigemo")
             (require 'migemo nil t))
    (require 'anything-migemo nil t))
  (when (require 'anything-complete nil t)
    (anything-lisp-complete-symbol-set-timer 150))
  (require 'anything-show-completion nil t)
  (when (require 'auto-install nil t)
    (require 'anything-auto-install nil t))
  (when (require 'descbinds-anything nil t)
    (descbinds-anything-install)))
;; moccur
;; https://www.emacswiki.org/emacs/color-moccur.el
;; http://svn.coderepos.org/share/lang/elisp/anything-c-moccur/trunk/anything-c-moccur.el
(when (require 'anything-c-moccur nil t)
  (setq
   anything-c-moccur-anything-idle-delay 0.1
   lanything-c-moccur-higligt-info-line-flag t
   anything-c-moccur-enable-auto-lookflag t
   anything-c-moccur-enable-initial-pattern t)
  (global-set-key (kbd "C-M-o") 'anything-c-moccur-occur-by-moccur))

(when (require 'color-moccur nil t)
  (define-key global-map (kbd "C-o") 'occur-by-moccur)
  (setq moccur-split-word t)
  (add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
  (add-to-list 'dmoccur-exclusion-mask "^#.+#$"))

(require 'moccur-edit nil t)  ; moccur(C-o) > r(-edit)
(defadvice moccur-edit-change-file
    (after save-after-moccur-edit-buffer activate)
  (save-buffer))

;; auto-complete
;; melpa(M-x list-packages > auto-complete)
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories
               "~/.emacs.d/elisp/ac-dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default))

;; cua-mode
(cua-mode t)
(setq cua-enable-cua-keys nil)

