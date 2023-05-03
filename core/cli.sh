#!/bin/bash

source "$EXEC_PATH/utils.sh"

if [ -e "./.jimrc" ]; then
  source ./.jimrc
fi

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
elif [ "$COMMAND" == "" ]; then
  DIR_JIM_SCRIPTS=$DIR_JIM_SCRIPTS DIR_CORE=$EXEC_PATH "$EXEC_PATH/modules/info.sh" "$@"
else
	_log "Command '$COMMAND' not found" $COLOR_RED
fi