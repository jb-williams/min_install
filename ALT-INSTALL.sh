#!/usr/bin/env bash
#########################################################
########## xFafnirOS debian test install script #########
#########################################################
#!!!!!!!!!!!!!!!!!!! USE AT OWN RISK !!!!!!!!!!!!!!!!!!!#
## !! This is a test install script for Debian !!
# Updated: Mon Mar 13 12:38:39 PM CDT 2023
# !!!!!!! ASSUMES gits are held in ~/Gits !!!!!!
# Easily changed in the function cloning_git below
bold='\e[1m'
red='\e[31m'
lightyellow='\e[93m'
blink='\e[5m'
default='\e[0;39m'
green='\e[32m'

reset2green() {
    printf "%b%b" "\e[0;39m" "\e[32m"
}

error_print() {
    printf "%b%b%b%s%b%b %s %b%s%b%s\n" "${bold}" "${blink}" "${red}" "ERROR!!!" "${default}" "${green}" "Failed:" "${lightyellow}" "$*" "${green}" "!!!" | tee -a "$HOME"/install-script-error.log
}

cloning_git() {
    printf "%b%s%b\n" "${default}${green}" "Cloning repo into ~/Gits/min_install....." "${default}"
    if [[ ! -d "$HOME"/Gits ]]; then
        mkdir -p "$HOME"/Gits; cd "$_" || error_print "Error Making/Moving to Gits Dir"
        git clone https://github.com/jb-williams/min_install.git || error_print "Error Cloning Repo Dir"
        cd min_install || error_print "Moving to Repo Dir"
	elif [[ -d "$HOME"/Gits ]] && [[ ! -d "$HOME"/Gits/min_install ]]; then
        git clone https://github.com/jb-williams/min_install.git || error_print "Error Cloning Repo Dir"
        cd min_install || error_print "Error Moving to Repo Dir"
	elif [[ -d "$HOME"/Gits ]] && [[ -d "$HOME"/Gits/min_install ]]; then
		printf "It seems like you already cloned this repo.\nTo avoid a greater chance of errors, go to 'individual-scripts' and run they one(s) that didn't work"
	else
		error_print "Unknown error in cloning_git func!!"
    fi
}

10-sources-packages.sh
15-setup-umask.sh
20-min-package.sh
30-base-package.sh
40-gui-package.sh
install-brave.sh
install-golang.sh
install-rust.sh
setup-fail2ban.sh
setup-flatpak.sh
setup-user-dots.sh
sources-packages.sh
ssh_setup.sh
