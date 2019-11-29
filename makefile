.PHONY: all

DIR := $(shell basename "$(shell pwd)")
NAME = "mvp-builder"
DOCKERFILE = "./Dockerfile"

clean:
	rm -rf out

dockerbuild:
	docker build -f $(DOCKERFILE) -t $(NAME) .

forcedockerbuild:
	docker build --no-cache -f $(DOCKERFILE) -t $(NAME) .
