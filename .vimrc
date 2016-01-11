"set line number
set nu

"set paste mode
set paste

"Change working directory of VIM to the directory of the file opened
set autochdir

colorscheme torte

syntax on

" Backspace will delete over line breaks, indent or the place where the
" insert mode started
set backspace=indent,eol,start

" Set autoread when a file is changed from the outside
set autoread

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

set shiftwidth=4
set tabstop=4
set softtabstop=4
set smarttab
set expandtab
set smartindent

autocmd BufRead * highlight BadWhitespace ctermbg=red guibg=red
autocmd BufRead * match BadWhitespace /^\t\+/
autocmd BufRead * match BadWhitespace /\s\+$/

"the status bar is always displayed
set laststatus=2
if has("statusline")
    set statusline=%<%f%h%m%r%=%l,%c\ %P
elseif has("cmdline_info")
    set ruler " display cursor position
endif

filetype plugin on

let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_typescript_checkers = ['tslint']
execute pathogen#infect()
