(load "llm-io.lisp")
(defpackage :prompt-templates
  (:use :cl)
  (:export :get-action-prompt)
  (:export :get-ambient-prompt)
  (:export :get-summarization-prompt))

(in-package :prompt-templates)

(defun get-action-prompt (quest-requirements)
  (format nil "Im currently generating quests for my Gothic 2 Multiplayer Server. I want to spread hints, on what the player should do to get a great reward.
I want you to give me a list of dialogues for each completed player action between 500 and 1000 characters, that tell a captivating story that keeps the player engaged.
These dialogues should be told by a third person narrator to comment on what happens after a player has fullfilled an action. The narrator must refer to the player as 'you'.

The setting of the Gothic 2 is a medieval fantasy world. The Player roams through the island of Khorinis. Khorinis has a city, thats also called Khorinis and it is a hubspot for
adventurers from all over the world.

Please return to me a plain json, so that a can continue processing your output in my code.
Just give me a array of json objects that return the dialogues. Like [{\"dialogue\": \"My dialogue\"}, {\"dialogue\": \"My dialogue\"}] etc.
One dialogue should just give one hint.

These are the actions that the player has to fullfill:
~{- ~A~%~}
" quest-requirements))

(defun get-ambient-prompt (quest-requirements)
  (format nil  "Im currently generating quests for my Gothic 2 Multiplayer Server. I want to spread hints on what the player should do to get a great reward.
I want you to give me a list of 5 dialogues between 500 and 1000 characters, that tell a captivating story that keeps the player engaged while hinting on what actions have to be done.
These dialogues will be used by ambient npc's. Try to connect the hints to a coherent story so it feels like the player is playing a legit quest.

The setting of the Gothic 2 is a medieval fantasy world. The Player Roams through the island of Khorinis. Khorinis has a city, thats also called Khorinis and it is a hubspot for
adventurers from all over the world.

Please return to me a plain json, so that a can continue processing your output in my code.
Just give me a array of json objects that return the dialogues. Like [{\"dialogue\": \"My dialogue\"}, {\"dialogue\": \"My dialogue\"}] etc.
One dialogue should just give one hint.

These are the actions that the player has to fullfill:
~{- ~A~%~}
" quest-requirements))

(defun get-summarization-prompt (action-answers)
  (format nil "Im currently generating quests for my Gothic 2 Multiplayer Server. I want to summarize the actions the player has done in a captivating story.
I want you to give me a summary between 1000 and 1500 characters, that tell a captivating story of what the player has done and how his actions connected to a coherent outcome.
The dialogue should be told by a third person narrator to comment on what happens after a player has fullfilled all actions.
The narrator must refer to the player as 'you'.

The setting of the Gothic 2 is a medieval fantasy world. The Player Roams through the island of Khorinis. Khorinis has a city, thats also called Khorinis and it is a hubspot for
adventurers from all over the world.

Please return to me a plain json, so that a can continue processing your output in my code.
Just give me a array with one json object that returns the dialogue. Like [{\"dialogue\": \"My dialogue\"}] etc.
It should be only one dialogue that summarizes the players action.

These are the actions the player has completed so far, summarized as little stories themselves:
~{- ~A~%~}
" action-answers))

