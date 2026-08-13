.PHONY: clean build serve deploy

BUILD_DIR := ./build/
SRC_DIR := ./src/
WIKI := $(HOME)/wiki 

DEPLOY_BRANCH := deploy
DEPLOY_DIR := ../website-deploy
DATE := $(shell date +%F)

clean:
	@rm -rf build

build: clean
	@env WIKI=$(WIKI) sbcl --script build.lisp

serve: build
	@printf "Running server at localhost:%s\n" $(PORT)
	@python -m http.server $(PORT) --directory $(BUILD_DIR)

deploy: build
	if [ ! -e "$(DEPLOY_DIR)/.git" ]; then \
		git worktree add -B "$(DEPLOY_BRANCH)" "$(DEPLOY_DIR)" "origin/$(DEPLOY_BRANCH)"; \
	fi; \
	rsync -a --delete --exclude='.git' build/ "$(DEPLOY_DIR)/"; \
	printf '%s\n' andreilazer.me > "$(DEPLOY_DIR)/CNAME"; \
	cd "$(DEPLOY_DIR)"; \
	git pull; \
	git add -A; \
	if ! git diff --cached --quiet; then \
		git commit -m "Deploy site"; \
	fi; \
	git push;
