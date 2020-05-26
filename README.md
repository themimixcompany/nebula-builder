nebula-builder
==============


<a name="toc">Table of Contents</a>
-----------------------------------

- [Overview](#overview)
- [Setup](#setup)
  + [Docker image](#docker)
  + [GitHub access](#github)
- [Building](#building)
  + [Paths](#paths)
  + [Manual build](#manualbuild)
  + [Make build](#makebuild)


<a name="overview">Overview</a>
-------------------------------

nebula-builder is the toplevel code for building Nebula from different software components. The nebula-builder is run inside a Docker container in order to provide consistency and reproducibility.


<a name="setup">Setup</a>
-------------------------

### <a name="docker">Docker Image</a>

If you have the tarball, you can load it with:

    docker load -i nebula-builder.tar.gz

If you don't have a pre-built Docker image, you can create one by cloning this repo:

    git clone https://github.com/themimixcompany/nebula-builder

then, run:

    docker build -t nebula-builder .

Then, verify that the image has been built with:

    docker images

If you can see `nebula-builder` in the list, we’re good to go.


### <a name="github">GitHub Access</a>

1. First, we need to make sure that the SSH keys that you have on your machine
   are properly registered to your GitHub acount. If you haven’t yet, go to the
   [Keys](https://github.com/settings/keys) page of your account then paste the
   contents of your public key.

2. Find your local public and private key paths. Your public key is located in
   `~/.ssh/` and `%HOMEPATH%/.ssh` for Unix and Windows systems
   respectively. Call them `${SSH_PUBLIC_KEY}` and `${SSH_PRIVATE_KEY}`.

3. Next, we need to get an access token from your GitHub account. The token will
   be used to fetch the binaries of the Engine. To do so, go to the
   [Tokens](https://github.com/settings/tokens) in your account, then copy the
   alphanumeric string. Call it `${TOKEN}`.


<a name="building">Building</a>
-------------------------------

### <a name="paths">Paths</a>

1. Next, we need to specify the location of the local sources for the build
   dependencies. The directory must contain the local git repositories of
   [nebula](https://github.com/themimixcompany/nebula) and
   [local-world](https://github.com/themimixcompany/local-world), with the same
   exact names as found on GitHub. Call it `${SOURCES}`.

2. Next, we need to specify the location on your local disk where the releases
   will be put. Call it `${RELEASES}`.

3. Next, we need to specify the targets to create the releases with. In our
   case, we use the string `linux,windows,macos,electron,docker` which means
   that we want to build for Linux, Windows, macOS systems, together with the
   platform-neutral Electron app, and the Docker image.

4. Lastly, we need to specify the version tag name that will be used when
   creating the releases. It can be a string like `1.0.0`. This will become the
   final output folder name. Call it `${TAG}`.


### <a name="manualbuild">Manual build</a>

In order to build Nebula, we need to run the Docker image, with specific
parameters.  A template showing where to place all these named variables looks
like this:

```bash
docker run --rm -it \
--mount type=bind,source=${SSH_PRIVATE_KEY},target=/root/.ssh/id_rsa,readonly \
--mount type=bind,source=${SSH_PUBLIC_KEY},target=/root/.ssh/id_rsa.pub,readonly \
--volume ${SOURCES}:/var/lib/sources \
--volume ${RELEASES}:/var/lib/releases \
--env TOKEN=${TOKEN} \
--env TARGETS=${TARGETS} \
--env TAG=${TAG} \
nebula-builder
```

This example has all named variables replaced with real values:

```bash
docker run --rm -it \
--mount type=bind,source=$HOME/.ssh/id_rsa,target=/root/.ssh/id_rsa,readonly \
--mount type=bind,source=$HOME/.ssh/id_rsa.pub,target=/root/.ssh/id_rsa.pub,readonly \
--volume $HOME/mimix/src:/var/lib/sources \
--volume $HOME/mimix/releases:/var/lib/releases \
--env TOKEN=4a386c297c7c53a4f8ea01d9e9e947312cd645d1 \
--env TARGETS=linux,windows,macos,electron,docker \
--env TAG=1.0.0 \
nebula-builder
```

When the command finishes, the directory `~/mimix/releases/` will have a
structure like the following:

```bash
.
├── docker
│   └── nebula
│       └── app
│           └── 1.0.0
├── electron
│   └── nebula
│       └── app
│           └── 1.0.0
├── linux
│   └── nebula
│       └── app
│           └── 1.0.0
├── macos
│   └── nebula
│       └── app
│           └── 1.0.0
└── windows
    └── nebula
        └── app
            └── 1.0.0
```

Where `1.0.0` contains the binaries for the corresponding target.


### <a name="makebuild">Make build</a>

Another way to run the builder is through the use of make. The makefile that
accompanies this document contains the necessary instructions in order to build
Nebula for Linux, Windows, and macOS.

To run the make builder, run:

```bash
SOURCES=$HOME/src RELEASES=$HOME/releases TOKEN=a386c27c7c53a44f8ea019e9e9473d12cd6459d0 TARGETS=linux,windows,macos,electron,docker make
```

`SOURCES` points to the directory containing the sources for nebula, and other
dependencies. `RELEASES` points to a directory where the binary releases will be
saved. `TOKEN` is the 40-digit GitHub access token. `TARGETS` is a
comma-separated list of build targets.
