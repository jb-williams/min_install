filetype plugin on 
"vim.opt.filetype=on
"" doesnt work on nvim
"set noesckeys
"" Make backspace a bit nicer
set backspace=eol,start,indent
"vim.opt.backspace="eol","start","indent"

"""""""""""""""""""""""""""""""""""
""""""""HISTORY / SEARCHING""""""""
"""""""""""""""""""""""""""""""""""
"" History
set history=50
"vim.opt.history=50
set t_Co=256
"vim.opt.t_Co=256
set smartindent
"vim.opt.smartindent
set noswapfile
set nobackup
set cursorline
set cursorcolumn
"set lazyredraw

"" Searching
set incsearch
set ignorecase
set smartcase
set gdefault
set showmatch
set hlsearch

"" Enable jumping into files in a search buffer
set hidden 

"" Trying this so do the undo function properly
if has("persistent_undo")
    set undodir=~/.config/nvim/backup
    set undofile
    set undoreload=100
endif

"" Visual prompt for command completion
if has('wildmenu')
    set wildmenu
    set wildchar=<TAB>
endif

""""""""""""""""""""""""""
""""""""FORMATTING""""""""
""""""""""""""""""""""""""
set encoding=utf-8
set path+=**
set nocompatible

"" folding
set nofoldenable

"" Line wrapping
set wrap
set linebreak
set showbreak=~▹

"" Indentation
""" Auto indent what you can
set autoindent
set shiftwidth=4
set tabstop=4
set softtabstop=4
set shiftround
set expandtab
"" Disable mouse=     enable set mouse=a
set mouse=a
"set sidescrolloff=999
"set scrolloff=999

set ls=2
set showmode
set showcmd
set modeline
set ruler
set title
set nu rnu

"""""""""""""""""""""""""""""""""""""""""
""""""""DISPLAY / WINDOWS / COLOR""""""""
"""""""""""""""""""""""""""""""""""""""""
"" color column and scheme
set colorcolumn=90
set background=dark
"" Colorscheme
if executable('rg')
	let g:rg_derive_root='true'
endif

"" Toggle BG
function! ToggleBG()
    let s:tbg = &background
    if s:tbg == "dark"
        set background=light
    else
        set background=dark
    endif
endfunction

""""""""""""""""""""""""""""""
""""""""SYNTAX / SPELL""""""""
""""""""""""""""""""""""""""""
"" auto correct 'teh' to 'the'
ab teh the
ab ehlp help

"""""""""""""""""""""""""""
""""""""LEADER KEYS""""""""
"""""""""""""""""""""""""""
noremap <leader>ns :set spell!<CR>
noremap <leader>bg :call ToggleBG()<CR>

"" toggle highlighting or searchers. user space bar to clear highligh
noremap <silent> <leader>hl :set hlsearch!<CR>
noremap <silent> <SPACE> :noh<CR>

"" Source Current File while working on it without exiting it
nnoremap <leader>sop :source %<CR>

"" Copy/Paste,,, copy copys whole line // need to fix sometime
"vnoremap <leader>y  mm:w!xclip -i -sel clip<CR>`m
vnoremap <leader>y :!xclip -f -sel clip<CR>
vnoremap <leader>x :!xclip -f -sel clip<CR>:!cpclpxf<CR><ENTER>
"map <leader>p mm:-1r !xclip -o<CR>`m
map <leader>p mm:-1r !xclip -o -sel clip<CR>`m

"" Basic Spell Checking/Fixing
nnoremap <leader>sp :normal! mm[s1z=`m<CR>

"" Edit Vim RC
noremap <leader>ev :tabnew $MYVIMRC<CR>

"" Add Semi-Colon at end of line/ not losing your space
nnoremap <leader>; mmA;<esc>`m

"" Not sure what it does
"noremap <leader>cd :cd %:p:h<CR>:pwd<CR>
noremap <leader>cd :cd $(pwd)<CR>

"" Find Date Insert it
nnoremap <leader>fd "=strftime("%a %x %X")<CR>p
vnoremap <leader>" <Esc>`>a"<Esc>`<i"<Esc>
vnoremap <leader>' <Esc>`>a'<Esc>`<i'<Esc>
vnoremap <leader>( <Esc>`>a)<Esc>`<i(<Esc>
vnoremap <leader>[ <Esc>`>a]<Esc>`<i[<Esc>
vnoremap <leader>{ <Esc>`>a}<Esc>`<i{<Esc>
vnoremap <leader>** <Esc>`>a**<Esc>`<i**<Esc>
noremap <leader>m1 mmI#<Space><Esc>`ml
noremap <leader>m2 mmI##<Space><Esc>`ml
noremap <leader>m3 mmI###<Space><Esc>`ml

"""""""""""""""""""""""""""""""
""""""""NON CATEGORIZED""""""""
"""""""""""""""""""""""""""""""
"""""""""""""""
""""command""""
"""""""""""""""
"" Switch tabs
map 8 <Esc>:tabe 
map 9 gT
map 0 gt

"" Gundo toggle
map <F5> <Esc>:GundoToggle<CR>

"" Toggle line-wrap
map <F6> <Esc>:set wrap!<CR>

"" Open file under cursor in new tab
map <F9> <Esc><C-W>gF<CR>:tabm<CR>

"" Write current file with sudo perms (doesnt seem to work in vim)
"command! W w !sudo tee % > /dev/null
"command! W w
command! -bang Qall qall

"" Bash / emacs keys for command line
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

""""""""""""""
""""NORMAL""""
""""""""""""""
"" moving around windows and tabs
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

"" Split the window horizontally or vertically, or close the window. To switch
"" windows, use <C-W> followed by <C-H> for left, <C-L> for right, <C-J> for
"" down, and <C-K> for up. Or tap <C-W><C-W> to switch between each.
if has('windows')
	noremap <silent> <leader>ws :split<CR>
	noremap <silent> <leader>wvs :vsplit<CR>
	noremap <silent> <leader>wc :close<CR>
endif

"" Direction keys for wrapped lines
noremap <silent> <expr> j (v:count == 0? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0? 'gk' : 'k')
"nnoremap <silent> k 
"nnoremap <silent> j gj
nnoremap <silent> <Up> gk
nnoremap <silent> <Down> gj

"" Base64 decode word under cursor
nmap <Leader>b :!echo <C-R><C-W> \| base64 -d<CR>

"" grep recursively for word under cursor
nmap <Leader>g :tabnew\|read !grep -Hnr '<C-R><C-W>'<CR>

"" sort the buffer removing duplicates
nmap <Leader>s :%!sort -u --version-sort<CR>

""""""""""""""
""""insert""""
""""""""""""""
inoremap <silent> <Up> <Esc>gka
inoremap <silent> <Down> <Esc>gja

"""""""""""""""
""""VIMENV"""""
"""""""""""""""
if $VIMENV == 'talk'
  set background=light
  noremap <Space> :n<CR>
  noremap <Backspace> :N<CR>
"  Goyo
"  Limelight
else
  " Trans background
  hi Normal ctermbg=none
  hi NonText ctermbg=none
endif
if $VIMENV == 'prev'
  noremap <Space> :n<CR>
  noremap <Backspace> :N<CR>
  noremap <C-D> :call delete(expand('%')) <bar> argdelete % <bar> bdelete<CR>
  set noswapfile
endif

"" set the interactive flag so bash functions are sourced from ~/.bashrc etc
"set shellcmdflag=-ci
set secure
