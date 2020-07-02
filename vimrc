set nocompatible
filetype off

let g:python3_host_prog = '/usr/local/bin/python3'

call plug#begin('~/.vim/bundle')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

Plug 'ericcurtin/CurtineIncSw.vim'
Plug 'vim-airline/vim-airline'
Plug 'danngreen/vim-airline-themes'
Plug 'majutsushi/tagbar'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'amix/open_file_under_cursor.vim'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'thaerkh/vim-workspace'
Plug 'tpope/vim-fugitive'
Plug 'flazz/vim-colorschemes'
Plug 'bfrg/vim-qf-preview'
Plug 'ajh17/VimCompletesMe'
Plug 'dr-kino/cscope-maps'

let g:vcm_default_maps = 0
imap <c-space>   <plug>vim_completes_me_forward

Plug 'neoclide/coc.nvim', { 'branch': 'release' }
call plug#end()
set rtp+=/usr/local/opt/fzf
set runtimepath^=~/.vim/bundle/ctrlp.vim

"Shortcut Keys
"-------------
let mapleader = ","

nnoremap <esc> :noh<CR>
inoremap jk <esc>
inoremap jj <esc>
"Repeat last macro
noremap Q @@
"Sensible Yank whole line with Y, like D
noremap Y y$

" Searching
" ---------
" Replace all occurances of word under cursor (s = ask for conf., S = don't)
nnoremap <leader>r *Nyiw:%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
nnoremap <leader>R *N:%s/\<<C-r><C-w>\>//g<Left><Left>
" Replace visual selection (works with any characters, even / and \
" (r = ask for conf. R = don't ask)
vnoremap <leader>r y:%s/\V<C-R>=escape(@",'/\')<CR>//gc<Left><Left><Left>
vnoremap <leader>R y:%s/\V<C-R>=escape(@",'/\')<CR>//g<Left><Left>

"Fuzzy search for a file
noremap <F3> :Files<CR>
noremap <leader><F3> :Files<space>


"   :AG  - Start fzf with hidden preview window that can be enabled with "?" key
"   :AG! - Start fzf in fullscreen and display the preview window above
" 	:Ags Case-sensitive
command! -bang -nargs=* Ags
	\ call fzf#vim#ag_raw('-s '. <q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

command! -bang -nargs=* Ag
	\	call fzf#vim#ag(<q-args>,
	\       <bang>0 ? fzf#vim#with_preview('up:60%')
	\               : fzf#vim#with_preview('right:50%:hidden', '?'),
	\       <bang>0)

"Search all files for selected text

nnoremap <F4> :Ag<CR>
nnoremap <F16> :Ag <C-r><C-w><CR>
vnoremap <F16> :<C-u>Ag <C-r><C-w><CR>
nnoremap <leader><F4> :Ags <C-r><C-w><CR>
vnoremap <leader><F4> :<C-u>Ags <C-r><C-w><CR>

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

noremap <F12> :NERDTreeToggle<CR>
noremap <F24> :Vexplore<CR>
let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:netrw_altv = 1
let g:netrw_browse_split = 4

"Option-h : toggle .h and .c: FixMe: doesn't always pick closest counterpart 
noremap <M-h> :call CurtineIncSw()<CR>

"Tags
nnoremap <F11> :TagbarToggle<CR>
"<F23> is Shift+<F11>
nnoremap <F23> :!ctags -R .<CR>:!cscope -bkqR<CR>

nnoremap <F10> :Copen<CR>
nnoremap <F22> :ccl<CR>

nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>
nnoremap <leader>vs :source ~/.vimrc<CR>
nnoremap <leader>vv :edit ~/.vimrc<CR>

"Copy/paste
vnoremap <M-c> "+y
vnoremap <M-x> "+d
nnoremap <leader>l :set norelativenumber<CR>
nnoremap <leader>L :set relativenumber<CR>

"Completion
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

"Building
"nnoremap <leader>b :silent make<CR>:cw<CR>
nnoremap <leader>m :Make<CR>

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
set magic 				" For regular expressions turn magic on
set inccommand=nosplit

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline_highlighting_cache = 1
let g:airline_section_x='' "Disable displaying current function name (I find it distracting)
let g:airline_theme = 'dgmolokai'
let g:airline_powerline_fonts = 1 	"clone and install fonts from https://github.com/powerline/fonts,
" 									 then set iTerm or MacVim font to a font ending in 'for Powerline'

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
hi Search guibg=white guifg=black
hi Visual guibg=#803D3D
hi MatchParen term=bold cterm=bold gui=bold guibg=#446644 guifg=NONE
hi Function guifg=#22EEA6
hi cCustomFunc guifg=#A6EE22 gui=bold
hi comment guifg=#999999

set incsearch
set inccommand=nosplit
set listchars=eol:⏎,tab:\|\ ,trail:*,nbsp:⎵,space:.

"Popup
hi Pmenu guibg=#333333
set completeopt=menu


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
let g:cpp_concepts_highlight = 1
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

augroup commentary_c_cpp
	autocmd!
	autocmd FileType c setlocal commentstring=//%s
	autocmd FileType cpp setlocal commentstring=//%s
augroup END

augroup commentary_php
	autocmd!
	autocmd FileType php setlocal commentstring=//%s
augroup END

augroup qfAlwaysBottom
	autocmd!
	autocmd FileType qf if (getwininfo(win_getid())[0].loclist != 1) | wincmd J | endif
augroup END

augroup kicad_lib_filetype
	autocmd!
	autocmd BufNewFile,BufRead *.lib set syntax=none
augroup END

augroup qfpreview
    autocmd!
	"autocmd QuickFixCmdPost * copen
    autocmd FileType qf nmap <buffer> p <plug>(qf-preview-open)
augroup END

set makeprg=bear\ make

set wildignore+=tags,tags.*,build/*,tests/*
let &path.="src,include,tests,inc,../src,../include,../tests,../inc"

function! <SID>StripTrailingWhitespaces()
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction
nnoremap <leader>T :call <SID>StripTrailingWhitespaces()<CR>

function! SearchMultiLine(bang, ...)
  if a:0 > 0
    let sep = (a:bang) ? '\_W\+' : '\_s\+'
    let @/ = join(a:000, sep)
  endif
endfunction
command! -bang -nargs=* -complete=tag S call SearchMultiLine(<bang>0, <f-args>)|normal! /<C-R>/<CR>

set exrc

set secure
