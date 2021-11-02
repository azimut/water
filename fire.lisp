(in-package #:water)

(defun draw-a-few-lines (filename width height)
  "Create a new image with WIDTH x HEIGHT pixel containing 50 random lines
    and save it in FILENAME."
  (magick:with-magick-wand (wand :create width height :comp (0 0 0))
    (magick:with-drawing-wand (dw)
      (magick:with-pixel-wand (pw :comp (255 255 255))
        (magick:draw-set-stroke-color dw pw))
      (magick:draw-set-stroke-width dw 3d0)
      (dotimes (i 50)
        (magick:draw-line dw
                          (coerce (random width) 'double-float)
                          (coerce (random height) 'double-float)
                          (coerce (random width) 'double-float)
                          (coerce (random height) 'double-float)))
      (magick:draw-image wand dw))
    (magick:write-image wand filename)))

(defun start ()
  (draw-a-few-lines "some.png" 100 100))
