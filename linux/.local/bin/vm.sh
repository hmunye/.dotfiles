#!/usr/bin/env bash

set -euo pipefail

VM="Windows 11 (G)"
URI="qemu:///system"

state=$(virsh -c "$URI" domstate "$VM" 2>/dev/null || true)

if [[ "$state" == "running" ]]; then
    exit 0
fi

virsh -c "$URI" start "$VM"
