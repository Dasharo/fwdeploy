#!/bin/bash

source container-config

( [ "${1}" == "" ] || [ ! -f "${1}" ] || [ "${2}" == "" ] || [ ! -f "${2}" ] ) && \
 echo "Usage: ./run.sh <fw_dump_bin> <cb_stub_bin>" && exit 1

docker run -v $(readlink -f ${1}):/home/fwdeploy/fw.bin -v $(readlink -f ${2}):/home/fwdeploy/cb.bin -t $DOCKER_USER_NAME/$DOCKER_IMAGE_NAME:latest fw.bin cb.bin

