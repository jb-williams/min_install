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

cloning_git() {
    printf "%b%s%b\n" "${default}${green}" "Cloning repo into ~/Gits/min_install....." "${default}"
    if [[ ! -d "$HOME/Gits" ]]; then
        mkdir -p "$HOME/Gits"; cd "$_" || error_print "Error Making/Moving to Git Dir" && exit 1
        git clone https://github.com/jb-williams/min_install.git
        cd "$_" || error_print "Error Cloning/Moving to Repo Dir" && exit 1
    else
        git clone https://github.com/jb-williams/min_install.git
        cd "$_" || error_print "Error Cloning/Moving to Repo Dir" && exit 1
    fi
    return
}

reset2green() {
    printf "%b%b" "\e[0;39m" "\e[32m"
}

error_print() {
    printf "%b%b%b%s%b%b %s %b%s%b%s\n" "${bold}" "${blink}" "${red}" "ERROR!!!" "${default}" "${green}" "Failed:" "${lightyellow}" "$*" "${green}" "!!!" | tee -a /root/install_error.log
}

change_umask() { printf "\n%b%b%s%b\n" "${default}" "${green}" "Setting Umask...." "${default}"
    sudo sed -i 's/022/027/g' /etc/login.defs 2>/dev/null \
        || error_print "${FUNCNAME[idx]}" 
}

backup_sources() {
    printf "\n%b%b%s%b\n" "${default}" "${green}" "Backing up sources.list...." "${default}"
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak \
        || error_print "${FUNCNAME[idx]}" 
}

add_non_free() {
    printf "\n%b%b%s%b\n" "${default}" "${green}" "Adding Non-Free Repos..." "${default}"
    sudo sed -i 's/main contrib/main contrib non-free/g' /etc/apt/sources.list \
        || error_print "${FUNCNAME[idx]}" 
}

change_testing() {
    printf "\n%b%b%s%b\n" "${default}" "${green}" "Changing sources to Testing..." "${default}"
    sudo sed -i 's/bullseye/testing/g' /etc/apt/sources.list \
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

setup_ssh_moduli() {
    printf "\n%b%b%s%b\n" "${default}" "${green}" "Setting up SSH moduli..." "${default}"
    sudo cp --archive /etc/ssh/moduli /etc/ssh/moduli-COPY-"$(date +'%Y%m%d%H%M%S')"
    sudo sed -i 's/^\#HostKey \/etc\/ssh\/ssh_host_\(rsa\|ed25519\)_key$/HostKey \/etc\/ssh\/ssh_host_\1_key/g' /etc/ssh/sshd_config \
        || error_print "${FUNCNAME[idx]}" 
    sudo awk '$5 >= 3071' /etc/ssh/moduli | sudo tee /etc/ssh/moduli.safe \
        || error_print "${FUNCNAME[idx]}" 
    sudo sh -c "mv -f /etc/ssh/moduli.safe /etc/ssh/moduli" \
        || error_print "${FUNCNAME[idx]}" 
}

setup_harden_ssh_conf() {
    printf "\n%b%b%s%b\n" "${default}" "${green}" "Hardening SSH..." "${default}"
    sudo echo -e "\n# Restrict key exchange, cipher, and MAC algorithms, as per sshaudit.com\n# hardening guide.\nKexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256\nCiphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\nMACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com\nHostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-512,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com" | sudo tee /etc/ssh/sshd_config.d/ssh-audit_hardening.conf \
        || error_print "${FUNCNAME[idx]}" 
}

setup_ssh_conf() {
    printf "\n%b%b%s%b\n" "${default}" "${green}" "Configuring SSH..." "${default}"
    sudo cp --archive /etc/sshd_config /etc/ssh/sshd_config-COPY-"$(date +'%Y%m%d%H%M%S')"
    sudo sed -i 's/#LogLevel INFO/LogLevel VERBOSE/g' /etc/ssh/sshd_config \
        || error_print "${FUNCNAME[idx]}" 
    sudo sed -i 's/#PermitRootLogin prohibit-passowrd/PermitRootLogin no/g' /etc/ssh/sshd_config \
        || error_print "${FUNCNAME[idx]}" 
    sudo sed -i 's/#MaxAuthTries 6/MaxAuthTries 3/g' /etc/ssh/sshd_config \
        || error_print "${FUNCNAME[idx]}" 
    sudo sed -i 's/#MaxSessions 10/MaxSessions 2/g' /etc/ssh/sshd_config \
        || error_print "${FUNCNAME[idx]}" 
    sudo sed -i 's/AllowAgentForwarding yes/AllowAgentForwarding no/g' /etc/ssh/sshd_config \
        || error_print "${FUNCNAME[idx]}" 
    sudo sed -i 's/#AllowTcpForwarding yes/AllowTcpForwarding no/g' /etc/ssh/sshd_config \
        || error_print "${FUNCNAME[idx]}" 
    sudo sed -i 's/X11Forwarding yes/X11Forwarding no/g' /etc/ssh/sshd_config \
        || error_print "${FUNCNAME[idx]}" 
}

restart_ssh() {
    printf "\n%b%b%s%b\n" "${default}" "${green}" "Restarting SSH..." "${default}"
    sudo systemctl restart sshd \
        || error_print "${FUNCNAME[idx]}" 
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

#setup_sendmail() {
#    printf "\n%b%b%s%b\n" "${default}" "${green}" "Configuring SendMail for Fail2ban..." "${default}"
    #sed -i 's/destmail = root@locahost/destmail = <mail>/g' /etc/fail2ban/jail.local 2>/dev/null \
#    sudo sed -i 's/destmail = root@locahost/destmail = <mail>/g' /etc/fail2ban/jail.local \
#        || error_print "${FUNCNAME[idx]}" 
    #sed -i 's/sender = root@<fq-hostname>/sender = <sendermail>/g' /etc/fail2ban/jail.local 2>/dev/null \
#    sudo sed -i 's/sender = root@<fq-hostname>/sender = <sendermail>/g' /etc/fail2ban/jail.local \
#        || error_print "${FUNCNAME[idx]}" 
#}

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

install_base_packages() {
    printf "\n%b%b%s%b\n" "${default}" "${green}" "Installing Base Packages..." "${default}" \
        && sudo apt install \
        keepassxc \
        udiskie \
        gir1.2-gtk-2.0 \
        feh \
        galculator \
        libx11-dev \
        libxcb1-dev \
        libxft-dev \
        libharfbuzz-dev \
        libfontconfig1-dev \
        libxrandr-dev \
        libxinerama-dev \
        bsdgames \
        bsdgames-nonfree \
        mpd \
        mpc \
        sox \
        libsox-fmt-mp3 \
        cmus -y
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

install_rust() {
    if ! which cargo &> /dev/null; then
        /usr/bin/curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        source "$HOME/.cargo/env" 2>/dev/null
        source "$HOME/.bashrc" 2>/dev/null
    else
        printf "Rust is Already Installed..."
    fi
    read -p "Would you like to install my basic rust programs?(Y/n): " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cargo install cargo-install-update bat exa fd-find ripgrep \
            || error_print "install_basic_rust"
    fi
    read -p "Would you like to install Alacritty terminal?(Requires certain packages)(Y/n): " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [[ ! -d "$HOME"/Gits ]];then
            mkdir -p "$HOME"/Gits
        fi
        pushd "$HOME/Gits" \
            && git clone https://github.com/alacritty/alacritty.git \
            && cd alacritty \
            && cargo build --release \
            && sudo cp target/release/alacritty /usr/local/bin/ \
            && sudo cp extra/logo/alacritty-term+scanlines.svg \
            && sudo desktop-file-install extra/linux/Alacritty.desktop \
            && sudo update-desktop-database \
            && sudo sh -c "mkdir -p /usr/local/share/man/man1" \
            && gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null \
            && gzip -c extra/alacritty-msg.man | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
        popd || error_print "${FUNCNAME[idx]}" 
    fi
    read -p "Would you like to install rust programs for pentest?(Y/n): " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cargo install feroxbuster rustscan \
            || error_print "install_pentest" 
    fi
}

install_VsCode() {
    if ! which code; then
    sudo apt install dirmngr ca-certificates software-properties-common apt-transport-https curl -y \
        && curl -fSsL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor | sudo tee /usr/share/keyrings/vscode.gpg \
        && sudo echo deb [arch=amd64 signed-by=/usr/share/keyrings/vscode.gpg] https://packages.microsoft.com/repos/vscode stable main | sudo tee /etc/apt/sources.list.d/vscode.list \
        && sudo apt update -y && sudo apt install code -y
    else 
        printf "%b%s%b\n" "${green}" "VsCode Already Installed" "${default}"
    fi
}

install_Steam() {
    if ! which steam; then
        sudo apt update -y && sudo apt upgrade -y \
            && sudo apt install software-properties-common apt-transport-https dirmngr ca-certificates gnupg2 curl -y \
            && sudo dpkg --add-architecture i386 \
            && curl -fsSL http://repo.steampowered.com/steam/archive/stable/steam.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/steam.gpg > /dev/null \
            && sudo echo deb [arch=amd64 signed-by=/usr/share/keyrings/steam.gpg] http://repo.steampowered.com/steam/ stable steam | sudo tee /etc/apt/sources.list.d/steam.list \
            && sudo apt update -y && sudo apt upgrade -y && sudo apt-get install libgl1-mesa-dri:amd64 \
            libgl1-mesa-dri:i386 \
            libgl1-mesa-glx:amd64 \
            libgl1-mesa-glx:i386 \
            steam-launcher
    else
        printf "%b%s%b\n" "${green}" "Steam Already Installed" "${default}"
    fi
}

install_LibreWolfStable() {
    if ! which librewolf; then
        distro=$(if echo " una vanessa focal jammy bullseye vera uma" | grep -q " \"$(lsb_release -sc)\" "; then echo "\"$(lsb_release -sc)\""; else echo focal; fi)
        wget -O- https://deb.librewolf.net/keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/librewolf.gpg
        sudo tee /etc/apt/sources.list.d/librewolf.sources << EOF > /dev/null
Types: deb
URIs: https://deb.librewolf.net
Suites: $distro
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/librewolf.gpg
EOF
        sudo apt update \
            && sudo apt install librewolf -y
    else
        printf "%b%s%b\n" "${green}" "LibreWolf Stable Already Installed" "${default}"
    fi
}

install_LibreWolfUnstable() {
    if ! which librewolf; then
        ! [ -d /etc/apt/keyrings ] && sudo sh -c "mkdir -p /etc/apt/keyrings" && sudo sh -c "chmod 755 /etc/apt/keyrings"
        wget -O- https://download.opensuse.org/repositories/home:/bgstack15:/aftermozilla/Debian_Unstable/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/home_bgstack15_aftermozilla.gpg
        sudo tee /etc/apt/sources.list.d/home_bgstack15_aftermozilla.sources << EOF > /dev/null
Types: deb
URIs: https://download.opensuse.org/repositories/home:/bgstack15:/aftermozilla/Debian_Unstable/
Suites: /
Signed-By: /etc/apt/keyrings/home_bgstack15_aftermozilla.gpg
EOF
        sudo apt update \
            && sudo apt install librewolf -y
    else
        printf "%b%s%b\n" "${green}" "LibreWolf Unstable Already Installed" "${default}"
    fi
}

install_BraveBrowser() {
    if ! which brave-browser;then
        sudo apt install curl \
            && sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg \
            && sudo echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list \
            && sudo apt update \
            && sudo apt install brave-browser -y
    else
        printf "%b%s%b\n" "${green}" "Brave Already Installed" "${default}"
    fi
}

setup_userDots() {
    
        pushd "${HOME}"/Gits || error_print "${FUNCNAME[idx]}" 
        dotfilesDir="${HOME}/Gits/min_install"

        linkDotfile() {
        dest="${HOME}/${1}"
        dateStr=$(date +%Y-%m-%d-%H%M)

        if [ -h ~/"${1}" ]; then
            # Existing symlink 
            echo "Removing existing symlink: ${dest}"
            rm "${dest}" 

        elif [ -f "${dest}" ]; then
            # Existing file
            echo "Backing up existing file: ${dest}"
            mv "${dest}"{,."${dateStr}"}

        elif [ -d "${dest}" ]; then
            # Existing dir
            echo "Backing up existing dir: ${dest}"
            mv "${dest}"{,."${dateStr}"}
        fi

        echo "Creating new symlink: ${dest}"
        ln -s "${dotfilesDir}"/"${1}" "${dest}"
        }

        linkDotfile .ackrc
        linkDotfile .aliases
        linkDotfile .bash_profile
        linkDotfile .bashrc
        linkDotfile .ctags
        linkDotfile .curlrc
        linkDotfile .cwmrc
        linkDotfile .dmrc
        linkDotfile .exrc
        linkDotfile .inputrc
        linkDotfile .kshrc
        linkDotfile .localrc
        linkDotfile .profile
        linkDotfile .tmux.conf
        linkDotfile .Xresources
        linkDotfile .xsession
        linkDotfile scripts

        source "$HOME"/.bashrc 2>/dev/null
}
###########################################
####### MAIN RUNNING PART OF SCRIPT #######
###########################################
printf "\n%b%b%s%b%b%s\n%s\n" "${bold}" "${lightyellow}" "!! Run at Own Risk !!" "${default}" "${green}" "This is a test install script for Debian Linux." "Error handling not fully descriptive yet, and script may break system!"

reset2green
read -p "Would you like to continue running the install script?(Y/n): " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	printf "\n%s\n%s\n" "Thanks for running the install script" "I tried to have any errors or logs sent to /root/install_error.log"
    cloning_git \
        || error_print "cloning_git" && exit 1

    reset2green
    read -p "Would you like to change umask to 27?(Y/n): " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        change_umask \
            || error_print "change_umask" 
    fi

    reset2green
    read -p "Would you like to add non-free sources?(Y/n): " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        backup_sources \
            || error_print "backup_sources" 
        add_non_free \
            || error_print "add_non_free" 
    fi

    reset2green
    read -p "Would you like to change sources to testing?(Y/n): " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        backup_sources \
            || error_print "backup_sources" 
        change_testing \
            || error_print "change_testing" 
    fi

    reset2green
    read -p "Would you like to add i386?(Y/n): " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        add_i386 \
            || error_print "add_i386" 
    fi

    update_apt \
        || error_print "update_apt" 
    install_minimal \
        || error_print "install_minimal" 
    setup_ssh_moduli \
        || error_print "setup_ssh_moduli" 
    setup_harden_ssh_conf \
        || error_print "setup_harden_ssh_conf" 
    setup_ssh_conf \
        || error_print "setup_ssh_conf" 
    restart_ssh \
        || error_print "restart_ssh" 
    setup_logrotate \
        || error_print "setup_logrotate" 
    setup_fail2ban \
        || error_print "setup_fail2ban" 
    #setup_sendmail \
        #|| error_print "${FUNCNAME[idx]}" 

    reset2green
    read -p "Would you like to install basic packages?(Y/n): " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_base_packages \
            || error_print "install_base_packages" 
    fi

    reset2green
    read -p "Would you like to install GUI packages?(Y/n): " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_GUI \
            || error_print "install_GUI" 

        reset2green
        read -p "Would you like to setup slock?(Y/n): " -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            setup_slock || error_print "setup_slock" 
        fi

        reset2green
        printf "%b%s%b LibreWolf is downgraded for Debian Testing at the momment\n" "${blink}${red}" "WARNING" "${green}"
        read -p "Would you like to install Librewolf?(Y/n): " -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            read -p "Would you like to install Stable?(Y/n): " -n 1 -r
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                install_LibreWolfStable \
                    || error_print "install_librewolf" 
            else
                read -p "Would you like to install Unstable?(Y/n): " -n 1 -r
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    install_LibreWolfUnstable \
                        || error_print "install_librewolf" 
                fi
            fi
        fi

        reset2green
        read -p "Would you like to install Brave?(Y/n): " -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_BraveBrowser \
                || error_print "install_brave" 
        fi

        reset2green
        read -p "Would you like to install Steam?(Y/n): " -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_Steam \
                || error_print "install_steam" 
        fi
        
        reset2green
        read -p "Would you like to install VSCode?(Y/n): " -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_VsCode \
                || error_print "install_vscode" 
        fi
    fi

    reset2green
    read -p "Would you like to install golang?(Y/n): " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_golang \
            || error_print "install_golang" 
    fi

    reset2green
    read -p "Would you like to install rust?(Y/n): " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_rust \
            || error_print "install_rust" 
    fi

    reset2green
    read -p "Would you like setup user dotfiles?(Y/n): " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then

        mkdir -p "$HOME"/{Desktop,Downloads,Documents,deb,Gits,go/src,Pictures,Music,Video}
        if [[ -d "${HOME}"/Gits ]]; then
            install_userDots \
                || error_print "setup_userDots" 
        else
            mkdir -p "$HOME"/Gits
            install_userDots \
                || error_print "setup_userDots" 

        fi
    fi

    reset2green
    recheck_updates_cleanup \
        || error_print "recheck_updates_cleanup" 

    ###################
    ####### END #######
    ###################
    printf "\n%s\n%s\n" "Thanks for running the install script" "I tried to have any errors or logs sent to /root/install_error.log"
    printf "%b" "${default}"
else
    exit
fi

