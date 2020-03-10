set nocompatible
filetype off

let g:python3_host_prog = '/usr/local/bin/python3'
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
"Plugin 'ycm-core/YouCompleteMe'
Plugin 'scrooloose/nerdtree'
Plugin 'ericcurtin/CurtineIncSw.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'majutsushi/tagbar'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'amix/open_file_under_cursor.vim'
Plugin 'junegunn/fzf.vim'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-commentary'
Plugin 'ctrlpvim/ctrlp.vim.git'
Plugin 'thaerkh/vim-workspace.git'
"Plugin 'jeetsukumaran/vim-buffergator.git'
Plugin 'tpope/vim-fugitive.git'
Plugin 'jreybert/vimagit.git'
Plugin 'flazz/vim-colorschemes.git'
Plugin 'ajh17/VimCompletesMe.git'
" Plugin 'ervandew/supertab.git'

call vundle#end()
set rtp+=/usr/local/opt/fzf
set runtimepath^=~/.vim/bundle/ctrlp.vim

filetype plugin indent on

"Shortcut Keys
"-------------
let mapleader = ","

:nnoremap <esc> :noh<CR>
:imap <esc> jk:noh<CR>a
:vnoremap <esc> <nop>
:vnoremap <esc> <esc>
:inoremap jk <esc>
:inoremap jj <esc>

" Searching
" ---------
" Replace all occurances of word under cursor (ask for conf.)
:nnoremap <Leader>s *N:%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
:vnoremap <Leader>s *N:<C-w>%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
" Replace all occurances of word under cursor (don't ask for conf.)
:nnoremap <Leader>S *N:%s/\<<C-r><C-w>\>//g<Left><Left>
:vnoremap <Leader>S *N:<C-w>%s/\<<C-r><C-w>\>//g<Left><Left>

"Fuzzy search for a file
noremap <F3> :Files<CR>
noremap <leader><F3> :Files<space>

"Search all files for selected text
vnoremap <F4> :<C-w>Ag <C-r><C-w><CR>
nnoremap <F4> yiw:Ag <C-r>"

" Buffer Navigation
" -----------------
" Close the current buffer and move to the previous one
nmap <leader>w :bp <BAR> bd #<CR>

"Select a buffer from airline tabline
"Relies on iTerm2 Preferences>Profiles>Keys>Left/Right Option Key = Esc+
nmap <M-1> <Plug>AirlineSelectTab1
nmap <M-2> <Plug>AirlineSelectTab2
nmap <M-3> <Plug>AirlineSelectTab3
nmap <M-4> <Plug>AirlineSelectTab4
nmap <M-5> <Plug>AirlineSelectTab5
nmap <M-6> <Plug>AirlineSelectTab6
nmap <M-7> <Plug>AirlineSelectTab7
nmap <M-8> <Plug>AirlineSelectTab8
nmap <M-9> <Plug>AirlineSelectTab9
nmap <M-TAB> <Plug>AirlineSelectNextTab
nmap <S-TAB> <Plug>AirlineSelectPrevTab
"Another way to select a buffer from airline tabline
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
"Todo: Ctrl-Tilde?
nnoremap <C-`> <Plug>AirlineSelectNextTab

noremap <F12> :NERDTreeToggle<CR>

"Option-h : toggle .h and .c: FixMe: doesn't always pick closest counterpart 
noremap <M-h> :call CurtineIncSw()<CR>

nnoremap <F11> :TagbarToggle<CR>
nnoremap <F23> :!ctags -R .<CR> "Shift + F11

nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>
nnoremap <leader>vs :source ~/.vimrc<CR>
nnoremap <leader>vv :edit ~/.vimrc<CR>

"Copy/paste
noremap <M-C> "+y
noremap <M-X> "+d

"Completion
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

"Building
nnoremap <leader>b :silent make<CR>:cw<CR>

"Settings
"--------
set ts=4
set sw=4
set hlsearch
set number
set hidden
set mouse=a
set splitright
set formatoptions-=r 	" Don't insert comment leader after hitting <Enter>
set formatoptions-=o 	" Dont' insert comment leader after hitting o or O
set formatoptions+=n 	" Format lists

if !&scrolloff
  set scrolloff=3       " Show next 3 lines while scrolling.
endif
if !&sidescrolloff
  set sidescrolloff=5   " Show next 5 columns while side-scrolling.
endif
set nostartofline       " Do not jump to first character with page commands.
set noswapfile                  " Don't use swapfile
set backspace=indent,eol,start  " Makes backspace key more powerful.
set listchars=eol:⏎,tab:\|\ ,trail:*,nbsp:⎵,space:. 


let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline_highlighting_cache = 1
"clone and install fonts from https://github.com/powerline/fonts
"then set MacVim font to a font ending in 'for Powerline'
let g:airline_powerline_fonts = 1

"vim-workspace shouldn't remove trailing spaces: conflicts with exiting Insert
"mode with a (temporary) trailing space in order to paste a buffer, and losing a space
let g:workspace_autosave_untrailspaces = 0 

" Display
" -------
syntax on
colors molokai
set termguicolors
set guifont=Roboto_Mono_Light_for_Powerline:h13
hi NonText guibg=black
hi Normal guibg=black
hi LineNr guibg=black
hi Search guibg=DarkYellow
set listchars=eol:⏎,tab:\|\ ,trail:*,nbsp:⎵,space:. 
hi MatchParen term=bold cterm=bold gui=bold guibg=#446644 guifg=NONE

"Popup
hi Pmenu guibg=#333333
set completeopt=menu


" Comments
autocmd FileType c setlocal commentstring=//%s
autocmd FileType cpp setlocal commentstring=//%s

" Syntax
" ------
"vim-cpp-enhanced-highlight options:
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
"Highlight template functions (can be a little slow on large files)
"let g:cpp_experimental_simple_template_highlight = 1
"Highlight template functions (faster implementation but has some corner cases where it doesn't work.)
let g:cpp_experimental_template_highlight = 1
"Highlighting of library concepts 
"This will highlight the keywords concept and requires as well as all named requirements (like DefaultConstructible) in the standard library.
"let g:cpp_concepts_highlight = 1
"Disable highlighting of user defined functions
"let g:cpp_no_function_highlight = 1

"ctrlP
"-----
" Setup some default ignores
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(png|jpg|jpeg|pdf|o|d|a)$',
\}
" Use nearest .git directory as cwd
let g:ctrlp_working_path_mode = 'r'

" Let clangd fully control code completion
let g:ycm_clangd_uses_ycmd_caching = 0
let g:ycm_clangd_binary_path = exepath("clangd")
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']
let g:ycm_semantic_triggers =  {
\   'c': ['->', '.'],
\   'objc': ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
\            're!\[.*\]\s'],
\   'ocaml': ['.', '#'],
\   'cpp,cuda,objcpp': ['->', '.', '::'],
\   'perl': ['->'],
\   'php': ['->', '::'],
\   'cs,d,elixir,go,groovy,java,javascript,julia,perl6,python,scala,typescript,vb': ['.'],
\   'ruby,rust': ['.', '::'],
\   'lua': ['.', ':'],
\   'erlang': [':'],
\ }
let g:ycm_auto_trigger = 1
noremap <F10> :let g:ycm_auto_trigger=0<CR>
noremap <F22> :let g:ycm_auto_trigger=1<CR> "Shift+F10

let &path.="src,include,tests,inc,../src,../include,../tests,../inc"

function! SearchMultiLine(bang, ...)
  if a:0 > 0
    let sep = (a:bang) ? '\_W\+' : '\_s\+'
    let @/ = join(a:000, sep)
  endif
endfunction
command! -bang -nargs=* -complete=tag S call SearchMultiLine(<bang>0, <f-args>)|normal! /<C-R>/<CR>

" For regular expressions turn magic on
set magic

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>
function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

