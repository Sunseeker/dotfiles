set nu    " show line numbers
set nocompatible " choose no compatibility with legacy vi
syntax enable
set encoding=utf-8
set showcmd " display incomplete commands
filetype plugin indent on " load file type plugins + indentation

"" Whitespace
set nowrap " don't wrap lines
set tabstop=4 shiftwidth=4 " a tab is two spaces (or set this to 4)
set expandtab " use spaces, not tabs
set backspace=indent,eol,start " backspace through everything in insert mode

"" Searching
set hlsearch " highlight matches
set incsearch " incremental searching
set ignorecase " searches are case insensitive...
set smartcase " ... unless they contain at least one capital letter

"" Mappings
nmap <F8> :TagbarToggle<CR> " mapping f8 to TagbarToggle
nmap <F2> :NERDTreeToggle<CR> " mapping f2 to NERDTreeToggle
nmap <F3> :NumbersToggle<CR> " mapping f3 to NumbersToggle
noremap <F5> :GundoToggle<CR> " mapping f5 to Gundo
noremap <F9> :Gcommit<CR> " mapping f9 to Gcommit
noremap! jj <Esc> "<Esc> to jj

"" Mapping
let mapleader = "," " setting leader to ,

"" Color Scheme
colorscheme evening

set laststatus=2 " Always show the statusline

" Enable fancy mode
let g:Powerline_symbols = 'fancy' " Powerline

"SWAGG
set colorcolumn=120 " line to show 120 character mark
"set cursorline " shows the horizontal cursor line
nmap <leader>ev :vsplit $MYVIMRC<cr> " mapping to edit my vimrc quickly
nmap <leader>sv :source $MYVIMRC<cr> " mapping to source my vimrc quickly

"Badass Functions
function! OpenChangedFiles()
  only " Close all windows, unless they're modified
  let status = system('git status -s | grep "^ \?\(M\|A\|UU\)" | sed "s/^.\{3\}//"')
  let filenames = split(status, "\n")
  exec "edit " . filenames[0]
  for filename in filenames[1:]
    exec "sp " . filename
  endfor
endfunction
command! OpenChangedFiles :call OpenChangedFiles()