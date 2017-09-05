" this file has ordered commands for it to work. don't blindly change the order.

" this is a minimal vimrc, to be used with vim in secure mode: no plugins, no
" undo file, etc

" When you Vim finds .vimrc it gets itself into nocompatible mode automatically.
" If it finds .exrc instead or you use -u you need to tell Vim to be in
" nocompatible mode:
set nocompatible

" Lang {{{
language messages en_US.utf8
set langmenu=en_US.utf8
let $LANG = 'en_US.utf8'
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
set spelllang=en,es
set complete+=kspell			" add dictionary words to completion
" }}}

" Filetype & languages {{{
filetype on						" enable filetype detection
filetype indent on				" enable filetype-specific indenting. can conflict with set autoindent smartindent
filetype plugin on				" enable filetype-specific plugins

" C language
let g:c_space_errors = 1
let g:c_comment_strings = 0		" dont highlight strings inside C comments

" Python language
let python_space_errors = 1
augroup python_files
	autocmd!
	autocmd FileType python setl tabstop=8 expandtab shiftwidth=4 softtabstop=4
augroup END

" Java language
let java_space_errors = 1

" Markdown instead of modula2:
augroup markdown_files
	autocmd!
	autocmd BufNewFile,BufReadPost *.md setl filetype=markdown spell textwidth=0 wrapmargin=0
augroup END

" TXT files
augroup txt_files
	autocmd!
	autocmd BufNewFile,BufReadPost *.txt setl spell textwidth=0 wrapmargin=0
augroup END

" Mail files from mutt
augroup mail_files
	autocmd!
	autocmd FileType mail setl nonumber spell textwidth=0 wrapmargin=0
augroup END

" Latex files
let g:tex_flavor = "latex"		" default tex flavour if not specified in the file

" Help files
augroup help_files
	autocmd!
	autocmd filetype help wincmd l	" always open help files in vertical splits
augroup end
" }}}

" Spaces & Tabs {{{
set tabstop=4						" number of visual spaces per TAB
set autoindent smartindent			" copy indent from current line when starting a new line, and smart indent automatically inserts one level of indentation in some cases.
" set listchars=tab:\|·,trail:·,eol:¬	" show tabs, eol and trailing whitespace when showing separators TODO
" set listchars=tab:\ \ ,trail:·		" only show trailing whitespace when showing separators. the tab is 2 spaces
"set list							" show listchars
" }}}

" Line wrap {{{
set wrap							" soft wrap long lines, visually, instead of changing the file
set linebreak						" wrap long lines at characters in 'breakat' rather than at the last character that fits
let &colorcolumn=join(range(81,250),",") " colors columns past 80
set textwidth=80
set formatoptions=tcrql             " t autowrap to textwidth
									" c autowrap comments to textwidth
									" r autoinsert comment leader with <enter>
									" q allow formatting of comments with gq
									" l	Long lines are not broken in insert mode: When a line was longer than 'textwidth' when the insert command started, Vim does not automatically format it.
									" 1	Don't break a line after a one-letter word. It's broken before it instead (if possible).
									" j	Where it makes sense, remove a comment leader when joining lines
" }}}

" Look and feel {{{
set title							" change terminal title
syntax on							" enable syntax processing
"set virtualedit=all				" move the cursor everywhere
set synmaxcol=2048					" prevents huge slow downs from syntax highlighting
set number							" show line numbers
"set relativenumber					" show relative numbers. can be on at the same time that number
set cursorline						" highlight current line

augroup cursorline
	autocmd!
	autocmd winenter * setlocal cursorline		" make cursorline appear only in the focused window  todo: remove if using conoline
	autocmd winleave * setlocal nocursorline
augroup END

set conceallevel=2					" display unicode characters instead of they plaintext counterparts (epsilon, lambda, etc)
" don't change colors of concealed characters:
highlight Conceal ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
set showcmd							" show (partial) command in status line
set wildmenu                        " visual autocomplete for command menu
set wildmode=longest,list,full		" complete longest common string, then list alternatives, then select the sortest first
set cpoptions+=$					" put a '$' at the end of the changed text
set showmatch						" highlight matching brackets
set mouse=a							" enable mouse usage (all modes)
set mousehide						" hide the mouse when typing text
set backspace=indent,eol,start		" allow backspacing over all of that
set ruler                           " show the cursor position and line number at the bar
set lazyredraw						" don't redraw while in macros
set scrolloff=5						" keep at least 5 lines above/below
set sidescrolloff=5                 " keep at least 5 lines left/right
set splitright                      " vertical splits use right half of screen
set splitbelow                      " horizontal splits use bottom half of screen
set noerrorbells					" no sound bells please
set visualbell t_vb=				" no flash screen for the visual bell
if has('autocmd')
	autocmd GUIEnter * set visualbell t_vb=     "redo t_vb= for gui so it takes place
endif
set timeout							" time out on key codes
set ttimeoutlen=500					" the time in milliseconds that is waited for a key code or mapped key sequence to complete

if has("gui_running")
	set guiheadroom=0				" vim padding: fix it in ~/.gtkrc-2.0
	set background=dark             " if using a dark background, for syntax highlighting

	colorscheme wombat256mod
	set guioptions-=T				" remove Toolbar
	set guioptions+=c				" use console dialogs
	set guioptions-=r				" remove right-hand scrollbar
	set guioptions-=R				" remove right-hand scrollbar
	set guioptions-=l				" remove left-hand scrollbar
	set guioptions-=L				" remove left-hand scrollbar

	if has("gui_gtk2")
		"set guifont=Monospace\ 10
		"set guifont=DejaVu\ Sans\ Mono\ 10
		"set guifont=Terminus\ 9
		set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 8
	elseif has("gui_macvim")
		set guifont=Menlo\ Regular:h14
	elseif has("gui_win32")
		set guifont=Consolas:h11:cANSI
	endif
else
	" set t_Co=256					" force number of colors to 256 inside vim. this shouldn't be done, better with TERM
	set background=dark             " if using a dark background, for syntax highlighting
	colorscheme wombat256mod
	highlight ColorColumn ctermbg=234 guibg=#1C1C1C     " colorcolumn for wombat256mod
endif

" colorscheme settings I want to be there even if I change themes:
highlight Comment cterm=italic gui=italic	" put comments in italic (needs to be after your colorscheme) (needs tmux to be correctly set)
highlight String cterm=italic gui=italic	" put comments in italic (needs to be after your colorscheme) (needs tmux to be correctly set)
highlight clear SignColumn					" sets the git gutter to the same color as the number column (needs to be after your colorscheme)

" change cursor to a '|' when on vim console and insert mode:
if &term == 'xterm-256color' || &term == 'rxvt-unicode-256color' || &term == 'screen-256color' || &term == 'screen-256color-it' || &term == 'tmux-256color'
	let &t_SI = "\<Esc>[5 q"
	let &t_EI = "\<Esc>[1 q"
	" urxvt has not implemented the bar cursor until 9.21, if that's the case, use an underbar: let &t_SI = "\<Esc>[3 q"
endif

" netrw:
set isfname+=32										" to open files with spaces
let g:netrw_liststyle=3								" default to tree view (you can rotate netrw views with i)
" Netrw remote transfers
let g:netrw_altv          = 1						" change from left splitting to right splitting
let g:netrw_special_syntax= 1						" highlight certain files (*.bak, *.zip..)
" }}}

" Persistence {{{
" delete the empty buffer that appears on startup:
"autocmd VimEnter * nested if  bufname('')==''  &&  line('$') == 1 &&  col('$')==1 &&  !&modified | bd % | endif

set hidden							" don't mark buffers as abandoned if hidden
set noundofile						" deactivate undo file
set history=0						" deactivate history
" }}}

" Backup and Swap files {{{
set nobackup
set nowritebackup
" }}}

" Searching {{{
set ignorecase						" do case insensitive matching
set smartcase						" overrides ignorecase if uppercase used in search string
set incsearch						" incremental search
set hlsearch						" highlight matches
set wrapscan						" jumps to the beginning if reaching end, and viceversa
" }}}

" Mappings {{{
" make these commonly mistyped commands still work:
command! WQ wq
command! Wq wq
command! Wqa wqa
command! W w
command! Q q

let mapleader = "\<Space>"

" use tab key to cycle through the buffers:
nnoremap <leader><Tab>   :bnext<CR>
nnoremap <leader><S-Tab> :bprevious<CR>

" remap jk and kj to escape:  You'll never type it anyway, so it's great!
inoremap jk <Esc>
inoremap kj <Esc>

" use hjkl-movement between rows when soft wrapping:
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" include the default behaviour by doing reverse mappings so you can move linewise with gj and gk:
nnoremap gj j
nnoremap gk k

" keep the cursor in place when joining lines with J (by dropping a mark and returning there):
nnoremap J mzJ`z

" Y yanks lines from the cursor to the end of the line: (as said in :h Y)
map Y y$

" list of shared binds:
" remove trailing whitespaces:
map <F1> :%s/\s\+$//<CR>

" toggle spell checking:
map <F2> :setlocal spell!<CR>

" close buffer:
map <silent> <F4> <Esc>:bd<CR>

" open urls, files, etc. example: http://google.com:
noremap <F6> :!xdg-open <cfile><CR><CR>
" }}}

" Folding {{{
set foldmethod=syntax
set foldlevel=99
set foldnestmax=10			" max 10 depth
set nofoldenable			" don't fold files by default on open
set foldlevelstart=1		" start with fold level of 1
" }}}

" Launch {{{
set encoding=utf8
set autochdir				" automatically cd into the directory that the file is in (this will break plugins if activated!!!)
set autoread                " watch for file changes
set nomodeline              " dont make vim check beginning and ending lines of files for options. HUGE VULNERABILITY
" }}}

" vim:foldmethod=marker:foldlevel=0
