mvp-builder
===========


Overview
--------

This repo contains code for building the Mimix MVP from different software
components. The mvp-builder is run inside a Docker container in order to provide
consistency and reproducibility. To use the mvp-builder, only an installation of
Docker is needed.


Usage
-----


### Create Docker container

In order to use the builder, the Docker image must first be created. To do so,
run:

    docker build -t mvp-builder .

When it has finished running, it will create a Docker image named
`mvp-builder`. You may check its existence with the following command:

    docker images

If you can see `mvp-buider` in the list, then we’re good to go.


### Run the builder

The mvp-builder maps a directory from the local filesystem to the Docker
container. This will be used by the builder for the creation of the releases.

To create this directory, run:

    mkdir -p releases

After creating this directory, run the builder itself:

    docker run --rm -v ./releases:/releases mvp-builder
