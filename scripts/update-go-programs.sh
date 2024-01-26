#!/usr/bin/env bash

#rustup update

#pushd ${HOME}/Gits
#git clone https://github.com/alacritty/alacritty.git && cd alacritty
#cargo build --release && sudo cp target/release/alacritty /usr/local/bin/
#popd

install_go() {                                                                 
        /usr/local/go/bin/go install "$1"
}
install_go golang.org/x/tools/cmd/goimports@latest
install_go github.com/nsf/gocode@latest
install_go github.com/tomnomnom/gf@latest
install_go github.com/tomnomnom/gron@latest
install_go github.com/tomnomnom/unfurl@latest
install_go github.com/tomnomnom/fff@latest
install_go github.com/tomnomnom/httprobe@latest
install_go github.com/tomnomnom/meg@latest
install_go github.com/tomnomnom/waybackurls@latest
install_go github.com/tomnomnom/assetfinder@latest
#install_go github.com/bitrise-io/go-xcode@latest
