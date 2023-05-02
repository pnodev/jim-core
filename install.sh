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

if [ -z "$(command -v jim)" ] >/dev/null; then
  echo -e "${COLOR_BOLD}${COLOR_YELLOW}Installing jim… $COLOR_RESET"
  echo ""
  echo -e "${COLOR_CYAN}You need to grant permission in order to install the jim command${COLOR_RESET}"
  echo ""
  if [ ! -e /usr/local/bin ]; then
    sudo mkdir -p /usr/local/bin
  fi

  sudo cp "${SCRIPT_DIR}/core/assets/jim" /usr/local/bin
  echo -e "${COLOR_YELLOW} ✓ jim executable installed${COLOR_RESET}️"

  if [ -e /etc/bash_completion.d ]; then
    # linux autocompletion path
    sudo cp "${SCRIPT_DIR}/core/assets/autocompletion.sh" /etc/bash_completion.d/jim
    autocompletePath="/etc/bash_completion.d/jim"
    echo -e "${COLOR_YELLOW} ✓ autocompletion installed${COLOR_RESET}️"
  elif [ -e /usr/local/etc/bash_completion.d ]; then
    # osx autocompletion path; if bash completion is installed
    sudo cp "${SCRIPT_DIR}/core/assets/autocompletion.sh" /usr/local/etc/bash_completion.d/jim
    autocompletePath="/usr/local/etc/bash_completion.d/jim"
    echo -e "${COLOR_YELLOW} ✓ autocompletion installed${COLOR_RESET}️"
  fi

  echo ""

  if [[ $SHELL == *"zsh"* && "$1" != "--local" ]]; then
  	echo -e "${COLOR_CYAN}Hey, seems like you are using zsh.${COLOR_RESET}"
  	echo -e "${COLOR_CYAN}Put these lines in your .zshrc-file to enable autocompletion:${COLOR_RESET}"

  	echo -e "\n\tautoload bashcompinit"
  	echo -e "\tbashcompinit"
  	echo -e "\tsource $autocompletePath\n"
  fi

  echo -e "${COLOR_CYAN}Installation finished. You can now start using the 'jim' command.${COLOR_RESET}"
else
  echo -e "${COLOR_CYAN}jim is already installed${COLOR_RESET}"
fi