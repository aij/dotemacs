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
 ;;'(ensime-default-java-flags
 ;;  (quote
 ;;   ("-Xmx6g" "-XX:MaxMetaspaceSize=512m" "-javaagent:/home/aij/jmx_exporter/jmx_prometheus_javaagent-0.1.0.jar=1235:/home/aij/jmx_exporter/config.yaml ")))
 '(ensime-default-java-flags (quote ("-Xmx6g" "-XX:MaxMetaspaceSize=512m")))
 '(ensime-startup-notification nil)
 '(ensime-startup-snapshot-notification nil)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(js-indent-level 2)
 '(js2-basic-offset 2)
 '(js2-bounce-indent-p t)
 '(js2-strict-trailing-comma-warning nil)
 '(package-selected-packages
   (quote
    (rainbow-delimiters rjsx-mode psc-ide purescript-mode geiser editorconfig use-package smartparens rust-mode projectile math-symbol-lists magit json-mode js2-mode groovy-mode ensime auto-complete)))
 '(safe-local-variable-values
   (quote
    ((js2-strict-trailing-comma-warning . f)
     (groovy-indent-offset . 2)
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
;;(add-to-list 'auto-mode-alist '("\\.js$" . rjsx-mode))

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
  :delight smartparens-mode
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

;; (add-to-list 'load-path "~/.emacs.d/git/ensime-emacs")
;; (use-package ensime
;;   ;;:pin melpa-stable
;;   ;;:ensure t
;;   ;;:pin melpa
;;   )

(use-package god-mode
  :bind (("<escape>" . god-mode-all)
         :map god-local-mode-map
         ("." . repeat)))

(use-package dumb-jump
  :bind (("M-g o" . dumb-jump-go-other-window)
         ("M-g j" . dumb-jump-go)
         ("M-g i" . dumb-jump-go-prompt)
         ("M-g x" . dumb-jump-go-prefer-external)
         ("M-g z" . dumb-jump-go-prefer-external-other-window))
  ;:config (setq dumb-jump-selector 'ivy) ;; (setq dumb-jump-selector 'helm)
  )

(use-package projectile
  :demand
  :delight " P"
  ;; :init   (setq projectile-use-git-grep t)
  :config (projectile-global-mode t)
  :bind   (("C-c p" . projectile-command-map)
           ("s-f" . projectile-find-file)
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
      (turn-on-purescript-indentation)))
  :bind (("C-<tab>" . company-complete)))

(use-package web-mode
  :mode "\\.js\\'"
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-attr-indent-offset 2)
  (setq web-mode-content-types-alist
        '(("jsx" . "\\.js\\'")
          ("jsx" . "\\.jsx\\'"))
        ))

(use-package flow-minor-mode
  :config
  (add-hook 'js2-mode-hook 'flow-minor-enable-automatically)
  (add-hook 'web-mode-hook 'flow-minor-mode)
  (require 'flycheck-flow)
  (with-eval-after-load 'flycheck
    (flycheck-add-mode 'javascript-flow 'flow-minor-mode)
    (flycheck-add-mode 'javascript-eslint 'flow-minor-mode)
    (flycheck-add-next-checker 'javascript-flow 'javascript-eslint)))
;;(when (file-exists-p "~/.emacs.d/git/flow-for-emacs/flow.el")
;;  (load "~/.emacs.d/git/flow-for-emacs/flow.el"))

(use-package prettier-js
  :init (add-hook 'web-mode-hook 'prettier-js-mode)
  :config
  ;;(setq prettier-js-args '("--insert-pragma")))
  (setq prettier-js-args '("--insert-pragma" "--require-pragma")))

(use-package highlight-indent-guides
  :delight
  :init
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode))

(use-package direnv
 :config
 (direnv-mode)
 (add-to-list 'direnv-non-file-modes 'compilation-mode) )


;; Enable scala-mode and sbt-mode
;(use-package scala-mode
;  :mode "\\.s\\(cala\\|bt\\)$")

(use-package sbt-mode
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  ;; allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map))

;;(use-package eglot
;;  :config
;;  (add-to-list 'eglot-server-programs '(scala-mode . ("metals-emacs")))
;;  ;; (optional) Automatically start metals for Scala files.
;;  :hook (scala-mode . eglot-ensure))

;; Enable nice rendering of diagnostics like compile errors.
(use-package flycheck
  :init (global-flycheck-mode))

(use-package lsp-mode
  :init (setq lsp-prefer-flymake nil))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode))

(use-package lsp-scala
  :load-path "~/.emacs.d/git/lsp-scala"
  :after scala-mode
  :demand t
  ;; Optional - enable lsp-scala automatically in scala files
  :hook (scala-mode . lsp))

(use-package dhall-mode
  :config
  (setq-default dhall-format-arguments '("--ascii")))
