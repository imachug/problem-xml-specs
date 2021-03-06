(ql:quickload "bordeaux-threads")
(ql:quickload "str")
(load "solution")
(defun read-integers () (map 'list #'parse-integer (str:words (read-line))))
(let* ((input (read-integers))
       (n (car input))
       (answer (car (cdr input)))
       (n-guesses 0)
       (success 0)
       (lock (bordeaux-threads:make-lock)))
    (defun guess (num)
        (check-type num integer)
        (bordeaux-threads:with-lock-held (lock)
            (progn
                (incf n-guesses)
                (cond ((< answer num) -1)
                      ((> answer num) 1)
                      (t (progn (setf success 1) 0))))))
    (solve n)
    (bordeaux-threads:with-lock-held (lock)
        (format t "~d ~d~%" n-guesses success)))
