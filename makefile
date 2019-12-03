.PHONY: all

DIR := $(shell basename "$(shell pwd)")
NAME = "mvp-builder"
DOCKERFILE = "./Dockerfile"

clean:
	rm -rf out

build:
	docker build -f $(DOCKERFILE) -t $(NAME) .

run:
	docker run --rm -it \
	--mount type=bind,source=$(CURDIR)/ssh/id_rsa,target=/root/.ssh/id_rsa \
	--mount type=bind,source=$(CURDIR)/ssh/id_rsa.pub,target=/root/.ssh/id_rsa.pub \
	--volume $(CURDIR)/releases:/var/lib/releases \
	$(NAME) /bin/bash

run1:
	docker run --rm -it -v $SSH_AUTH_SOCK:/tmp/ssh_auth.sock -e SSH_AUTH_SOCK=/tmp/ssh_auth.sock $(NAME) /bin/sh
