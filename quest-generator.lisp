(load "llm-io.lisp")
(load "prompt-templates.lisp")

(defpackage :quest-generator
  (:use :cl)
  (:export :init-quest-state)
  (:export :get-current-actions)
  (:export :get-current-ambients)
  (:export :get-current-summary)
  (:export :get-quest-requirements)
  (:import-from :llm-io :prompt-simple-answer-list)
  (:import-from :prompt-templates :get-action-prompt)
  (:import-from :prompt-templates :get-ambient-prompt)
  (:import-from :prompt-templates :get-summarization-prompt))

(in-package :quest-generator)

(defparameter mob-list '("Orc Elite" "Orc Warrior" "Lurker" "Wolf" "Scavenger" "Black Troll"
			 "Troll" "Warg" "Snapper" "Dragon Snapper"))

(defparameter item-list '("Health Root" "Mana Root" "Mana Blade"))

(defparameter quest-requirements  '("Kill Lurker until you find a Health Root" "Kill Elite Orc" "Pray at Innos statue"))

(defun generate-kill-quest-requirement (mobs)
  (let* ((mob-index (random (length mobs))))

        (format nil "Kill ~A" (nth mob-index mobs))))

(defun generate-kill-until-quest-requirement (mobs items)
  (let* ((mob-index (random (length mobs)))
	 (item-index (random (length items))))
    (format nil "Kill ~A until you find a ~A" (nth mob-index mobs) (nth item-index items))))


(defun generate-quest-requirement (mobs items)
  (let* ((quest-index (random 10)))
    
    (cond
      ((< quest-index 4) (generate-kill-quest-requirement mobs))
      ((< quest-index 8) (generate-kill-until-quest-requirement mobs items))
      ((< quest-index 9) "Pray at Innos shrine.")
      ((< quest-index 10)"Pray at Belliar shrine."))))

(defun generate-quest-requirements ()
  `(,(generate-quest-requirement mob-list item-list)
    ,(generate-quest-requirement mob-list item-list)
    ,(generate-quest-requirement mob-list item-list)))

(defun get-api-key ()
  (let ((api-str (sb-ext:posix-getenv "OPENAI_API_KEY")))
    (if api-str
        api-str
        "")))

(defparameter *action-answers* '())
(defparameter *ambient-answers* '())
(defparameter *summary-answers* '())
(defparameter *quest-requirements* '())

(defun generate-action-answers (quest-requirements)
  (defparameter *action-answers*
    (prompt-simple-answer-list (get-action-prompt quest-requirements) (get-api-key) "dialogue")))

(defun generate-ambient-answers (quest-requirements)
  (defparameter *ambient-answers*
    (prompt-simple-answer-list (get-ambient-prompt quest-requirements) (get-api-key) "dialogue")))

(defun generate-summary-answers (action-answers)
  (defparameter *summary-answers*
    (prompt-simple-answer-list (get-summarization-prompt action-answers) (get-api-key) "dialogue")))

(defun init-quest-state ()
  (let* ((quest-requirements (generate-quest-requirements)))
    (progn
      (generate-action-answers quest-requirements)
      (generate-ambient-answers quest-requirements)
      (generate-summary-answers *action-answers*)
      (defparameter *quest-requirements* quest-requirements))))

(defun get-current-actions ()
  *action-answers*)

(defun get-current-ambients ()
  *ambient-answers*)

(defun get-current-summary()
  *summary-answers*)

(defun get-quest-requirements()
  *quest-requirements*)

