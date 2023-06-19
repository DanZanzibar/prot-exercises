(defvar zanv-list-of-majors ())
(defvar zanv-list-of-majors--mode-found nil)

(defun zanf-get-majors--mapatoms-f (symbol)
  (when (and (apply 'provided-mode-derived-p symbol zanv-list-of-majors)
	     (not (member symbol zanv-list-of-majors)))
    (setq zanv-list-of-majors--mode-found t)
    (add-to-list 'zanv-list-of-majors symbol)))


(defun zanf-get-majors--get-derived-modes (&rest modes)
  (setq zanv-list-of-majors--mode-found-last-pass nil)
  (mapatoms 'zanf-get-majors--mapatoms-f)
  (if zanv-list-of-majors--mode-found-last-pass
      (zanf-get-majors--get-derived-modes zanv-list-of-majors)))


(defun zanf-get-majors ()
  (interactive)
  (setq zanv-list-of-majors '(fundamental-mode text-mode prog-mode special-mode))
  (zanf-get-majors--get-derived-modes zanv-list-of-majors)
  zanv-list-of-majors)


