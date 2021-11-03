.PHONY: tar clean run strip

water:
ifeq ($(OS),Windows_NT)
	sbcl --non-interactive \
             --eval '(load "~/quicklisp/setup.lisp")' \
             --eval '(ql:quickload :deploy)' \
             --load ../water.asd \
             --eval '(ql:quickload :water)' \
             --eval '(asdf:make :water :force t)'
else
	sbcl --non-interactive \
             --eval '(load "~/quicklisp/setup.lisp")' \
             --eval '(ql:quickload :deploy)' \
             --load ../water.asd \
             --eval '(ql:quickload :water)' \
             --eval '(deploy:define-library CL-OPENGL-BINDINGS::OPENGL :dont-deploy t)' \
             --eval '(deploy:define-library (quote libz) :path "/lib/libz.so")' \
             --eval '(asdf:make :water :force t)'
endif
strip:
	find . -name '*.so*' -exec strip {} \;

tar:
	tar cvf ../water.tar ../bin --transform s/bin/water/

clean:
	rm -v -f ../water.tar
	rm -v -f ./*.so*
	rm -v -f ./water

run:
	LD_PRELOAD="$(shell echo ./*.so*)" ./water
