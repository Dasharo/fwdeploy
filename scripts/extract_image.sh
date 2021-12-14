#!/bin/bash -x

ACM_BIOS_GUID="2D27C618-7DCD-41F5-BB10-21166BE7E143"
SCH5545_EC_FW="D386BEB8-4B54-4E69-94F5-06091F67E0D3"

fw_dump_bin="${1}"
cb_stub_bin="${2}"

( [ "${fw_dump_bin}" == "" ] || [ ! -f "${fw_dump_bin}" ] \
	|| [ "${cb_stub_bin}" == "" ] || [ ! -f "${cb_stub_bin}" ]) && \
       	echo "Usage: ./dell_optiplex_9010_dasharo.sh <fw_dump_bin> <cb_stub_bin>" && exit 1

uefiextract=/home/fwdeploy/UEFITool/UEFIExtract/UEFIExtract
cbfstool=/home/fwdeploy/coreboot/util/cbfstool/cbfstool

${uefiextract} "${fw_dump_bin}" ${ACM_BIOS_GUID} -o acm_bios -m body
cp acm_bios/body.bin txt_bios_acm.bin
${uefiextract} "${fw_dump_bin}" ${SCH5545_EC_FW} -o ec -m body
cp ec/body.bin sch5545_ecfw.bin

# get descriptor, me, gbe
${uefiextract} "${fw_dump_bin}" all
cp ${fw_dump_bin}.dump/0\ Descriptor\ region/body.bin descriptor.bin
cp ${fw_dump_bin}.dump/2\ ME\ region/body.bin me.bin
cp ${fw_dump_bin}.dump/1\ GbE\ region/body.bin gbe.bin

sha256sum -c /home/fwdeploy/blobs/dell_optiplex_9010.sha256

${cbfstool} ${cb_stub_bin} add -t raw -f txt_bios_acm.bin -n txt_bios_acm.bin -a 0x20000 -r COREBOOT
${cbfstool} ${cb_stub_bin} add -t raw -f sch5545_ecfw.bin -n sch5545_ecfw.bin  -r COREBOOT
${cbfstool} ${cb_stub_bin} write -r SI_DESC -f descriptor.bin -u
${cbfstool} ${cb_stub_bin} write -r SI_ME -f me.bin -u
${cbfstool} ${cb_stub_bin} write -r SI_GBE -f gbe.bin -u
