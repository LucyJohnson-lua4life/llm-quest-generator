(load (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname)))
(load "main.lisp")

(sb-ext:save-lisp-and-die "main"
  :toplevel #'main:main
  :executable t)
