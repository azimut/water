# water

Testing [lisp-magick-wand](https://github.com/ruricolist/lisp-magick-wand) with [CEPL](https://github.com/cbaggers/cepl).

## raison d'être

Only using emac's `auto-revert-mode` was too slow in opening the new image.

## Notes

* I had to add my .so name into lisp-magick-wand/base.lisp. In my case `libMagickWand-6.Q16.so`.
* Looks like calls to `(magick:draw-image)` are the most cpu expensive and get more and more expesive as more draws are added into the `draw wand` being used, like `(magick:draw-line)`.

## Examples
* `example1.lisp` translation of basic example provided with lisp-magick-wand. Just evaluate `(draw-a-few-lines)`
* `example2.lisp` same as above but with an update (auto) and draw (manual) loop, evalute `(make-line)` and `(draw-a-few-lines)`
* `example3.lisp` removed classes and update/draw calls but made all the wands globals, use any of the commented draw calls with the global wands. Don't forget to push-g.

## License

MIT

