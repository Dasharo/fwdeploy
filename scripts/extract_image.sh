#!/bin/sh

image="${1}"

( [ "${image}" == "" ] || [ ! -f "${image}" ] ) && \
 echo "Usage: ./extract_image.sh <image>" && exit 1

set -e
which uefiextract >/dev/null
which acpibin >/dev/null
set +e

uefiextract "${image}" unpack
rm "${image}.report.txt"
cd "${image}.dump/"

find . -regextype awk \
 \( -not -regex "./(File|Section)_(TE|PE32|Raw)_.*" -a \
    -not -regex "./.*?Pad(ding)?_Non-empty.*" \
    -o -name "*.txt" -o -name "*_header.bin" \
 \) -delete

mkdir acpi/
for i in Section_Raw_*.bin; do
 header="$(acpibin -h ${i} | tr -d ' ')"
 sig="$(grep -oP '(?<=Signature:)\w+'  <<< ${header})"
 oid="$(grep -oP '(?<=OEMID:)\w+'      <<< ${header})"
 tid="$(grep -oP '(?<=OEMTableID:)\w+' <<< ${header})"

 [[ "${sig}" == "" || "${header}" =~ "invalid" ]] && continue
 [[ "${tid}" =~ "${oid}" ]] && oid=""

 name="${sig}${oid:+_${oid}}${tid:+_${tid}}"
 iasl -p ${name}.dsl ${i} && mv --backup=numbered ${name}.dsl acpi/ && rm ${i}
done

ls Section_{PE32,TE}_image_*.bin | \
 gawk 'match($0, /^Section_([^_]+)_image_([A-F0-9-]+)_(.*)_body.bin$/, a) { print $0 " " a[3]"_"a[1]"_"a[2]".bin" }' | \
 xargs -n2 mv

mkdir x32/ x64/ raw/
mv *_TE_*.bin x32/
file *.bin | grep x86-64 | cut -d: -f1 | xargs -i mv {} x64/
file *.bin | grep 80386  | cut -d: -f1 | xargs -i mv {} x32/
mv *.bin raw/
