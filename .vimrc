" Allow mouse 
if has('mouse')
    set mouse=a
endif
autocmd VimEnter * echo "Ctr+e: Recent files | Ctr+n: Toggle Tree | F2: Save | F3: Save & Exit | F4: Exit"
set nu rnu
scriptencoding utf-8
set encoding=utf-8
set cindent
set wildmenu
set fileencodings=ucs-bom,utf-8,default
set nomodeline
set printoptions=paper:a4
set ruler
set shiftwidth=4
set shortmess=filnxtToOc
set tabstop=4
set tags=./tags;,tags
" Enable auto indentation custom per file type
filetype plugin indent on
" Set tabs to 4 space chars
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
" Set backspace behavior in insert mode
set backspace=indent,eol,start
" Highlight search results
set hlsearch
" Enable incremental search
set incsearch
filetype plugin indent on
" Automatically install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" before call project#rc()
let g:project_enable_welcome = 1
" if you want the NERDTree integration.
let g:project_use_nerdtree = 1
set rtp+=~/.vim/plugged/vim-project/

call project#rc("~/Code")
"File content Project list
source ~/.vim/plugged/vim-project/prj.txt
""Functions for Project Management
function! RemoveTextWidth(...) abort
  setlocal textwidth=0
endfunction
function! AddSpecToPath(tile) abort
  setlocal path+=spec
endfunction

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" ---------------- < PLUGINS START > ---------------- 

" File Manager
Plug 'preservim/nerdtree' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin' |
            \Plug 'gpanders/vim-oldfiles'

Plug 'quocnho/vim-project'

" Beautiful GUI for Vim
Plug 'morhetz/gruvbox'

" Auto-pairs for brackets and parentheses
Plug 'jiangmiao/auto-pairs'

" Git built-in commands and diff realtime support for Vim
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Unprecise search for the case when you don't know exact name
Plug 'kien/ctrlp.vim'

" Easy Motion - extremely cool thing
Plug 'easymotion/vim-easymotion'

" Generic C, JavaScript and Rust auto-completion; ctags
Plug 'Valloric/YouCompleteMe'

" PHP & Symfony Auto-Completion
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'm2mdas/phpcomplete-extended'
Plug 'm2mdas/phpcomplete-extended-symfony'
Plug 'sniphpets/sniphpets-symfony'
Plug 'qbbr/vim-symfony'

" Automatically add 'use' for classes under cursor
Plug 'arnaud-lb/vim-php-namespace'

" Display tags in a window, ordered by scope
Plug 'majutsushi/tagbar'

" Ultimate solution for snippets in Vim
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Helper functions for creating php snippets
Plug 'sniphpets/sniphpets'

" PHP snippets for Symfony framework
Plug 'sniphpets/sniphpets-symfony'
" Plugin outside ~/.vim/plugged with post-update hook
Plug 'itchyny/lightline.vim'
Plug 'StanAngeloff/php.vim'
Plug 'stephpy/vim-php-cs-fixer'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-commentary'
Plug 'vim-syntastic/syntastic'
Plug 'craigemery/vim-autotag'
Plug 'mattn/emmet-vim'
Plug 'evidens/vim-twig'

Plug 'bun913/min-todo.vim' 
" ---------------- < / PLUGINS END > ---------------- 

" Initialize plugin system
call plug#end()
" Map NERDTree
map <C-n> :NERDTreeToggle<CR>
" Set dark gruvbox theme
colorscheme gruvbox
set background=dark
"vim-php-cs-fixer ----
"(autosave)
autocmd BufWritePost *.php silent! call PhpCsFixerFixFile()

" Give more space for displaying messages.
set cmdheight=2

" Set dark gruvbox theme
colorscheme gruvbox

" Map easy-motions key
map <Leader> <Plug>(easymotion-prefix)
let g:mapleader=','

" Enable auto-completion for phpcomplete
autocmd FileType php setlocal omnifunc=phpcomplete_extended#CompletePHP

" Map tag bar to F8 key
nmap <F8> :TagbarToggle<CR>

" vim-php-namespace: Import classes or functions (add use statements)
function! IPhpInsertUse()
    call PhpInsertUse()
    call feedkeys('a',  'n')
endfunction
autocmd FileType php inoremap <Leader>u <Esc>:call IPhpInsertUse()<CR>
autocmd FileType php noremap <Leader>u :call PhpInsertUse()<CR>

" vim-php-namespace: Make class or function names fully qualified
function! IPhpExpandClass()
    call PhpExpandClass()
    call feedkeys('a', 'n')
endfunction
autocmd FileType php inoremap <Leader>e <Esc>:call IPhpExpandClass()<CR>
autocmd FileType php noremap <Leader>e :call PhpExpandClass()<CR>

" vim-php-namespace: sort existing use statements alphabetically
autocmd FileType php inoremap <Leader>z <Esc>:call PhpSortUse()<CR>
autocmd FileType php noremap <Leader>z :call PhpSortUse()<CR>

" ultisnips: Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<F4>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" ultisnips: If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_php_checkers = ['php']
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_enable_signs=1
" Using jk combination as "esc" key
inoremap jk <esc>
let g:user_emmet_mode='a'    "enable all function in all mode.
" only enable Emmet for certain file types
let g:user_emmet_install_global = 1
autocmd FileType html,css EmmetInstall
let g:gitgutter_git_executable = '/usr/bin/git'
" Get a list of counts of added, modified, and removed lines in the current buffer
function! GitStatus()
  let [a,m,r] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', a, m, r)
endfunction
set statusline+=%{GitStatus()}

let g:gitgutter_max_signs = -1

"Chuyển đổi giữa các hộp kiểm chưa hoàn thành và đã đóng chế độ bình thường
nnoremap <C-x> :ToggleTask<CR>
"Tạo một nhiệm vụ mới trong chế độ chèn
imap <C-x> <ESC>:CreateTask<CR>A
"Lưu các nhiệm vụ đã hoàn thành 
nnoremap <A-x> :ArchiveTasks<CR>
"Đăng ký phím tắt để có thể mở tệp quản lý tác vụ ngay lập tức
nnoremap <Leader>t :tabe ~/todo.md<CR>
"Recent files

nnoremap <leader>q :call OldfilesToggle()<cr>

let g:quickfix_is_open = 0
function! OldfilesToggle()
    if g:quickfix_is_open
        echo 'CTRL+e to Open/Close Recent files'
        cclose
        let g:quickfix_is_open = 0
    else
        Oldfiles
        let g:quickfix_is_open = 1
    endif
endfunction

map <C-e> :call OldfilesToggle()<CR>
let g:oldfiles_blacklist = ['sys']


 " Create Blank Newlines and stay in Normal mode
nnoremap <silent> zj o<Esc>k
nnoremap <silent> zk O<Esc>j
" Jump out quotes to end of line

inoremap <silent><c-space> <Esc>A
inoremap <F2> <esc>:w<cr>
nnoremap <F2> :w<cr>
inoremap <F3> <esc>:wq<cr>               " save and exit
nnoremap <F3> :wq<cr>
inoremap <F4> <esc>:qa!<cr>               " Exit without save.
nnoremap <F4> :qa!<cr>
"===============================

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction
