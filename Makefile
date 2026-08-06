SHELL := /usr/bin/bash

REPO_ROOT := $(shell git rev-parse --show-toplevel)
DEPLOY_DIR := $(REPO_ROOT)/../website-deploy
DEPLOY_BRANCH := deploy

.PHONY: build test clean

export WIKI := $(HOME)/wiki

build:
	@set -euo pipefail; \
	rm -rf build; \
	sbcl --noinform --noprint --non-interactive --load build.lisp; \
	cp -r src/styles build/; \
	cp -r src/assets build/

test:
	@sbcl --noinform --non-interactive --load run-tests.lisp

deploy: build
	@set -euo pipefail; \
	cd "$(REPO_ROOT)"; \
	if [ ! -e "$(DEPLOY_DIR)/.git" ]; then \
		git worktree add -B "$(DEPLOY_BRANCH)" "$(DEPLOY_DIR)" HEAD; \
	fi; \
	rsync -a --delete --exclude='.git' build/ "$(DEPLOY_DIR)/"; \
	cd "$(DEPLOY_DIR)"; \
	printf '%s\n' andreilazer.me > "$(DEPLOY_DIR)/CNAME"; \
	git pull; \
	git add -A; \
	if ! git diff --cached --quiet; then \
		git commit -m "Deploy site"; \
	fi; \
	git push; 

serve:
	@python3 -m http.server 8080 --directory ./build & \
	server_pid=$$!; \
	trap "kill $$server_pid" EXIT; \
	find src build.lisp -type f | entr -cr make build

clean:
	rm -rf build

