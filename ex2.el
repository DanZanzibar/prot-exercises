;; 1. Write a function that returns a list with all the known major modes.
;;    In this context, "known" is every major mode that you have loaded in the
;;    current Emacs session.  So if you have a package installed but have not
;;    loaded it, Emacs knows nothing about it.

;;    It is not obvious where to look for to find all the major modes, so I
;;    will give you this.  There is a function called 'mapatoms'.  It
;;    always returns nil.  That function maps a predicate over a special
;;    list that you will read more about.  You need to somehow create a
;;    local variable, push valid elements to it, and return it (instead of
;;    the nil of 'mapatoms').

;; 2. Once you have a list of all the known major modes, you want to write
;;    a function that prompts the user to pick one among them.  This is
;;    done with completion.

;; 3. Figure out how to create and display a new buffer.

;; 4. Combine the above with 'with-current-buffer' in order to add some
;;    functionality to that buffer.  You want to enable the major mode you
;;    got earlier.  Perhaps you can also give the new buffer a name that
;;    references the user's choice of major mode.


(defvar zanv-derived-majors ())


(defun zanf-derived-majors--derived-p (mode)
  (and (apply 'provided-mode-derived-p mode zanv-derived-majors)
       (not (member mode zanv-derived-majors))))


(defun zanf-derived-majors--get-modes ()
  (let ((mode-found nil))
    (mapatoms '(lambda (symbol)
		 (when (zanf-derived-majors--derived-p symbol)
		   (setq mode-found t)
		   (add-to-list 'zanv-derived-majors symbol))))
    (when mode-found (zanf-derived-majors--get-modes))))


(defun zanf-derived-majors (&rest modes)
  "Search 'obarray' for derived major modes currently loaded in Emacs.

Parent modes can be specified, or if none are given, defaults to prog-mode
and text-mode. Returns a list of found major modes. Also updates variable
'zanv-derived-majors' with returned list."
  (let ((parent-modes (if modes modes '(prog-mode text-mode))))
    (setq zanv-derived-majors parent-modes)
    (zanf-derived-majors--get-modes)
    (dolist (mode parent-modes zanv-derived-majors)
      (setq zanv-derived-majors (remove mode zanv-derived-majors)))))


(defun zanf-scratch-buffer--choose-major ()
  (completing-read "Which major mode? (default: python-mode) "
		   (zanf-derived-majors) nil nil nil nil "python-mode"))


(defun zanf-scratch-buffer ()
  "Create and switch to a new scratch buffer with the chosen major mode enabled.

Completion is available for major modes currently loaded in Emacs according to
the function 'zanf-derived-majors'. If you wish to use a major mode not yet
loaded, you may specify it anyway (without completion)."
  (interactive)
  (let* ((mode (zanf-scratch-buffer--choose-major))
	(scratch-name (format "*%s-scratch*"
			     (substring mode 0 -5))))
    (get-buffer-create scratch-name)
    (switch-to-buffer scratch-name)
    (funcall (intern-soft mode))))

