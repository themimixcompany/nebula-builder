.PHONY: all build

DIR := $(shell basename "$(shell pwd)")
NAME = mvp-builder
DOCKERFILE = ./Dockerfile

all: build
	docker run --rm -it \
	--mount type=bind,source=${SSH_PRIVATE_KEY},target=/root/.ssh/id_rsa,readonly \
	--mount type=bind,source=${SSH_PUBLIC_KEY},target=/root/.ssh/id_rsa.pub,readonly \
	--volume ${SOURCES}:/var/lib/sources \
	--volume ${RELEASES}:/var/lib/releases \
	--env TOKEN=${TOKEN} \
	--env ARCHS=${ARCHS} \
	--env TAG=${TAG} \
	$(NAME)

build:
	docker build -f $(DOCKERFILE) -t $(NAME) .
