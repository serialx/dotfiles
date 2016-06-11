
call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'kien/ctrlp.vim'
" replaced with vim-airline
"Plug 'fholgado/minibufexpl.vim'
Plug 'vim-airline/vim-airline'
Plug 'Valloric/YouCompleteMe'
Plug 'tpope/vim-fugitive'
Plug 'fatih/molokai'
Plug 'fatih/vim-go'
call plug#end()

" color scheme
colorscheme molokai

" list mode
set list lcs=extends:>,precedes:<
set lcs+=tab:»\ ,trail:·

" key mapping neovim + mac workaround
" https://github.com/neovim/neovim/issues/2048
if has('nvim')
  nmap <BS> <c-h>
endif

" ESC key input bug workaround
" https://github.com/neovim/neovim/issues/2017#issuecomment-163337531
set ttimeout
set ttimeoutlen=0

" key mapping
let mapleader = '\'
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

" autocmd
au FileType python setl ts=8 sw=4 sts=4 et
au FileType ruby setl ts=8 sw=2 sts=2 et
au FileType go setl lcs=tab:\ \ ,trail:· ts=4 sw=4 noet
au FileType sh setl ts=8 sw=4 sts=4 et