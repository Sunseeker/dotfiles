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
set nowrap " don't wrap lines
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
set nowrap       " wrap long lines
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

set colorcolumn=120 " line to show 120 character mark
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

