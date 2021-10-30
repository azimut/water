(in-package #:water)

(defvar *bs*  NIL)
(defvar *car* NIL)
(defvar *tex* NIL)
(defvar *sam* NIL)

(defvar *dimensions* '(256 256))

(defun init ()
  (slynk-hook)
  (unless *car*
    (setf *car* (make-c-array NIL :dimensions *dimensions* :element-type :vec3))
    (setf *tex* (make-texture *car*))
    (setf *sam* (sample *tex* :wrap :clamp-to-edge)))
  (unless *bs*
    (setf *bs*  (make-buffer-stream NIL :primitive :points)))
  ;; Draw
  (draw-a-few-lines))

(defun slynk-hook ()
  #+slynk
  (slynk-mrepl::send-prompt (find (bt:current-thread) (slynk::channels)
                                  :key #'slynk::channel-thread)))

(defun draw-a-few-lines (&optional (width 256) (height 256))
  (magick:with-magick-wand
      (wand :create width height :comp ((random 255) (random 255) (random 255)))
    (magick:with-drawing-wand (dw)
      (magick:with-pixel-wand (pw :comp (255 255 255))
        (magick:draw-set-stroke-color dw pw))
      (magick:draw-set-stroke-width dw 3d0)
      (dotimes (i 100)
        (magick:draw-line dw
                          (random width)
                          (random height)
                          (random width)
                          (random height)))
      (magick:draw-image wand dw))
    (magick:get-image-pixels wand 0 0 width height "RGB" :float
                             (c-array-pointer *car*))
    (push-g *car* (texref *tex*))))

(defun draw ()
  (when (or (key-down-p key.escape))
    (stop))
  (setf (resolution (current-viewport))
        (surface-resolution (current-surface)))
  (as-frame
    (map-g #'water-pipe *bs*
           :image *sam*)))

(defun-g water-frag ((uv :vec2) &uniform (image :sampler-2d))
  (texture image uv))
(defpipeline-g water-pipe (:points)
  :fragment (water-frag :vec2))

(define-simple-main-loop play (:on-start #'init)
  (draw))

(defun start ()
  (play :start))
(defun stop ()
  (play :stop))
