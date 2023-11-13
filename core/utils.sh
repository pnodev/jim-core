#!/bin/bash

if [ -e "./.jimrc" ]; then
  source ./.jimrc
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "${SCRIPT_DIR}/colors.sh"

function _log() {
  FORMAT_START=
  FORMAT_END=
  if [ -v 2 ]; then
    FORMAT_START=$2
    FORMAT_END=$COLOR_RESET
  fi
  echo -e "${COLOR_DIMMED}[jim]${COLOR_RESET} ${FORMAT_START}${1}${FORMAT_END}"
}

function _ask() {
  read -p "${COLOR_DIMMED}[jim]${COLOR_RESET} ${COLOR_CYAN}${1}${COLOR_RESET} ${COLOR_YELLOW}[y/n]${COLOR_RESET}" -n 1 -r
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    return 0
  else
    return 1
  fi
}

function setNodeVersion() {
  # abort if node version has already been set in current session or no NODE_VERSION has been set at all
  if [ "$JIM_NODE_VERSION_HAS_BEEN_SET" = true ] || [ ! -v NODE_VERSION ]; then
    return
  fi

  NVM_PATH=~/.nvm/nvm.sh
  if [[ -f "$NVM_PATH" ]]; then
    # shellcheck disable=SC1090
    source "$NVM_PATH"
    nvm use --delete-prefix "${NODE_VERSION}" >/dev/null
    _log "Using node $(node -v)" "$COLOR_YELLOW"
    export JIM_NODE_VERSION_HAS_BEEN_SET=true
  else
    echo ""
    _log " ⚠️  It looks like the nvm command is not installed on your system." "$COLOR_RED"
    _log " ⚠️  Setting the node version automatically depends on this command." "$COLOR_RED"
    _log " ⚠️  Please visit https://github.com/nvm-sh/nvm to find out how to install it on your system." "$COLOR_RED"
    echo ""
  fi
}
