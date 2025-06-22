#!/bin/bash

# === CONFIGURATION ===
URL_LIST="fits_urls.txt"  # Text file with one URL per line
BASE_URL="https://desdr-server.ncsa.illinois.edu/despublic/dr2_tiles/"  # Common prefix
OUTPUT_DIR="/sdf/data/rubin/repo/main/DECam/communityProcessed/dr2_tiles"  # Destination base
NUM_PARALLEL=64

# === VALIDATION ===
if [[ ! -f "$URL_LIST" ]]; then
    echo "❌ URL list '$URL_LIST' not found."
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "⬇️  Starting parallel downloads with curl..."

export BASE_URL
export OUTPUT_DIR

cat "$URL_LIST" | xargs -n1 -P"$NUM_PARALLEL" -I{} bash -c '
    url="$1"
    base="$BASE_URL"
    outroot="$OUTPUT_DIR"

    # Compute relative path by stripping the BASE_URL
    if [[ "$url" == "$base"* ]]; then
        rel="${url#"$base"}"
    else
        echo "  ⚠️  Skipping unmatched URL: $url"
        exit 0
    fi

    out_path="$outroot/$rel"
    out_dir=$(dirname "$out_path")
    mkdir -p "$out_dir"

    if [[ -f "$out_path" ]]; then
        echo "  ⏩ Skipping existing: $rel"
    else
        echo "  ↓ Downloading: $rel"
        curl -sSf -o "$out_path" "$url" || echo "  ⚠️ Failed to download: $url"
    fi
' _ {}

echo "✅ All downloads complete. Existing files left untouched."
