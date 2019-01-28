;;;; water.lisp

(in-package #:water)

(defvar *bs* NIL)
(defun init ()
  (unless *bs*
    (setf *bs* (make-buffer-stream NIL :primitive :points))))
(defun draw ()
  (as-frame
    (map-g #'water-pipe *bs*)))

(defun-g water-frag ((uv :vec2))
  (v! 1 0 0 0))
(defpipeline-g water-pipe (:points)
  :fragment (water-frag :vec2))

(define-simple-main-loop play (:on-start #'init)
  (draw))
