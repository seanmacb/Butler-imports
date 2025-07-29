#!/bin/bash

# === CONFIGURATION ===
PATH_LIST="stripped_paths2.txt"  # Each line is a full path on remote2, e.g., /taiga/.../file.fits
REMOTE_USER="seanmacb"
# REMOTE_HOST="descmp2.cosmology.illinois.edu"
# JUMP_HOST="seanmacb@deslogin.cosmology.illinois.edu"
LOCAL_OUT="/sdf/data/rubin/repo/main/DECam/communityProcessed/decade_coadds"
NUM_PARALLEL=1

# === VALIDATION ===
if [[ ! -f "$PATH_LIST" ]]; then
    echo "❌ Path list '$PATH_LIST' not found."
    exit 1
fi

mkdir -p "$LOCAL_OUT"

echo "⬇️  Starting parallel rsync downloads through desar..."

export REMOTE_USER NUM_PARALLEL PATH_LIST LOCAL_OUT

cat "$PATH_LIST" | xargs -n1 -P"$NUM_PARALLEL" -I{} bash -c '
    full_path="$1"
    echo "Full path:$full_path"
    user="$REMOTE_USER"
    local_out="$LOCAL_OUT"

    # Compute relative path
    rel_path="${full_path#/}"  # Strip leading subdir
    rel_path="${rel_path:11}"
    echo "Relative path:$rel_path"
    out_path="$local_out/taiga/deca_archive/DEC/multiepoch/$rel_path"
    echo "Out path:$out_path"
    out_dir=$(dirname "$out_path")
    mkdir -p "$out_dir"

    echo "  ↓ Downloading (overwrite if needed): $rel_path"
    rsync -avz --password-file=pwFile --inplace seanmacb@desar.cosmology.illinois.edu::deca_archive/$rel_path $out_path || echo " ⚠️ Failed: $rel_path"
    
' _ {}

echo "✅ All rsync transfers complete."
