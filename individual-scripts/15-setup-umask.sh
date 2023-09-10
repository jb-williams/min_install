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
    printf "%b%b%b%s%b%b %s %b%s%b%s\n" "${bold}" "${blink}" "${red}" "ERROR!!!" "${default}" "${green}" "Failed:" "${lightyellow}" "$*" "${green}" "!!!" | tee -a "$HOME"/install-hardening-error.log
}

change_umask() { printf "\n%b%b%s%b\n" "${default}" "${green}" "Setting Umask...." "${default}"
    sudo sed -i 's/022/027/g' /etc/login.defs 2>/dev/null \
        || error_print "${FUNCNAME[idx]}" 
}


reset2green
change_umask \
	|| error_print "change_umask"
reset2green

