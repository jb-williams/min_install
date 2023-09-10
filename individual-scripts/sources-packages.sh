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
    printf "%b%b%b%s%b%b %s %b%s%b%s\n" "${bold}" "${blink}" "${red}" "ERROR!!!" "${default}" "${green}" "Failed:" "${lightyellow}" "$*" "${green}" "!!!" | tee -a "$HOME"/install-package-sources-error.log
}

backup_sources() {
    printf "\n%b%b%s%b\n" "${default}" "${green}" "Backing up sources.list...." "${default}"
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak \
        || error_print "${FUNCNAME[idx]}" 
}

add_non_free() {
    printf "\n%b%b%s%b\n" "${default}" "${green}" "Adding Non-Free Repos..." "${default}"
    sudo sed -i 's/main non-free-firmware/main non-free-firmware contrib/g' /etc/apt/sources.list \
        || error_print "${FUNCNAME[idx]}" 
}

change_testing() {
    printf "\n%b%b%s%b\n" "${default}" "${green}" "Changing sources to Testing..." "${default}"
    sudo sed -i 's/bookworm/testing/g' /etc/apt/sources.list \
        || error_print "${FUNCNAME[idx]}" 
}

add_i386() {
    printf "\n%b%b%s%b\n" "${default}" "${green}" "Adding i386 architecture..." "${default}"
    sudo dpkg --add-architecture i386 \
        || error_print "${FUNCNAME[idx]}" 
}

update_apt() {
    printf "\n%b%b%s%b\n" "${default}" "${green}" "Updating Apt..." "${default}"
    sudo apt update -y \
        || error_print "${FUNCNAME[idx]}" 
}

recheck_updates_cleanup() {
    printf "\n%b%b%s%b\n" "${default}" "${green}" "Re-Checking for Upgrades and cleaning up..." "${default}" \
        && sudo apt update -y \
        && sudo apt upgrade -y \
        && sudo apt full-upgrade \
        && sudo apt-get autoremove --purge -y \
        && sudo apt clean -y \
        && sudo sh -c "rm -rf /tmp/*" \
        && sudo sh -c "rm -rf /var/tmp/*" \
        && sudo sh -c "rm -rf /root/.cache/thumbnails"
}

reset2green
backup_sources || error_print "backup_sources"
reset2green
#add_non_free || error_print "add_non_free"
#reset2green
change_testing || error_print "change_testing"
reset2green
add_i386 || error_print "add_i386"
reset2green
update_apt || error_print "update_apt"
reset2green
#recheck_updates_cleanup || error_print "recheck_updates_cleanup"

