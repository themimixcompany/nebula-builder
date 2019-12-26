#-------------------------------------------------------------------------------
# Head
#-------------------------------------------------------------------------------

SHELL := bash
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
.RECIPEPREFIX +=


#-------------------------------------------------------------------------------
# Body
#-------------------------------------------------------------------------------

.PHONY: all build

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

all: build
  ./dispatcher \
    --ssh-private-key ${SSH_PRIVATE_KEY} \
    --ssh-public-key ${SSH_PUBLIC_KEY} \
    --sources ${SOURCES} \
    --releases ${RELEASES} \
    --token ${TOKEN} \
    --targets ${TARGETS} \
    --tag $(TAG) \
    --name $(NAME)

build:
  docker build -f $(DOCKERFILE) -t $(NAME) .
