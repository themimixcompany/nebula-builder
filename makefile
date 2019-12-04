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
	--mount type=bind,source=${SSH_PRIVATE_KEY},target=/root/.ssh/id_rsa \
	--mount type=bind,source=${SSH_PUBLIC_KEY},target=/root/.ssh/id_rsa.pub \
	--volume ${SOURCES}:/var/lib/sources \
	--volume ${RELEASES}:/var/lib/releases \
	--env TOKEN=${TOKEN} \
	--env ARCHS=${ARCHS} \
	$(NAME)
