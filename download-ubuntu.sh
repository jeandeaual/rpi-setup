#!/bin/bash

set -euo pipefail

for cmd in curl shasum gpg; do
    command -v "${cmd}" &>/dev/null || {
        echo "${cmd} is not installed" 1>&2
        exit 1
    }
done

readonly IMAGE_URL="https://cdimage.ubuntu.com/releases/22.04/release/ubuntu-22.04-preinstalled-server-arm64+raspi.img.xz"
readonly HASH="9cd6b5e6b4e4a7453cfde276927efe20380ab9ec0377318d5ce0bc8c8a56993b"

curl -L -O "${IMAGE_URL}"

readonly ARCHIVE_NAME="${IMAGE_URL##*/}"

echo "${HASH}  ${ARCHIVE_NAME}" | shasum -a 256 --check

xz -d "${ARCHIVE_NAME}"
