(require 'package)
(setq package-archives nil) ; makes unpure packages archives unavailable
(package-initialize)

(require 'use-package)

(add-to-list 'load-path "~/.emacs.d/lisp")

;; Switch quickly between .h/.c .h/.cpp etc.
(global-set-key (kbd "C-o") 'ff-find-other-file)

;; Keybindings recommended for org-mode. https://orgmode.org/manual/Activation.html
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)


;;(add-to-list 'auto-mode-alist '("\\.js$" . js2-jsx-mode))
;;(add-to-list 'auto-mode-alist '("\\.jsx$" . js2-jsx-mode))
;;(add-to-list 'auto-mode-alist '("\\.js$" . rjsx-mode))

(add-hook 'java-mode-hook
          (lambda ()
            (setq tab-width 4)))

;; Stop the beeping
(setq visible-bell t)

;; Lets just get rid of trailing whitespace.
;(add-hook 'before-save-hook 'delete-trailing-whitespace)

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
  ;; :init (setq lsp-prefer-flymake nil)
  ;; Enable lsp-scala automatically in scala files
  :hook (scala-mode . lsp)
        (c-mode . lsp)
        (c++-mode . lsp))

(use-package dhall-mode
  :config
  (setq-default dhall-format-arguments '("--ascii")))

(use-package org
  :defer t
  :config
  (setq org-log-done t)
  (setq org-agenda-files (list "~/org/"))
  (setq org-agenda-todo-ignore-scheduled 'future)
  ; https://orgmode.org/manual/Tracking-TODO-state-changes.html
  (setq org-todo-keywords
      '((sequence "TODO(t)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELED(c@)"))))
