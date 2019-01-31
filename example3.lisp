;;;; water.lisp

(in-package #:water)

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
  (clear-drawing-wand *draw*)
  (with-pixel-wand (pw :comp (0 0 0))
                          (new-image *wand* 256 256 pw))
  (with-pixel-wand (pw :comp (155 255 100))
                          (draw-set-stroke-color *draw* pw))
  (draw-image *wand* *draw*))

(defun push-wand ()
  "get image from magick-wand and push it to GL texture"
  (get-image-pixels *wand* 0 0 256 256 "RGB" :float (c-array-pointer *car*))
  (push-g *car* (texref *tex*)))

(defun init ()
  (setf *things* NIL)
  (unless *bs*
    (setf *bs*  (make-buffer-stream NIL :primitive :points)))
  (unless *car*
    (setf *car* (make-c-array NIL :dimensions '(256 256) :element-type :vec3))
    (setf *tex* (make-texture *car*))
    (setf *sam* (sample *tex* :wrap :clamp-to-edge)))
  (unless *wand*
    (setf *wand* (new-magick-wand))
    (with-pixel-wand (pw :comp (0 0 0))
      (new-image *wand* 256 256 pw))
    ;;
    (setf *draw* (new-drawing-wand))
    (draw-set-stroke-width *draw* 2d0)
    (with-pixel-wand (pw :comp (25 25 25))
      (draw-set-stroke-color *draw* pw))
    ;;
    (setf *pixw* (new-pixel-wand))
    (pixel-set-red *pixw* 0)
    (pixel-set-green *pixw* 0)
    (pixel-set-blue *pixw* 111)))

(defun draw! ()
  (let ((time (* 1f0 (get-internal-real-time))))
    (setf (resolution (current-viewport))
          (surface-resolution (current-surface)))
    (as-frame
      (map-g #'water-pipe *bs* :image *sam*))))

;; (draw-circle *draw* (random 250) (random 250) (random 250) (random 250))
;; (draw-line *draw* (random 250) (random 250) (random 250) (random 250))
;; (draw-rectangle *draw* (random 250) (random 250) (random 250) (random 250))
;; (draw-annotation *draw* 20 20 "end me")
;; (draw-image *wand* *draw*)
;; (add-noise-image *wand* 7)
;;(clear-wand)
;;(push-wand)

(defun-g water-frag ((uv :vec2) &uniform (image :sampler-2d))
  (texture image (v! (x uv) (- 1 (y uv)))))
(defpipeline-g water-pipe (:points)
  :fragment (water-frag :vec2))

(define-simple-main-loop play (:on-start #'init)
  (draw!))
