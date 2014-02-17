;; auto-async-byte-compile
;; add second comment
(add-to-list 'load-path "~/.emacs.d/elisp/auto-async-byte-compile")
(require 'auto-async-byte-compile)
(setq auto-async-byte-compile-exclude-files-regexp "/junc/")
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)
