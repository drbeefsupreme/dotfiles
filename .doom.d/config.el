;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;
;;    GENERAL       ;;;
;;;;;;;;;;;;;;;;;;;;;;;

;;loading own modules
(load! "+bindings")
(load! "+private")

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
;;        org        ;;
;;;;;;;;;;;;;;;;;;;;;;;

(setq org-directory "~/Dropbox/org-mode/"
      org-agenda-files (directory-files-recursively "~/Dropbox/org-mode/" "\.org$") ;;look for .org files here for the agenda.
      org-archive-location (concat org-directory "archive/%s::")
      org-ellipsis " ▼ "
      org-superstar-headline-bullets-list '("☰" "☱" "☲" "☳" "☴" "☵" "☶" "☷" "☷" "☷" "☷")
      org-pretty-entities t)

(after! org
  (setq org-todo-keywords
        '((sequence "TODO(t)" ; A task that needs doing and is ready to do
                    "PROJ(p)" ; An ongoing project that cannot be completed in one task
                    "STRT(s)" ; A task that is in progress
                    "WAIT(w@/!)" ; Something external is holding up this task
                    "|"
                    "DONE(d!)" ; Task successfully completed
                    "CANC(c@)")))) ; Task was canceled for some reason

;;TODO Setup org-super-agenda

;;(require 'org-gcal)
;;(setq org-gcal-client-id "427665355006-38ina3s4krjrh10l4bmim9r6pub8l1no.apps.googleusercontent.com"
;;      org-gcal-client-secret "xjolCzpSDajB8dCMoplxRDP5"
;;      org-gcal-file-alist '(("jonpaprocki@gmail.com"  .  "~/Dropbox/org-mode/calendar.org")))

;;(add-hook 'org-agenda-mode-hook (lambda () (org-gcal-sync) ))  ;;syncs google calendar whenever i open org-agenda


;; images
;;
(setq org-startup-with-inline-images t)
;; from https://llazarek.com/2018/10/images-in-org-mode.html
(defvar org/insert-screenshot/redisplay-images t
  "Redisplay images after inserting a screenshot with
`org/insert-screenshot'?")

(defun org/insert-screenshot (&optional arg)
  "Capture a screenshot and insert a link to it in the current
buffer. If `org/insert-screenshot/redisplay-images' is non-nil,
redisplay images in the current buffer.

By default saves images to ./resources/screen_%Y%m%d_%H%M%S.png,
creating the resources directory if necessary.

With a prefix arg (C-u) prompt for a filename instead of using the default.

Depends upon `import` from ImageMagick."
  (interactive)
  (unless (or arg
              (file-directory-p "./resources"))
    (make-directory "resources"))
  (let* ((default-dest
           (format-time-string "./resources/screen_%Y%m%d_%H%M%S.png"))
         (dest (if arg
                   (helm-read-string "Save to: " default-dest)
                 default-dest)))
    (start-process "import" nil "import" dest)
    (read-char "Taking screenshot... Press any key when done.")
    (org-insert-link t (concat "file:" dest) "")
    (when org/insert-screenshot/redisplay-images
      (org-remove-inline-images)
      (org-display-inline-images))))


(defvar org/edit-image/redisplay-images t
  "Redisplay images after editing an image with `org/edit-image'?")

(defun org/edit-image (&optional arg)
  "Edit the image linked at point. If
`org/insert-screenshot/redisplay-images' is non-nil, redisplay
images in the current buffer."
  (interactive)
  (let ((img (org/link-file-path-at-point)))
    (start-process "gimp" nil "gimp" img)
    (read-char "Editing image... Press any key when done.")
    (when org/edit-image/redisplay-images
      (org-remove-inline-images)
      (org-display-inline-images))))

(defun org/resize-image-at-point (&optional arg)
  "Resize the image linked at point. If
`org/insert-screenshot/redisplay-images' is non-nil, redisplay
images in the current buffer."
  (interactive)
  (let ((img (org/link-file-path-at-point))
        (percent (read-number "Resize to what percentage of current size? ")))
    (start-process "mogrify" nil "mogrify"
                   "-resize"
                   (format "%s%%" percent)
                   img)
    (when org/edit-image/redisplay-images
      (org-remove-inline-images)
      (org-display-inline-images))))

(defun org/link-file-path-at-point ()
  "Get the path of the file referred to by the link at point."
  (let* ((org-element (org-element-context))
         (is-subscript-p (equal (org-element-type org-element) 'subscript))
         (is-link-p (equal (org-element-type org-element) 'link))
         (is-file-p (equal (org-element-property :type org-element) "file")))
    (when is-subscript-p
      (user-error "Org thinks you're in a subscript. Move the point and try again."))
    (unless (and is-link-p is-file-p)
      (user-error "Not on file link"))
    (expand-file-name (org-element-property :path org-element))))

;;;;;;;;;;;;;;;;;;;;;;;
;;    org-roam       ;;
;;;;;;;;;;;;;;;;;;;;;;;

;;(setq org-roam-directory "~/Dropbox/org-mode/roam")
;;(add-hook 'after-init-hook 'org-roam-mode)

;;;;;;;;;;;;;;;;;;;;;;;
;;     Magit         ;;
;;;;;;;;;;;;;;;;;;;;;;;

;;  magit status buffer appears in current window
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
(magit-auto-revert-mode) ;refreshes buffers after changing branch

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
