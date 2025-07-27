(ql:quickload :hunchentoot)
(ql:quickload :com.inuoe.jzon)
(load "cl-data-structures.lisp")
(load "quest-generator.lisp")
(defpackage :main
  (:use :cl :hunchentoot :com.inuoe.jzon)
  (:import-from :cl-data-structures :hashmap)
  (:import-from :quest-generator :init-quest-state)
  (:import-from :quest-generator :get-current-actions)
  (:import-from :quest-generator :get-current-ambients)
  (:import-from :quest-generator :get-current-summary)
  (:import-from :quest-generator :get-quest-requirements)
  (:export :main))

(in-package :main)

(defun create-content-json (answer-list)
  (com.inuoe.jzon:stringify
   (hashmap "content" answer-list)))

(hunchentoot:define-easy-handler (init :uri "/init") ()
  (progn
    (init-quest-state)
    (setf (hunchentoot:content-type*) "application/json")
    (com.inuoe.jzon:stringify
     (hashmap "status" "OK!"))))

(hunchentoot:define-easy-handler (actions :uri "/actions") ()
  (setf (hunchentoot:content-type*) "application/json")
  (create-content-json (get-current-actions)))

(hunchentoot:define-easy-handler (ambients :uri "/ambients") ()
  (setf (hunchentoot:content-type*) "application/json")
  (create-content-json (get-current-ambients)))

(hunchentoot:define-easy-handler (summary :uri "/summary") ()
  (setf (hunchentoot:content-type*) "application/json")
  (create-content-json (get-current-summary)))

(hunchentoot:define-easy-handler (requirements :uri "/requirements") ()
  (setf (hunchentoot:content-type*) "application/json")
  (create-content-json (get-quest-requirements)))

;; Start the server
(defvar *server* nil)

(defun start-server (&optional (port 4242))
  (setf *server*
	(make-instance 'hunchentoot:easy-acceptor :port 4242))
  (hunchentoot:start *server*)
  (format t "Server started on http://localhost:~a/hello~%" port))

(defun stop-server ()
  (when *server*
    (hunchentoot:stop *server*)
    (setf *server* nil)
    (format t "Server stopped.~%")))

(defun main ()
  (init-quest-state)
  (start-server)
  (loop (sleep 60)))
;;(stop-server)


