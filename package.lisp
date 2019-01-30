;;;; package.lisp

(uiop:define-package #:water
    (:use #:cl
          #:cepl
          #:rtg-math
          #:vari
          #:cepl.skitter
          #:nineveh
          #:livesupport)
  (:import-from #:temporal-functions
                #:make-stepper
                #:seconds))
