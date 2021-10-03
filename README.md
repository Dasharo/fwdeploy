# fwdeploy

[![Build Status](https://travis-ci.com/dasharo/fwdeploy.svg?branch=master)](https://travis-ci.com/dasharo/fwdeploy)

Dockerized utility for deploying [Dasharo](https://dasharo.com) firmware.

The container has been designed to avoid installing many dependencies, build
tools and other packages on the system required to deploy Dasharo firmware. It
also helps in avoiding legal problem of dealing with binary blobs necessary to
boot the platform.

## Pull docker image

```
docker pull dasharo/fwdeploy
```

## Usage

```
#TODO: wrap that in single simple command
#TODO: script should receive parameters similar to flashrom
docker run --rm --privileged -it -v $PWD/<dasharo_fimware.img>:/tmp/<dasharo_fimware.img> 3mdeb/fwdeploy flash <dasharo_fimware.img>
```

The container inside must run as root, thus the Dockerfile uses the root user.
Host also have to expose SPI host controlled which will be used for firmware
deployment.

## Build Docker image

```
./build.sh
```

## Release Docker image

Refer to the [docker-release-manager](https://github.com/3mdeb/docker-release-manager/blob/master/README.md)

## Troubleshooting

If similar message appears:

- in `flashrom.err.log` :

```
ERROR: Could not get I/O privileges (Operation not permitted).
You need to be root.
Error: Programmer initialization failed.
```

You may need to add `iomem=relaxed` parameter to Linux kernel command line.

