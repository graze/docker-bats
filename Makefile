build_args := --build-arg BUILD_DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ") \
              --build-arg VCS_REF=$(shell git rev-parse --short HEAD)

ver?=1.10.0
latest:=1.10.0

.PHONY: build build-quick test tag push deploy help

build-quick: ## Build using caches
	@${MAKE} build cache=""

build: cache ?=--pull --no-cache
build: ## Build a bats version
	docker buildx build --output type=docker --platform=linux/amd64,linux/arm64,linux/arm/v7  ${cache} ${build_args} -t graze/bats:${ver} .

test: ## Test the image
	docker run --rm \
		-v /var/run/docker.sock:/var/run/docker.sock -v $$(pwd):/app \
		-e ver=${ver} \
		graze/bats:${ver} .

tag: ## Tag the image to latest if it is the latest
ifeq (${ver},${latest})
	docker tag graze/bats:${ver} graze/bats:latest
endif

push: ## Push the images to the respository
	docker push graze/bats:${ver}
ifeq (${ver},${latest})
	docker push graze/bats:latest
endif

deploy: ## Tag and push the image
deploy: tag push

help: ## Show this help message.
	@echo 'usage: make [target] ...'
	@echo
	@echo 'targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'
