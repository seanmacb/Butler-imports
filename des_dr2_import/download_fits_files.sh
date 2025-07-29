#!/bin/bash

# === CONFIGURATION ===
URL_LIST="split00.txt"  # Text file with list of FITS or FITS.FZ URLs
BASE_URL="https://desdr-server.ncsa.illinois.edu/despublic/dr2_tiles/"  # Common URL prefix to strip
OUTPUT_DIR="/sdf/data/rubin/repo/main/DECam/communityProcessed/dr2_tiles"  # Where to save files
NUM_PARALLEL=128  # Number of simultaneous downloads

# === VALIDATION ===
if [[ ! -f "$URL_LIST" ]]; then
    echo "❌ URL list '$URL_LIST' not found."
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "⬇️  Starting parallel downloads..."
cat "$URL_LIST" | xargs -n1 -P"$NUM_PARALLEL" -I{} bash -c '
    url="$1"
    base="$2"
    outroot="$3"

    # Compute relative path by stripping base URL
    if [[ "$url" == "$base"* ]]; then
        rel="${url#"$base"/}"
    else
        echo "  ⚠️  Skipping unmatched URL: $url"
        exit 0
    fi

    # Compute output path
    out_path="$outroot/$rel"
    out_dir=$(dirname "$out_path")
    mkdir -p "$out_dir"

    if [ -f "$out_path" ]; then
        echo "  ⏩ Skipping existing: $rel"
    else
        echo "  ↓ Downloading: $rel"
        curl -sSf -o "$out_path" "$url" || echo "  ⚠️ Failed to download: $url"
    fi
' _ {} "$BASE_URL" "$OUTPUT_DIR"

echo "✅ All downloads complete. Existing files left untouched."
