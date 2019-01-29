;;;; water.lisp

(in-package #:water)

(defvar *things* NIL)
(defvar *bs* NIL)
(defvar *car* NIL)
(defvar *tex* NIL)
(defvar *sam* NIL)

(defclass line ()
  ((from :initarg :from)
   (to   :initarg :to))
  (:default-initargs
   :from (v! 0 0)
   :to   (v! 0 0)))

(defun make-line ()
  (push (make-instance 'line
                       :from (v! (random 250) (random 250))
                       :to (v! (random 250) (random 250)))
        *things*))

(defgeneric draw (thing dw))
(defmethod draw ((thing line) dw)
  (with-slots (from to) thing
    (magick:draw-line dw
                      (x from) (y from)
                      (x to)   (y to))))

(defun draw-all-things (dw)
  (loop :for thing :in *things* :do
       (draw thing dw)))
(defun draw-a-few-lines (&optional (width 256) (height 256))
  (magick:with-magick-wand (wand :create width height :comp (0 0 0))
    (magick:with-drawing-wand (dw)
      (magick:with-pixel-wand (pw :comp (255 255 255))
        (magick:draw-set-stroke-color dw pw))
      (magick:draw-set-stroke-width dw 3d0)
      (draw-all-things dw)
      (magick:draw-image wand dw))
    (magick:get-image-pixels wand 0 0 width height "RGB" :float
                             (c-array-pointer *car*))
    (push-g *car* (texref *tex*))))

(defgeneric update (thing time))
(defmethod update ((thing line) time)
  (with-slots (from) thing
    (setf (x from) (* 40 (cos time)))
    (setf (y from) (* 50 (sin time)))))

;;
(progn
  ;;(make-line)
  (draw-a-few-lines))

(defvar *wand* NIL)
(defvar *draw* NIL)
(defvar *pixw* NIL)

(defun init ()
  (unless *car*
    (setf *car* (make-c-array NIL :dimensions '(256 256) :element-type :vec3))
    (setf *tex* (make-texture *car*))
    (setf *sam* (sample *tex* :wrap :clamp-to-edge)))
  (unless *wand*
    (setf *wand* (magick:make-wan)))
  (unless *bs*
    (setf *bs*  (make-buffer-stream NIL :primitive :points))))

(defun draw! ()
  (let ((time (* 1f0 (get-internal-real-time))))
    (setf (resolution (current-viewport))
          (surface-resolution (current-surface)))
    (loop :for thing :in *things* :do
         (update thing time))
    (as-frame
      (map-g #'water-pipe *bs*
             :image *sam*))))

(defun-g water-frag ((uv :vec2) &uniform (image :sampler-2d))
  (texture image uv))
(defpipeline-g water-pipe (:points)
  :fragment (water-frag :vec2))

(define-simple-main-loop play (:on-start #'init)
  (draw!))
