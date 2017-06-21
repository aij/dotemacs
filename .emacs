(require 'package)
;(add-to-list 'package-archives
;             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(setq
 use-package-always-ensure t
 package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                    ("org" . "http://orgmode.org/elpa/")
                    ("melpa" . "http://melpa.org/packages/")
                    ("melpa-stable" . "http://stable.melpa.org/packages/")))

(package-initialize)

;(unless (package-installed-p 'scala-mode2)
;  (package-refresh-contents) (package-install 'scala-mode2))

(when (not package-archive-contents)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(add-to-list 'load-path "~/.emacs.d/lisp")
(require 'ccap-purescript)

;; Restart emacs and do `M-x package-install [RETURN] ensime [RETURN]`
;; To keep up-to-date, do `M-x list-packages [RETURN] U x [RETURN]`

;; If necessary, make sure "sbt" and "scala" are in the PATH environment
;; (setenv "PATH" (concat "/path/to/sbt/bin:" (getenv "PATH")))
;; (setenv "PATH" (concat "/path/to/scala/bin:" (getenv "PATH")))
;;
;; On Macs, it might be a safer bet to use exec-path instead of PATH, for instance:
;; (setq exec-path (append exec-path '("/usr/local/bin")))

;(require 'ensime)
;(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(ensime-default-java-flags (quote ("-Xmx6g" "-XX:MaxMetaspaceSize=512m")))
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(js-indent-level 2)
 '(js2-basic-offset 2)
 '(js2-bounce-indent-p t)
 '(package-selected-packages
   (quote
    (rjsx-mode psc-ide purescript-mode geiser editorconfig use-package smartparens rust-mode projectile math-symbol-lists magit json-mode js2-mode groovy-mode ensime auto-complete)))
 '(safe-local-variable-values
   (quote
    ((js-switch-indent-offset . 2)
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
 '(default ((t (:family "DejaVu Sans Mono" :foundry "unknown" :slant normal :weight normal :height 98 :width normal)))))


;; 2-space indent for JS seems to be the norm for CCAP3.
;(setq js-indent-level 2)
(setq css-indent-offset 2)
;(setq java-indent-level 4)
;(custom-set-variables
; '(js2-basic-offset 2)
; '(js2-bounce-indent-p t)
; )

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

(use-package ensime
  ;;:pin melpa-stable
  :ensure t
  :pin melpa
  )
(setq ensime-startup-notification nil
      ensime-startup-snapshot-notification nil)

(use-package projectile
  :demand
  ;; :init   (setq projectile-use-git-grep t)
  :config (projectile-global-mode t)
  :bind   (("s-f" . projectile-find-file)
           ("s-F" . projectile-grep)))
