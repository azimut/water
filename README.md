# water

Testing [lisp-magick-wand](https://github.com/ruricolist/lisp-magick-wand) with [CEPL](https://github.com/cbaggers/cepl). Only due auto-revert-mode was too slow in opening the new image.

## Note

I had to add my .so into lisp-magick-wand/base.lisp. In my case "libMagickWand-6.Q16.so".

## Examples
* `example1.lisp` translation of basic example provided with lisp-magick-wand. Just evaluate `(draw-a-few-lines)`
* `example2.lisp` same as above but with an update (auto) and draw (manual) loop, evalute `(make-line)` and `(draw-a-few-lines)`

## License

MIT

