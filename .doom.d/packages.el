;; -*- no-byte-compile: t; -*-
;;; .doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:host github :repo "username/repo"))
;; (package! builtin-package :disable t)
;;
;;org mode

;;(package! org-super-agenda)
(package! org-gcal)
;;(package! elfeed-dashboard :recipe (:type git :host github :repo "Manoj321/elfeed-dashboard"))
;;(straight-use-package '(elfeed-dashboard :type git :host github :repo "Manoj321/elfeed-dashboard"))

;;
;;Hoon stuff
;;
(package! hoon-mode :recipe (:host github :repo "urbit/hoon-mode.el"))
(add-hook 'hoon-mode #'lsp)
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
;;
;;magit PR reviews
;;(package!
;;  github-review
;;  :recipe
;;    (:host github
;;    :repo "charignon/github-review"
;;     :files ("github-review.el")))
