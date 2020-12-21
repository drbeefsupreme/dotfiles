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
        :n "M-k" #'org-metaup
        :n "."   #'hydra-outline/body)
  (map! :localleader
        :map org-mode-map
        "S" #'org/insert-screenshot)
  (map! :desc "Create Sparse Tree" :ne "SPC / s" #'org-sparse-tree)
  (map! :desc "Create Sparse Tree for Tags" :ne "SPC / t" #'org-tags-sparse-tree))

;;magit
(map! :leader
      (:prefix-map ("g" . "git")
      :desc "Magit status" "g" 'magit-status-with-removed-dotfiles-args
      :desc "Magit dot file status" "d" 'dotfiles-magit-status)) ;see https://emacs.stackexchange.com/a/58859
;;not sure if this is also needed
;;(define-key! magit-file-mode-map (kbd "SPC g g") 'magit-status-with-removed-dotfiles-args)
;;(global-set-key (kbd "SPC g g") 'magit-status-with-removed-dotfiles-args)
;;(define-key magit-file-mode-map (kbd "SPC g g") 'magit-status-with-removed-dotfiles-args)

;;evaluations
(map! :leader
      (:prefix-map ("e". "Evaluate")
      "e" #'eval-last-sexp
      "b" #'eval-buffer
      "r" #'eval-region
      "f" #'eval-defun))
;;find file
(map! :leader
      :desc "Find in home dir" "f h" (lambda () (interactive) (cd "~/") (call-interactively 'find-file)))
;;el-feed
(map! :leader
       :desc "REPL" "o R"#'+eval/open-repl-other-window
       :desc "RSS feed" "o r" #'dbs/elfeed-load-db-and-open)
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



;;;;;;;;;;;;
;; hydras ;;
;;;;;;;;;;;;

(defhydra hydra-dired (:hint nil :color pink)
  "
_+_ mkdir          _v_iew           _m_ark             _(_ details        _i_nsert-subdir    wdired
_C_opy             _O_ view other   _U_nmark all       _)_ omit-mode      _$_ hide-subdir    C-x C-q : edit
_D_elete           _o_pen other     _u_nmark           _l_ redisplay      _w_ kill-subdir    C-c C-c : commit
_R_ename           _M_ chmod        _t_oggle           _g_ revert buf     _e_ ediff          C-c ESC : abort
_Y_ rel symlink    _G_ chgrp        _E_xtension mark   _s_ort             _=_ pdiff
_S_ymlink          ^ ^              _F_ind marked      _._ toggle hydra   \\ flyspell
_r_sync            ^ ^              ^ ^                ^ ^                _?_ summary
_z_ compress-file  _A_ find regexp
_Z_ compress       _Q_ repl regexp

T - tag prefix
"
  ("\\" dired-do-ispell)
  ("(" dired-hide-details-mode)
  (")" dired-omit-mode)
  ("+" dired-create-directory)
  ("=" diredp-ediff)         ;; smart diff
  ("?" dired-summary)
  ("$" diredp-hide-subdir-nomove)
  ("A" dired-do-find-regexp)
  ("C" dired-do-copy)        ;; Copy all marked files
  ("D" dired-do-delete)
  ("E" dired-mark-extension)
  ("e" dired-ediff-files)
  ("F" dired-do-find-marked-files)
  ("G" dired-do-chgrp)
  ("g" revert-buffer)        ;; read all directories again (refresh)
  ("i" dired-maybe-insert-subdir)
  ("l" dired-do-redisplay)   ;; relist the marked or singel directory
  ("M" dired-do-chmod)
  ("m" dired-mark)
  ("O" dired-display-file)
  ("o" dired-find-file-other-window)
  ("Q" dired-do-find-regexp-and-replace)
  ("R" dired-do-rename)
  ("r" dired-do-rsynch)
  ("S" dired-do-symlink)
  ("s" dired-sort-toggle-or-edit)
  ("t" dired-toggle-marks)
  ("U" dired-unmark-all-marks)
  ("u" dired-unmark)
  ("v" dired-view-file)      ;; q to exit, s to search, = gets line #
  ("w" dired-kill-subdir)
  ("Y" dired-do-relsymlink)
  ("z" diredp-compress-this-file)
  ("Z" dired-do-compress)
  ("q" nil)
  ("." nil :color blue))

(map! :map dired-mode-map
      :n "." #'hydra-dired/body)


(defhydra hydra-buffer-menu (:color pink
                             :hint nil)
  "
^Mark^             ^Unmark^           ^Actions^          ^Search
^^^^^^^^-----------------------------------------------------------------
_m_: mark          _u_: unmark        _x_: execute       _R_: re-isearch
_s_: save          _U_: unmark up     _b_: bury          _I_: isearch
_d_: delete        ^ ^                _g_: refresh       _O_: multi-occur
_D_: delete up     ^ ^                _T_: files only: % -28`Buffer-menu-files-only
_~_: modified
"
  ("m" Buffer-menu-mark)
  ("u" Buffer-menu-unmark)
  ("U" Buffer-menu-backup-unmark)
  ("d" Buffer-menu-delete)
  ("D" Buffer-menu-delete-backwards)
  ("s" Buffer-menu-save)
  ("~" Buffer-menu-not-modified)
  ("x" Buffer-menu-execute)
  ("b" Buffer-menu-bury)
  ("g" revert-buffer)
  ("T" Buffer-menu-toggle-files-only)
  ("O" Buffer-menu-multi-occur :color blue)
  ("I" Buffer-menu-isearch-buffers :color blue)
  ("R" Buffer-menu-isearch-buffers-regexp :color blue)
  ("c" nil "cancel")
  ("v" Buffer-menu-select "select" :color blue)
  ("o" Buffer-menu-other-window "other-window" :color blue)
  ("q" quit-window "quit" :color blue))

(map! :map Buffer-menu-mode-map
      :n "." #'hydra-buffer-menu/body)

(map! :leader
      :desc "Buffer menu" "b B" #'buffer-menu)


(defhydra hydra-outline (:color pink :hint nil :foreign-keys run)
  "
^Hide^             ^Show^           ^Move                        ^Source
^^^^^^------------------------------------------------------------------------------
_q_: sublevels     _a_: all         _u_: up                      _x_: send to tmux
_t_: body          _e_: entry       _n_: next visible            _l_: last command to tmux
_o_: other         _i_: children    _p_: previous visible
_c_: entry         _K_: branches    _f_: forward same level
_L_: leaves        _s_: subtree     _b_: backward same level
_d_: subtree
  "
  ;; Hide
  ("q" hide-sublevels)    ; Hide everything but the top-level headings
  ("t" hide-body)         ; Hide everything but headings (all body lines)
  ("o" hide-other)        ; Hide other branches
  ("c" hide-entry)        ; Hide this entry's body
  ("L" hide-leaves)       ; Hide body lines in this entry and sub-entries
  ("d" hide-subtree)      ; Hide everything in this entry and sub-entries
  ;; Show
  ("a" show-all)          ; Show (expand) everything
  ("e" show-entry)        ; Show this heading's body
  ("i" show-children)     ; Show this heading's immediate child sub-headings
  ("K" show-branches)     ; Show all sub-headings under this heading
  ("s" show-subtree)      ; Show (expand) everything in this heading & below
  ;; Move
  ("u" outline-up-heading)                ; Up
  ("n" outline-next-visible-heading)      ; Next
  ("p" outline-previous-visible-heading)  ; Previous
  ("f" outline-forward-same-level)        ; Forward - same level
  ("b" outline-backward-same-level)       ; Backward - same level
  ;; Source
  ("x" dbs/send-to-tmux-at-point)  ; mostly for urbit/hoon
  ("l" emamux:run-last-command)
  ;; exit
  ("z" nil "leave"))


(defhydra dbs/hydra-elfeed (:color pink :hint nil :foreign-keys run)
  "
^Filter^             ^Mark^          Actions
^^^^^^----------------------------------------
_U_: Urbit         _R_: All Read
_E_: emacs         _S_: Star
_Q_: quantum
_*_: starred
_A_: All
_T_: Today
  "
("U" (elfeed-search-set-filter "@6-months-ago +urbit"))
("E" (elfeed-search-set-filter "@6-months-ago +emacs"))
("Q" (elfeed-search-set-filter "@6-months-ago +quantum"))
("*" (elfeed-search-set-filter "@6-months-ago +star"))
("S" dbs/elfeed-toggle-star)
("A" (elfeed-search-set-filter "@6-months-ago"))
("T" (elfeed-search-set-filter "@1-day-ago"))
("R" dbs/elfeed-mark-all-as-read)
("X" dbs/elfeed-save-db-and-bury "Quit Elfeed" :color blue)
("x" nil "quit" :color blue))

(map! :map elfeed-search-mode-map
      :n "." #'dbs/hydra-elfeed/body)
