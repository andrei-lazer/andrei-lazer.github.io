#!/usr/bin/bash
rm -rf build
sbcl --noinform --noprint --non-interactive \
     --eval '(progn (require :asdf) (load "~/quicklisp/setup.lisp")
                    (push #p"./" asdf:*central-registry*))' \
     --eval '(ql:quickload :app)' \
     --eval '(app:main)'
# copying css files
cp -r src/styles build/
cp -r src/assets build/
