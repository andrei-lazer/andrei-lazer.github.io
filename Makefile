SHELL := /usr/bin/bash

.PHONY: build clean

export WIKI := $(HOME)/wiki

build:
	@set -euo pipefail; \
	rm -rf build; \
	sbcl --noinform --noprint --non-interactive --load build.lisp; \
	cp -r src/styles build/; \
	cp -r src/assets build/

serve: build
	@python3 -m http.server 8080 --directory ./build & \
	server_pid=$$!; \
	trap "kill $$server_pid" EXIT; \
	find src build.lisp -type f | entr -r make build

clean:
	rm -rf build

