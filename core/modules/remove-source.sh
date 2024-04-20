#!/bin/bash

source "$EXEC_PATH/utils.sh"
SOURCE_FILE="$HOME/.jim.sources"

_announceTaskStart "Removing $2 from sources"

if [ ! "$2" ]; then
  _log "Please provide a URL for the source" "${COLOR_RED}"
  exit 1
fi

if [ ! -e "$SOURCE_FILE" ]; then
  _log "No sources found" "$COLOR_RED"
fi

if ! find . | grep -q "$2" "$SOURCE_FILE"
then
  _announceTaskEnd "$2 is currently not in the source file"
  exit 0
fi

sed -i "/$2/d" "$SOURCE_FILE"
_announceTaskEnd "$2 has been removed"
