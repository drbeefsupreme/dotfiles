;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;
;;    GENERAL       ;;;
;;;;;;;;;;;;;;;;;;;;;;;

;;emacs
;;(server-start) ;;starts emacs in server mode so it doesn't die when last frame is closed

;;loading own modules
(load! "+bindings")
(load! "org")

;;exiting a mode will not go back a character
(setq evil-move-cursor-back nil)


;;kills all buffers not currently open in the current tab. need to figure out how to save buffers in other tabs
(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

;;;;;;;;;;;;;;;;;;;;;;;
;;     Visual        ;;
;;;;;;;;;;;;;;;;;;;;;;;

(setq doom-font (font-spec :family "monospace" :size 14 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "sans"))

;;(global-visual-line-mode 1) ;;henrik added this in as a hook with text-mode
(add-hook 'text-mode-hook #'auto-fill-mode)

(global-whitespace-mode 0)

(blink-cursor-mode -1)  ;;don't blink the cursor


;;;;;;;;;;;;;;;;;;;;;;;
;;     Magit         ;;
;;;;;;;;;;;;;;;;;;;;;;;

;;fixes:
;;Warning (with-editor): Cannot determine a suitable Emacsclient
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Determining an Emacsclient executable suitable for the                                      ;;
;; current Emacs instance failed.  For more information                                        ;;
;; please see https://github.com/magit/magit/wiki/Emacsclient. Disable showing Disable logging ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;(setq-default with-editor-emacsclient-executable "emacsclient")

;;magit status buffer appears in current window
(setq magit-display-buffer-function
      (lambda (buffer)
        (display-buffer
         buffer (if (and (derived-mode-p 'magit-mode)
                         (memq (with-current-buffer buffer major-mode)
                               '(magit-process-mode
                                 magit-revision-mode
                                 magit-diff-mode
                                 magit-stash-mode
                                 magit-status-mode)))
                    nil
                  '(display-buffer-same-window)))))

(add-hook 'after-save-hook 'magit-after-save-refresh-status t) ;refreshes magit automatically
;; (magit-auto-revert-mode) ;refreshes buffers after changing branch ;;I think this was breaking something

;;

;; copies both buffers in ediff to C. use with ~ to swap the order.
(defun ediff-copy-both-to-C ()
  (interactive)
  (ediff-copy-diff ediff-current-difference nil 'C nil
                   (concat
                    (ediff-get-region-contents ediff-current-difference 'A ediff-control-buffer)
                    (ediff-get-region-contents ediff-current-difference 'B ediff-control-buffer))))
(defun add-B-to-ediff-mode-map () (define-key! ediff-mode-map "B" 'ediff-copy-both-to-C))
(add-hook 'ediff-keymap-setup-hook 'add-B-to-ediff-mode-map)

;;working with my dotfiles bare repo

;; prepare the arguments
(setq dotfiles-git-dir (concat "--git-dir=" (expand-file-name "~/.cfg")))
(setq dotfiles-work-tree (concat "--work-tree=" (expand-file-name "~/")))

;; function to start magit on dotfiles
(defun dotfiles-magit-status ()
  (interactive)
  (add-to-list 'magit-git-global-arguments dotfiles-git-dir)
  (add-to-list 'magit-git-global-arguments dotfiles-work-tree)
  (call-interactively 'magit-status))
;;(global-set-key (kbd "F5 d") 'dotfiles-magit-status)

;; wrapper to remove additional args before starting magit
(defun magit-status-with-removed-dotfiles-args ()
  (interactive)
  (setq magit-git-global-arguments (remove dotfiles-git-dir magit-git-global-arguments))
  (setq magit-git-global-arguments (remove dotfiles-work-tree magit-git-global-arguments))
  (call-interactively 'magit-status))
;; redirect global magit hotkey to our wrapper


;;;;;;;;;;;;;;;;;;;;;;;
;;   languages      ;;;
;;;;;;;;;;;;;;;;;;;;;;;
(use-package! graphviz-dot-mode
;  :ensure t  ;; apparently doom doesnt like this
  :config
  (setq graphviz-dot-indent-width 4))

(use-package! company-graphviz-dot)
;;;;;;;;;;;;;;;;;;;;;;;
;;   Projectile     ;;;
;;;;;;;;;;;;;;;;;;;;;;;


(setq projectile-project-search-path '("~/Dropbox/Tlon/"))    ;;makes so projectile always looks for new projects here
(setq projectile-indexing-method 'alien)  ;; might make remote searching with tramp better

(defadvice projectile-on (around exlude-tramp activate)
  "This should disable projectile when visiting a remote file"
  (unless  (--any? (and it (file-remote-p it))
                   (list
                    (buffer-file-name)
                    list-buffers-directory
                    default-directory
                    dired-directory))
    ad-do-it))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Platformio support
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (projectile-register-project-type 'platformio '("platformio.ini") "platformio run" nil "platformio run -t upload") not sure why this doesn't work


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Ansi color
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'ansi-color)
(defun my-colorize-compilation-buffer ()
  (when (eq major-mode 'compilation-mode)
    (save-excursion
      (ansi-color-apply-on-region compilation-filter-start (point)))))
(ansi-color-for-comint-mode-on)
(add-hook 'compilation-filter-hook 'my-colorize-compilation-buffer)


;;;;;;;;;;;;;;;;;;;;;;;
;;; Desktops        ;;;
;;;;;;;;;;;;;;;;;;;;;;;

(setq desktop-dirname "~/.emacs.d/.local/etc/desktops/")
(setq desktop-restore-eager t)    ;not sure why this doesn't seem to be working
;;(desktop-save-mode 1) doesnt' work with doom https://github.com/hlissner/doom-emacs/issues/1781


;;;;;;;;;;;;;;;;;;;;;;;
;;      debugging    ;;
;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;
;; elfeed ;;
;;;;;;;;;;;;
(setq rmh-elfeed-org-files (list (concat doom-private-dir "elfeed.org")))

(setq elfeed-db-directory "~/Dropbox/org-mode/elfeed/")

;(defalias 'dbs/elfeed-toggle-star
;(elfeed-expose #'elfeed-search-toggle-all 'star))

;;functions to support syncing .elfeed between machines
;;makes sure elfeed reads index from disk before launching
(defun dbs/elfeed-load-db-and-open ()
"Wrapper to load the elfeed db from disk before opening"
(interactive)
(elfeed-db-load)
(elfeed)
(elfeed-search-update--force))

;;marks all as read
(defun dbs/elfeed-mark-all-as-read ()
(interactive)
(mark-whole-buffer)
(elfeed-search-untag-all-unread))

;;write to disk when quitting
(defun dbs/elfeed-save-db-and-bury ()
"Wrapper to save the elfeed db to disk before burying buffer"
(interactive)
(elfeed-db-save)
(quit-window))

;; (use-package! hercules
;;   :config
;;   (hercules-def
;;    :toggle-funs #'elfeed-hercules
;;    :keymap 'elfeed-search-mode-map
;;    :transient t))

;;;;;;;;;;;;;;;;;;;;;;;;
;;      graphviz      ;;
;;;;;;;;;;;;;;;;;;;;;;;

(setq graphviz-dot-revert-delay 1000)

;;;;;;;;;;;;;;;;;;;;;;;;;
;;   text editing      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

(map! [remap indent-for-tab-command] #'doom/dumb-indent) ;does dumb indenting

(add-to-list 'auto-mode-alist '("\\.ino\\'" . c++-mode)) ;C++ mode for .ino files
(add-to-list 'auto-mode-alist '("\\.tcc\\'" . c++-mode)) ;ditto for .tcc

;;LaTeX

(setq latex-run-command "pdflatex") ;;sets the default latex command to pdflatex


;;unfilling
(defun unfill-paragraph ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

(defun unfill-region ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-region (region-beginning) (region-end) nil)))


;;;;;;;;;;;;;;;;;;;;;;;;;
;;     security        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

(setq auth-sources '("~/.authinfo.gpg"))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;    tramp             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (after! tramp
;;   (push "/usr/bin" tramp-remote-path)
;;   (setq magit-git-executable "git")
;;   (setq tramp-remote-path '(tramp-own-remote-path)))
(defadvice! resolve-remote-executable ()
  :override #'+magit-optimize-process-calls-h
  (when-let (path (executable-find magit-git-executable t))
    (setq-local magit-git-executable path)))
(setq tramp-verbose 10) ;;wtf is going on with tramp
(setq tramp-copy-size-limit nil) ;makes it so you always use scp instead of ssh for TRAMP


;;;;;;;;;;;;
;; xmonad ;;
;;;;;;;;;;;;


;;the following is mostly for org-roam-dailies-capture from xmonad

(defadvice org-capture-finalize
    (after delete-capture-frame activate)
  "Advise capture-destroy to close the frame"
  (if (equal "capture" (frame-parameter nil 'name))
      (delete-frame)))

(defadvice org-capture-destroy
    (after delete-capture-frame activate)
  "Advise capture-destroy to close the frame"
  (if (equal "capture" (frame-parameter nil 'name))
      (delete-frame)))


;; make the frame contain a single window. by default org-capture
;; splits the window
(add-hook 'org-roam-dailies-find-file-hook
          'delete-other-windows)

(defun make-capture-frame ()
  "Create a new frame and run org-capture."
  (interactive)
  (make-frame '((name . "capture")
                (width . 120)
                (height . 15)))
  (select-frame-by-name "capture")
  (setq word-wrap 1)
  (setq truncate-lines nil)
  (org-roam-dailies-capture-today))


;;;;;;;;;;;
;; urbit ;;
;;;;;;;;;;;

(defun dbs/send-to-tmux-at-point ()
  (interactive)
  (emamux:send-command (org-element-property :value (org-element-context))))
