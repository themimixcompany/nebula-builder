.PHONY: all build releases_installers macos_installers

DIR := $(shell basename "$(shell pwd)")
NAME = nebula-builder
DOCKERFILE = ./Dockerfile

all: build releases_installers macos_installers

build:
	docker build -f $(DOCKERFILE) -t $(NAME) .

releases_installers:
	docker run --rm -it \
	--mount type=bind,source=${SSH_PRIVATE_KEY},target=/root/.ssh/id_rsa,readonly \
	--mount type=bind,source=${SSH_PUBLIC_KEY},target=/root/.ssh/id_rsa.pub,readonly \
	--volume ${SOURCES}:/var/lib/sources \
	--volume ${RELEASES}:/var/lib/releases \
	--env TOKEN=${TOKEN} \
	--env ARCHS=${ARCHS} \
	--env TAG=${TAG} \
	$(NAME)

macos_installers:
	RELEASES=${RELEASES} TAG=${TAG} make -C ../nebula clean install macos_package macos_installers
