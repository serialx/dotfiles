
call plug#begin()
Plug 'vim-airline/vim-airline'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1
Plug 'tpope/vim-fugitive'
Plug 'fatih/molokai'
Plug 'fatih/vim-go'
Plug 'dietsche/vim-lastplace'
Plug 'rust-lang/rust.vim'
Plug 'posva/vim-vue'
Plug 'hashivim/vim-terraform'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'martinda/Jenkinsfile-vim-syntax'
call plug#end()


if has("unix")
  let s:uname = system("uname")
  if s:uname == "Linux\n"
    " Terminator cursor workaround: https://github.com/neovim/neovim/issues/6062
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 0
  endif
endif


" Color column right after tw
set colorcolumn=+1

" color scheme
try
  colorscheme molokai
catch /^Vim\%((\a\+)\)\=:E185/
endtry

" clipboard integration
if has('mac')
  set clipboard=unnamed
endif

" Never lose clipboard when deleting text
let s:putSwap = 1
function! TogglePutSwap()
    if s:putSwap
        xnoremap p "_dP
        let s:putSwap = 0
        echo 'noreplace put'
    else
        silent! xunmap p
        let s:putSwap = 1
        echo 'replace put'
    endif
    return
endfunction
noremap ,p :call TogglePutSwap()<cr>

" enable buffer change without saving
set hidden

" smartcase search
set ignorecase
set smartcase

" list mode
set list lcs=extends:>,precedes:<
set lcs+=tab:»\ ,trail:·

" key mapping neovim + mac workaround
" https://github.com/neovim/neovim/issues/2048
if has('nvim')
  nmap <BS> <c-h>
endif

" key mapping
let mapleader = '\'
map <s-w> :bw<CR>
map <c-l> :bn<CR>
map <c-h> :bN<CR>
map - :Explore<cr>

" immediate buffer configuration
map <silent> <Leader>n :let &nu = 1 - &nu<CR>
map <silent> <Leader>l :let &list = 1 - &list<CR>
map <silent> <Leader>p :let &paste = 1 - &paste<CR>
map <silent> <Leader>w :let &wrap = 1 - &wrap<CR>
nmap <silent> <Leader>1 :set ts=1 sw=1<CR>
nmap <silent> <Leader>2 :set ts=2 sw=2<CR>
nmap <silent> <Leader>4 :set ts=4 sw=4<CR>
nmap <silent> <Leader>8 :set ts=8 sw=8<CR>

" editing and applying .vimrc
nmap <silent> <Leader>R :so $HOME/.config/nvim/init.vim<CR>
nmap <silent> <Leader>rc :e $HOME/.config/nvim/init.vim<CR>

" misc. mapping
nmap <silent> <Leader>cd :e %:p:h<CR>
nmap <silent> <Leader><Space> :noh<CR>

" vim-go
let g:go_fmt_command = "goimports"

" vim-airline
let g:airline#extensions#tabline#enabled = 1
"let g:airline_powerline_fonts = 1
"let g:airline#extensions#tabline#left_sep = ' '
"let g:airline#extensions#tabline#left_alt_sep = '|'

" ctlrp
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)|node_modules|venv$'

" autocmd
au FileType python setl ts=8 sw=4 sts=4 et
au FileType vue setl ts=8 sw=2 sts=2 et
au FileType ruby setl ts=8 sw=2 sts=2 et
au FileType html setl ts=8 sw=2 sts=2 et
au FileType yaml setl ts=8 sw=2 sts=2 et
au FileType json setl ts=8 sw=2 sts=2 et
au FileType tf setl ts=8 sw=2 sts=2 et
au FileType javascript setl ts=8 sw=2 sts=2 et
au FileType go setl lcs=tab:\ \ ,trail:· ts=4 sw=4 noet
au FileType cpp setl ts=8 sw=2 sts=2 et
au FileType c setl ts=8 sw=2 sts=2 et
au FileType sh setl ts=8 sw=4 sts=4 et
au FileType tex setl ts=8 sw=2 sts=2 et tw=78
au FileType md setl ts=8 sw=2 sts=2 et tw=78
let g:terraform_fmt_on_save = 1

" fzf
map <c-p> :FZF<CR>
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" Syntax cleanup
noremap <Leader>s <Esc>:syntax sync fromstart<CR>
inoremap <Leader>s <C-o>:syntax sync fromstart<CR>
