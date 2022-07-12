#!/bin/bash

set -euo pipefail

for cmd in curl md5sum gpg; do
    command -v "${cmd}" &>/dev/null || {
        echo "${cmd} is not installed" 1>&2
        exit 1
    }
done

readonly IMAGE_URL="http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-aarch64-latest.tar.gz"
readonly HASH_URL="${IMAGE_URL}.md5"
readonly SIGNATURE_URL="${IMAGE_URL}.sig"

# TMPDIR="$(mktemp -d)"
# trap '{ rm -rf -- "${TMPDIR} }"' EXIT

# cd "${TMPDIR}"

curl -L -O "${IMAGE_URL}"
curl -L -O "${HASH_URL}"
curl -L -O "${SIGNATURE_URL}"

readonly ARCHIVE_NAME="${IMAGE_URL##*/}"

md5sum -c "${HASH_URL##*/}"
# gpg --verify "${SIGNATURE_URL##*/}"

# bsdtar -xpf ArchLinuxARM-rpi-armv7-latest.tar.gz -C root
