#!/bin/bash

# === CONFIGURATION ===
PATH_LIST="fullPathList_fz.txt"  # Each line is a full path on remote2, e.g., /taiga/.../file.fits
REMOTE_USER="seanmacb"
REMOTE_HOST="descmp2.cosmology.illinois.edu"
JUMP_HOST="seanmacb@deslogin.cosmology.illinois.edu"
LOCAL_OUT="/sdf/data/rubin/repo/main/DECam/communityProcessed/decade_coadds"
NUM_PARALLEL=128

# === VALIDATION ===
if [[ ! -f "$PATH_LIST" ]]; then
    echo "❌ Path list '$PATH_LIST' not found."
    exit 1
fi

mkdir -p "$LOCAL_OUT"

echo "⬇️  Starting parallel rsync downloads through $JUMP_HOST..."

export REMOTE_USER REMOTE_HOST JUMP_HOST LOCAL_OUT

cat "$PATH_LIST" | xargs -n1 -P"$NUM_PARALLEL" -I{} bash -c '
    full_path="$1"
    user="$REMOTE_USER"
    host="$REMOTE_HOST"
    jump="$JUMP_HOST"
    local_out="$LOCAL_OUT"

    # Compute relative path
    rel_path="${full_path#/}"  # Strip leading slash
    out_path="$local_out/$rel_path"
    out_dir=$(dirname "$out_path")
    mkdir -p "$out_dir"

    if [ -f "$out_path" ]; then
        echo "  ⏩ Skipping existing: $rel_path"
    else
        echo "  ↓ Downloading: $rel_path"
        rsync -avz -e "ssh -J $jump" "$user@$host:$full_path" "$out_path" || echo "  ⚠️ Failed: $rel_path"
    fi
' _ {}

echo "✅ All rsync transfers complete."
