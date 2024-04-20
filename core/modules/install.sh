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
  INSTALLED_VERSION=$(grep -Po "(?<=VERSION=)[^=]+(?=)" < "$MODULE/jim.module")
  if [ "$INSTALLED_VERSION" != "$VERSION" ]; then
    if _ask "${MODULE} is already installed in version ${INSTALLED_VERSION}. Do you want to replace it?"
    then
      rm -rf "$MODULE"
    else
      exit 1
    fi
  else
    _log "$MODULE is already installed in version $VERSION"
    exit 0
  fi
fi
while IFS="" read -r p || [ -n "$p" ]
do
  git clone --depth 1 --branch "$VERSION" "${p}/${MODULE}.git" &> /dev/null
  # shellcheck disable=SC2181
  if [ $? -ne 0 ]; then
    _log "Skip $p"
    break
  fi
  if [ ! -e "$MODULE/jim.module" ]; then
    _log "$MODULE is not a valid jim module (missing module.jim file)" "$COLOR_RED"
    rm -rf "$MODULE"
    exit 1
  fi
done < "$SOURCE_FILE"
