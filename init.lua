vim.opt.filetype="on"
vim.opt.history=100
-- look stuffs
vim.opt.guicursor="i:block"
vim.opt.nu=true
vim.opt.rnu=true
vim.opt.cursorline=true
vim.opt.cursorcolumn=true
vim.opt.lazyredraw=true
vim.opt.showmode=true
vim.opt.showcmd=true
vim.opt.modeline=true
vim.opt.ruler=true
vim.opt.title=true
vim.opt.background="dark"
vim.opt.mouse="a"
vim.opt.ls=2
vim.opt.scrolloff=8
if vim.fn.executable("rg") == 1 then
    vim.g.rg_derive_root=true
end
-- netrw file manager stuff
vim.g.netrw_keepdir=0
vim.g.netrw_winsize=50
--vim.g.netrw_brows_split=1

-- search
vim.opt.hlsearch=true
vim.opt.incsearch=true
vim.opt.showmatch=true
vim.opt.ignorecase=true
vim.opt.smartcase=true
vim.opt.gdefault=true
vim.opt.encoding="utf-8"

-- lines
vim.opt.wrap=true
vim.opt.linebreak=true
vim.opt.showbreak="~▹"
-- indents/tabs
vim.opt.smartindent=true
vim.opt.autoindent=true
vim.opt.shiftwidth=4
vim.opt.tabstop=4
vim.opt.softtabstop=4
vim.opt.shiftround=true
vim.opt.expandtab=true

-- Allow for linewrap follow
vim.keymap.set("n", "k", "gk", {noremap=true, silent=true})
vim.keymap.set("n", "j", "gj", {noremap=true, silent=true})
vim.keymap.set("n", "<UP>", "gk", {noremap=true, silent=true})
vim.keymap.set("n", "<DOWN>", "gj", {noremap=true, silent=true})
-- insert mode following linewrap
vim.keymap.set("i", "<UP>", "<ESC>gka", {noremap=false, silent=true})
vim.keymap.set("i", "<DOWN>", "<ESC>gja", {noremap=false, silent=true})
vim.keymap.set("i", "<C-h>", "<ESC>ha", {noremap=false, silent=true})
vim.keymap.set("i", "<C-k>", "<ESC>gka", {noremap=false, silent=true})
vim.keymap.set("i", "<C-j>", "<ESC>gja", {noremap=false, silent=true})
vim.keymap.set("i", "<C-l>", "<ESC>la", {noremap=false, silent=true})

-- Leader key
vim.g.mapleader = "\\"

-- source document
vim.keymap.set("n", "<leader>so", ":so<CR>", {noremap=true, silent=true})

-- file browsing - keeping these to mess with but need to change the function call to lua sometime
vim.keymap.set("n", "<leader>vv", ":call ToggleNetrw()<CR>", {noremap=true, silent=true})

-- copy/paste and tmp clipboard
vim.keymap.set("v", "<leader>y", ":!xclip -f -sel clip<CR>", {noremap=false, silent=true})
vim.keymap.set("n", "<leader>p", "mm:-1r !xclip -o -sel clip<CR>`m", {noremap=false, silent=true})
vim.keymap.set("v", "<leader>x", ":!xclip -f -sel clip<CR>:!cpclpxf<CR><ENTER>", {noremap=false, silent=true})

-- searching and clear search
vim.keymap.set("n", "<leader>hl", ":set hlsearch!<CR>", {noremap=true, silent=true})
vim.keymap.set("n", "<SPACE>", ":noh<CR>", {noremap=true, silent=true})

-- add semicolon to end
vim.keymap.set("n", "<leader>;", "mmA;<ESC>`m", {noremap=true, silent=true})

-- Switch tabs
vim.keymap.set("n", "8", "<ESC>:tabe<CR>", {noremap=true, silent=true})
vim.keymap.set("n", "9", "gT", {noremap=true, silent=true})
vim.keymap.set("n", "0", "gt", {noremap=true, silent=true})

-- move splits
vim.keymap.set("n", "<C-h>", "<C-w>h", {noremap=true, silent=true})
vim.keymap.set("n", "<C-j>", "<C-w>j", {noremap=true, silent=true})
vim.keymap.set("n", "<C-k>", "<C-w>k", {noremap=true, silent=true})
vim.keymap.set("n", "<C-l>", "<C-w>l", {noremap=true, silent=true})
vim.keymap.set("n", "<leader>ws", ":split<CR>", {noremap=true, silent=true})
vim.keymap.set("n", "<leader>wvs", ":vsplit<CR>", {noremap=true, silent=true})
vim.keymap.set("n", "<leader>wc", ":close<CR>", {noremap=true, silent=true})

-- my surround bits
vim.keymap.set("v", '<leader>"', '<Esc>`>a"<Esc>`<i"<Esc>', {noremap=false, silent=true})
vim.keymap.set("v", "<leader>'", "<Esc>`>a'<Esc>`<i'<Esc>", {noremap=false, silent=true})
vim.keymap.set("v", "<leader>(", "<Esc>`>a)<Esc>`<i(<Esc>", {noremap=false, silent=true})
vim.keymap.set("v", "<leader>[", "<Esc>`>a]<Esc>`<i[<Esc>", {noremap=false, silent=true})
vim.keymap.set("v", "<leader>{", "<Esc>`>a}<Esc>`<i{<Esc>", {noremap=false, silent=true})
vim.keymap.set("v", "<leader>**", "<Esc>`>a**<Esc>`<i**<Esc>", {noremap=false, silent=true})
--vim.keymap.set("v", "<leader>>", "<Esc>`>a\><Esc>`<i\><Esc>", {noremap=false, silent=true})

-- base64 decode
vim.keymap.set("n", "<leader>b", ":!echo <C-R><C-W> \\| base64 -d<CR>", {noremap=true, silent=true})

vim.keymap.set("n", "<leader>g", ":tabnew | read !grep -Hnr '<C-R><C-W>' <CR>", {noremap=true, silent=false})
vim.keymap.set("n", "<leader><ENTER>", "<ESC><C-W>gF<CR>:tabm<CR>", {noremap=true, silent=false})

-- sort buffer by unique
vim.keymap.set("n", "<leader>s", ":%!sort -u --version-sort<CR>", {noremap=true, silent=true})


vim.cmd([[
let g:NetrwIsOpen=0
function! ToggleNetrw()
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i 
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Explore
        "silent Sex!
    endif
endfunction

ab teh the
ab ehlp help
set path+=**
set noswapfile
set nobackup
set nocompatible
set nofoldenable
set colorcolumn=90

"" Visual prompt for command completion
if has('wildmenu')
    set wildmenu
    set wildchar=<TAB>
endif

]])
vim.opt.secure=true
