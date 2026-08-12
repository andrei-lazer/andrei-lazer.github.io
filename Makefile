

.PHONY: clean build

BUILD_DIR := ./build/
SRC_DIR := ./src/
WIKI := $(HOME)/wiki 

PORT := 8080

clean:
	@rm -r build

build: clean
	@env WIKI=$(WIKI) sbcl --script build.lisp

serve: build
	@printf "Running server at localhost:%s\n" $(PORT)
	@python -m http.server $(PORT) --directory $(BUILD_DIR)
