#!/bin/bash

set -euo pipefail

for cmd in curl shasum gpg; do
    command -v "${cmd}" &>/dev/null || {
        echo "${cmd} is not installed" 1>&2
        exit 1
    }
done

readonly IMAGE_URL="https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2022-04-07/2022-04-04-raspios-bullseye-armhf-lite.img.xz"
readonly HASH_URL="${IMAGE_URL}.sha256"
readonly SIGNATURE_URL="${IMAGE_URL}.sig"

trap '{ rm -f -- "${HASH_URL##*/}" "${SIGNATURE_URL##*/}" }' EXIT

curl -L -O "${IMAGE_URL}"
curl -L -O "${HASH_URL}"
curl -L -O "${SIGNATURE_URL}"

readonly ARCHIVE_NAME="${IMAGE_URL##*/}"

shasum -a 256 --check "${HASH_URL##*/}"
# gpg --verify "${SIGNATURE_URL##*/}"

xz -d "${ARCHIVE_NAME}"
