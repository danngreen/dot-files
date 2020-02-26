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
"Plugin 'kcsongor/vim-tabbar.git'

call vundle#end()
set rtp+=/usr/local/opt/fzf
"
"vim-tabbar plugin:
"set tabline=%!tabbar#tabline()

filetype plugin indent on


" Display
" -------
colors molokai
set guifont=Menlo_Regular:h12

" Syntax
" ------
syntax on

"octol/vim-cpp-enhanced-highlight
"--------------------------------
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


"Shortcut Keys
"-------------
let mapleader = ","

"By number
noremap <F1> :ls<CR>:buffer#
noremap <S-F1> :ls<CR>:sp#
noremap <A-F1> :ls<CR>:vsp#

"By name
noremap <F2> :ls<CR>:b<space>
noremap <S-F2> :ls<CR>:sb<space>
noremap <A-F2> :ls<CR>:vert sb<space>
noremap <S-A-F2> :ls<CR>:vert belowright sb<space>

noremap <F3> :Files<space>
noremap <F12> :NERDTreeToggle<CR>
"
"Option-Tab : toggle .h and .c
noremap  :call CurtineIncSw()<CR> 

noremap <F11> :TagbarToggle<CR>
noremap <S-F11> :!ctags -R .<CR>

nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>
noremap <leader>vs :source ~/.vimrc<CR>
noremap <leader>vv :new ~/.vimrc<CR>

let &path.="src,include,tests/,../src,../include,../tests"

set ts=4
set sw=4

set hlsearch

hi MatchParen term=underline cterm=underline guibg=white 
let g:loaded_matchparen=1 

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


