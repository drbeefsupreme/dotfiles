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
;;
;;
;;Hoon stuff
;;
(package! hoon-mode :recipe (:host github :repo "urbit/hoon-mode.el"))
(add-hook 'hoon-mode #'lsp)
;;
(package! emamux)
;;
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
