## Common Aliases
alias tlist="tmux list-sessions"
alias more="less -RF"
#alias less="bat"
alias mkdir='mkdir -pv'
# Safety Nets catches bad deletions in /
alias rm='rm -I --preserve root'
#alias mv='mv -i'
alias :q='exit'

## Ls or Exa
alias ls='ls --color=always --group-directories-first' # list all
alias la='ls -a --color=always --group-directories-first' # list all
alias ll='ls -lahF --color=always --group-directories-first' # long list all human readable
#alias lt='exa -aT --color=always --group-directories-first' # tree listing
#alias l.='exa -a --color=always --group-directories-first | grep "^\." --color=always' # dots only
#alias ls='exa --color=always --group-directories-first' # list all
#alias la='exa -a --git --color=always --group-directories-first' # list all
#alias ll='exa -lahF --git --color=always --group-directories-first' # long list all human readable
#alias lt='exa -aT --git --color=always --group-directories-first' # tree listing
#alias l.='exa -a --git --color=always --group-directories-first | grep "^\." --color=always' # dots only
## Bat usage lists and stuff
alias bat='bat --theme=Dracula -f --language "pl"'
#alias cat='bat --theme=Dracula -f --language "pl"'
# Confirmation
alias ln='ln -i'

## Ownership
# restricting perms on /
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chrgp='chgrp --preserve-root'

alias pop='popd'
alias push='pushd'

## Programs and Procceses
alias vimwiki='pushd $HOME/.config/vimwiki && vim +VimwikiIndex && popd'
alias vim='vimprev'
alias nvim='nvim +Ex'
#alias vf='vifm ~/ $(pwd)'
alias vfvf='vifm $(pwd) $(pwd)'
#alias vf='vifm $(pwd) $(pwd)'
alias vifm='vifm  $(pwd) $(pwd)'
alias vfh='vifm ~/ ~/'
alias grep='grep --color=auto'
alias norg='gron --ungron'
alias ungron='gron --ungron'
alias vimpress='VIMENV=talk vim'
alias j='jobs -l'
alias follow='tail -f -n +1'
alias biggest='du -h --max-depth=1 | sort -h'
alias graph='git log --all --decorate --oneline --graph'
alias gitdir='cd ~/Gits && ls'

## System
alias fuck='sudo shutdown now'
# pip update/upgrade for user
alias pip-upgrade="pip3 freeze --user | cut -d'=' -f1 | xargs -n1 pip3 install -U"
# pip update/upgrade for virt env's
alias pip-upgrade-venv="pip3 freeze | cut -d'=' -f1 | xargs -n1 pip3 install -U"
# get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
# get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
# get error messages from journalctl
alias jctl='sudo journalctl -p 3 -xb'
alias ports='sudo netstat -tulpan'
