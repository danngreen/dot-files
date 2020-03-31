set nocompatible
filetype off

let g:python3_host_prog = '/usr/local/bin/python3'

call plug#begin('~/.vim/bundle')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'ericcurtin/CurtineIncSw.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'majutsushi/tagbar'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'amix/open_file_under_cursor.vim'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-commentary'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'thaerkh/vim-workspace'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'tpope/vim-fugitive'
Plug 'flazz/vim-colorschemes'
Plug 'ajh17/VimCompletesMe'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
call plug#end()
set rtp+=/usr/local/opt/fzf
set runtimepath^=~/.vim/bundle/ctrlp.vim

"Shortcut Keys
"-------------
let mapleader = ","

nnoremap <esc> :noh<CR>
vnoremap <esc> <esc>
inoremap <esc> <nop>
inoremap jk <esc>
inoremap jj <esc>
"Repeat last macro
noremap Q @@

" Searching
" ---------
" Replace all occurances of word under cursor (s = ask for conf., S = don't)
nnoremap <leader>r *Nyiw:%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
nnoremap <leader>R *N:%s/\<<C-r><C-w>\>//g<Left><Left>
" Replace visual selection (works with any characters, even / and \. 
" (r = ask for conf. R = don't ask)
vnoremap <leader>r y:%s/\V<C-R>=escape(@",'/\')<CR>//gc<Left><Left><Left>
vnoremap <leader>R y:%s/\V<C-R>=escape(@",'/\')<CR>//g<Left><Left>

"Fuzzy search for a file
noremap <F3> :Files<CR>
noremap <leader><F3> :Files<space>

"Search all files for selected text
nnoremap <F4> :Ag <C-r><C-w><CR>
vnoremap <F4> :<C-u>Ag <C-r><C-w><CR>

" Buffer Navigation
" -----------------

" Close the current buffer and move to the previous one
nmap <leader>w :bp <BAR> bd #<CR>

nmap <leader>T :enew<cr>

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

noremap <M-C> "+y
noremap <M-X> "+d
noremap <D-E> "+y
"Settings
"--------
set ts=4
set sw=4
set hlsearch
set number
set hidden
set mouse=a
set splitright

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
let g:airline_theme = 'dgmolokai'
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

