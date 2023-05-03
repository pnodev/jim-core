#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "${SCRIPT_DIR}/colors.sh"

function _log() {
  FORMAT_START=
  FORMAT_END=
  if [ -v 2 ]; then
    FORMAT_START=$2
    FORMAT_END=$COLOR_RESET
  fi
  echo -e "$COLOR_DIMMED[jim]$COLOR_RESET $FORMAT_START$1$FORMAT_END"
}