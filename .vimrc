"" to reload settings in vim use :so ~/.vimrc command

set nu    			    " show line numbers
colorscheme evening		"" Color Scheme
set laststatus=2 		" Always show the statusline

set nocompatible 		" choose no compatibility with legacy vi
syntax enable
set encoding=utf-8
set showcmd 		    	" display incomplete commands
filetype plugin indent on 	" load file type plugins + indentation

set viewoptions=folds,options,cursor,unix,slash " better unix / windows compatibility
set virtualedit=onemore 		" allow for cursor beyond last character
set history=1000 				" Store a ton of history (default is 20)
set spell 	 		    		" spell checking on


"" Whitespace
"set nowrap " don't wrap lines
set tabstop=4 shiftwidth=4 " a tab is two spaces (or set this to 4)
set expandtab " use spaces, not tabs
set backspace=indent,eol,start " backspace through everything in insert mode

set backup 			        " backups are nice ...
set undofile			    " so is persistent undo ...
set undolevels=1000 		" maximum number of changes that can be undone
set undoreload=10000 		" maximum number lines to save for undo on a buffer reload

au BufWinLeave * silent! mkview   " make vim save view (state) (folds, cursor, etc)
au BufWinEnter * silent! loadview " make vim load view (state) (folds, cursor, etc)

set showmode " display the current mode
hi cursorline guibg=#333333 " highlight bg color of current line
hi CursorColumn guibg=#333333 " highlight cursor

if has('cmdline_info')
    set ruler " show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
    set showcmd " show partial commands in status line and selected characters/lines in visual mode
endif


if has('statusline')
set laststatus=2

    " Broken down into easily includeable segments
    set statusline=%<%f\ " Filename
    set statusline+=%w%h%m%r " Options
"    set statusline+=%{fugitive#statusline()} " Git Hotness
    set statusline+=\ [%{&ff}/%Y] " filetype
    set statusline+=\ [%{getcwd()}] " current dir
    "set statusline+=\ [A=\%03.3b/H=\%02.2B] " ASCII / Hexadecimal value of char
    set statusline+=%=%-14.(%l,%c%V%)\ %p%% " Right aligned file nav info
endif

if has ('win32')
    set dir=C:\\Users\\ysamokhvalov\\_vim-tmp-files " dir for .swp files
    set backupdir=C:\\Users\\ysamokhvalov\\_vim-tmp-files
    set undodir=C:\Users\ysamokhvalov\_vim-tmp-files
else
    set backupdir=~/.vim-tmp-files
    set undodir=~/.vim-tmp-files
endif 
set linespace=0		" No extra spaces between rows
set showmatch		" show matching brackets/parenthesis
set incsearch		" find as you type search
set hlsearch		" highlight search terms
set winminheight=0	" windows can be 0 line high
set ignorecase 		" searches are case insensitive...
set smartcase 		" ... unless they contain at least one capital letter
set wildmenu		" show list instead of just completing
set wildmode=list:longest,full " command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,] " backspace and cursor keys wrap to
set scrolljump=5 	" lines to scroll when cursor leaves screen
set scrolloff=3 	" minimum lines to keep above and below cursor

" Formatting {
set wrap       " wrap long lines
set textwidth=120 " text width for wrapping
set autoindent   " indent at the same level of the previous line
set shiftwidth=4 " use indents of 4 spaces
set expandtab    " tabs are spaces, not tabs
set tabstop=4    " an indentation every four col
" }


filetype plugin indent on 	" Automatically detect file types.
syntax on 			" syntax highlighting
set mouse=a			" automatically enable mouse usage

"" Mapping
let mapleader = "," " setting leader to ,

" Enable fancy mode
let g:Powerline_symbols = 'fancy' " Powerline

" set colorcolumn=140
"set cursorline " shows the horizontal cursor line

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

nnoremap <F3> :set hlsearch!<CR>
nnoremap <F2> :w<CR>
nnoremap <F10> :q<CR>

au BufRead,BufNewFile *.qml set filetype=qml
au! Syntax qml source ~/.vim/syntax/qml.vim

" A new Vim package system
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()

let NERDTreeShowHidden=1   " show hidden files in NERDTree plugin
:nmap \e :NERDTreeToggle<CR>

" gvim specific settings (launch)
if has("win32") 
    set lines=50
    set columns=140
    set clipboard=unnamed " integrate with windows clipboard
endif


" setting font with cyryllic support in gvim for windows
if !has("gui gtk2") && !has("gui kde")
   set guifont=Lucida_Console:h14:cANSI
endif

" setting proper gui font for Mac
if has("unix")
    let s:uname = system("uname")
    if s:uname == "Darwin\n"
        set guifont=Consolas:h14
    endif
endif

" create dir on file saving if doesn't exist
function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

" change working dir to the current file path (only for the current buffer)
autocmd BufEnter * silent! lcd %:p:h

