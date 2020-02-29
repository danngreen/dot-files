set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'ycm-core/YouCompleteMe'
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
Plugin 'jeetsukumaran/vim-buffergator.git'
Plugin 'tpope/vim-fugitive.git'
Plugin 'flazz/vim-colorschemes.git'

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
:inoremap jk <esc>
:vnoremap jk <esc>

" Searching
" ---------

"Fuzzy search for a file
noremap <F3> :Files<CR>
noremap <leader><F3> :Files<space>

"Search all files for selected text
vnoremap <C-F> y:Ag <C-R>"<CR>

" Buffer Navigation
" -----------------

" Close the current buffer and move to the previous one
nmap <leader>w :bp <BAR> bd #<CR>
nmap <leader>c :bp <BAR> bd #<CR>

nmap <leader>T :enew<cr>
nnoremap <C-W>v :belowright vnew<CR>

"Select a buffer from airline tabline
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader><S-TAB> <Plug>AirlineSelectPrevTab
nmap <leader><TAB> <Plug>AirlineSelectNextTab
"Todo: Ctrl-Tilde?
nnoremap <C-`> <Plug>AirlineSelectNextTab

noremap <F12> :NERDTreeToggle<CR>

"Option-Tab : toggle .h and .c: FixMe: doesn't always work
noremap  :call CurtineIncSw()<CR> 

nnoremap <F11> :TagbarToggle<CR>
nnoremap <S-F11> :!ctags -R .<CR>

nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>
nnoremap <leader>vs :source ~/.vimrc<CR>
nnoremap <leader>vv :edit ~/.vimrc<CR>


"Settings
"--------
set ts=4
set sw=4
set hlsearch
set number
set hidden

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline_highlighting_cache = 1
"clone and install fonts from https://github.com/powerline/fonts
"then set MacVim font to a font ending in 'for Powerline'
let g:airline_powerline_fonts = 1

" Display
" -------
colors molokai
set guifont=Roboto_Mono_Light_for_Powerline:h13

" Syntax
" ------
syntax on

"vim-cpp-enhanced-highlight options:
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
"Highlight template functions (can be a little slow on large files)
let g:cpp_experimental_simple_template_highlight = 1
"Highlight template functions (faster implementation but has some corner cases where it doesn't work.)
"let g:cpp_experimental_template_highlight = 1
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


let &path.="src,include,tests/,../src,../include,../tests"

"hi MatchParen term=underline cterm=underline guibg=white
"let g:loaded_matchparen=1

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

