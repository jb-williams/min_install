#!/usr/bin/env bash
bold='\e[1m'
red='\e[31m'
lightyellow='\e[93m'
blink='\e[5m'
default='\e[0;39m'
green='\e[32m'
error_print() {
    printf "%b%b%b%s%b%b %s %b%s%b%s\n" "${bold}" "${blink}" "${red}" "ERROR!!!" "${default}" "${green}" "Failed:" "${lightyellow}" "$*" "${green}" "!!!" | tee -a "$HOME"/install-hardening-error.log
}

setup_fail2ban() {
    printf "\n%b%b%s%b\n" "${default}" "${green}" "Configuring Fail2ban..." "${default}"
    sudo cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local \
        || error_print "${FUNCNAME[idx]}" 
    sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local \
        || error_print "${FUNCNAME[idx]}" 
    sudo sed -i 's/#ignoreip = 127.0.0.1/8 ::1/ignoreip = 127.0.0.1/8 ::1/g' /etc/fail2ban/jail.local \
        || error_print "${FUNCNAME[idx]}" 
    sudo sed -i 's/findtime = 10m/findtime = 15m/g' /etc/fail2ban/jail.local \
        || error_print "${FUNCNAME[idx]}" 
    sudo sed -i 's/maxretry = 5/maxretry = 3/g' /etc/fail2ban/jail.local \
        || error_print "${FUNCNAME[idx]}" 
}

setup_fail2ban
