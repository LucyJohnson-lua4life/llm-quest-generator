(defpackage :cl-data-structures
  (:use :cl)
  (:export hashmap))

(in-package :cl-data-structures)


(defmacro hashmap (&rest pairs)
  (unless (evenp (length pairs))
    (error "Odd number of arguments to ht"))
  `(let ((table (make-hash-table :test 'equal)))
     ,@(loop for (key value) on pairs by #'cddr
             collect `(setf (gethash ,key table) ,value))
     table))
