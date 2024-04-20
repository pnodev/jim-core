#!/bin/bash

source "$EXEC_PATH/utils.sh"
SOURCE_FILE="$HOME/.jim.sources"

_announceTaskStart "Adding $2 as new source"

if [ ! "$2" ]; then
  _log "Please provide a URL for the new source" "${COLOR_RED}"
  exit 1
fi

if [ ! -e "$SOURCE_FILE" ]; then
  touch "$SOURCE_FILE"
fi

if find . | grep -q "$2" "$SOURCE_FILE"
then
  _announceTaskEnd "$2 has already been added"
  exit 0
fi

echo "$2" >> "$SOURCE_FILE"
_announceTaskEnd "$2 has been added"
