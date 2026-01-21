#!/bin/bash

REMOTE_HOST="des90.fnal.gov"
REMOTE_PATH="/data/delve01.b/data/delve/edr3/gold/v1.0/catalog"
OUT_FILE=".delve_file_paths"
REMOTE_USER="macbride"

ssh -K $REMOTE_USER@$REMOTE_HOST "find $REMOTE_PATH" > $OUT_FILE
