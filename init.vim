call plug#begin()
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'jacoborus/tender.vim'
Plug 'kyoz/purify', { 'rtp': 'vim' }
Plug 'sainnhe/sonokai'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'danilo-augusto/vim-afterglow'
Plug 'junegunn/goyo.vim'
Plug 'psf/black', { 'branch': 'stable' }
Plug 'z0mbix/vim-shfmt', { 'for': 'sh' }
Plug 'junegunn/vim-emoji'
Plug 'ryanoasis/vim-devicons'
call plug#end()

" Key Mappings {{{
vnoremap <C-c> "+y
"imap <C-v> <Esc>"+pi
nmap <F6> :NERDTreeToggle<CR>
map <F7> :e $MYVIMRC<CR>
map <F5> :source $MYVIMRC<CR>

" Write & quit on all tabs, windows
map <F9> :wqa<CR>

" Move lines up/down using Shift + ↑ ↓ 
nnoremap <S-k> :m-2<CR>==
nnoremap <S-j> :m+<CR>==
inoremap <A-k> <Esc>:m-2<CR>==gi
inoremap <A-j> <Esc>:m+<CR>==gi

" Move a block/range of lines {{{
vnoremap <S-J> :m '>+1<CR>gv=gv
vnoremap <S-k> :m '<-2<CR>gv=gv 
"}}}
" Resizing windows {{{
nnoremap <A-h> :vertical resize +3<CR>
nnoremap <A-l> :vertical resize -3<CR>
nnoremap <A-k> :resize +3<CR>
nnoremap <A-j> :resize -3<CR>
"}}}
"Use TAB to switch to command mode, backspace for back to normal mode
nnoremap <Tab> :
"Cycle through open buffers
nnoremap <S-Tab> :bn<CR>
" Custom function calls {{{
nnoremap <S-r> :call AddCmdOuput()<CR>
map <F8> :call Toggle_transparent()<CR>
nnoremap <S-l> :call OpenLink()<CR>
"}}}
" Disable arrow keys for good {{{
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>
"}}}
"}}}

" Abbreviations
:iabbrev @@    varshneybhupesh@gmail.com
:iabbrev webs  https://bhupesh-v.github.io

colorscheme sonokai

" Common Settings {{{
set number 
set rnu
set autoindent smartindent
set ts=4
set expandtab
set showcmd
set completefunc=emoji#complete
set spell
set title
set dictionary+=/usr/share/dict/words
set wildignorecase
set wildignore+=*/.git/*,*/site-packages/*,*/lib/*,*/bin/*,*.pyc
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg,*.avi,*.mp4,*.mkv,*.pdf,*.odt
set path+=**
set foldcolumn=2
"set shada="NONE"

"}}}

" netrw configs {{{
" Use v to open file in right window
" Use t to open a file in a new tab
let g:netrw_banner=0         " disable annoying banner
let g:netrw_liststyle=3      " tree view
let g:netrw_browse_split = 2 " Open file in new vertical split
let g:netrw_preview=1
let g:netrw_altv = 1
let g:netrw_winsize = 27     " Fix width to 27%
let g:netrw_special_syntax=1 " Enable special file highlighting
let g:netrw_browsex_viewer= "xdg-open"
"}}}

" airline settings {{{
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#formatter = 'unique_tail'
"}}}

" NERDTRee config {{{
let NERDTreeMinimalUI = 1  " Disable ? etc
let NERDTreeShowHidden=1  "Show hidden files (aka dotfiles)
"}}}

" Ulti snips config {{{
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" }}}

let g:auto_save = 1  " enable AutoSave on Vim startup (vim-auto-save plugin)
" Load my aliases
" Make sure a .vim_env_bash file exists
" Sample: https://github.com/Bhupesh-V/.Varshney/blob/master/.vim_bash_env
let $BASH_ENV = "~/.vim_bash_env"
" Toggle transparent mode
let g:is_transparent = 0

" Auto commands {{{

" Set foldmethod based on file type
augroup FoldMethodType
    autocmd!
    autocmd FileType python,css,javascript,go,html,sh setlocal foldmethod=indent
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" Map CapsLock to Esc (must be X.Org compliant)
au VimEnter * silent! !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
au VimLeave * silent! !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Caps_Lock'

" Set window title on every buffer switch
autocmd bufenter * let &titlestring = "bhupesh on " . buffer_name("%")
"Close NERDTree if its the only open window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"}}}

" My Plugins

" vim-emoji doesn't replace :emoji_string: with the actual emoji by default
" autocmd CompleteDone *  call FixEmoji()
function! FixEmoji()
		"let word = expand('<cWORD>')
        :echom v:completed_item['kind']
        " remove colons :
		" let current_word = word[1:strlen(word)-2]
		" let acemoji = emoji#for(current_word)
		execute "%s/" . expand('<cWORD>') . "/" . v:completed_item['kind'] . "/e"
		" :%s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/ge
		" :normal <C-o>
endfunction

" Toggle transparent mode (make sure this is always below colorscheme setting 
function! Toggle_transparent()
        if g:is_transparent == 0
                hi Normal guibg=NONE ctermbg=NONE
                let g:is_transparent = 1
        else 
                let g:is_transparent = 0 
                set background=dark 
        endif
endfunction 

" Run commands inside the editor & paste output in next line
function! AddCmdOuput()
        " A liner for this can be :
        " nnoremap <S-r> !!sh<CR>

		echo "Executing " . getline(".")[0:3] . " ... "
		let cmd_output = systemlist(getline("."))
		if stridx(cmd_output[0], "command not found") == -1
				call append(line('.'), cmd_output)
		else
				redraw
				echo "⚠️  " . getline(".")[0:3] . ".. not found"
		endif
endfunction

"Open hyper link in current line
function! OpenLink()
        let links = []
        try
                call substitute(getline('.'), 'https*:\/\/[^)\"]*', '\=add(links, submatch(0))', 'g')
                exe "silent! !xdg-open " . links[0]
        catch E684
                echo "No link found :("
                return
        endtry
endfunction

" Return 1 if file is a non-ascii file, otherwise 0
function! IsNonAsciiFile(file)
    let isNonAscii = 1
    let fileResult = system('file ' . a:file)
    " Check if file contains ascii or is empty
    if fileResult =~ "ASCII" || fileResult =~ "empty" || fileResult =~ "UTF"
        let isNonAscii = 0
    endif
    return isNonAscii
endfunction

" Open Binary files in their appropriate viewer
autocmd bufenter *.pdf,*.png,*.gif,*.jpg,*.mpv,*.mkv,*.avi :call OpenNonTextFiles()
function! OpenNonTextFiles()
        let current_file = expand('%')
        if IsNonAsciiFile(current_file) == 1
                execute "silent! !xdg-open " . current_file
                " Switch to next buffer and delete this one
                " Else open a new buffer
                if len(getbufinfo({'buflisted':1})) >= 2
                        execute "bNext"
                        execute "bd " . current_file
                else
                        execute "enew"
                endif
        endif
endfunction

"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
		set termguicolors
endif
