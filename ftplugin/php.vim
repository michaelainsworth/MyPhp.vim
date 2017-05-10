if exists('b:did_ftplugin') && 1 == b:did_ftplugin
    finish
endif

setlocal cindent
setlocal expandtab
setlocal shiftwidth=4
setlocal tabstop=4
setlocal textwidth=79
setlocal colorcolumn=0
setlocal suffixesadd=.php
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%80v.\+/

" TODO: Fix this
nnoremap gitcommit gg:set textwidth=50gqqj:set textwidth=72gqG

" PHP error checking
function! PhpLint(filename)
    let l:command = "php -l '" . a:filename . "' 2>&1 > /dev/null | sed 's/^.*in \\(.*\\.php\\) on line \\([0-9]\\{1,\\}\\).*$/\\1:\\2:\\0/g'"
    let l:error_lines = system(l:command)
    echo l:error_lines
endfunction

command PhpLint :call PhpLint(expand('%:p'))<cr>


