# water

Playground for [lisp-magick-wand](https://github.com/ruricolist/lisp-magick-wand) with [CEPL](https://github.com/cbaggers/cepl).

## Example

![water](../master/static/water.png?raw=true  "water")

Should work with the code of example3.lisp running.
```lisp
(progn
  (clear-wand)
  (magick:add-noise-image *wand* 5)
  (magick:gaussian-blur-image *wand* 1d0 1d0)
  (magick:draw-set-stroke-width *draw* 2d0)
  (magick:with-pixel-wand (pw :comp (100 100 100 255))
                          (magick:draw-set-fill-color *draw* pw))
  (dotimes (i 200)
    (magick:draw-rectangle *draw*
                           (+ 100 i)
                           (+ 300 (* 100 (cos (/ i 10))))
                           (+ 50 i 4)
                           (+ 250 4 (* 100 (cos (/ i 10))))))
  (magick:add-noise-image *wand* 5)
  (magick:draw-set-font-size *draw* 60)
  (magick:draw-set-stroke-width *draw* 3d0)
  (magick:draw-annotation *draw* 326 276 "water")
  (magick:draw-image *wand* *draw*)
  (push-wand)
  (magick:write-image *wand* "/home/sendai/water.png"))
```

## raison d'être

Only using emac's `auto-revert-mode` was too slow in opening the new image.

## Usage

I won't. But, in general is `(magick:draw-SOMETHING)` and `(magick:draw-image)` to get the image into the magick-wand then `(magick:get-image-pixels)` and `(push-g)` to pull the pixels into a usable c-array and into the gpu.

## Notes

* I had to add my .so name into lisp-magick-wand/base.lisp. In my case `libMagickWand-6.Q16.so`.
* Looks like calls to `(magick:draw-image)` are the most cpu expensive and get more and more expesive as more draws are added into the `draw wand` being used, like `(magick:draw-line)`.
* Due above, complex animations of many objects might note be possible.
xs

## Examples

* `example1.lisp` translation of basic example provided with lisp-magick-wand. Just evaluate `(draw-a-few-lines)`
* `example2.lisp` same as above but with an update (auto) and draw (manual) loop, evalute `(make-line)` and `(draw-a-few-lines)`
* `example3.lisp` removed classes and update/draw calls but made all the `wands` globals, use any of the commented draw calls with the global wands. Don't forget to push-g.
* `example4.lisp` animation with stepper once per second, removed use of new-image on clear

## License

MIT

