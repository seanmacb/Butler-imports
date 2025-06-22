#!/bin/bash

# Input file (change this to your actual file name)
INPUT_FILE="fullPathList.txt"
# Temporary output file
TEMP_FILE="fullPathList_fz.txt"

# Append .fz to every line and write to temp file
while IFS= read -r line; do
    echo "${line}.fz"
done < "$INPUT_FILE" > "$TEMP_FILE"