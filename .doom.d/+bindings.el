;;; +bindings.el ends here

;;  .doom.d/+bindings.el -*- lexical-binding: t; -*-
;;
;;  keybindings
;;
;;
;;
;;sets window number selector to space num
(map! :leader
      "0" #'winum-select-window-0-or-10
      "1" #'winum-select-window-1
      "2" #'winum-select-window-2
      "3" #'winum-select-window-3
      "4" #'winum-select-window-4
      "5" #'winum-select-window-5
      "6" #'winum-select-window-6
      "7" #'winum-select-window-7
      "8" #'winum-select-window-8
      "9" #'winum-select-window-9

      ;; leader <TAB> --- emacs 27 tabs
      (:prefix-map ("TAB" . "tabs")
        :desc "Switch to next tab"       "w" #'tab-next
        :desc "Switch to previous tab"   "q"   #'tab-previous
        :desc "New tab"                  "n"   #'tab-new
        :desc "Rename tab"               "r"   #'tab-rename
        :desc "Close tab"                "d"   #'tab-close
        :desc "Undo"                     "u"   #'tab-undo
        :desc "Toggle tab bar"           "b"   #'tab-bar-mode
        :desc "Move tab to the right"    ">"   #'tab-bar-move-tab
        :desc "Move tab to the left"     "<"   #'(tab-bar-move-tab -1)
        :desc "Select tab by name"       "TAB"   #'tab-bar-select-tab-by-name
        :desc "Select #1 tab"         "1"   #'tab-bar-select-tab
        :desc "Select #2 tab"         "2"   #'tab-bar-select-tab
        :desc "Select #3 tab"         "3"   #'tab-bar-select-tab
        :desc "Select #4 tab"         "4"   #'tab-bar-select-tab
        :desc "Select #5 tab"         "5"   #'tab-bar-select-tab
        :desc "Select #6 tab"         "6"   #'tab-bar-select-tab
        :desc "Select #7 tab"         "7"   #'tab-bar-select-tab
        :desc "Select #8 tab"         "8"   #'tab-bar-select-tab
        :desc "Select #9 tab"         "9"   #'tab-bar-select-tab
        ))

;;org-mode
(after! org
  (map! :map org-mode-map
        :n "M-j" #'org-metadown
        :n "M-k" #'org-metaup)
  (map! :localleader
        :map org-mode-map
        "S" #'org/insert-screenshot)
  (map! :desc "Create Sparse Tree" :ne "SPC / s" #'org-sparse-tree)
  (map! :desc "Create Sparse Tree for Tags" :ne "SPC / t" #'org-tags-sparse-tree))

;;evaluations
(map! :leader
      "e e" #'eval-last-sexp
      "e b" #'eval-buffer
      "e r" #'eval-region
      "e f" #'eval-defun)
;;ivy navigation
(map! :map counsel-find-file-map "<left>" #'counsel-up-directory)
(map! :map counsel-find-file-map "<right>" #'ivy-alt-done)
;;git time machine
(map! :leader
      "g p" #'git-timemachine-show-previous-revision
      "g n" #'git-timemachine-show-next-revision)
;;markdown
(map! :localleader
      :map markdown-mode-map
      :prefix ("i" . "Insert")
      :desc "Blockquote"    "q" 'markdown-insert-blockquote
      :desc "Bold"          "b" 'markdown-insert-bold
      :desc "Code"          "c" 'markdown-insert-code
      :desc "Emphasis"      "e" 'markdown-insert-italic
      :desc "Footnote"      "f" 'markdown-insert-footnote
      :desc "Code Block"    "s" 'markdown-insert-gfm-code-block
      :desc "Image"         "i" 'markdown-insert-image
      :desc "Link"          "l" 'markdown-insert-link
      :desc "List Item"     "n" 'markdown-insert-list-item
      :desc "Pre"           "p" 'markdown-insert-pre
      (:prefix ("h" . "Headings")
        :desc "One"   "1" 'markdown-insert-atx-1
        :desc "Two"   "2" 'markdown-insert-atx-2
        :desc "Three" "3" 'markdown-insert-atx-3
        :desc "Four"  "4" 'markdown-insert-atx-4
        :desc "Five"  "5" 'markdown-insert-atx-5
        :desc "Six"   "6" 'markdown-insert-atx-6))
;;file finding override (projectile hangs using tramp)
(map! :leader
      :prefix "s"
      :desc "git grep"          "g" #'counsel-git-grep)
