#!/bin/bash
module load rclone
# === CONFIGURATION ===
URL_LIST="split07.txt"  # List of direct URLs to FITS or FITS.FZ files
BASE_URL="https://desdr-server.ncsa.illinois.edu/despublic/dr2_tiles/"  # Prefix to strip
OUTPUT_DIR="/sdf/data/rubin/repo/main/DECam/communityProcessed/dr2_tiles"  # Destination
NUM_PARALLEL=64  # Number of parallel jobs

# === VALIDATION ===
if [[ ! -f "$URL_LIST" ]]; then
    echo "❌ URL list '$URL_LIST' not found."
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "⬇️  Starting parallel downloads with rclone..."

export BASE_URL
export OUTPUT_DIR

cat "$URL_LIST" | xargs -n1 -P"$NUM_PARALLEL" -I{} bash -c '
    url="$1"
    base="$BASE_URL"
    outroot="$OUTPUT_DIR"

    if [[ "$url" == "$base"* ]]; then
        rel="${url#"$base"}"
    else
        echo "  ⚠️  Skipping unmatched URL: $url"
        exit 0
    fi

    out_path="$outroot/$rel"
    out_dir=$(dirname "$out_path")
    mkdir -p "$out_dir"

    if [ -f "$out_path" ]; then
        echo "  ⏩ Skipping existing: $rel"
    else
        echo "  ↓ Downloading: $rel"
        rclone copyurl "$url" "$out_path" --quiet || echo "  ⚠️ Failed: $url"
    fi
' _ {}

echo "✅ All downloads complete. Existing files left untouched."
