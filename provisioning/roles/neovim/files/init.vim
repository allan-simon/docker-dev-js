set mouse=a
" fix for: https://github.com/neovim/neovim/issues/7049
set guicursor=
"
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab

set expandtab
set smartindent

set wildmode=longest,full 

set autochdir

set showcmd

colorscheme torte

"the status bar is always displayed
set laststatus=2 
if has("statusline")
    set statusline=%<%f%h%m%r%=%l,%c\ %P  
elseif has("cmdline_info")
    set ruler " display cursor position
endif

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')


Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
" for autocompletion

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug ‘ternjs/tern_for_vim’, { ‘do’: ‘npm install && npm install -g tern’ }
 Plug ‘carlitux/deoplete-ternjs’
" for fuzzy completion
Plug 'Shougo/denite.nvim'
Plug 'Shougo/echodoc.vim'

" to display in red extra whitespaces
Plug 'ntpeters/vim-better-whitespace'
Plug 'neomake/neomake'


" Initialize plugin system
call plug#end()

let g:neomake_javascript_enabled_makers = [‘eslint’]

" for language server

set hidden

" Automatically start language servers.
let g:LanguageClient_autoStart = 1

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

" used by deoplete
let g:deoplete#enable_at_startup = 1


" to easily switch from a split containing a terminal to an other split
" see https://medium.com/@garoth/neovim-terminal-usecases-tricks-8961e5ac19b9
func! s:mapMoveToWindowInDirection(direction)
    func! s:maybeInsertMode(direction)
        stopinsert
        execute "wincmd" a:direction

        if &buftype == 'terminal'
            startinsert!
        endif
    endfunc

    execute "tnoremap" "<silent>" "<C-" . a:direction . ">"
                \ "<C-\\><C-n>"
                \ ":call <SID>maybeInsertMode(\"" . a:direction . "\")<CR>"
    execute "nnoremap" "<silent>" "<C-" . a:direction . ">"
                \ ":call <SID>maybeInsertMode(\"" . a:direction . "\")<CR>"
endfunc
for dir in ["h", "j", "l", "k"]
    call s:mapMoveToWindowInDirection(dir)
endfor


" Figure out the system Python for Neovim.
" otherwise neovim is confused by virtualenv of other projects
if exists("$VIRTUAL_ENV")
    let g:python3_host_prog=substitute(system("which -a python3 | head -n2 | tail -n1"), "\n", '', 'g')
else
    let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')
endif
