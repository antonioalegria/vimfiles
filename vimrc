
""
" Antonio Alegria's vimrc
" References:
" - http://github.com/jsvd/configs
" - http://amix.dk/vim/vimrc.html
" - http://mislav.uniqpath.com/2011/12/vim-revisited/
" - https://github.com/ctford/vim-fireplace-easy
""

"""""""""""
" General "
"""""""""""

" choose no compatibility with legacy vi
set nocompatible

" Sets how many lines of history VIM has to remember
set history=700

" Pathogen (plugin manager)
execute pathogen#infect()
call pathogen#helptags()

" Enable filetype plugins + indentation
filetype plugin on
filetype indent on

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","


""""""""""
" VIM UI "
""""""""""

" Always show current position
set ruler

" Show line numbers
set number

" Show matching brackets when text indicator is over them
set showmatch

" Set number of seconds to blink matching bracket
set mat=5

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

" Clear search with the F3 key
nnoremap <F3> :let @/ = ""<CR>


" Display incomplete commands
set showcmd

" Toggle paste mode using F2 key. Also, get visual feedback from it
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Store temporary files in a central spot
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Time to wait after ESC (default causes an annoying delay)
set timeoutlen=60

""""""""""""""""""""
" Colors and Fonts "
""""""""""""""""""""

" Enable syntax highlighting
syntax enable

" Set Monaco 14pt as the GVIM font
if has('gui_running')
  set guifont=Monaco:h14
endif

" Workaround to get Solarized to work in Mac's terminal
let g:solarized_termcolors=256
if $TERM == "xterm-256color"
  set t_Co=256
endif

" Set the dark Solarized scheme
colorscheme solarized
set background=dark

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" color useless whitespace
highlight RedundantWhitespace ctermbg=red guibg=red
match RedundantWhitespace /\s\+$\|\t/

" Set cursor colors for different modes
if &term =~ "xterm\\|rxvt"
  " use an orange cursor in insert mode
  let &t_SI = "\<Esc>]12;orange\x7"
  " use a red cursor otherwise
  let &t_EI = "\<Esc>]12;gray\x7"
  silent !echo -ne "\033]12;gray\007"
  " reset cursor when vim exits
  autocmd VimLeave * silent !echo -ne "\033]112\007"
  " use \003]12;gray\007 for gnome-terminal
endif


""""""""""""""""""""""""""""""""
" Text, tab and indent related "
""""""""""""""""""""""""""""""""

"" Whitespace
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set smarttab                    " Be smart when using tabs
set backspace=indent,eol,start  " backspace through everything in insert mode

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines


""""""""""""""""""""
" Custom Languages "
""""""""""""""""""""
au BufNewFile,BufRead *.pql set filetype=sql


""""""""""""""""""""""""""""""""""
" NERDTree Customization (Janus) "
""""""""""""""""""""""""""""""""""

"
" The following is changed:
" * Use <Leader>n to toggle NERDTree
" * Ignore compiled ruby, python, and java files
" * When opening vim with vim /path, open the left NERDTree to that directory, set the vim pwd, and clear the right buffer
" * In general, assume that there is a single NERDTree buffer on the left and one or more editing buffers on the right
"
"
let NERDTreeIgnore=['\.pyc$', '\.pyo$', '\.rbc$', '\.rbo$', '\.class$', '\.o$', '\~$']

" Default mapping, <leader>n
map <leader>n :NERDTreeToggle<CR> :NERDTreeMirror<CR>

augroup AuNERDTreeCmd
autocmd AuNERDTreeCmd VimEnter * call s:CdIfDirectory(expand("<amatch>"))
autocmd AuNERDTreeCmd FocusGained * call s:UpdateNERDTree()

" If the parameter is a directory, cd into it
function s:CdIfDirectory(directory)
  let explicitDirectory = isdirectory(a:directory)
  let directory = explicitDirectory || empty(a:directory)

  if explicitDirectory
    exe "cd " . fnameescape(a:directory)
  endif

  " Allows reading from stdin
  " ex: git diff | mvim -R -
  if strlen(a:directory) == 0
    return
  endif

  if directory
    NERDTree
    wincmd p
    bd
  endif

  if explicitDirectory
    wincmd p
  endif
endfunction

" NERDTree utility function
function s:UpdateNERDTree(...)
  let stay = 0

  if(exists("a:1"))
    let stay = a:1
  end

  if exists("t:NERDTreeBufName")
    let nr = bufwinnr(t:NERDTreeBufName)
    if nr != -1
      exe nr . "wincmd w"
      exe substitute(mapcheck("R"), "<CR>", "", "")
      if !stay
        wincmd p
      end
    endif
  endif
endfunction

" NERDTree buffer quit with :q
function! NERDTreeQuit()
  redir => buffersoutput
  silent buffers
  redir END
  "                     1BufNo  2Mods.     3File           4LineNo
  let pattern = '^\s*\(\d\+\)\(.....\) "\(.*\)"\s\+line \(\d\+\)$'
  let windowfound = 0

  for bline in split(buffersoutput, "\n")
    let m = matchlist(bline, pattern)

    if (len(m) > 0)
      if (m[2] =~ '..a..')
        let windowfound = 1
      endif
    endif
  endfor

  if (!windowfound)
    quitall
  endif
endfunction
autocmd WinEnter * call NERDTreeQuit()


"""""""""""
" Clojure "
"""""""""""

" ClojureScript support
"autocmd BufRead,BufNewFile *.cljs setlocal filetype=clojure
"
