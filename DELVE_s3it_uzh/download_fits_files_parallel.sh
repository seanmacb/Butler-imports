#!/bin/bash
set -euo pipefail

REMOTE_HOST="des90.fnal.gov"
REMOTE_USER="macbride"

REMOTE_ROOT="/data/delve01.b/data/delve/edr3/gold/v1.0/catalog"
LOCAL_ROOT="/shares/soares-santos.physik.uzh/catalogs/DELVE_DR3"

FILE_LIST=".delve_file_paths"
NWORKERS=4   # start with 2–4

mkdir -p "$LOCAL_ROOT"

echo "⬇️ Parallel pull from FNAL"
echo "Remote root : $REMOTE_ROOT"
echo "Local root  : $LOCAL_ROOT"
echo "Workers     : $NWORKERS"
echo

export REMOTE_HOST REMOTE_USER REMOTE_ROOT LOCAL_ROOT

cat "$FILE_LIST" | shuf | xargs -n1 -P"$NWORKERS" -I{} bash -c '
    src="$1"
    rel="${src#$REMOTE_ROOT/}"
    dst="$LOCAL_ROOT/$rel"

    mkdir -p "$(dirname "$dst")"

    echo "→ $rel"
    rsync -aL --partial --inplace --whole-file --no-compress --progress \
      -e "ssh -F /dev/null -K" \
      "$REMOTE_USER@$REMOTE_HOST:$src" "$dst" \
      || echo "⚠️ FAILED: $src"
' _ {}
