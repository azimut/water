;;;; water.asd

(asdf:defsystem #:water
  :description "Describe water here"
  :author "azimut <azimut.github@protonmail.com>"
  :license  "MIT"
  :version "0.0.1"
  :serial t
  :depends-on (#:cepl
               #:rtg-math.vari
               #:cepl.sdl2
               #:swank
               #:nineveh
               #:livesupport
               #:cepl.skitter.sdl2
               #:dirt
               #:lisp-magick-wand)
  :components ((:file "package")
               (:file "water")))
