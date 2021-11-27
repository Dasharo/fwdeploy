#!/bin/bash

source container-config

( [ "${1}" == "" ] || [ ! -f "${1}" ] ) && \
 echo "Usage: ./run.sh <image>" && exit 1

docker run -v $(readlink -f ${1}):/home/fwdeploy/fw.bin -t $DOCKER_USER_NAME/$DOCKER_IMAGE_NAME:latest fw.bin

