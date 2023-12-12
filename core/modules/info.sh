#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if [ -e "./.jimrc" ]; then
  source ./.jimrc
fi
source "${SCRIPT_DIR}/../colors.sh"

echo ""
echo -e "$COLOR_BOLD$COLOR_BLUE   __        __.__           $COLOR_RESET"
echo -e "$COLOR_BOLD$COLOR_BLUE   \ \      |__|__| _____    $COLOR_RESET"
echo -e "$COLOR_BOLD$COLOR_BLUE    \ \     |  |  |/     \   $COLOR_RESET"
echo -e "$COLOR_BOLD$COLOR_BLUE    / /     |  |  |  Y Y  \  $COLOR_RESET"
echo -e "$COLOR_BOLD$COLOR_BLUE   /_/  /\__|  |__|__|_|  /  $COLOR_RESET"
echo -e "$COLOR_BOLD$COLOR_BLUE        \______|        \/   $COLOR_RESET"
echo ""

echo -e " Installed Version: ${COLOR_CYAN}$(sed -n 's/.*"version": *"\([^"]*\)".*/\1/p' "${SCRIPT_DIR}"/../../package.json)${COLOR_RESET}"

COMMANDS_CORE=""
for file in "$EXEC_PATH"/modules/*.sh
do
  if [ "$COMMANDS_CORE" == "" ]
  then
    COMMANDS_CORE="$(basename "$file" ".sh")"
  else
    COMMANDS_CORE="$COMMANDS_CORE $(basename "$file" ".sh")"
  fi
done

COMMANDS_USER=""
if [ "$DIR_JIM_SCRIPTS" != "" ] && [ -d "$DIR_JIM_SCRIPTS" ]
then
  for file in "$DIR_JIM_SCRIPTS"/*.sh
  do
    if [ "$COMMANDS_USER" == "" ]
    then
      COMMANDS_USER="$(basename "$file" ".sh")"
    else
      COMMANDS_USER="$COMMANDS_USER $(basename "$file" ".sh")"
    fi
  done
fi

echo ""

echo -e " Core commands:"

for COMMAND in $COMMANDS_CORE
do
  echo -e "${COLOR_CYAN}  - ${COMMAND}${COLOR_RESET}"
done

if [ "$DIR_JIM_SCRIPTS" != "" ] && [ -d "$DIR_JIM_SCRIPTS" ]
then
  echo ""
  echo -e " User installed commands:"

  for COMMAND in $COMMANDS_USER
  do
    echo -e "${COLOR_CYAN}  - ${COMMAND}${COLOR_RESET}"
  done
  echo ""
fi

echo " Used node version:"
if [ ! -v NODE_VERSION ]; then
  echo -e "${COLOR_CYAN}  - Not specified${COLOR_RESET}"
else
  echo -e "${COLOR_CYAN}  - ${NODE_VERSION}${COLOR_RESET}"
fi

echo ""
