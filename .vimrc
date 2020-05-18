filetype off
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree'
Plug 'easymotion/vim-easymotion'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'

Plug 'editorconfig/editorconfig-vim'

Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'prabirshrestha/asyncomplete-neosnippet.vim'

Plug 'OmniSharp/omnisharp-vim'
Plug 'mattn/emmet-vim'

Plug 'tpope/vim-sleuth'
Plug 'cohama/lexima.vim'
call plug#end()
filetype indent plugin on

" NERDTree Settings
let g:NERDTreeWinPos="bottom"

" Airline Settings
let g:airline_powerline_fonts=1
let g:airline_theme='dark'
" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
if !exists('g:airline_symbols')
	let g:airline_symbols={}
else
	let g:airline_symbols.branch = ''
	let g:airline_symbols.readonly = ''
	let g:airline_symbols.linenr = ''
	let g:airline_symbols.notexists = '∄'
endif
let g:airline_mode_map={
\		'n': 'N',
\		'i': 'I',
\		'R': 'R',
\		'c': 'C',
\		'v': 'V',
\		'V': 'L',
\		'': 'B',
\	}

" color scheme
syntax on
function! DefineHighlights()
	highlight Comment ctermfg=darkgreen guifg=#005f00
	highlight Visual ctermbg=8
	highlight Pmenu ctermbg=237
	highlight PmenuSel ctermbg=240 ctermfg=81
endfunction
augroup cs
	autocmd!
	autocmd ColorScheme * :call DefineHighlights()
augroup END
colorscheme molokai
set t_Co=256
" indent
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
" search
set ignorecase
set smartcase
set hlsearch
set incsearch
set wrapscan
" display row number
set number
" highlight the line where the cursor is
set cursorline
" highlight pair brace
set showmatch
set noexpandtab
set wildmenu
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set backspace=indent,eol,start

set ttimeoutlen=10
" 
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
nnoremap <silent><C-r> :NERDTreeToggle<CR>

" sudo save
cnoremap w!! w !sudo tee > /dev/null %<CR>:e!<CR>

" 
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <C-D> <Del>

" set key bind to cansel highlight
nnoremap <Esc><Esc> :noh<CR>

let mapleader = ";"
" reload .vimrc
nnoremap <Leader>r :source $VIMRC<CR>:noh<CR>

" LSP key binding
augroup LSPSetting
	autocmd!
	autocmd BufWritePre <buffer> LspDocumentFormatSync
augroup END
nnoremap gdf :LspDefinition<CR>
nnoremap gdl :LspDeclaration<CR>
nnoremap gi :LspImplementation<CR>
nnoremap <Leader>df :LspPeekDefinition<CR>
nnoremap <Leader>dl :LspPeekDelcaration<CR>
nnoremap <Leader>i :LspPeekImplementation<CR>
nnoremap <Leader>f :LspDocumentFormat<CR>
nnoremap <Leader>o :LspHover<CR>
nnoremap <Leader>e :LspNextDiagnostic<CR>
nnoremap <Leader>w :LspPreviousDiagnostic<CR>
nnoremap <Leader>n :LspRename<CR>

" EasyMotion settings
" map <Leader> <Plug>(easymotion-prefix)
nmap f <Plug>(easymotion-f2)
nmap F <Plug>(easymotion-F2)
nmap <Leader><Leader>w <Plug>(easymotion-bd-w)
" nnoremap <Leader><Leader>/ /
map / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map n <Plug>(easymotion-next)
map N <Plug>(easymotion-prev)
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)

" Snippet Settings
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)
let g:neosnippet#snippets_directory='${VDOTDIR}/plugged/neosnippet-snippets/neosnippets/,${VDOTDIR}/snippets'

" Emmet Settings
let g:user_emmet_leader_key = '<C-E>'
let g:user_emmet_settings = {
\ 	'variables': {
\ 		'lang': 'ja'
\ 	},
\ 	'html': {
\ 		'indepentation': '	',
\ 		'snippets': {
\ 			'html:5': "<!DOCTYPE html>\n"
\ 				."<html lang=\"${lang}\">\n"
\ 				."<head>\n"
\ 				."\t<meta charset=\"${charset}\">\n"
\ 				."\t<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\n"
\ 				."\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n"
\ 				."\t<title></title>\n"
\ 				."</head>\n"
\ 				."<body>\n\t${child}|\n</body>\n"
\ 				."</html>",
\ 		}
\ 	}
\ }

" do not auto-indent code from clipboard
if &term =~ "xterm"
	let &t_SI .= "\e[?2004h"
	let &t_EI .= "\e[?2004l"
	let &pastetoggle = "\e[201~"

	function XTermPasteBegin(ret)
		set paste
		return a:ret
	endfunction

	inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif
