#!/bin/bash

source ./core/colors.sh
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo ""
echo -e "$COLOR_BOLD$COLOR_BLUE   __        __.__           $COLOR_RESET"
echo -e "$COLOR_BOLD$COLOR_BLUE   \ \      |__|__| _____    $COLOR_RESET"
echo -e "$COLOR_BOLD$COLOR_BLUE    \ \     |  |  |/     \   $COLOR_RESET"
echo -e "$COLOR_BOLD$COLOR_BLUE    / /     |  |  |  Y Y  \  $COLOR_RESET"
echo -e "$COLOR_BOLD$COLOR_BLUE   /_/  /\__|  |__|__|_|  /  $COLOR_RESET"
echo -e "$COLOR_BOLD$COLOR_BLUE        \______|        \/   $COLOR_RESET"
echo ""

if [ ! -z "$(command -v jim)" ] >/dev/null; then
  echo -e "${COLOR_BOLD}${COLOR_YELLOW}Removing jim… $COLOR_RESET"
  echo ""
  echo -e "${COLOR_CYAN}You need to grant permission in order to remove the jim command${COLOR_RESET}"
  echo ""

  sudo rm /usr/local/bin/jim
  echo -e "${COLOR_YELLOW} ✓ jim executable removed${COLOR_RESET}️"

  if [ -e /etc/bash_completion.d ]; then
    # linux autocompletion path
    sudo rm /etc/bash_completion.d/jim
    echo -e "${COLOR_YELLOW} ✓ autocompletion removed${COLOR_RESET}️"
  elif [ -e /usr/local/etc/bash_completion.d ]; then
    # osx autocompletion path; if bash completion is installed
    sudo rm /usr/local/etc/bash_completion.d/jim
    echo -e "${COLOR_YELLOW} ✓ autocompletion removed${COLOR_RESET}️"
  fi

  echo ""

  if [[ $SHELL == *"zsh"* && "$1" != "--local" ]]; then
  	echo -e "${COLOR_CYAN}Hey, seems like you are using zsh.${COLOR_RESET}"
  	echo -e "${COLOR_CYAN}Put these lines in your .zshrc-file to enable autocompletion:${COLOR_RESET}"

  	echo -e "\n\tautoload bashcompinit"
  	echo -e "\tbashcompinit"
  	echo -e "\tsource $autocompletePath\n"
  fi

  echo -e "${COLOR_CYAN}The 'jim' command has been removed.${COLOR_RESET}"
else
  echo -e "${COLOR_CYAN}jim is not installed${COLOR_RESET}"
fi