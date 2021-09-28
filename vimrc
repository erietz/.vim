" vim: foldmethod=marker
" Author: Ethan Rietz
" Date: Thu Sep 23 06:30:18 PDT 2021
" Description: A minimal curl-able vimrc for working on remote systems

let g:mapleader = "\<Space>"
let g:maplocalleader = ','
let g:vimsyn_embed = 'lPr'
set background=dark

" {{{ Plugins
if filereadable(expand("~/.vim/autoload/plug.vim"))
    call plug#begin('~/.local/share/vim/plugins')
    " Plug 'sheerun/vim-polyglot'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-dispatch'
    " Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'junegunn/vim-easy-align'
    Plug 'morhetz/gruvbox'
    call plug#end()

    colorscheme gruvbox

    " vim-easy-align
    xmap ga <Plug>(EasyAlign)
    nmap ga <Plug>(EasyAlign)

    " diable fzf preview window
    " let g:fzf_preview_window = []

    " command! -bang -nargs=* GGrep
    "   \ call fzf#vim#grep(
    "   \   'git grep --line-number -- '.shellescape(<q-args>), 0,
    "   \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

    " command! -bang -nargs=* Rg
    "   \ call fzf#vim#grep(
    "   \   'grep -R -n -- '.shellescape(<q-args>), 1,
    "   \   fzf#vim#with_preview(), <bang>0)

    nnoremap <leader><CR> :Files<CR>
    nnoremap <leader><leader> :Buffers<CR>
    nnoremap <leader>rg :Rg<CR>
    nnoremap <leader>df :Files ~/.ewr<CR>
    nnoremap <leader>gf :GFiles<CR>
    nnoremap <leader>gs :GFiles?<CR>
    nnoremap <leader>gc :Commits<CR>

else
    colorscheme pablo
endif


" }}}
" {{{ Options

set tabstop=4 shiftwidth=4 expandtab smarttab
set autoindent
set hidden
set guicursor=
set number
set relativenumber
" searching
set ignorecase smartcase incsearch nohlsearch
set list listchars=nbsp:¬,tab:»·,trail:·,extends:>
set wildmenu
set wildmode=longest:full,full
set mouse=i
set nowrap
set nobackup
set noswapfile
set undodir=~/.vim/undodir/
set undofile
set scrolloff=8
set colorcolumn=80
set backspace=indent,eol,start
set statusline=%<%f\ %h%m%r%=%-10.(%y%)\ %-14.(%l,%c%V%)\ %P
set laststatus=2

" see :h fo-table
augroup DoNotOverrideMySettings
  au!
  au FileType * setlocal formatoptions+=ronc " formatoptions-=c
augroup end

" }}}
" {{{ Mappings

" Changing window splits
nnoremap <silent> <c-h> :wincmd h<CR>
nnoremap <silent> <c-j> :wincmd j<CR>
nnoremap <silent> <c-k> :wincmd k<CR>
nnoremap <silent> <c-l> :wincmd l<CR>
"nnoremap <tab>   <c-w>w
"nnoremap <S-tab> <c-w>W

" toggle quickfix
nnoremap <leader>q :copen<CR>
nnoremap <leader>l :lopen<CR>
nnoremap <leader>c :cclose<bar>lclose<CR>

" Yank to clipboard
vnoremap <leader>y "+y

" delete but don't yank
vnoremap <leader>d "_d

" paste without 
vnoremap <leader>p "_dP

" navigation
nnoremap ]q :cnext<CR>zz
nnoremap [q :cprev<CR>zz
nnoremap ]l :lnext<CR>zz
nnoremap [l :lprev<CR>zz
nnoremap ]b :bnext<CR>
nnoremap [b :bprev<CR>
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>

" Native grep better than plugins
" command! -nargs=+ -complete=file Grep execute 'silent lgrep! <args>' | lopen
" command! -nargs=+ VimGrep execute 'silent lvimgrep! <q-args>' . '**/*' | lopen
" nnoremap <leader>gg :Grep 
" nnoremap <leader>vg :VimGrep 

" Resize windows
nnoremap <Left> :vertical resize -2<CR>
nnoremap <Right> :vertical resize +2<CR>
nnoremap <Up> :resize -2<CR>
nnoremap <Down> :resize +2<CR>

" View current file and current directory
nnoremap <leader>fv :Vex<bar>set winfixwidth<CR>
nnoremap <leader>dv :Lex<bar>set winfixwidth<CR>

" Adding comments until end of line---------------------------------------------
nnoremap <leader>- 80A-<esc>81<bar>d$_<cr>
nnoremap <leader>_ 50A-<esc>51<bar>d$_<cr>

if has('terminal')
    " Terminal mappings
    tnoremap <leader><Esc> <c-\><c-n>
    tnoremap <Esc><Esc> <c-\><c-n>
    tnoremap <C-h> <C-\><C-n><C-w>h
    tnoremap <C-j> <C-\><C-n><C-w>j
    tnoremap <C-k> <C-\><C-n><C-w>k
    tnoremap <C-l> <C-\><C-n><C-w>l
endif

" Clean up whitespace
function! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfunction

command! TrimWhitespace call TrimWhitespace()

function Cheat(query)
  let query = 'cheat.sh/' . a:query
  execute 'split | term curl ' . query
  execute 'resize ' . string(&lines/3)
endfunction

command! -nargs=1 CheatSh call Cheat(<q-args>)
nnoremap <leader>h :CheatSh <C-R>=&filetype<CR>/

function Retab()
  " change all four spases to a tab
  set ts=4 sts=4 noet
  retab!
  " change all tabs to two spaces
  set ts=2 sts=2 et
  retab
endfunction

function About()
    let date = system('date +%F')
    echo date
    " execute "normal A Author        : Ethan Rietz"
    " execute "normal A Date          : " .. date
    " execute "normal A Description   : "
endfunction

" }}}
