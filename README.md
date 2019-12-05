mvp-builder
===========


Overview
--------

The mvp-builder is the toplevel code for This repo contains code for the Mimix MVP from different software components. The mvp-builder is run inside a Docker container in order to provide consistency and reproducibility.


Usage
-----


### Create Docker container

In order to use the builder, the Docker image must first be created. To do so, run:

```bash
docker build -t mvp-builder .
```

If you have the tarball, you may load it instead of building it. To do so, run:

```bash
docker load -i mvp-builder.tar.gz
```

When it has finished running, it will create a Docker image named `mvp-builder`. You may check its existence with the following command:

```bash
docker images
```

If you can see `mvp-buider` in the list, then we’re good to go.


### Run the builder

In order to run the builder, there are several things that we need to prepare first.

First, we need to make sure that the SSH keys that you have on your machine are properly registered to your GitHub acount. If you haven’t yet, go to the [Keys](https://github.com/settings/keys) page of your account then paste the contents of your public key. Your public key is located in `~/.ssh/` and `%HOMEPATH%/.ssh` for Unix and Windows systems respectively.

Next, we need to get an access token from your GitHub account. The token will be used to fetch the binaries of the Engine. To do so, go to the [Tokens](https://github.com/settings/tokens) in your account, then copy the alphanumeric string.

Next, we need to specify the location of the local sources for the build dependencies. In this example, let’s presume that you have them stored at `~/mimix/src/`. The directory must contain the local git repositories of [mvp-electron](https://github.com/themimixcompany/mvp-electron) and [mvp-shell](https://github.com/themimixcompany/mvp-electron), with the same exact names as found on GitHub.

Next, we need to specify the location on your local disk where the releases will be put. In this example, let’s use the path `~/mimix/releases/`.

Next, we need to specify the target architectures to create releases with. In our case, we use the string `linux,win32` which means that we want to build for Linux and Windows systems.

Lastly, we need to specify the version tag name that will be used when creating the releases. It can be a string like `1.0.8.`.

An example builder run would look something like the following:

```bash
docker run --rm -it \
--mount type=bind,source=${SSH_PRIVATE_KEY},target=/root/.ssh/id_rsa,readonly \
--mount type=bind,source=${SSH_PUBLIC_KEY},target=/root/.ssh/id_rsa.pub,readonly \
--volume ${SOURCES}:/var/lib/sources \
--volume ${RELEASES}:/var/lib/releases \
--env TOKEN=${TOKEN} \
--env ARCHS=${ARCHS} \
--env TAG=${TAG} \
mvp-builder
```

To use actual values, we run it like so:

```bash
docker run --rm -it \
--mount type=bind,source=$HOME/.ssh/id_rsa,target=/root/.ssh/id_rsa,readonly \
--mount type=bind,source=$HOME/.ssh/id_rsa.pub,target=/root/.ssh/id_rsa.pub,readonly \
--volume $HOME/mimix/src:/var/lib/sources \
--volume $HOME/mimix/releases:/var/lib/releases \
--env TOKEN=4a386c297c7c53a4f8ea01d9e9e947312cd645d1 \
--env ARCHS=linux,win32 \
--env TAG=1.0.8 \
mvp-builder
```

When the command finishes, the directory `~/mimix/releases/` will have a structure like the following:

```bash
.
├── electron
│   └── mvp
│       └── 1.0.8
├── linux
│   └── mvp
│       └── 1.0.8
└── win32
    └── mvp
        └── 1.0.8
```

Where `1.0.8` contains the binaries for the corresponding platform.
