"" to reload settings in vim use :so ~/.vimrc command

set nu    			    " show line numbers
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
set wrap            " wrap long lines (or set nowrap)
set textwidth=0     " text width for wrapping (0 - physical wrapping is turned off)
set autoindent      " indent at the same level of the previous line
set mouse=a			" automatically enable mouse usage
set nocompatible 		" choose no compatibility with legacy vi
set encoding=utf-8
set showcmd 		    	" display incomplete commands
set viewoptions=folds,options,cursor,unix,slash " better unix / windows compatibility
set virtualedit=onemore 		" allow for cursor beyond last character
set history=1000 				" Store a ton of history (default is 20)
set spell 	 		    		" spell checking on
set tabstop=4 
set shiftwidth=4 " a tab is two spaces (or set this to 4)
set expandtab " use spaces, not tabs
set backspace=indent,eol,start " backspace through everything in insert mode
set backup 			        " backups are nice ...
set undofile			    " so is persistent undo ...
set undolevels=1000 		" maximum number of changes that can be undone
set undoreload=10000 		" maximum number lines to save for undo on a buffer reload
set showmode                " display the current mode
" set colorcolumn=140
"set cursorline " shows the horizontal cursor line

syntax enable
filetype plugin indent on 	" load file type plugins + indentation
colorscheme evening		" Color Scheme

au BufWinLeave * silent! mkview   " make vim save view (state) (folds, cursor, etc)
au BufWinEnter * silent! loadview " make vim load view (state) (folds, cursor, etc)

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

"" Mapping
let mapleader = "," " setting leader to ,

" Enable fancy mode
let g:Powerline_symbols = 'fancy' " Powerline

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
            
" Functional keys mappings
nnoremap <F2>  :w<CR>
nnoremap <F10> :q<CR>
nmap     <F3>  :NERDTreeToggle<CR>
nmap     <F4>  :TagbarToggle<CR>

au BufRead,BufNewFile *.qml set filetype=qml
au! Syntax qml source ~/.vim/syntax/qml.vim

" A new Vim package system
execute pathogen#infect()
execute pathogen#helptags()

let NERDTreeShowHidden=1   " show hidden files in NERDTree plugin

" gvim specific settings (launch)
if has("win32") 
    set lines=50
    set columns=140
    set clipboard=unnamed " integrate with windows clipboard
endif


" setting font with cyryllic support in gvim for windows
if !has("gui gtk2") && !has("gui kde") && has("win32")
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
function! s:MkNonExDir(file, buf)
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

if &diff
    " diff mode
    set diffopt+=iwhite
endif

"Use TAB to complete when typing words, else inserts TABs as usual.
"Uses dictionary and source files to find matching words to complete.

"See help completion for source,
"Note: usual completion is on <C-n> but more trouble to press all the time.
"Never type the same word twice and maybe learn a new spellings!
"Use the Linux dictionary when spelling is in doubt.
"Window users can copy the file to their machine.
"function! Tab_Or_Complete()
"  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
"    return "\<C-N>"
"  else
"    return "\<Tab>"
"  endif
"endfunction
":inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>

" Map ctrl-movement keys to window switching
map <C-k> <C-w><Up>
map <C-j> <C-w><Down>
map <C-l> <C-w><Right>
map <C-h> <C-w><Left>

" Switch to alternate file
map <C-Tab> :bnext<cr>
map <C-S-Tab> :bprevious<cr>

" Save all buffers on VIM focus lost though silently ignore unnamed buffers (those won't be saved)
:au FocusLost * silent! :wa
let g:molokai_original = 1

au FileType go set makeprg=go\ build\ ./...
nmap<F5> :make<CR>:copen<CR>

" regenerate ctags automatically when saving Go source files
au BufWritePost *.go silent! !ctags -R &
