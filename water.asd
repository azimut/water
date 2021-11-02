(asdf:defsystem #:water
  :description "Describe water here"
  :author "azimut <azimut.github@protonmail.com>"
  :license  "MIT"
  :version "0.0.1"
  :serial t
  :defsystem-depends-on (:deploy)
  :build-operation "deploy-op"
  :build-pathname "water"
  :entry-point "water:start"
  :depends-on (;;#:cepl
               ;;#:cepl.sdl2
               ;;#:cepl.skitter.sdl2
               #:lisp-magick-wand
               ;;#:livesupport
               ;;#:rtg-math.vari
               ;;#:temporal-functions
               )
  :components ((:file "package")
               ;;(:file "water")
               (:file "fire")
               ))
