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
    printf "%b%b%b%s%b%b %s %b%s%b%s\n" "${bold}" "${blink}" "${red}" "ERROR!!!" "${default}" "${green}" "Failed:" "${lightyellow}" "$*" "${green}" "!!!" | tee -a "$HOME"/install-min-package-error.log
}

install_minimal() {
    printf "\n%b%b%s%b\n" "${default}" "${green}" "Installing Minimal Packages..." "${default}" \
        && sudo apt install \
        apparmor-utils \
        apparmor apparmor-notify \
        apparmor-profiles \
        apparmor-profiles-extra \
        apt-listbugs apt-transport-https \
        auditd \
        chkrootkit \
        curl \
        debsecan \
        debsums \
        dialog \
        fail2ban \
        fzf \
        htop \
        iptables \
        rkhunter \
        strace \
        tmux \
        libpam-tmpdir \
        logrotate \
        lynis \
        needrestart \
        neovim \
        net-tools \
        nmap \
        pkg-config \
        vifm \
        wget \
        xclip \
        fonts-opendyslexic \
        neofetch \
        fortune \
        dkms \
        rfkill \
        pass \
        intel-microcode \
        iucode-tool \
        lynx \
        firmware-misc-nonfree \
        amd64-microcode \
        openssh-server \
        openssh-client \
        python3 \
        usbguard \
        usbguard-notifier \
        iptables-persistent -y
}

reset2green
install_minimal || error_print "install_minimal"
