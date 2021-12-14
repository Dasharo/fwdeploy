#!/bin/bash -x

ACM_BIOS_GUID="2D27C618-7DCD-41F5-BB10-21166BE7E143"
SCH5545_EC_FW="D386BEB8-4B54-4E69-94F5-06091F67E0D3"

image="${1}"

( [ "${image}" == "" ] || [ ! -f "${image}" ] ) && \
 echo "Usage: ./extract_image.sh <image>" && exit 1

uefiextract=/home/fwdeploy/UEFITool/UEFIExtract/UEFIExtract

${uefiextract} "${image}" ${ACM_BIOS_GUID} -o acm_bios -m body
cp acm_bios/body.bin txt_bios_acm.bin
${uefiextract} "${image}" ${SCH5545_EC_FW} -o ec -m body
cp ec/body.bin sch5545_ecfw.bin

# get descriptor, me, gbe
${uefiextract} "${image}" all
cp ${image}.dump/0\ Descriptor\ region/body.bin descriptor.bin
cp ${image}.dump/2\ ME\ region/body.bin me.bin
cp ${image}.dump/1\ GbE\ region/body.bin gbe.bin

sha256sum -c /home/fwdeploy/blobs/dell_optiplex_9010.sha256
