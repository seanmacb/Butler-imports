#!/bin/bash

# Usage: ./search_fits_with_prefix.sh input_paths.txt output.txt prefix
# Example: ./search_fits_with_prefix.sh paths.txt fits_list.txt "file:///data/observations/"

INPUT_FILE="$1"
OUTPUT_FILE="$2"
PREFIX="$3"

if [[ ! -f "$INPUT_FILE" ]]; then
    echo "❌ Input file not found: $INPUT_FILE"
    exit 1
fi

if [[ -z "$PREFIX" ]]; then
    echo "❌ Prefix string is missing."
    exit 1
fi

> "$OUTPUT_FILE"
echo "🔍 Searching using prefix: $PREFIX"
echo ""

while IFS= read -r relative_path || [[ -n "$relative_path" ]]; do
    relative_path=$(echo "$relative_path" | xargs)  # trim whitespace
    [[ -z "$relative_path" ]] && continue

    search_root="${PREFIX}${relative_path}"
    local_root="${relative_path}"

    echo "➡️  Looking inside: $search_root"

    if [[ -d "$search_root" ]]; then
        find "$search_root" -type f \( -iname "*.fits" -o -iname "*.fits.fz" \) | while read -r match; do
            full_path=$(realpath "$match")
            echo "${PREFIX}${full_path}" >> "$OUTPUT_FILE"
            echo "   ✅ Found: ${PREFIX}${full_path}"
        done
    elif [[ -f "$search_root" ]]; then
        if [[ "$search_root" =~ \.fits$ || "$search_root" =~ \.fits\.fz$ ]]; then
            full_path=$(realpath "$local_root")
            echo "${PREFIX}${full_path}" >> "$OUTPUT_FILE"
            echo "   ✅ Found file: ${PREFIX}${full_path}"
        else
            echo "   ⏭️  Not a FITS file: $local_root"
        fi
    else
        echo "   ⚠️  Local path does not exist: $local_root"
    fi

    echo ""
done < "$INPUT_FILE"

echo "✅ Done. Output written to $OUTPUT_FILE"
