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

setup_slock() {
    if which slock 2>/dev/null; then
        printf '%s "%s"\n\t%s\t"%s"\t"%s"\n\t%s\t"%s"\t"%s"\n%s\n' "Section" "ServerFlags" "Option" "DontVTSwitch" "True" "Option" "DontZap" "True" "EndSection" >> /etc/X11/xorg.conf || error_print "${FUNCNAME[idx]}" 
    elif ! which slock 2>/dev/null; then
        sudo apt install suckless-tools || error_print "${FUNCNAME[idx]}" 
        setup_slock || error_print "${FUNCNAME[idx]}" 
    else
        error_print "${FUNCNAME[idx]}" 
    fi
}

