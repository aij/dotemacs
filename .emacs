(require 'package)
(setq package-archives nil) ; makes unpure packages archives unavailable
(package-initialize)

(require 'use-package)

(add-to-list 'load-path "~/.emacs.d/lisp")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(ensime-default-java-flags (quote ("-Xmx6g" "-XX:MaxMetaspaceSize=512m")))
 '(ensime-startup-notification nil)
 '(ensime-startup-snapshot-notification nil)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(js-indent-level 2)
 '(js2-basic-offset 2)
 '(js2-bounce-indent-p t)
 '(package-selected-packages
   (quote
    (rainbow-delimiters rjsx-mode psc-ide purescript-mode geiser editorconfig use-package smartparens rust-mode projectile math-symbol-lists magit json-mode js2-mode groovy-mode ensime auto-complete)))
 '(safe-local-variable-values
   (quote
    ((groovy-indent-offset . 2)
     (js-switch-indent-offset . 2)
     (js2-basic-offset . 2)
     (js-indent-level . 2)
     (scala-indent:use-javadoc-style . t)
     (js2-bounce-indent-p . t)
     (java-indent-level . 4)
     (css-indent-offset . 2))))
 '(save-place t nil (saveplace))
 '(scroll-error-top-bottom t)
 '(sentence-end-double-space nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil))
 ;;'(sbt:default-command "compile")
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans Mono" :foundry "unknown" :slant normal :weight normal :height 98 :width normal))))
 '(rainbow-delimiters-depth-1-face ((t (:foreground "red"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "orange"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "yellow"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "chartreuse"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "cyan"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "deep sky blue"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "purple"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "magenta1"))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "hot pink")))))

;;(add-to-list 'auto-mode-alist '("\\.js$" . js2-jsx-mode))
;;(add-to-list 'auto-mode-alist '("\\.jsx$" . js2-jsx-mode))
(add-to-list 'auto-mode-alist '("\\.js$" . rjsx-mode))

(add-hook 'java-mode-hook
          (lambda ()
            (setq tab-width 4)))

;; Stop the beeping
(setq visible-bell t)

;; Lets just get rid of trailing whitespace.
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; It's really nice to be able to open more files with emacsclient
(server-mode)

;; I want \qe to type a QUESTIONED EQUAL TO
; http://www.emacswiki.org/emacs/TeXInputMethod
;(let ((quail-current-package (assoc "TeX" quail-package-alist)))
;  (quail-define-rules ((append . t))
;		      ("^\\qe" ≟)))

;; Emacs Scalaz Unicode input method
;; https://github.com/folone/emacs-scalaz-unicode-input-method/
;(add-to-list 'load-path "~/.emacs.d/git/emacs-scalaz-unicode-input-method")
;(require 'scalaz-unicode-input-method)
;(add-hook 'scala-mode-hook
;  (lambda () (set-input-method "scalaz-unicode")))


(require 'math-symbol-lists)
(quail-define-package "math" "UTF-8" "Ω" t)
;(quail-define-rules ; add whatever extra rules you want to define here...
; ("\\qe"    ≟)
; ("\\unrhd"   #X22B5))
(mapc (lambda (x)
        (if (cddr x)
            (quail-defrule (cadr x) (car (cddr x)))))
      (append math-symbol-list-basic math-symbol-list-extended))


(add-hook 'scala-mode-hook
  (lambda () (set-input-method "math")))

;(add-hook 'scala-mode-hook
;	  (local-set-key (kbd "C-x '") 'sbt-run-previous-command))

(use-package smartparens
  :diminish smartparens-mode
  :config
  (require 'smartparens-config)
  (progn (show-smartparens-global-mode t))
  (sp-use-smartparens-bindings)
  (sp-pair "(" ")" :wrap "C-c (")
  (sp-pair "[" "]" :wrap "C-c [")
  (sp-pair "{" "}" :wrap "C-c {")
  (bind-key "M-[" 'sp-backward-unwrap-sexp smartparens-mode-map)
  (bind-key "M-]"  'sp-unwrap-sexp smartparens-mode-map)
  ;; WORKAROUND https://github.com/Fuco1/smartparens/issues/543
  ;;(bind-key "C-<left>" nil smartparens-mode-map)
  ;;(bind-key "C-<right>" nil smartparens-mode-map)

  ;;(bind-key "s-<delete>" 'sp-kill-sexp smartparens-mode-map)
  ;;(bind-key "s-<backspace>" 'sp-backward-kill-sexp smartparens-mode-map)
  )

(add-hook 'prog-mode-hook 'turn-on-smartparens-strict-mode)
(add-hook 'markdown-mode-hook 'turn-on-smartparens-strict-mode)

(add-to-list 'load-path "~/.emacs.d/git/ensime-emacs")
(use-package ensime
  ;;:pin melpa-stable
  ;;:ensure t
  ;;:pin melpa
  )
;;(setq ensime-startup-notification nil
;;      ensime-startup-snapshot-notification nil)

(use-package projectile
  :demand
  ;; :init   (setq projectile-use-git-grep t)
  :config (projectile-global-mode t)
  :bind   (("s-f" . projectile-find-file)
           ("s-F" . projectile-grep)))

(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package psc-ide
  :init
  (require 'ccap-purescript)
  :config
  (add-hook 'purescript-mode-hook
    (lambda () ;; From https://github.com/epost/psc-ide-emacs
      (psc-ide-mode)
      (company-mode)
      (flycheck-mode)
      (turn-on-purescript-indentation))))