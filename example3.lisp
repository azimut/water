;;;; water.lisp

(in-package #:water)

(defparameter *step* (make-stepper (seconds 1)
                                   (seconds 1)))
(defvar *things* NIL)
(defvar *bs* NIL)
(defvar *car* NIL)

(defvar *tex* NIL)
(defvar *sam* NIL)

(defvar *wand* NIL)
(defvar *draw* NIL)
(defvar *pixw* NIL)

(defun clear-wand ()
  "clears both drawing-wand and magick-wand"
  (magick:clear-drawing-wand *draw*)
  (magick:with-pixel-wand (pw :comp (0 0 0))
                          (magick:new-image *wand* 256 256 pw))
  (magick:with-pixel-wand (pw :comp (155 255 100))
                          (magick:draw-set-stroke-color *draw* pw))
  (magick:draw-image *wand* *draw*))

(defun push-wand ()
  "get image from magick-wand and push it to GL texture"
  (magick:get-image-pixels *wand* 0 0 256 256 "RGB" :float (c-array-pointer *car*))
  (push-g *car* (texref *tex*)))

(defun init ()
  (setf *things* NIL)
  (unless *car*
    (setf *car* (make-c-array NIL :dimensions '(256 256) :element-type :vec3))
    (setf *tex* (make-texture *car*))
    (setf *sam* (sample *tex* :wrap :clamp-to-edge)))
  (unless *wand*
    (setf *wand* (magick:new-magick-wand))
    (setf *draw* (magick:new-drawing-wand))
    (setf *pixw* (magick:new-pixel-wand)))
  ;; Only helpers to init wands are internal %init macros...
  (magick:pixel-set-red *pixw* 0)
  (magick:pixel-set-green *pixw* 0)
  (magick:pixel-set-blue *pixw* 111)
  (magick:draw-set-stroke-width *draw* 2d0)
  (magick:with-pixel-wand (pw :comp (0 0 0))
                          (magick:new-image *wand* 256 256 pw))
  (magick:with-pixel-wand (pw :comp (25 25 25))
                          (magick:draw-set-stroke-color *draw* pw))
  (unless *bs*
    (setf *bs*  (make-buffer-stream NIL :primitive :points))))

(defun draw! ()
  (let ((time (* 1f0 (get-internal-real-time))))
    (setf (resolution (current-viewport))
          (surface-resolution (current-surface)))
    (as-frame
      (map-g #'water-pipe *bs* :image *sam*))))

;; (magick:draw-circle *draw* (random 250) (random 250) (random 250) (random 250))
;; (magick:draw-line *draw* (random 250) (random 250) (random 250) (random 250))
;; (magick:draw-rectangle *draw* (random 250) (random 250) (random 250) (random 250))
;; (magick:draw-annotation *draw* 20 20 "end me")
;; (magick:draw-image *wand* *draw*)
;; (magick:add-noise-image *wand* 7)
;;(clear-wand)
;;(push-wand)

(defun-g water-frag ((uv :vec2) &uniform (image :sampler-2d))
  (texture image (v! (x uv) (- 1 (y uv)))))
(defpipeline-g water-pipe (:points)
  :fragment (water-frag :vec2))

(define-simple-main-loop play (:on-start #'init)
  (draw!))
