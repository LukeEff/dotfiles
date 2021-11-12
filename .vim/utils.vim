function! IsMacOS()
  return has('mac')
endfunction

function! IsNeovim()
  return has('nvim')
endfunction

function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
endfunction

function! IsNERDTreeFocused()
  return -1 != match(expand('%'), 'NERD_Tree')
endfunction

function! IsDiffMode()
  return &diff
endfunction

function! IsInsideCwd()
  return -1 != stridx(expand('%:p'), getcwd())
endfunction

function! IsBufferWritable()
  return &modifiable && &buftype == ''
endfunction

function! IsNamedBuffer()
  return strlen(expand('%:t')) > 0
endfunction

function! IsNoBuffer()
  return len(getbufinfo({'buflisted':1})) == 0
endfunction

function! IsOnlyBuffer()
  return len(getbufinfo({'buflisted':1})) == 1
endfunction

function! IsOnlyWindow()
  return winnr("$") == 1
endfunction

function! HasTerminalBuffer()
  return exists(':terminal')
endfunction

function! IsTerminalBuffer()
  return &buftype == 'terminal'
endfunction

function IsCommandLineEditor()
  return bufname('%') == '[Command Line]'
endfunction

function! IsALEPreviewWindow()
  return bufnr('ALEPreviewWindow') == bufnr('%')
endfunction

function! IsCtrlPBuffer()
  return bufname('%') == 'ControlP'
endfunction

function! TabNext()
  if IsNERDTreeFocused() | wincmd l
  elseif IsALEPreviewWindow() | wincmd k | endif
  if !IsNoBuffer() | bnext | endif
  if IsTerminalBuffer() | bnext | endif
endfunction

function! TabPrev()
  if IsNERDTreeFocused() | wincmd l
  elseif IsALEPreviewWindow() | wincmd k | endif
  if !IsNoBuffer() | bprev | endif
  if IsTerminalBuffer() | bprev | endif
endfunction

function! QuitBuffer()
  if IsCommandLineEditor() | call feedkeys("\<c-c>")
  else
    if IsBufferWritable() && IsNamedBuffer() | w | endif
    if IsOnlyBuffer() | q! | else | bd! | endif
    if IsTerminalBuffer() | vs; bprev | endif  " split terminal overtakes window
  endif
endfunction

function! GetLogStatement()
  let ft = &filetype
  if ft == 'sh' | call feedkeys("O\<CR>echo <CR>\<Esc>k$a")
  elseif ft == 'php' | echo feedkeys("O\<CR>error_log(print_r(, true));\<CR>\<Esc>kf,i")
  else | echo feedkeys("O\<CR>console.log();\<CR>\<Esc>kf(a")
  endif
endfunction

function! ToggleRelativeLineNumbers()
  if &relativenumber | set norelativenumber | else | set relativenumber | endif
endfunction

function! SetLeaderCommand(key, description, command)
  let keymap = 'nnoremap'
  if a:command =~ '<Plug>' | let keymap = 'nmap' | endif
  execute keymap . ' <Leader>' . a:key . ' ' . a:command
  let g:leaderGuide_map[a:key] = [a:key, a:description]
endfunction

function! ExecuteInTerminal()
  if !IsTerminalBuffer()

    "use .run file if present
    let filename = fnamemodify(".run", ":p")
    if !filereadable(filename) | let filename = expand("%:p") | endif

    "reuse existing terminal if exists, else create one
    let terms = getbufinfo("!/bin/bash")
    if empty(terms) | let bufnum = term_start(&shell, {"vertical": 1})
    else | let bufnum = terms[0].bufnr | endif

    "send filename to terminal as command
    call term_sendkeys(bufnum, filename . "\<cr>")
    "if empty(terms) | bprev | endif
  endif
endfunction

function! ExitNormalModeInTerminal()
  unmap <buffer> <silent> <RightMouse>
  call feedkeys("a")
endfunction

function! EnterNormalModeInTerminal()
  if IsTerminalBuffer() && mode('') == 't'
    call feedkeys("\<c-w>N")
    call feedkeys("\<c-y>")
    map <buffer> <silent> <RightMouse> :call ExitNormalModeInTerminal()<CR>
  endif
endfunction

function! SyncNERDTreeToOpenBuffers()
  if IsBufferWritable() && IsNERDTreeOpen() && !IsNERDTreeFocused()
	\ && IsNamedBuffer() && !IsDiffMode() && IsInsideCwd()
    NERDTreeFind
    wincmd p
  endif
endfunction

function! ToggleNERDTree()
  if IsCtrlPBuffer() | return | endif
  if IsNERDTreeOpen() | NERDTreeClose
  elseif IsNoBuffer() | NERDTree
  else | NERDTreeFind
  endif
endfunction

function! QuitNERDTreeIfLastBuffer()
  if IsOnlyWindow() && IsNERDTreeOpen() | q | endif
endfunction

function! FetchPluginsIfMissing()
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	  \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endfunction

function! UseDuringSu()
  " Use my vimrc when switching users
  if ! exists("g:realuser")
    let g:realuser=system('w | grep $(ps w | grep ' . getpid()
	  \ . ' | head -n1 | awk "{ print \$2 }") | awk "{ print \$1 }"')
    let g:vimrc=system('printf /home/%s/.vim/vimrc '. g:realuser)
    if filereadable(g:vimrc)
      exec ":let $HOME = '" . system('printf /home/%s '. g:realuser) . "'"
      exec ":let $LOGNAME = '" . system('printf %s '. g:realuser) . "'"
      exec ":source " . g:vimrc
      finish
    endif
  endif
endfunction

function! ListNERDTreeBookmarks()
  return systemlist("cut -sd' ' -f 2 ~/.NERDTreeBookmarks")
endfunction

function! GetUniqueSessionName()
  let path = fnamemodify(getcwd(), ':~:t')
  let path = empty(path) ? 'no-project' : path
  let branch = gitbranch#name()
  let branch = empty(branch) ? '' : '-' . branch
  return substitute(path . branch, '/', '-', 'g')
endfunction

function! GetCustomHeader()
  return [
	\'                                             __  _  ____  ____ __  __ _  __  __ ',
	\'                                            |  \| || ===|/ () \\ \/ /| ||  \/  |',
	\'                                            |_|\__||____|\____/ \__/ |_||_|\/|_|',
	\'   ..../////....................................................................',
	\]
endfunction

function! ShowDocumentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

function! UnQuote()
  normal mz
  exe 's/["' . "'" . ']\(\k*\%#\k*\)[' . "'" . '"]/\1/'
  normal g'z
endfunction
