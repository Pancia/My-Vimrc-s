set shiftwidth=2
set tabstop=2

highlight link clojureKeyword Constant

let g:airline_detect_whitespace=0

let g:clojure_maxlines=300
let g:clojure_align_multiline_strings=1
let g:clojure_syntax_keywords = {
      \ 'clojureMacro': [
      \   'defsc', '>defn', 'defmutation',
      \   'specification', 'behavior', 'provided', 'assertions', 'component',
      \   'provided', 'when-mocking', 'provided!', 'when-mocking!',
      \   ]
      \ }

let g:clojure_fuzzy_indent = 1
let g:clojure_fuzzy_indent_patterns = '.*'
let g:clojure_fuzzy_indent_blacklist = []

" LANDMARK: ======== CONJURE =========

function! ResolveSymbol()
  call luaeval("require('conjure.client')['with-filetype']('clojure', require('conjure.eval')['eval-str'], { origin = 'dotfiles/clojuredocs', code = '(do {:conjure-highlight/silent true} `".expand("<cword>").")', ['passive?'] = true, ['on-result'] = function(sym) vim.api.nvim_command('call OpenClojureDocs(\"'..sym..'\")') end})")
endfunction

function! OpenClojureDocs(fqsym)
  echomsg "open clojure docs for: " . a:fqsym
  let [l:ns, l:sym] = split(a:fqsym, "/")
  if l:ns =~? 'clojure\..*'
    execute "!open 'https://clojuredocs.org/".l:ns."/".l:sym."'"
  else
    execute "!open 'https://www.google.com/search?q=".a:fqsym."'"
  endif
endfunction

nnoremap ,vd :call ResolveSymbol()<CR>

function! KaochaRunTest()
  call luaeval("require('conjure.client')['with-filetype']('clojure', require('conjure.eval')['eval-str'], { origin = 'dotfiles/run_specification', code = '(require (symbol \"kaocha.repl\"))(kaocha.repl/run '..require('conjure.extract')['form']({['root?'] = true})['content']..' (if (.exists (new java.io.File \"tests.local.edn\")) {:config-file \"tests.local.edn\"} {}))' })")
endfunction

nnoremap ,tt :call KaochaRunTest()<CR>

nnoremap <buffer><silent> ,cs :ConjureConnect 9000<CR>

nnoremap <buffer><silent> ,fg :ConjureEval (require 'development)(in-ns 'development)(start)<CR>
nnoremap <buffer><silent> ,fs :ConjureEval (require 'development)(in-ns 'development)(stop)<CR>
nnoremap <buffer><silent> ,fr :ConjureEval (require 'development)(in-ns 'development)(restart)<CR>

nnoremap <buffer><silent> ,vc :ConjureEval {:vlaaad.reveal/command '(clear-output)}<CR>

nnoremap <buffer><expr> <esc> bufname('') =~ 'conjure-log-\d\+.cljc' ? ':normal ,lq<CR>' : '<esc>'

" LANDMARK: ======== LSP =========

setlocal completefunc=LanguageClient#complete

nnoremap <buffer><silent> K    :call LanguageClient#textDocument_hover()<CR>
nnoremap <buffer><silent> gd   :call LanguageClient#textDocument_definition()<CR>

function! s:Expand(exp) abort
    let l:result = expand(a:exp)
    return l:result ==# '' ? '' : "file://" . l:result
endfunction

function! LSP_exe_here(cmd, ...) abort
  call LanguageClient#workspace_executeCommand(a:cmd,
        \ [s:Expand('%:p'), line('.') - 1, col('.') - 1] + a:000)
endfunction

function! LSP_restart()
    LanguageClientStop
    LanguageClientStart
endfunction

call WhichKey_GROUP('s', '+lsp')
call WhichKey_CMD('ss', 'restart', 'LSP_restart()')

call WhichKey_GROUP('sr', '+refactorings')

call WhichKey_GROUP('srt', '+threading')
call WhichKey_CMD('srtf', 'thread-first', 'LSP_exe_here("thread-first")')
call WhichKey_CMD('srtt', 'thread-last', 'LSP_exe_here("thread-last")')
call WhichKey_CMD('srtF', 'thread-first-all', 'LSP_exe_here("thread-first-all")')
call WhichKey_CMD('srtT', 'thread-last-all', 'LSP_exe_here("thread-last-all")')
call WhichKey_CMD('srtu', 'unwind-thread', 'LSP_exe_here("unwind-thread")')
call WhichKey_CMD('srtU', 'unwind-all', 'LSP_exe_here("unwind-all")')

call WhichKey_GROUP('srr', '+requires')
call WhichKey_CMD('srra', 'add-missing-libspec', 'LSP_exe_here("add-missing-libspec")')

call WhichKey_GROUP('srl', '+let')
call WhichKey_CMD('srle', 'expand-let', 'LSP_exe_here("expand-let")')
call WhichKey_CMD('srlm', 'move-to-let', 'LSP_exe_here("move-to-let", input("Binding name: "))')
call WhichKey_CMD('srli', 'introduce-let', 'LSP_exe_here("introduce-let", input("Binding name: "))')
call WhichKey_CMD('su', 'find usages', 'LanguageClient#textDocument_references()')

" LANDMARK: ======== COPILOT =========

nnoremap <buffer><silent> ,gcf :call copilot#check_current_file()<CR>
nnoremap <buffer><silent> ,gcF :call copilot#refresh_and_check_current_file()<CR>
nnoremap <buffer><silent> ,gcr :call copilot#check_root_form()<CR>
nnoremap <buffer><silent> ,gcR :call copilot#refresh_and_check_root_form()<CR>
