#!/bin/bash

REMOTE_HOST="des91.fnal.gov"
REMOTE_PATH="/data/delve01.b/data/delve/edr3/gold/v1.0/catalog"
LOCAL_OUT="/shares/soares-santos.physik.uzh/catalogs/DELVE_DR3"
REMOTE_USER="macbride"

mkdir -p "$LOCAL_OUT"

echo "⬇️ Mirroring DELVE archive..."
echo "Remote path: $REMOTE_HOST:$REMOTE_PATH"
echo "Remote user: $REMOTE_USER"
echo "Local path: $LOCAL_OUT"

rsync -avL --partial --inplace --whole-file --no-compress --progress \
    -e "ssh -F /dev/null -K -v" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH/" \
    "$LOCAL_OUT"
