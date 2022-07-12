#!/bin/bash

set -euo pipefail

new_user="$1"
new_password="$2"

old_user="$(id -nu 1000)"

echo "Updating user ${old_user} to ${new_user}"

# Change user name
usermod -l "${new_user}" "${old_user}"

# Change user home
usermod -m -d "/home/${new_user}" "${new_user}"

# Update user password
echo "${new_user}:${new_password}" | chpasswd

# Disable root password
passwd -l root
