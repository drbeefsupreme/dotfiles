;; -*- no-byte-compile: t; -*-
;;; .doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:host github :repo "username/repo"))
;; (package! builtin-package :disable t)
;;
;;
;; emacs
(package! undo-tree)
;;(require `undo-tree)
;;(global-undo-tree-mode)
;;
;;org mode

;;(package! org-super-agenda)
(package! org-gcal)
(package! doct)  ;;declarative org templates
;;(package! elfeed-dashboard :recipe (:type git :host github :repo "Manoj321/elfeed-dashboard"))
;;(straight-use-package '(elfeed-dashboard :type git :host github :repo "Manoj321/elfeed-dashboard"))
(package! solidity-mode)
;;(require 'solidity-mode)
(package! origami)

;;
;;Hoon stuff
;;
;;(use-package! hoon-mode :recipe (:host github :repo "urbit/hoon-mode.el"))
(package! hoon-mode :recipe (:host github :repo "urbit/hoon-mode.el"))
(add-hook 'hoon-mode #'lsp)
;;(use-package! hoon-mode)
;;
(package! emamux)
;;
;;(package! hercules)
;;(require 'hercules)
(package! emacsql-sqlite3)

;;
;;graphviz
(package! graphviz-dot-mode)
;;(package! company-graphviz-dot)
;;tutorial
(package! evil-tutor)

;;magit PR reviews
;;(package!
;;  github-review
;;  :recipe
;;    (:host github
;;    :repo "charignon/github-review"
;;     :files ("github-review.el")))
