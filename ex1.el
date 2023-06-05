;; Let's start with an interactive function that duplicates the current
;; line WITHOUT using the kill ring.  We already have the rudiment of this
;; in the code we worked on for refiling.

;; Bonus points if you can duplicate the current line OR region.

;; Are, in terms of code, "current line" and "region" different or are they
;; the same?

;; ZAN - I realised there was some room for interpreting what this function
;; ought to do. When duplicating the line, the most intuitive resulft would
;; be for the current line to be duplicated below on a new line with point at
;; the end of the new line. When duplicating a region, there's a little more
;; room for interpretation, but I decided to simply insert the region exactly
;; after the region selected. 

;; Below I'm assuming the region is continuous. Otherwise it's gross...
(defun zanf-dup--start-end ()
  (interactive)
  (if mark-active
      (car (region-bounds))
    (cons (line-beginning-position) (line-end-position))))

(defun zanf-dup-line-or-region ()
  (interactive)
  (let* ((bounds (zanf-dup--start-end))  ;this "unpacking" must be easier
	 (start (car bounds))
	 (end (cdr bounds))
	 (string-to-dup (buffer-substring start end)))
    (unless mark-active
      (setq string-to-dup (concat "\n" string-to-dup)))
    (save-excursion
      (goto-char end)
      (insert string-to-dup))))

;; Are, in terms of code, "current line" and "region" different or are they
;; the same?

;; ZAN - While they are both substrings, there are differences in how they need
;; to be handled, specifically lines need some special treament due to newline
;; characters.
