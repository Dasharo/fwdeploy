# fwdeploy

[![Build Status](https://travis-ci.com/dasharo/fwdeploy.svg?branch=master)](https://travis-ci.com/dasharo/fwdeploy)

Dockerized utility for deploying [Dasharo](https://dasharo.com) firmware.

The container has been designed to avoid installing many dependencies, build
tools and other packages on the system required to deploy Dasharo firmware. It
also helps in avoiding legal problem of dealing with binary blobs necessary to
boot the platform.

## Usage

[Install Docker](https://docs.docker.com/engine/install/), if it is not yet in
the system.

Before using `fwdeploy` you have to backup your original BIOS. How to do that
is left to the user, since procedure is hardware-specific.

### BIOS backup

* [Dell OptiPlex 7010/9010 SFF](https://docs.dasharo.com/variants/dell_optiplex/installation-manual/#install-flashrom)

### Include non-redistributable blobs

```shell
wget https://raw.githubusercontent.com/Dasharo/fwdeploy/main/run.sh
./run.sh <bios_backup> <dasharo_dell_optiplex_firmware_binary>
```

## Pull docker image

```
docker pull dasharo/fwdeploy
```

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

