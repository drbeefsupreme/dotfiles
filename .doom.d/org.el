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

(setq org-roam-directory "~/Dropbox/org-mode/roam")
(setq org-roam-buffer-position 'right)
(add-hook 'after-init-hook 'org-roam-mode)

;;daily journals

(setq org-roam-dailies-capture-templates
      '(("d" "default" entry #'org-roam-capture--get-point
         "* %?" :file-name "daily/%<%Y-%m-%d>"
         :head "#+title: %<%Y-%m-%d>\n")))



;;;;;;;;;;;;;;;;;;;;;;
;; capture templates;;
;;;;;;;;;;;;;;;;;;;;;;


(setq org-capture-templates
      (doct '(
        ("Todo" :keys "t"
         ;;:icon ("checklist" :set "octicon") ;;doesn't seem to work idk why
         :file "~/Dropbox/org-mode/inbox.org"
         :prepend t
         :template ("* TODO %?\n%i\n%a"
                    "Entered on %U")
         :headline "Tasks"
         :type entry)
        ("Note" :keys "n"
         :file "~/Dropbox/org-mode/inbox.org"
         :prepend t
         :template ("* %?\n\%i\n%a")
         :headline "Notes")
        )))




;; (("t" "Personal todo" entry
;;   (file+headline +org-capture-todo-file "Inbox")
;;   "* [ ] %?\n%i\n%a" :prepend t)
;;  ("n" "Personal notes" entry
;;   (file+headline +org-capture-notes-file "Inbox")
;;   "* %u %?\n%i\n%a" :prepend t)
;;  ("j" "Journal" entry
;;   (file+olp+datetree +org-capture-journal-file)
;;   "* %U %?\n%i\n%a" :prepend t)
;;  ("p" "Templates for projects")
;;  ("pt" "Project-local todo" entry
;;   (file+headline +org-capture-project-todo-file "Inbox")
;;   "* TODO %?\n%i\n%a" :prepend t)
;;  ("pn" "Project-local notes" entry
;;   (file+headline +org-capture-project-notes-file "Inbox")
;;   "* %U %?\n%i\n%a" :prepend t)
;;  ("pc" "Project-local changelog" entry
;;   (file+headline +org-capture-project-changelog-file "Unreleased")
;;   "* %U %?\n%i\n%a" :prepend t)
;;  ("o" "Centralized templates for projects")
;;  ("ot" "Project todo" entry #'+org-capture-central-project-todo-file "* TODO %?\n %i\n %a" :heading "Tasks" :prepend nil)
;;  ("on" "Project notes" entry #'+org-capture-central-project-notes-file "* %U %?\n %i\n %a" :heading "Notes" :prepend t)
;;  ("oc" "Project changelog" entry #'+org-capture-central-project-changelog-file "* %U %?\n %i\n %a" :heading "Changelog" :prepend t))


;;adds :icon functionality to doct capture templates
(defun +doct-icon-declaration-to-icon (declaration)
  "Convert :icon declaration to icon"
  (let ((name (pop declaration))
        (set  (intern (concat "all-the-icons-" (plist-get declaration :set))))
        (face (intern (concat "all-the-icons-" (plist-get declaration :color))))
        (v-adjust (or (plist-get declaration :v-adjust) 0.01)))
    (apply set `(,name :face ,face :v-adjust ,v-adjust))))

(defun +doct-iconify-capture-templates (groups)
  "Add declaration's :icon to each template group in GROUPS."
  (let ((templates (doct-flatten-lists-in groups)))
    (setq doct-templates (mapcar (lambda (template)
                                   (when-let* ((props (nthcdr (if (= (length template) 4) 2 5) template))
                                               (spec (plist-get (plist-get props :doct) :icon)))
                                     (setf (nth 1 template) (concat (+doct-icon-declaration-to-icon spec)
                                                                    "\t"
                                                                    (nth 1 template))))
                                   template)
                                 templates))))

(setq doct-after-conversion-functions '(+doct-iconify-capture-templates))


;;;;;;;
;;;;;;; refiling
;;;;;;;


(defun org-roam-create-note-from-headline ()
  "Create an Org-roam note from the current headline and jump to it.

Normally, insert the headline’s title using the ’#title:’ file-level property
and delete the Org-mode headline. However, if the current headline has a
Org-mode properties drawer already, keep the headline and don’t insert
‘#+title:'. Org-roam can extract the title from both kinds of notes, but using
‘#+title:’ is a bit cleaner for a short note, which Org-roam encourages."
  (interactive)
  (let ((title (nth 4 (org-heading-components)))
        (has-properties (org-get-property-block)))
    (org-cut-subtree)
    (org-roam-find-file title nil nil 'no-confirm)
    (org-paste-subtree)
    (unless has-properties
      (kill-line)
      (while (outline-next-heading)
        (org-promote)))
    (goto-char (point-min))
    (when has-properties
      (kill-line)
      (kill-line))))
