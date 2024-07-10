#!/usr/bin/bash
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

NVIM_DESTINATION=$HOME/.config/nvim/

rsync -r $SCRIPT_DIR/nvim/ $NVIM_DESTINATION/
