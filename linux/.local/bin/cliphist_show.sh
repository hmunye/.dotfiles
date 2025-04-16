#!/usr/bin/env bash

set -euo pipefail

selected=$(cliphist list | sed 's/^[0-9[:space:]]*//' | anyrun --plugins libstdin.so)

echo "$selected" | wl-copy
