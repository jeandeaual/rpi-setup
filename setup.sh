#!/bin/bash

set -euo pipefail

function cleanup() {
    for mount_point in "${boot_mount_path}" "${root_mount_path}"; do
        mountpoint -q "${mount_point}" && umount "${mount_point}"
    done
    if [[ -n "${loop_device}" ]]; then
        readonly loop_device_path="/dev/${loop_device}"
        echo "Detaching ${loop_device_path}..."
        kpartx -d "${loop_device_path}"
        losetup -d "${loop_device_path}"
    fi
}

# Cleanup at script exit
trap cleanup EXIT

src="$1"
img="$1"

# Copy to new file if requested
if [[ "$#" -ge 2 ]]; then
    readonly target="$2"

    echo "Copying ${src} to ${target}..."

    cp --reflink=auto --sparse=always "$1" "${target}"

    if [[  $? -ne 0 ]]; then
        echo "Could not copy file..." 1>&2
        exit 5
    fi

    old_owner=$(stat -c %u:%g "$1")
    chown "${old_owner}" "${target}"

    img="${target}"
fi

# Mount root
kpartx_output="$(kpartx -av "${img}")"
echo "kpartx output: ${kpartx_output}"

partition_count="$(echo "${kpartx_output}" | wc -l)"
if [[ "${partition_count}" != 2 ]]; then
    echo "Invalid partition count: ${partition_count}" 1>&2
    exit 2
fi

root_device="$(echo "${kpartx_output}" | tail -n 1 | cut -d ' ' -f 3)"
boot_device="$(echo "${kpartx_output}" | tail -n 2 | head -n 1 | cut -d ' ' -f 3)"
loop_device="${root_device%p[0-9]}"
echo "Loop device: ${loop_device}"
echo "Boot device: ${boot_device}"
echo "Root device: ${root_device}"

readonly boot_device_path="/dev/mapper/${boot_device}"
readonly root_device_path="/dev/mapper/${root_device}"
readonly boot_mount_path="/mnt/boot"
readonly root_mount_path="/mnt/root"

for dir in "${boot_mount_path}" "${root_mount_path}"; do
    if [[ ! -d "${dir}" ]]; then
        mkdir -p "${dir}"
    fi
done

echo "Mounting ${boot_device_path} on ${boot_mount_path}"
mount "${boot_device_path}" "${boot_mount_path}"

echo "Mounting ${root_device_path} on ${root_mount_path}"
mount "${root_device_path}" "${root_mount_path}"

# Enable the SSH server on Rapsberry Pi OS
touch "${boot_mount_path}/ssh"

# Update the default username and password
readonly new_user="alexis"
readonly new_password="password"

cp ./update_user.sh "${root_mount_path}/"

chroot "${root_mount_path}" /bin/bash -c "su - root -c '/update_user.sh ${new_user} ${new_password}'"

rm -f "${root_mount_path}/update_user.sh"
