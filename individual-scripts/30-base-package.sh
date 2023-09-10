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
    printf "%b%b%b%s%b%b %s %b%s%b%s\n" "${bold}" "${blink}" "${red}" "ERROR!!!" "${default}" "${green}" "Failed:" "${lightyellow}" "$*" "${green}" "!!!" | tee -a "$HOME"/install-base-package-error.log
}

install_base_packages() {
    printf "\n%b%b%s%b\n" "${default}" "${green}" "Installing Base Packages..." "${default}" \
        && sudo apt install \
        feh \
		ffmpeg \
        libx11-dev \
        libxcb1-dev \
        libxft-dev \
        libharfbuzz-dev \
        libfontconfig1-dev \
        libxrandr-dev \
        libxinerama-dev \
        bsdgames \
        bsdgames-nonfree \
		taskwarrior \
		python3 \
		python3-neovim \
		python3-pynvim \
		python3-tasklib \
        mpd \
        mpc \
        sox \
        libsox-fmt-mp3 \
        cmus -y
        #udiskie \
        #gir1.2-gtk-2.0 \
        #gir1.2-gtk-3.0 \
}

reset2green
install_base_packages \
	|| error_print "install_base_packages"
