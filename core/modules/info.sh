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

COMMANDS_CORE=$(ls $SCRIPT_DIR/ | grep '.sh\|.js'$ | cut -f 1 -d .)
COMMANDS_USER=$(ls $DIR_JIM_SCRIPTS | grep '.sh\|.js'$ | cut -f 1 -d .)

echo ""

echo -e " Core commands:"

for COMMAND in $COMMANDS_CORE
do
  echo -e "${COLOR_CYAN}  - ${COMMAND}${COLOR_RESET}"
done

echo ""
echo -e " User installed commands:"

for COMMAND in $COMMANDS_USER
do
  echo -e "${COLOR_CYAN}  - ${COMMAND}${COLOR_RESET}"
done
echo ""

echo " Used node version:"
if [ ! -v NODE_VERSION ]; then
  echo -e "${COLOR_CYAN}  - Not specified${COLOR_RESET}"
else
  echo -e "${COLOR_CYAN}  - ${NODE_VERSION}${COLOR_RESET}"
fi

echo ""
