#!/bin/bash

BASE_URL="https://desdr-server.ncsa.illinois.edu/despublic/dr2_tiles"
OUTPUT_DIR="/sdf/data/rubin/repo/main/DECam/communityProcessed/DES_DR2"

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

# Step 1: Get all tile directories
echo "📂 Fetching directory list from $BASE_URL..."
curl -s "$BASE_URL/" | grep -oP 'href="\K[^"/]+(?=/")' | sort -u > tile_dirs.txt

# Step 2: Loop over each tile directory and collect .fits/.fits.fz links
echo "🔎 Collecting .fits and .fits.fz file URLs..."
> fits_urls.txt
while read tile; do
    TILE_URL="$BASE_URL/$tile/"
    echo "  → Scanning $tile..."
    curl -s "$TILE_URL" | grep -Eo "href=\"[^\"]+\.(fits|fits\.fz)\"" | \
        sed -E 's/^href="([^"]+)"/\1/' | \
        awk -v prefix="$TILE_URL" '{print prefix $0}' >> fits_urls.txt
done < tile_dirs.txt

# Step 3: Download files if not already present
echo "⬇️  Starting file downloads (only new files)..."
while read url; do
    rel_path="${url#"$BASE_URL/"}"
    out_path="$OUTPUT_DIR/$rel_path"
    out_dir=$(dirname "$out_path")
    mkdir -p "$out_dir"

    if [ -f "$out_path" ]; then
        echo "  ⏩ Skipping existing: $rel_path"
    else
        echo "  ↓ Downloading: $rel_path"
        curl -s -o "$out_path" "$url"
    fi
done < fits_urls.txt

echo "✅ All new files downloaded. Existing files left untouched."
