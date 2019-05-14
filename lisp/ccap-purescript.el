(require 'psc-ide)

(defun run-psc-ide-server (project-dir)
  "Start 'psc-ide-server'."
  (interactive (list (expand-file-name
                      (read-directory-name "Which project? "
                                           (psc-ide-suggest-project-dir)))))
  (let ((project-name
         (file-name-nondirectory
          (directory-file-name
           (file-name-directory project-dir)))))
    (apply 'start-process `("*purs-ide-server*" "*purs-ide-server*"
                            ,(concat project-dir "../bin/run-purs-ide-server") ,project-name))
    (message "Loading project files...")
    (run-at-time "1 sec" nil
                 (lambda ()
                   (psc-ide-send psc-ide-command-load-all
                                 (lambda (res)
                                   (condition-case ex
                                       (progn
                                         (psc-ide-unwrap-result res)
                                         (message "Done!"))
                                     ('error (error "%s" ex)))))))))

(provide 'ccap-purescript)
