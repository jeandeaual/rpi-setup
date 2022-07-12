#!/bin/bash

set -euo pipefail

command -v nmap &>/dev/null || {
    echo 'nmap not installed' 1>&2
    exit 1
}

if [[ $EUID -ne 0 ]]; then
   echo 'This script must be run as root' 1>&2
   exit 1
fi

if [[ $# -eq 0 ]]; then
    echo 'No argument supplied' 1>&2
    exit 1
fi

network=$1

echo "Looking for Raspberry Pi devices on ${network}"
echo "(this will not work if iptables is running on the Pi)"
echo

nmap -sP "${network}" | awk '/^Nmap/{ip=$NF}/B8:27:EB/{print ip}'
