#!/bin/bash

source "$EXEC_PATH/utils.sh"
SOURCE_FILE="$HOME/.jim.sources"
SOURCE_FOLDER="$HOME/.jim-modules"

if [ ! -d "$SOURCE_FOLDER" ]; then
  mkdir "$SOURCE_FOLDER"
fi

# Set @ as the delimiter
IFS='@'
# Read the split words into an array
# based on space delimiter
read -ra newarr <<< "$2"

MODULE="${newarr[0]}"
VERSION="${newarr[1]}"

cd "$SOURCE_FOLDER" || exit
if [ -d "$MODULE" ]; then
  rm -rf "$MODULE"
else
  _log "$MODULE is not installed" "$COLOR_RED"
  exit 1
fi
