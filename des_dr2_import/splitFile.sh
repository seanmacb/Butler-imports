#!/bin/bash

# === CONFIGURATION ===
INPUT_FILE="$1"   # Input: full path to .txt file with one full path per line
NUM_SPLITS=12     # Number of output files to create
OUT_PREFIX="split"  # Base name for output files

# === VALIDATION ===
if [[ -z "$INPUT_FILE" || ! -f "$INPUT_FILE" ]]; then
    echo "❌ Input file '$INPUT_FILE' not found or not specified."
    echo "Usage: $0 filepaths.txt"
    exit 1
fi

# === COMPUTE LINES PER FILE ===
total_lines=$(wc -l < "$INPUT_FILE")
lines_per_file=$(( (total_lines + NUM_SPLITS - 1) / NUM_SPLITS ))  # Round up

# === SPLIT ===
split -l "$lines_per_file" -d -a 2 "$INPUT_FILE" "$OUT_PREFIX"

# === RENAME TO .txt ===
for f in ${OUT_PREFIX}[0-9][0-9]; do
    mv "$f" "$f.txt"
done

# === FEEDBACK ===
echo "✅ Split complete: $total_lines lines split into $NUM_SPLITS files:"
ls -1 ${OUT_PREFIX}*.txt