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
"Plug 'bfrg/vim-qf-preview'
Plug 'ajh17/VimCompletesMe'
Plug 'dr-kino/cscope-maps'
Plug 'rhysd/vim-clang-format'
Plug 'dense-analysis/ale'
Plug 'mhinz/vim-signify'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
call plug#end()
set rtp+=/usr/local/opt/fzf
set runtimepath^=~/.vim/bundle/ctrlp.vim

set exrc
set secure

let g:vcm_default_maps = 0
imap <c-space>   <plug>vim_completes_me_forward

"Shortcut Keys
"-------------
let mapleader = ","

nnoremap <space> :noh<CR>
inoremap jk <esc>
inoremap jj <esc>
"Repeat last macro
noremap Q @@
"Sensible Yank whole line with Y, like D
noremap Y y$

" Cursor in Insert mode
let &t_SI = "\e[5 q"
let &t_EI = "\e[2 q"

" optional reset cursor on start:
augroup myCmds
	au!
	autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END

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

"Search all files for selected text
"   :Ag  - Start fzf with preview window that can be disabled with "?" key
"   :Ag! - Start fzf in fullscreen and display the preview window above
" 	:Ags and Ags! - Case-sensitive versions
"   :Files and Files! - search directory given by argument ,for example, :Files ../otherproject
command! -bang -nargs=* Ags
	\ call fzf#vim#ag_raw('-s '. <q-args>,
	\                 <bang>0 ? fzf#vim#with_preview('up:60%')
	\                         : fzf#vim#with_preview('right:50%', '?'),
	\                 <bang>0)

command! -bang -nargs=* Ag
	\	call fzf#vim#ag(<q-args>,
	\       <bang>0 ? fzf#vim#with_preview('up:60%')
	\               : fzf#vim#with_preview('right:50%', '?'),
	\       <bang>0)

nnoremap <F4> :Ag<CR>
nnoremap <F16> :Ag <C-r><C-w><CR>
vnoremap <F16> :<C-u>Ag <C-r><C-w><CR>
nnoremap <leader><F4> :Ags <C-r><C-w><CR>
vnoremap <leader><F4> :<C-u>Ags <C-r><C-w><CR>

" command! -bang -complete=dir -nargs=* LS
"     \ call fzf#run(fzf#wrap({'source': 'fd --type f --type l --hidden --follow --no-ignore --exclude .git --exclude .ccls-cache', 'dir': <q-args>}, <bang>0))

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
nnoremap <leader>h <C-W>v:call CurtineIncSw()<CR>

noremap <F9> :set list!<CR>
"Tags
nnoremap <F11> :TagbarToggle<CR>
"<F23> is Shift+<F11>
nnoremap <F23> :Dispatch! ctags -R .<CR>:Dispatch! cscope -bkqR<CR>

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

"Building
"nnoremap <leader>b :silent make<CR>:cw<CR>
nnoremap <leader>m :wa<CR>:Make<CR>
nnoremap <leader>M :wa<CR>:Dispatch ccache make -f tests/Makefile<CR>

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
set magic 				" For regular expressions turn magic on

" Airline
" -------
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline_highlighting_cache = 1
let g:airline_section_x=airline#section#create(['']) "Disable displaying current function name (I find it distracting)
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
if has("nvim")
	set termguicolors
endif
set guifont=Roboto_Mono_Light_for_Powerline:h13
hi NonText guibg=black
hi Normal guibg=black
hi LineNr guibg=black
hi Search guibg=#DDAA00 guifg=black
hi Visual guibg=#803D3D
hi MatchParen term=bold cterm=bold gui=bold guibg=#446644 guifg=NONE
hi Function guifg=#22EEA6
hi cCustomFunc guifg=#A6EE22 gui=bold
hi comment guifg=#999999

set incsearch
if has("nvim")
	set inccommand=nosplit
	set listchars=eol:⏎,tab:\|\ ,trail:*,nbsp:⎵,space:.
endif
hi Whitespace guifg=grey50 gui=none

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

" ALE / Clang-tidy
" ------------
let g:ale_linters = {'c' : ['clangtidy']}
let g:ale_linters = {'cpp' : ['clangtidy']}
let g:ale_c_parse_compile_commands = 1
let g:ale_c_clangtidy_checks = ['clang-analyzer-*,bugprone-*,performance-*,readability-*']
let g:ale_cpp_clangtidy_checks = ['clang-analyzer-*,bugprone-*,performance-*,readability-*']
let g:ale_cpp_gcc_executable = ['arm-none-eabi-gcc']
"only run manually, no automatic linting
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 0
let g:ale_lint_on_filetype_changed = 0

" Clang-format
" ------------
let g:clang_format#auto_format = 0
let g:clang_format#detect_style_file = 1
let g:clang_format#enable_fallback_style = 1
let g:clang_format#style_options = {
			\ "BasedOnStyle" : "LLVM",
            \ "AccessModifierOffset" : "-4",
            \ "AllowShortIfStatementsOnASingleLine" : "true",
			\ "AllowShortBlocksOnASingleLine" : "Always",
            \ "AlwaysBreakTemplateDeclarations" : "true",
			\ "BreakBeforeBraces" : "Stroustrup",
            \ "Standard" : "c++14",
			\ "IndentCaseLabels" : "true",
			\ "IndentPPDirectives" : "BeforeHash",
			\ "IndentWidth" : 2,
			\ "ColumnLimit" : 120,
			\ "BreakConstructorInitializers" : "BeforeComma",
			\ "BreakInheritanceList" : "BeforeComma",
			\ "SpaceBeforeInheritanceColon" : "true",
			\ "SpaceBeforeCtorInitializerColon" : "true",
			\ "SpaceBeforeAssignmentOperators" : "true",
			\ "SpaceAfterTemplateKeyword" : "false",
			\ "SpaceAfterCStyleCast" : "false",
			\ "SpaceBeforeParens" : "ControlStatements",
			\ "SpaceBeforeRangeBasedForLoopColon" : "true",
			\ "SpaceInEmptyParentheses" : "false",
			\ "SpacesInAngles" : "false",
			\ "SpacesInCStyleCastParentheses" : "false",
			\ "UseTab" : "Always",
			\ "TabWidth" : 2
			\}

augroup commentary_c_cpp
	autocmd!
	autocmd FileType c setlocal commentstring=//%s
	autocmd FileType cpp setlocal commentstring=//%s
augroup END

augroup commentary_php
	autocmd!
	autocmd FileType php setlocal commentstring=//%s
augroup END

" augroup qfAlwaysBottom
" 	autocmd!
" 	  autocmd FileType qf if (getwininfo(win_getid())[0].loclist != 1) | wincmd J | endif
" augroup END

augroup kicad_lib_filetype
	autocmd!
	autocmd BufNewFile,BufRead *.lib set syntax=none
augroup END

" augroup qfpreview
"     autocmd!
"     autocmd FileType qf nmap <buffer> p <plug>(qf-preview-open)
" augroup END

"set makeprg=ccache\ bear\ make\ -j16
set makeprg=bear\ make\ -j16

set wildmenu
set wildignore+=tags,tags.*,build/*,tests/*
let &path.="src,include,tests,inc,src/drivers,src/util,src/processors"

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

set cmdheight=2
set updatetime=300
set signcolumn=yes

"Coc
"
""Completion
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

inoremap <silent><expr> <c-space> coc#refresh()

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  "autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

