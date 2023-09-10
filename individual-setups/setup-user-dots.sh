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
    printf "%b%b%b%s%b%b %s %b%s%b%s\n" "${bold}" "${blink}" "${red}" "ERROR!!!" "${default}" "${green}" "Failed:" "${lightyellow}" "$*" "${green}" "!!!" | tee -a "$HOME"/install-user-dots-error.log
}

setup_userDots() {
		if [ ! -d "${HOME}"/Gits ]; then
			mkdir -p "${HOME}"/Gits
		else
			pushd "${HOME}"/Gits || error_print "${FUNCNAME[idx]}" 
		fi
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

        linkDotfile .ackrc || error_print "ackrc"
        linkDotfile .bash_aliases || error_print "aliases"
        linkDotfile .bash_profile || error_print "bash_profile"
        linkDotfile .bashrc || error_print "bashrc"
        linkDotfile .ctags || error_print "ctags"
        linkDotfile .curlrc || error_print "curlrc"
        linkDotfile .cwmrc || error_print "cwmrc"
        #linkDotfile .dmrc || error_print "setup_userDots"
        linkDotfile .exrc || error_print "exrc"
        linkDotfile .inputrc || error_print "inputrc"
        linkDotfile .kshrc || error_print "kshrc"
        linkDotfile .localrc || error_print "localrc"
        linkDotfile .profile || error_print "profile"
        linkDotfile .tmux.conf || error_print "tmux"
        linkDotfile .Xresources || error_print "Xresources"
        linkDotfile .xsession || error_print ".xsession"
        linkDotfile scripts || error_print "scripts"

        source "$HOME"/.bashrc
}

reset2green
setup_userDots || error_print "setup_userDots"
