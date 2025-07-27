(ql:quickload :dexador)
(ql:quickload :com.inuoe.jzon)
(defpackage :llm-io
  (:use :cl)			       
  (:export :prompt-simple-answer-list)
  (:export :parse-llm-response)
  (:export :retrieve-answers-from-simple-list))

(in-package :llm-io)

(defun create-header (bearer)
  `(("Authorization" . ,(format nil "Bearer ~A" bearer))
    ("Content-Type" . "application/json")))

(defun create-prompt-body (prompt gpt-model)
  (let* ((usr (make-hash-table)))
    (setf (gethash "role" usr) "user")
    (setf (gethash "content" usr) prompt)
    (let* ((result-body (make-hash-table)))
      (setf (gethash "model" result-body) gpt-model)
      (setf (gethash "messages" result-body) (vector usr))
      result-body)))

(defun stringify-llm-body (prompt)
  (com.inuoe.jzon:stringify (create-prompt-body prompt "gpt-3.5-turbo") :pretty t))

(defun query-llm (prompt api-key)
  (dexador:post "https://api.openai.com/v1/chat/completions"
		:headers (create-header api-key)
		:content (stringify-llm-body prompt)))

(defun retrieve-llm-content (llm-response)
  (gethash "content"
	   (gethash "message"
		    (aref (gethash "choices" llm-response) 0))))

(defun parse-llm-response (llm-response)
  (let* ((parsed (com.inuoe.jzon:parse llm-response)))
    (com.inuoe.jzon:parse (multiple-value-bind (result _)
			      (retrieve-llm-content parsed) result))))

(defun retrieve-answers-from-simple-list (parsed-llm-response key-to-list)
  (map 'list
       (lambda (content) (gethash key-to-list content))
       parsed-llm-response))

(defun query-simple-answer-list (prompt api-key key-to-answer-list)
  (let* ((query-result (query-llm prompt api-key))
	 (parsed-llm-response (parse-llm-response query-result)))
    (retrieve-answers-from-simple-list parsed-llm-response key-to-answer-list)))

;; public
(defun prompt-simple-answer-list (prompt api-key key-to-answer-list &key (max-retries 5))
  "Tries to query gpt and parse its response, retrying up to MAX-RETRIES times.
Returns parsed object or NIL if all attempts fail."
  (loop for attempt from 1 to max-retries
        for result = (handler-case
                         (query-simple-answer-list prompt api-key key-to-answer-list)
                       (error (e)
                         ;; You could log the error if needed
                         (format t "Attempt ~D failed: ~A~%" attempt e)
                         nil))
        when result
          do (return result)
        finally (return nil)))
