#BROWSER=/usr/local/bin/firefox
#BROWSER=/bin/firefox
EDITOR=/usr/local/bin/vim
export EDITOR=vim
export XDG_DATA_DIRS=/usr/local/share
export LANG=en_US.UTF-8
export PATH=$HOME/bin:/root/.cargo/bin:$HOME/.local/bin:$HOME/.local/bin/dmenuscripts:$HOME/.cargo/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games

# Aliases
alias ..='cd ..' 
alias ...='cd ../..' 
#alias ls='lsd'
alias df='df -h'
set -o emacs
alias __A=`echo "\020"`     # up arrow = ^p = back a command
alias __B=`echo "\016"`     # down arrow = ^n = down a command
alias __C=`echo "\006"`     # right arrow = ^f = forward a character
alias __D=`echo "\002"`     # left arrow = ^b = back a character
alias __H=`echo "\001"`     # home = ^a = start of line
alias __Y=`echo "\005"`     # end = ^e = end of line

#pokemon-colorscripts -n togepi | sed '1,2d'
#HOSTN=$( hostname | cut -c 7- )
HOSTN=$( uname -sn | awk '{print $2}' )
#PS1='\033[32m${USER}\033[35m@\033[34m${HOSTN} \033[33m${PWD}\n \033[36m$ \033[0m'
PS1='${USER}-${HOSTN}-${PWD}$: '
export PS1

