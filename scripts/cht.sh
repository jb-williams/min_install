#!/usr/bin/env bash
languages=("bash
golang
rust
c
cpp
lua")

core_utilss=("xargs
find
mv
sed
awk")

selected=$(printf "%s\n%s" "${languages[@]}" "${core_utilss[@]}" | fzf --border --margin=5% --color=dark --height=100% --reverse)
read -p "query: " -r query
#read -p "query(lang keyword): " -r query

if printf "%s" "${languages[@]}" | grep -qs "$selected"; then
	tmux neww bash -c "curl cht.sh/$selected/$(echo "$query" | tr ' ' '+') & while [ : ]; do sleep 1; done"
else
	tmux neww bash -c "curl cht.sh/$selected~$(echo "$query" | tr ' ' '+') & while [ : ]; do sleep 1; done"
fi
