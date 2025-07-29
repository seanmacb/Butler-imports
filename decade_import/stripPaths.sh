#!/bin/bash

# === CONFIGURATION ===
INPUT_FILE="stripped_paths.txt"       # File with full paths
OUTPUT_FILE="stripped_paths2.txt"  # Where to write modified paths

# === PROCESSING ===
> "$OUTPUT_FILE"  # Clear output file

while read -r line; do
    # Strip the first two directories
    stripped=$(echo "$line" | cut -d'/' -f3-)
    echo "$stripped" >> "$OUTPUT_FILE"
done < "$INPUT_FILE"

echo "✅ Done. Stripped paths saved to: $OUTPUT_FILE"
