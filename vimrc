" ---------------- vim-plug plugins (start) -------------------
call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
"Plug 'ctrlpvim/ctrlp.vim' " replaced by fzf
Plug 'godlygeek/tabular'
Plug 'tpope/vim-markdown'
Plug 'suan/vim-instant-markdown'
Plug 'tmhedberg/matchit'
" Plug 'mileszs/ack.vim'
Plug 'rking/ag.vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'ntpeters/vim-better-whitespace'
Plug 'jlanzarotta/bufexplorer'
Plug 'tpope/vim-vinegar'
Plug 'vim-syntastic/syntastic'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'neomake/neomake' " asynchronous make
Plug 'nathanaelkane/vim-indent-guides'
" Plug 'Valloric/MatchTagAlways' causes errors on startup in html files
Plug 'gregsexton/MatchTag'

" Auto closing brackets
Plug 'jiangmiao/auto-pairs'

"Tag list
Plug 'vim-scripts/taglist.vim'
Plug 'majutsushi/tagbar'

"Debugging with gdb
" Plug 'vim-scripts/Conque-GDB'
" Plug 'cpiger/NeoDebug'


" R support
" Plug 'vim-scripts/Vim-R-plugin'

" Frontend development
Plug 'mattn/emmet-vim'
Plug 'othree/html5.vim'
Plug 'alvan/vim-closetag' " closes tags (except some html single tags)
Plug 'leafgarland/typescript-vim'
Plug 'posva/vim-vue'
" Asynchronous lint engine (allows to use prettier, eslint and others)
Plug 'dense-analysis/ale'
" Plug 'jaxbot/browserlink.vim' " live preview --> disabled since cause write,
" problem with python3 binding
"Plug 'fholgado/minibufexpl.vim'
""tmux
Plug 'christoomey/vim-tmux-navigator'

" colorschemes
Plug 'chriskempson/base16-vim'
Plug 'lifepillar/vim-solarized8'
Plug 'altercation/vim-colors-solarized'
Plug 'navarasu/onedark.nvim'

" Goyo for writing (text in center + padding)
Plug 'junegunn/goyo.vim'

" Deoplete autocompletion
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
  Plug 'zchee/deoplete-jedi'
endif

Plug 'fishbullet/deoplete-ruby'
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
Plug 'zchee/deoplete-clang'
Plug 'Shougo/neoinclude.vim' " completion for c files from included header files
Plug 'Shougo/neco-syntax' " completion source for deoplete for languages included in VIM by default

call plug#end()
" ---------------- vim-plug plugins (start) -------------------

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GENERAL SETTINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible              " be iMproved, required
set encoding=utf8

scriptencoding utf-8     " set default script encoding
syntax on                " enable syntax processing

set autoread             " If file was changed outside of vim (but not inside)
                         " it is automatically loaded (buffer is refresehd)

set tabstop=2            " number of visual spaces per TAB character
set softtabstop=2        " number of spaces in tab when editing
set shiftwidth=2         " size of indentation
set expandtab            " tabs are replaced by spaces

set number               " shows line numbers
set showcmd              " shows last command in bottom bar
set cursorline           " highlight current line
set wildmenu             " shows visual autocomplete options for command menu

set lazyredraw           " redraw only when needed (not in macros)
set showmatch            " highlight matching [{()}]

set incsearch            " search as characters are entered
set hlsearch             " highlight matches
set ignorecase           " do not distinguish upper and lowercase when searching

set foldenable           " enable folding
set foldlevelstart=10    " open most folds by default (10+ will be folded)
set foldnestmax=10       " 10 nested fold max
set foldmethod=indent    " fold is based on indent level

set colorcolumn=80       " Highligts column 80

"set clipboard=unnamedplus " Use system clipboard for yanking

set autoindent
filetype indent on          " load filetype-specific indent files (.vim/indent)

set hidden               " Edited tab cen be also hidden without saving
set confirm              " Ask user when quiting and there is modified buffer

set wrap                 " visual wrapping only (no CR character included)
set linebreak            " do not break word when wrapping
set showbreak=+          " adds + one the begging of line in wrapped lines
"set tw=xxx              " automatic wrapping at column xxx (includes CR char)

set splitbelow           " create horizontal splits below current window
set splitright           " create vertical split right from current window

set exrc   " Allows vim to source additional vimrc from working directory
           " NOTE: nvim sources only: .nvimrc ._nvimrc and .exrc (not the
           " .vimrc!)
set secure " This disables some potentionaly dangerous commands to be executed in project specific vimrc


" Ignore *.o files in expansion (used by CTRL-P plugin as well)
"set wildignore+=*.so,*.o


" Show powerline even if splits are not used
set laststatus=2

" Spelllang settins
set spelllang=en,cs

" Fix E command to open Explore (syntastic plugin overrides E)
" so without the fix vim don't know how to interpret E since there is a
" conflict
command! E Ex

" ------------- colorscheme settings

" disabled colorscheme settings:
let base16colorspace=256  " Access colors present in 256 colorspace"
"set t_Co=256 " Explicitly tell vim that the terminal supports 256 colors"
"execute "set background=".$BACKGROUND
"execute "colorscheme ".$THEME."-".$BACKGROUND
"colorscheme base16-solarized-dark
" set bg=dark
"
set termguicolors "This breaks some simple colorschemes, but makes other work properly

colorscheme onedark


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGIN SPECIFIC SETTINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:fzf_layout = { 'down': '~60%' }


" deoplete ternjs configuration
"enable deoplete at startup
let g:deoplete#enable_at_startup = 1
" Whether to include the types of the completions in the result data. Default: 0
let g:deoplete#sources#ternjs#types = 1
" Whether to include documentation strings (if found) in the result data.
let g:deoplete#sources#ternjs#docs = 1
" Whether to use a case-insensitive compare between the current word and
" potential completions. Default 0
let g:deoplete#sources#ternjs#case_insensitive = 1

" see https://github.com/carlitux/deoplete-ternjs/issues/88 otherwise i get
" erros
call deoplete#custom#option('num_processes', 4)
call deoplete#custom#option({ 'auto_complete_delay': 200, 'smart_case': v:true, 'ignore_case': v:true , 'refresh_always': v:true, 'camel_case': v:true})
let g:tern_request_timeout = 1
let g:tern_request_timeout = 6000

" Whether to ignore the properties of Object.prototype unless they have been
" spelled out by at least two characters. Default: 1
let g:deoplete#sources#ternjs#omit_object_prototype = 0

" Deoplete clang
let g:deoplete#sources#clang#include_default_arguments = 'True'


" Tagbar
let g:tagbar_sort = 0 " --> do not sort tags by name

" Airline config
let g:airline_powerline_fonts = 1                " use powerline look
let g:airline_theme = 'base16'                   " use base16 theme for airline
let g:airline#extensions#tabline#enabled = 1     " enable the list of buffers
let g:airline#extensions#tabline#fnamemod = ':p:.' " show just the filename

" NerdTree config
let g:NERDTreeHijackNetrw=1    " use NERDTree as default folder explorer?

" Disable vim instant markdown autostart (do not open browse automatically on
" opening *.md file)
let g:instant_markdown_autostart = 0


" Asynchronous lint engine
" (enable prettier and eslint fixers
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'eslint'],
\   'vue': ['remove_trailing_lines', 'trim_whitespace']
\}

let g:ale_fix_on_save = 1
let g:ale_linter_aliases = {'vue': ['javascript', 'html', 'scss']}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" KEYBINDINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" This changes naviagation so that j and k keys goes down or up by 1 visual
" line not one linebreak!
nnoremap j gj
nnoremap k gk

map <C-n> :NERDTreeToggle<CR>
map <silent> <C-p> :FZF<CR>

imap <C-k> :Git commit<CR>
nmap <C-k> :Git commit<CR>
"map <C-u> :Git push<CR> " conflict"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM SHORTCUTS AND COMMANDS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" write as root
noremap <Leader>W :w !sudo tee % > /dev/null
:command! Writemode colorscheme base16-solarized-light | setlocal spell | Goyo
:command! Codemode colorscheme base16-solarized-dark | set nospell | Goyo!
:command! NormalMode Codemode


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FILETYPE SPECIFIC SETTINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" auto wrap for git commit message
autocmd Filetype gitcommit setlocal spell textwidth=72

" Set 2 spaces indentation for YAML,html,css files:
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType java setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType ruby setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType c setlocal ts=4 sts=4 sw=4 expandtab

" Open writemode automatically for txt files
"autocmd FileType text :Writemode
