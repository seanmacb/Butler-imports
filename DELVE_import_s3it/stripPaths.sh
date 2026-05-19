#!/bin/bash

# === CONFIGURATION ===
INPUT_CSV="$1"
OUTPUT_FILE="$2"

if [[ ! -f "$INPUT_CSV" ]]; then
    echo "❌ Input CSV file '$INPUT_CSV' not found."
    echo "Usage: $0 input.csv output.txt"
    exit 1
fi

> "$OUTPUT_FILE"  # Clear output file

# === PROCESSING ===
while IFS=, read -r col1 col2 rest; do
    # Strip first 33 characters from second field
    stripped="${col1:33}"
    echo "$stripped" >> "$OUTPUT_FILE"
done < "$INPUT_CSV"

echo "✅ Done. Stripped values saved to: $OUTPUT_FILE"
