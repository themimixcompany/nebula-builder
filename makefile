#-------------------------------------------------------------------------------
# Head
#-------------------------------------------------------------------------------

SHELL := bash
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:


#-------------------------------------------------------------------------------
# Body
#-------------------------------------------------------------------------------

.PHONY: all build releases_installers macos_installers

DIR := $(shell basename "$(shell pwd)")
NAME = nebula-builder
DOCKERFILE = ./Dockerfile

TAG := $(shell jq '.version' ../nebula/package.json)

ifndef SSH_PRIVATE_KEY
  override SSH_PRIVATE_KEY=${HOME}/.ssh/id_ed25519
endif

ifndef SSH_PUBLIC_KEY
  override SSH_PUBLIC_KEY=${HOME}/.ssh/id_ed25519.pub
endif

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
	--env TAG=$(TAG) \
	$(NAME)

macos_installers:
	RELEASES=${RELEASES} TAG=$(TAG) $(MAKE) -C ../nebula clean install macos_package macos_installers
