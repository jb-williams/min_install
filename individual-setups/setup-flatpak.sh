#!/usr/bin/env bash
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
    printf "%b%b%b%s%b%b %s %b%s%b%s\n" "${bold}" "${blink}" "${red}" "ERROR!!!" "${default}" "${green}" "Failed:" "${lightyellow}" "$*" "${green}" "!!!" | tee -a "$HOME"/install-flatpak-error.log
}

reset2green
read -p "Would you like to install flatpak?(Y/n): " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	sudo apt install flatpak gnome-software-plugin-flatpak || error_print "failed apt install" 
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || error_print "failed flatpak repo add" 
	printf "%s!\n" "A list of possible flatpaks to install and used are in flatpaks.md"
fi

