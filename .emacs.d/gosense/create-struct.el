
(defun create-struct()
  (interactive)

  ;;Get current symbol and position
  (setq struct-name (thing-at-point 'symbol))

  ;;Find point of insertion
  ;;1. Find next close brace (})
  ;;2. Is brace in top most level?
  ;;3. Yes? Add two new lines
  ;;4. NO? start again from new position
  (move-to-insertion-pos)

  ;;Insert snippet with variables assigned
  (insert "struct")
  (yas-expand)
  (insert struct-name)
  )

(defun move-to-insertion-pos()
  ;;Find point of insertion
  ;;1. Find next close brace (})
  ;;2. Is brace in top most level?
  ;;3. Yes? Add two new lines
  ;;4. NO? start again from new position
  (if  (is-in-package-scope)
      (insert "\n\n")
      (move-to-insertion-pos)))

;; Returns true if we are in the package scope and false otherwise
(defun is-in-package-scope()
  ;;if we find a } brace before we find a { brace then we are not in the top level
  (setq starting-pos (point))
  (setq next-} (search-forward "}" nil t))
  (if (equal next-} nil)
      (progn (end-of-line) t)
      (progn (goto-char starting-pos)
       (setq next-{ (search-forward "{" nil t))
       (goto-char next-})
       (if (not (equal next-{ nil))
	   (less-than next-{ next-})
	   nil)
      )
      ))

(provide 'create-struct)
