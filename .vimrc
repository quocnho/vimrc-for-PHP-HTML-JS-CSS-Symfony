" Show line numbers
set nu rnu
set mouse=a
scriptencoding utf-8
set encoding=utf-8
if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim
imap <Nul> <C-Space>
"Move line up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Highlight search results
set hlsearch
syntax on
" Enable incremental search
set incsearch

nnoremap \d :YcmShowDetailedDiagnostic
vmap gx <Plug>NetrwBrowseXVis
nmap gx <Plug>NetrwBrowseX

let &cpo=s:cpo_save
unlet s:cpo_save
set background=dark
set backspace=indent,eol,start
set cindent
set wildmenu
set completeopt=preview,menuone
set cpoptions=aAceFsB
set expandtab
set fileencodings=ucs-bom,utf-8,default,latin1
set nomodeline
set printoptions=paper:a4
set ruler
set shiftwidth=4
set shortmess=filnxtToOc
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set tabstop=4
set tags=./tags;,tags
" vim: set ft=vim :

" https://vi.stackexchange.com/questions/27399/whats-t-te-and-t-ti-added-by-vim-8
" This terminal options were added to vim
let &t_TI = ""
let &t_TE = ""
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

source ~/.vim/plugged/vim-project/prj.txt
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
""Functions for Project Management
function! RemoveTextWidth(...) abort
  setlocal textwidth=0
endfunction
function! AddSpecToPath(tile) abort
  setlocal path+=spec
endfunction
" ---------------- < PLUGINS START > ----------------
call plug#begin('~/.vim/plugged')

Plug 'majutsushi/tagbar'

Plug 'vim-airline/vim-airline'

Plug 'vim-airline/vim-airline-themes'

Plug 'HerringtonDarkholme/yats.vim'

Plug 'Valloric/YouCompleteMe'

Plug 'vim-syntastic/syntastic'

Plug 'osfameron/perl-tags', { 'for': [ 'perl' ] }

Plug 'airblade/vim-gitgutter'

Plug 'tpope/vim-fugitive'

" File Manager
Plug 'preservim/nerdtree' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin' |
            \Plug 'gpanders/vim-oldfiles'
            
Plug 'vim-vdebug/vdebug'
Plug 'quocnho/vim-project'
Plug 'mileszs/ack.vim', { 'on' : 'Ag' }

Plug 'editorconfig/editorconfig-vim'

Plug 'phpactor/phpactor', {'for': 'php', 'tag': '*', 'do': 'composer install --no-dev -o'}

Plug 'craigemery/vim-autotag'



" Auto-pairs for brackets and parentheses
Plug 'jiangmiao/auto-pairs'

" Unprecise search for the case when you don't know exact name
Plug 'kien/ctrlp.vim'

" Automatically add 'use' for classes under cursor
Plug 'arnaud-lb/vim-php-namespace'

" PHP & Symfony Auto-Completion
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'shawncplus/phpcomplete.vim'
Plug 'm2mdas/phpcomplete-extended-symfony'
Plug 'sniphpets/sniphpets-symfony'

" Automatically add 'use' for classes under cursor
Plug 'arnaud-lb/vim-php-namespace'

Plug 'evidens/vim-twig'

Plug 'bun913/min-todo.vim' 

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'benwainwright/fzf-project'

call plug#end()
"===============================END PLUGINS========================================
"set number
"set relativenumber
" Switch to last-active tab
if !exists('g:Lasttab')
    let g:Lasttab = 1
    let g:Lasttab_backup = 1
endif
autocmd! TabLeave * let g:Lasttab_backup = g:Lasttab | let g:Lasttab = tabpagenr()
autocmd! TabClosed * let g:Lasttab = g:Lasttab_backup
nmap <silent> <Leader>` :exe "tabn " . g:Lasttab<cr>
" ============================================
" Phan + vim
" ============================================
" https://github.com/phan/phan/blob/master/plugins/vim/phansnippet.vim
"
" Standalone vim snippet for php and html files.
"
" May conflict with other syntax checking plugins.
" Need to use absolute path to phan_client, or put it in your path (E.g. $HOME/bin/phan_client)
" This is based off of a snippet mentioned on http://vim.wikia.com/wiki/Runtime_syntax_check_for_php

" Note: in Neovim, instead use %m\ in\ %f\ on\ line\ %l
"au FileType php,html setlocal makeprg=~/bin/phan_client\ --daemonize-socket\ /var/run/user/1000/phan.socket
au FileType php,html setlocal makeprg=~/bin/phan_client\ --daemonize-tcp-port\ default
au FileType php,html setlocal errorformat=%m\ in\ %f\ on\ line\ %l,%-GErrors\ parsing\ %f,%-G

au! BufWritePost  *.php,*.html    call PHPsynCHK()

function! PHPsynCHK()
  let winnum =winnr() " get current window number
  " or 'silent make --disable-usage-on-error -l %' in Phan 0.12.3+
  silent make -l %
  cw " open the error window if it contains an error. Don't limit the number of lines.
  " return to the window with cursor set on the line of the first error (if any)
  execute winnum . "wincmd w"
  :redraw!
endfunction

" ============================================
" VimDiff configuration
" ============================================
" Setting default colorscheme for vimdiff
if &diff
    colorscheme default
endif

" ============================================
" Syntastic configuration
" ============================================
" When using 'airline' you should NOT follow the recommendation outlined in
" the |syntastic-statusline-flag| section above to modify your |'statusline'|.
" airline" shall make all necessary changes automatically.
"
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_php_checkers = ['php']
let g:syntastic_enable_perl_checker = 1
let g:syntastic_perl_checkers = ['perl', 'perlcritic'] " Note: remember to install Perl::Critic via CPAN

" ============================================
" YouCompleteMe
" ============================================
" LSP configuration
"
" Note: this is a symlink to my \$HOME/bin folder
"
if !exists("g:ycm_language_server")
    let g:ycm_language_server = []
endif
let g:ycm_language_server += [
\   {
\     'name': 'php',
\     'cmdline': [ '/home/jespinal/bin/phpactor', 'language-server' ], 
\     'filetypes': [ 'php' ],
\   },
\ ]

let g:ycm_collect_identifiers_from_tags_files = 1

" https://github.com/Microsoft/TypeScript/wiki/TypeScript-Editor-Support#vim
if !exists("g:ycm_semantic_triggers")
     let g:ycm_semantic_triggers = {}
endif

let g:ycm_semantic_triggers =  {
  \   'typescript': ['.'],
  \   'c': ['->', '.'],
  \   'objc': ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
  \            're!\[.*\]\s'],
  \   'ocaml': ['.', '#'],
  \   'cpp,cuda,objcpp': ['->', '.', '::'],
  \   'perl': ['->'],
  \   'php': ['->', '::'],
  \   'cs,d,elixir,go,groovy,java,javascript,julia,perl,perl6,python,scala,typescript,vb': ['.'],
  \   'ruby,rust': ['.', '::'],
  \   'lua': ['.', ':'],
  \   'erlang': [':'],
  \ }

" Turning off Hover window by default
let g:ycm_auto_hover=''

" The logging level that YCM and the ycmd completion server use.
" Valid values are the following, from most verbose to least verbose: - debug - info - warning - error - critical
let g:ycm_log_level='critical'

nmap <leader>D <plug>(YCMHover)

" Tweaking the fg and bg colors in color terminals in order
" to have it looking more like ErrorMsg than SpellBad, which
" looks horrible in dark terminals
:hi SyntasticError ctermbg=1 ctermfg=15

" ============================================
" Tabs remaping
" ============================================
" Remaping tabs switching to capital H and capital L
nnoremap H gT
nnoremap L gt

" Using jk combination as "esc" key
inoremap jk <esc>

" ============================================
" Smarty Templates
" ============================================
" site: https://github.com/vim-scripts/smarty.vim
"
au BufRead,BufNewFile *.tpl set filetype=smarty
au Filetype smarty exec('set dictionary=~/.vim/syntax/smarty.vim')
au Filetype smarty set complete+=k

" Enabling Smarty template format for SilverStripe
au BufNewFile,BufRead *.ss set filetype=smarty

" ============================================
" Airline
" ============================================
let g:airline#extensions#tagbar#enabled=1
let g:airline#extensions#tagbar#flags='f'  " show function name in status bar
let g:airline#extensions#gutentags#enabled = 1

" ============================================
" Airline Theme
" ============================================
let g:airline_theme='angr'

" ============================================
" Tagbar
" ============================================
let g:tagbar_ctags_bin='~/bin/ctags'

" Typescript ctags support
let g:tagbar_type_typescript = {
  \ 'ctagstype': 'typescript',
  \ 'kinds': [
    \ 'c:classes',
    \ 'n:modules',
    \ 'f:functions',
    \ 'v:variables',
    \ 'v:varlambdas',
    \ 'm:members',
    \ 'i:interfaces',
    \ 'e:enums',
  \ ]
\ }

" ============================================
" Gutentags
" ============================================
"let g:gutentags_ctags_executable = "~/bin/ctags"
"let g:gutentags_trace = 0
"let g:gutentags_project_root = [
"    \ 'hostpapa',
"\]
"
"let g:gutentags_add_default_project_roots = 1
"
"let g:gutentags_ctags_exclude = [
"    \ 'themes/*',
"    \ 'puphpet/*',
"    \ 'vendor/*',
"    \ 'googlesitemaps/*',
"    \ 'minify/*',
"    \ 'Landers/*',
"    \ 'sqlite3/*',
"    \ 'phpunit/*',
"    \ 'framework/thirdparty*',
"    \ 'bootstrap-forms*'
"\]

"============================================
" GitGutter
"============================================
"
" Customizing the signal column:
"
" Note: these colors can be specified as hexadecimal
" values, or as a value from the highlight-ctermbg palette.
" gnome-terminal tends to overwrite the palette with the current
" theme colors
"
" a. Removing the console-terminal-background
" b. Setting additions foreground color green
" c. Setting changes foreground color skyblue
" d. Setting delete to red
"
:hi SignColumn   term=bold ctermbg=NONE
:hi GitGutterAdd term=bold ctermfg=2
:hi GitGutterChange term=bold ctermfg=4
:hi GitGutterDelete term=bold ctermfg=1

let g:gitgutter_git_executable = '/usr/bin/git'

" Get a list of counts of added, modified, and removed lines in the current buffer
function! GitStatus()
  let [a,m,r] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', a, m, r)
endfunction
set statusline+=%{GitStatus()}

let g:gitgutter_max_signs = -1

"============================================
" NERDTree
"============================================
" In order to have NERDTree automatically start when vim starts up
" autocmd vimenter * NERDTree
map <C-n> :NERDTreeToggle<CR>
" ============================================
" Vdebug
" ============================================
if !exists('g:vdebug_options')
    let g:vdebug_options = {}
endif
let g:vdebug_options.port = 9500
let g:vdebug_options.path_maps = {
    \ "/var/www/local.srv.hostpapa/legacy" : "/var/www/html/hostpapa/hplegacy",
    \ "/var/www/local.srv.hostpapa/cms/current" : "/var/www/html/hostpapa/hpcms",
    \ "/var/www/local.srv.oneplan/current/" : "/var/www/html/hostpapa/opsite",
    \ "/var/www/local.srv.support/current/" : "/var/www/html/hostpapa/kbwordpress",
\ }

let g:vdebug_options.break_on_open = 0
let g:vdebug_options.debug_file = "/tmp/vdebug.log"
let g:vdebug_options.debug_file_level = 3
"let g:vdebug_options.vdebug_force_ascii = 1

" :help Vdebug, #VdebugFeatures:
" https://xdebug.org/docs/dbgp#feature-names
"
" The DBGP protocol allows you to set features for debugging, such as the max
" length of data that the debugger returns. You can set these features in the Vim
" dictionary g:vdebug_features, and they will be sent to the debugger when you
" start a new debugging session.
"
" For example:
"    let g:vdebug_features['max_depth'] = 2048
"
" max number of array or object children to initially retrieve
let g:vdebug_features = { 'max_children': 512 }

" ============================================
" Replacement for 'omnifunc'
" ============================================
"
if has("autocmd") && exists("+omnifunc")
autocmd FileType php,html
        \	if &omnifunc == "" |
        \       setlocal omnifunc=phpactor#Complete |
        \	endif
endif

" ============================================
" Ack.vim (configuration needed for _ag_)
" Note: there's a slight modification in ack.vim where I duplicated the
" `command` lines at the end, and changed the handler from Ack to Ag
" (s/Ack/Ag/)
" ============================================
if executable("ag")
    let g:ackprg = "ag --nogroup --nocolor --column"
endif

" ============================================
" Fuzzy Finder: installed via Linuxbrew
" ============================================
set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

let g:fzf_preview_window = ['right:50%', 'ctrl-/']

" ============================================
" Highlight variable under the cursor
" ============================================
" :autocmd CursorMoved * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))

" While typing a search command, show where the pattern, as it was typed so far, matches.
set incsearch
set nohls

" In many terminal emulators the mouse works just fine, use this to enable it
if has('mouse')
    "set mouse=a
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  " autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else
  set autoindent        " always set autoindenting on
endif " has("autocmd")

" vim-php-namespace: sort existing use statements alphabetically
autocmd FileType php inoremap <Leader>z <Esc>:call PhpSortUse()<CR>
autocmd FileType php noremap <Leader>z :call PhpSortUse()<CR>

" ultisnips: Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<F4>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" ultisnips: If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

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
        cclose
        let g:quickfix_is_open = 0
    else
        Oldfiles
        let g:quickfix_is_open = 1
    endif
endfunction

map <C-e> :call OldfilesToggle()<CR>
let g:oldfiles_blacklist = ['.vim','sys']


 " Create Blank Newlines and stay in Normal mode
nnoremap <silent> zj o<Esc>k
nnoremap <silent> zk O<Esc>j
