(in-package #:water)

(defun draw-a-few-lines (&optional (width 256) (height 256))
  (magick:with-magick-wand (wand :create width height :comp ((random 255)
                                                             (random 255)
                                                             (random 255)))
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

