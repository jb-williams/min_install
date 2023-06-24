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
    printf "%b%b%b%s%b%b %s %b%s%b%s\n" "${bold}" "${blink}" "${red}" "ERROR!!!" "${default}" "${green}" "Failed:" "${lightyellow}" "$*" "${green}" "!!!" | tee -a "$HOME"/install_error.log
}

install_GUI() {
    printf "\n%b%b%s%b\n" "${default}" "${green}" "Installing Base Packages..." "${default}" \
        && sudo apt install \
        tango-icon-theme \
        gnome-themes-extra \
        dzen2 \
        sxiv \
        i965-va-driver-shaders \
        intel-media-va-driver-non-free \
        firmware-amd-graphics \
        r8168-dkms \
        cwm -y
}

reset2green
install_GUI \
	error_print "install_GUI"
