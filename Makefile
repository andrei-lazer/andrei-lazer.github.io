SHELL := /usr/bin/bash

REPO_ROOT := $(shell git rev-parse --show-toplevel)
DEPLOY_DIR := $(REPO_ROOT)/../website-deploy
DEPLOY_BRANCH := deploy

.PHONY: build deploy clean

build:
	@set -euo pipefail; \
	cd "$(REPO_ROOT)"; \
	rm -r build; \
	sbcl --noinform --noprint --non-interactive --load build.lisp; \
	cp -r src/styles build/; \
	cp -r src/assets build/

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
	fi;

clean:
	rm -rf build
