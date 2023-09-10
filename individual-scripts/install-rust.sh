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
    printf "%b%b%b%s%b%b %s %b%s%b%s\n" "${bold}" "${blink}" "${red}" "ERROR!!!" "${default}" "${green}" "Failed:" "${lightyellow}" "$*" "${green}" "!!!" | tee -a "$HOME"/install-rust-error.log
}

install_rust() {
    if ! which cargo &> /dev/null; then
        /usr/bin/curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
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

reset2green
install_rust || error_print "install_rust"
