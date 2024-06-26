set tags='./tags'
" set runtime path?
set runtimepath+=/usr/share/vim/vim*/syntax
"  set warn on
set warn
" display current mode (insert/norm)
set showmode

" display all erroor messages
set verbose

set window=100

" print helpful messages (eg, 4 lines yanked
set report=3

" line numbers
set number

" display row/column info
set ruler

" set column
set column=80

" wordwrap # chars from right side of window
"set wm=5
set wraplen=80
" set wrapmargin=7 

set redraw

" auto writes changes when multiple files are open
"set autowrite

" set auto indent
set autoindent

" autoindent width = 4 spaces
set shiftwidth=4

" tab width = 4 spaces
"set tabstop=2
set tabstop=4

" To swap two words, put cursor at start of first word and type v: 
map v deelp
"map v dwElp

" set troff macros, disallow message
"set sections=SeAhBhChDh nomesg 

" alias move to next file
"map q :w^M:n^M
"map 9 :N
" map 0 :n

" enable horizontal scrolling
set leftright

" use extended regular expressions
set extended

" show matching parens, braces, etc
set showmatch

" searches don't wrap at end of file
"set nowrapscan 

" case-insensitive search, unless an upercase letter is used
set iclower

" incremental search
set searchincr

" set escape time
Set escapetime=1
