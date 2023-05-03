#!/bin/bash

source "$EXEC_PATH/utils.sh"

if [ -e "./.jimrc" ]; then
  source ./.jimrc
fi

function setNodeVersion() {
  # abort if no NODE_VERSION has been set
  if [ ! -v NODE_VERSION ]; then
    return
  fi

  NVM_PATH=~/.nvm/nvm.sh
  if [[ -f "$NVM_PATH" ]]; then
    source "$NVM_PATH"
    nvm use --delete-prefix "${NODE_VERSION}" >/dev/null
    _log "Using node $(node -v)" $COLOR_YELLOW
  else
    echo ""
    _log " ⚠️  It looks like the nvm command is not installed on your system." $COLOR_RED
    _log " ⚠️  Setting the node version automatically depends on this command." $COLOR_RED
    _log " ⚠️  Please visit https://github.com/nvm-sh/nvm to find out how to install it on your system." $COLOR_RED
    echo ""
  fi
}

COMMAND=$1

if [ "$COMMAND" == "shortlist" ]; then
	taskList=""
	echo -e "${taskList}" $(ls $EXEC_PATH/modules/ | grep '.sh\|.js'$ | cut -f 1 -d .)
	if [ -v DIR_JIM_SCRIPTS ]; then
		echo -e "${taskList}" $(ls $DIR_JIM_SCRIPTS | grep '.sh\|.js'$ | cut -f 1 -d .)
	fi
  echo -e "${taskList}"
# Check core shell scripts
elif [ -e "$EXEC_PATH/modules/$COMMAND.sh" ]; then
  DIR_JIM_SCRIPTS=$DIR_JIM_SCRIPTS DIR_CORE=$EXEC_PATH "$EXEC_PATH/modules/$COMMAND.sh" "$@"
# check user defined shell scripts
elif [ -v DIR_JIM_SCRIPTS ] && [ -e "$DIR_JIM_SCRIPTS/$COMMAND.sh" ]; then
	shift
	# shellcheck disable=SC2098
	# shellcheck disable=SC2097
	DIR_JIM_SCRIPTS=$DIR_JIM_SCRIPTS DIR_CORE=$EXEC_PATH "$DIR_JIM_SCRIPTS/$COMMAND.sh" "$@"
# check core node scripts
elif [ -e "$EXEC_PATH/modules/$COMMAND.js" ]; then
	setNodeVersion
	shift
	node "$EXEC_PATH/modules/$COMMAND.js" "$@"
# check user defined node scripts
elif [ -v DIR_JIM_SCRIPTS ] && [ -e "$DIR_JIM_SCRIPTS/$COMMAND.js" ]; then
  setNodeVersion
  shift
  node "$DIR_JIM_SCRIPTS/$COMMAND.js" "$@"
else
	_log "Command '$COMMAND' not found" $COLOR_RED
fi