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

install_golang() {
    VERSION="$(curl https://go.dev/dl/ | grep -iE '<span>go[0-9].[0-9]{2}.[0-9]{1,2}.linux-amd64.tar.gz' | sed -e 's/<[^>]*.//g' | tr -d ' ')"
    read -p "Curl read Current Go Version as \"$VERSION\" : Would you like to Continue?(Y/n): " -n 1 -r
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        pushd /tmp || error_print "${FUNCNAME[idx]}" 
        wget https://go.dev/dl/"$VERSION"
        tar xvfz "$VERSION"
        if [[ -d /usr/local/go ]]; then
            sudo sh -c "rm -rf /usr/local/go"
            sudo sh -c "mv go /usr/local/"
            rm "$VERSION"
        else 
            sudo sh -c "mv -i go /usr/local/"
        fi
        popd || error_print "${FUNCNAME[idx]}" 
    fi
}

reset2green
install_golang || error_print "install_golang"
