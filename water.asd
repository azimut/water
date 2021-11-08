(asdf:defsystem #:water
  :description "Describe water here"
  :author "azimut <azimut.github@protonmail.com>"
  :license  "MIT"
  :version "0.0.1"
  :serial t
  ;; :depends-on (#:cepl
  ;;              #:cepl.sdl2
  ;;              #:cepl.skitter.sdl2
  ;;              #:lisp-magick-wand
  ;;              #:livesupport
  ;;              #:rtg-math.vari
  ;;              #:temporal-functions
  ;;              )
  :components ((:file "package")
               (:file "earth")
               ;;(:file "water")
               ;;(:file "fire")
               ))

(asdf:defsystem #:water/static
  :depends-on (#:water)
  :defsystem-depends-on ("cffi-grovel")
  :build-operation :static-program-op
  :build-pathname "water"
  :entry-point "water:start")

(asdf:defsystem #:water/deploy
  :depends-on (#:water)
  :defsystem-depends-on (:deploy)
  :build-operation "deploy-op"
  :build-pathname "water"
  :entry-point "water:start")
