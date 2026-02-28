#!/usr/bin/env bash
# Mount/unmount system.VHDX from Archive drive

VHDX="/mnt/archive/system.VHDX"
MOUNTPOINT="$HOME/mnt/system-vhdx"

if mountpoint -q "$MOUNTPOINT" 2>/dev/null; then
    echo "Unmounting $MOUNTPOINT..."
    guestunmount "$MOUNTPOINT"
    echo "Done."
else
    if [[ ! -f "$VHDX" ]]; then
        echo "Error: $VHDX not found. Is the Archive drive mounted?"
        exit 1
    fi
    mkdir -p "$MOUNTPOINT"
    fusermount -uz "$MOUNTPOINT" 2>/dev/null
    echo "Mounting $VHDX to $MOUNTPOINT..."
    if guestmount -a "$VHDX" -i --ro "$MOUNTPOINT"; then
        echo "Mounted at $MOUNTPOINT"
    else
        echo "Error: failed to mount VHDX."
        exit 1
    fi
fi
