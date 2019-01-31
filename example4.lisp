;;;; water.lisp

(in-package #:water)

(defparameter *step* (make-stepper (seconds 1) (seconds 1)))

(defvar *bs* NIL)
(defvar *car* NIL)
(defvar *tex* NIL)
(defvar *sam* NIL)
(defvar *wand* NIL)
(defvar *draw* NIL)
(defvar *pixw* NIL)
(defvar *black-wand* NIL)

(defparameter *h* 256)
(defparameter *w* 512)

(defun draw (&optional (n 200))
  (clear-wand)
  (add-noise-image *wand* 5)
  ;; (magick:gaussian-blur-image *wand* 1d0 1d0)
  ;; (magick:draw-set-stroke-width *draw* .4d0)
  (dotimes (i n)
    (draw-rectangle *draw*
                    (+ 150  i)
                    (+ 150 (* 50 (cos (/ i 12))))
                    (+ 135 i (sin i))
                    (+ 130  (* 50 (cos (/ i 30))))))
  ;;(magick:add-noise-image *wand* 5)
  (draw-image *wand* *draw*)
  (push-wand))

(defun clear-wand ()
  "clears both drawing-wand and magick-wand"
  (clear-drawing-wand *draw*)
  (set-image *wand* *black-wand*)
  (with-pixel-wand (pw :comp (155 255 100 254))
    (with-pixel-wand (pww :comp (0 0 0 0))
      (magick:set-background-color *wand* pww))
    (draw-set-stroke-color *draw* pw))
  (draw-image *wand* *draw*))

(defun push-wand ()
  "get image from magick-wand and push it to GL texture gpu array"
  (get-image-pixels *wand* 0 0 *w* *h* "RGBA" :float (c-array-pointer *car*))
  (push-g *car* (texref *tex*)))

(defun reset ()
  (when *car*
    (free *tex*)
    (free *car*)
    (setf *car* NIL))
  (when *wand*
    (destroy-magick-wand *wand*)
    (destroy-pixel-wand *pixw*)
    (destroy-drawing-wand *draw*)
    (setf *wand* NIL)))

(defun init ()
  (unless *bs*
    (setf *bs*  (make-buffer-stream NIL :primitive :points)))

  (unless *car*
    (setf *car* (make-c-array NIL :dimensions (list *w* *h*) :element-type :vec4))
    (setf *tex* (make-texture *car*))
    (setf *sam* (sample *tex* :wrap :clamp-to-edge)))

  (unless *wand*
    (setf *wand* (new-magick-wand))
    (magick:with-pixel-wand (pw :comp (0 0 0 0))
      (magick:new-image *wand* *w* *h* pw))
    ;;
    (setf *draw* (new-drawing-wand))
    (with-pixel-wand (pw :comp (25 25 25 0))
      (draw-set-stroke-color *draw* pw))
    (magick:draw-set-stroke-width *draw* 2d0)
    ;;
    (setf *pixw* (new-pixel-wand))
    (pixel-set-red   *pixw* 0)
    (pixel-set-green *pixw* 0)
    (pixel-set-blue  *pixw* 111)
    (pixel-set-alpha *pixw* 0)
    ;; Used to restore the background, instead of just generate
    ;; a new image which is leaky (go figure) might be there is
    ;; another way to clean up the wand...dunno
    (setf *black-wand* (new-magick-wand))
    (with-pixel-wand (pw :comp (0 0 0 254))
      (new-image *black-wand* *w* *h* pw))))

(defun draw! ()
  (let ((time (* 1f0 (get-internal-real-time)))
        (res  (surface-resolution (current-surface))))
    (setf (resolution (current-viewport)) res)
    ;;(setf (resolution (current-viewport)) (v! *w* *h*))
    (as-frame
      (when (funcall *step*)
        (draw (random 200)))
      (map-g #'water-pipe *bs* :image *sam*))))

(defun-g water-frag ((uv :vec2) &uniform (image :sampler-2d))
  (texture image (v! (x uv) (- 1 (y uv)))))
(defpipeline-g water-pipe (:points)
  :fragment (water-frag :vec2))

(define-simple-main-loop play (:on-start #'init)
  (draw!))
