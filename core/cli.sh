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

  if [ -d "${HOME}/.jim-modules" ]; then
    for folder in ${HOME}/.jim-modules/*
      do
        if [ "$taskList" == "" ]
        then
          taskList="$(basename "$folder" "/jim.sh")"
        else
          taskList="$taskList $(basename "${folder//jim-module-/}")"
        fi
      done
  fi

  # print the complete taskList
  echo -e "${taskList}"

###############################
# Begin actual task execution #
###############################

# To determine which file to execute for a given task name, we are doing an
# algorithmic lookup that stops as soon as it has found a valid candidate
# to execute:
#
#  1. Check core scripts
#     We want the core-commands that get shipped with to always work,
#     so they have to be the first thing we check.
#
#  2. Check user script
#     If there are user scripts defined, they should have 2nd priority.
#     That way it will be possible to override module commands on a
#     project-level.
#
#  3. Check module scripts
#     Lastly, check if there are jim modules installed that provide the
#     desired task.

# Check core shell scripts
elif [ -e "$EXEC_PATH/modules/$COMMAND.sh" ]; then
  t1=$(date +%s%3N)
  DIR_JIM_SCRIPTS=$DIR_JIM_SCRIPTS DIR_CORE=$EXEC_PATH "$EXEC_PATH/modules/$COMMAND.sh" "$@"
  t2=$(date +%s%3N)
  _reportExecutionTime $((t2-t1))
# check jim modules
elif [ -e "$HOME/.jim-modules/jim-module-$COMMAND/jim.sh" ]; then
  shift
  t1=$(date +%s%3N)
  # shellcheck disable=SC2098
  # shellcheck disable=SC2097
  DIR_JIM_SCRIPTS=$DIR_JIM_SCRIPTS DIR_CORE=$EXEC_PATH "$HOME/.jim-modules/jim-module-$COMMAND/jim.sh" "$@"
  t2=$(date +%s%3N)
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
