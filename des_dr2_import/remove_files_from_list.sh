#!/bin/bash

# === CONFIGURATION ===
LIST_FILE="$1"

# === CHECK INPUT ===
if [[ ! -f "$LIST_FILE" ]]; then
    echo "❌ Error: File list '$LIST_FILE' not found."
    echo "Usage: $0 path/to/list.txt"
    exit 1
fi

echo "🗑️  Starting file removal from: $LIST_FILE"
# === PROCESS FILE LIST ===
while IFS= read -r filepath; do
    if [[ -z "$filepath" ]]; then
    	continue  # skip empty lines
    fi
    if [[ -f "$filepath" ]]; then
    	rm "$filepath" && echo "✅ Removed: $filepath" || echo "⚠️ Failed to remove: $filepath"
	else
    	echo "❌ File not found: $filepath"
	fi
done < "$LIST_FILE"
echo "✅ Done."
