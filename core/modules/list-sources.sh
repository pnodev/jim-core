#!/bin/bash

source "$EXEC_PATH/utils.sh"
SOURCE_FILE="$HOME/.jim.sources"

if [ ! -e "$SOURCE_FILE" ] || [ ! -s "$SOURCE_FILE" ]; then
  _log "No sources found" "$COLOR_RED"
  exit 1
fi

echo ""
_log "Sources in $SOURCE_FILE" "$COLOR_DIMMED$COLOR_CYAN"
echo ""
cat "$SOURCE_FILE"
echo ""
