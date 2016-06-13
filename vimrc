execute pathogen#infect()

set nobackup

set nocompatible
filetype plugin on
filetype on  " Automatically detect file types.
syntax enable

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set scrolloff=3 " 3 lines breathing room on top and bottom of screen
set history=200 " keep 50 lines of command line history

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set incsearch " do incremental searching

set cf                 " Enable error files & error jumping.
set history=256        " Number of things to remember in history.
set autowrite          " Writes on make/shell commands
set nu                 " Line numbers on
set nowrap             " Line wrapping off
set timeoutlen=250     " Time to wait after ESC (default causes an annoying delay)
set rnu

" Formatting (some of these are for coding in C and C++)
set ts=2  " Tabs are 2 spaces
set bs=2  " Backspace over everything in insert mode
set shiftwidth=2  " Tabs under smart indent
set nocp incsearch
set cinoptions=:0,p0,t0
set cinwords=if,else,while,do,for,switch,case
set formatoptions=tcqr
set cindent
set autoindent
set smarttab
set expandtab

" Visual
set showmatch    " Show matching brackets.
set mat=5        " Bracket blinking.
set novisualbell " No blinking .
set noerrorbells " No noise.
set vb           " No audible bell
set listchars=tab:>-,trail:.,precedes:<,extends:>
set list

" Window switching  turned off, C-h/j/k/l is mapped by tmux-navigation
noremap <C-w>h ""
noremap <C-w>j ""
noremap <C-w>k ""
noremap <C-w>l ""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2        " Always show status line.
set statusline=%f       "tail of the filename
set statusline+=%#warningmsg#
set statusline+=%*
set statusline+=%h      "help file flag
set statusline+=%y      "filetype
set statusline+=%m      "modified flag
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%{fugitive#statusline()}
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set laststatus=2
set cursorline

" the leader character
let mapleader = ","
noremap \ ,

command! W :w
command! Q :q

" Backups & Files
set backup                   " Enable creation of backup file.
set backupdir=~/.vim/backups " Where backups will go.
set directory=~/.vim/tmp     " Where temporary files will go.

set showtabline=2
set hlsearch

"mark syntax errors with :signs
let g:syntastic_enable_signs=1

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Auto-apply changes to vimrc
  autocmd bufwritepost .vimrc source $MYVIMRC
  
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  autocmd BufReadPost *.raml set syntax=yaml

  autocmd FileType python     set omnifunc=pythoncomplete#Complete
  autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType html       set omnifunc=htmlcomplete#CompleteTags
  autocmd FileType css        set omnifunc=csscomplete#CompleteCSS
  autocmd FileType xml        set omnifunc=xmlcomplete#CompleteTags
  autocmd FileType php        set omnifunc=phpcomplete#CompletePHP
  autocmd FileType c          set omnifunc=ccomplete#Complete
  autocmd FileType ruby       set omnifunc=rubycomplete#Complete
  augroup END
else
  set autoindent		" always set autoindenting on
endif " has("autocmd")

nnoremap <Space> za

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PROMOTE VARIABLE TO RSPEC LET
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\)\s*=\s*\(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
:map <leader>p :PromoteToLet<cr>

" arrow-keys disabled in normal and visual mode
noremap  <Up> ""
noremap  <Down> ""
noremap  <Left> ""
noremap  <Right> ""

" indetiting text in visual mode leaves editor in visual mode
vmap > >gv
vmap < <gv
vmap <Tab> >gv
vmap <S-Tab> <gv

nmap <leader>wv :tabedit $MYVIMRC<CR>
nmap <leader>ww :tabedit $HOME/notes<CR>

au BufNewFile,BufRead Guardfile set filetype=ruby
au BufNewFile,BufRead *.hamlc   set filetype=haml

set updatetime=4000
let g:cssColorVimDoNotMessMyUpdatetime = 1

" Rooter - set project root
" map <silent> <unique> <leader>H <Plug>RooterChangeToRootDirectory

" Script execution
map <leader>rr :w<CR>:exe ":!ruby " . getreg("%") . "" <CR>

" File Navigation
" expand %% to the current file's path in command mode
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" map <leader>e :edit %%
" map <leader>v :view %%
" switching between last two files
nnoremap <leader><leader> <c-^>

" Rails Commands/Navigation
autocmd User Rails Rnavcommand serializer app/serializers -suffix=_serializer.rb

map <leader>m :Rmodel
map <leader>c :Rcontroller
map <leader>v :Rview
map <leader>s :Rserializer

map <leader>gr :topleft :split config/routes.rb<cr>
map <leader>gg :topleft 100 :split Gemfile<cr>

" Show the current routes in the split
function! ShowRoutes()
  " Requires 'scratch' plugin
  :topleft 100 :split __Routes__
  " Make sure Vim doesn't write __Routes__ as a file
  :set buftype=nofile
  " Delete everything
  :normal 1GdG
  " Put routes output in buffer
  :0r! rake -s routes
  " Size window to number of lines (1 plus rake output length)
  :exec ":normal " . line("$") . "_ "
  " Move cursor to bottom
  :normal 1GG
  " Delete empty trailing line
  :normal dd
endfunction
map <leader>gR :call ShowRoutes()<cr>

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
map <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>
map <leader>D :NERDTree $HOME/Projects<CR>

" Duplicate a selection
" Visual mode: D
vmap D y'>p

" For Haml
au! BufRead,BufNewFile *.haml         setfiletype haml

" No Help, please
nmap <F1> <Esc>

" Press ^F from insert mode to insert the current file name
imap <C-F> <C-R>=expand("%")<CR>

" Press Shift+P while in visual mode to replace the selection without
" overwriting the default register
vmap P p :call setreg('"', getreg('0')) <CR>

" Edit routes
command! Rroutes  :e config/routes.rb
command! RTroutes :tabe config/routes.rb
command! RSroutes :split config/routes.rb

" Local config
if filereadable(".vimrc.local")
  source .vimrc.local
endif

" Color scheme
if has('gui_running')
  set background=light
else
  set background=dark
endif
colorscheme solarized

" highlight long lines
set colorcolumn=100

" Numbers
set number
set numberwidth=5

" Snippets are activated by Shift+Tab
let g:snippetsEmu_key = "<S-Tab>"

" Tab completion options
set completeopt=longest,menu
set wildmenu
set wildmode=full
set wildignore=vendor/bundle
set complete=.,t

" case only matters with mixed case expressions
set ignorecase
set smartcase

" Add recently accessed projects menu (project plugin)
set viminfo^=!

" alt+n or alt+p to navigate between entries in QuickFix
map <silent> <m-p> :cp <cr>
map <silent> <m-n> :cn <cr>

set runtimepath^=~/.vim/bundle/ctrlp
