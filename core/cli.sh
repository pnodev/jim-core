#!/bin/bash

source "$EXEC_PATH/utils.sh"

if [ -e "./.jimrc" ]; then
  source ./.jimrc
fi

COMMAND=$1

# The shortlist command gets called implicitly when invoking autocompletion
# We need to return a space-separated list of available commands
if [ "$COMMAND" == "shortlist" ]; then
  taskList=""
  # Fist, check internal modules
  for file in "$EXEC_PATH"/modules/*.sh
  do
    if [ "$taskList" == "" ]
    then
      taskList="$(basename "$file" ".sh")"
    else
      taskList="$taskList $(basename "$file" ".sh")"
    fi
  done

  # If there are user-defined modules, check them as well
  if [ -v DIR_JIM_SCRIPTS ]; then
    for file in "$DIR_JIM_SCRIPTS"/*.sh
    do
      if [ "$taskList" == "" ]
      then
        taskList="$(basename "$file" ".sh")"
      else
        taskList="$taskList $(basename "$file" ".sh")"
      fi
    done
  fi

  # print the complete taskList
  echo -e "${taskList}"

###############################
# Begin actual task execution #
###############################

# Check core shell scripts
elif [ -e "$EXEC_PATH/modules/$COMMAND.sh" ]; then
  t1=$(date +%s%3N)
  DIR_JIM_SCRIPTS=$DIR_JIM_SCRIPTS DIR_CORE=$EXEC_PATH "$EXEC_PATH/modules/$COMMAND.sh" "$@"
  t2=$(date +%s%3N)
  _reportExecutionTime $((t2-t1))
# check user defined shell scripts
elif [ -v DIR_JIM_SCRIPTS ] && [ -e "$DIR_JIM_SCRIPTS/$COMMAND.sh" ]; then
  shift
  t1=$(date +%s%3N)
  # shellcheck disable=SC2098
  # shellcheck disable=SC2097
  DIR_JIM_SCRIPTS=$DIR_JIM_SCRIPTS DIR_CORE=$EXEC_PATH "$DIR_JIM_SCRIPTS/$COMMAND.sh" "$@"
  t2=$(date +%s%3N)
  _reportExecutionTime $((t2-t1))
# If there is no command specified, execute the info task
elif [ "$COMMAND" == "" ]; then
  DIR_JIM_SCRIPTS=$DIR_JIM_SCRIPTS DIR_CORE=$EXEC_PATH "$EXEC_PATH/modules/info.sh" "$@"
else
  _log "Command '$COMMAND' not found" "$COLOR_RED"
fi
