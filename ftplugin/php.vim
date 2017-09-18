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

" PHP error checking
function! s:PhpLint(filename)
    "let l:command = "php -l '" . shellescape(a:filename) . "' 2>&1 > /dev/null | sed 's/^.*in \\(.*\\.php\\) on line \\([0-9]\\{1,\\}\\).*$/\\1:\\2:\\0/g'"
    let l:command = "php -l " . shellescape(a:filename)
    let l:error_lines = system(l:command)
    echo l:error_lines
endfunction

command! PhpLint :call <SID>PhpLint(expand('%:p'))

" Add a function that transforms the formatting of a function call from
" 
"     $foo->bar($a, $b, $c);
" 
" to
" 
"     $foo->bar(
"         $a,
"         $b,
"         $c
"     );

" Changes 'private $thing;' to an accessor function.
function! s:PhpVariableToAccessor() range
    '<,'>s/^\(\s*\)\(private\|protected\|public\) \$\([a-zA-Z0-9_]\+\);\s*$/\1public function \3() {\1\1return $this->\3;\1}/g
endfunction!
command! -range PhpVariableToAccessor :call <SID>PhpVariableToAccessor()

" Changes 'private $thing;' to an assignment.
" I.e., to be used in a constructor.
function! s:PhpVariableToAssignment() range
    '<,'>s/^\(\s\+\)\(private\|protected\|public\) \$\([a-zA-Z0-9_]\+\);\s*$/\1$this->\3 = $\3;/g
endfunction!
command! -range PhpVariableToAssignment :call <SID>PhpVariableToAssignment()

" Tabulates values in an array so that they are
" aligned by the "=>" characters.
function! s:PhpArrowTabulate()
    '<,'>Tab /=>
    " The following tabulation works in the format:
    "
    "     $x =
    "     [
    "           'a' => 1
    "         , 'this' => 2
    "         , 'that there' => 3
    "     ];
    "
    " It would produce:
    "
    "     $x =
    "     [
    "           'a'          => 1
    "         , 'this'       => 2
    "         , 'that there' => 3
    "     ];
    "
    " '<,'>Tab /\('[^']\+'\|"[^"]\+"\)
endfunction
command! -range PhpArrowTabulate :call <SID>PhpArrowTabulate()
vnoremap <leader>> :call <SID>PhpArrowTabulate()<cr>

" Tabulates values in a list of assignments so that they are
" aligned by the "=" character.
function! s:PhpEqualsTabulate()
    '<,'>Tab / = 
endfunction
command! -range PhpEqualsTabulate :call <SID>PhpEqualsTabulate()
vnoremap <leader>= :call <SID>PhpEqualsTabulate()<cr>

function! s:PhpSortUses()
    let l:old_p = getpos('.')
    let l:old_a = getpos("'a")
    let l:old_b = getpos("'b")

    try
        normal gg/^usema
        normal G?^usemb

        'a,'b!sort -u
    finally
        call setpos("'a", l:old_a)
        call setpos("'b", l:old_b)
        call setpos(".", l:old_p)
    endtry
endfunction
command! PhpSortUses :call <SID>PhpSortUses()
nnoremap <leader>u :call <SID>PhpSortUses()<cr>

set iskeyword=$,a-z,A-Z,48-57,_-_,.,-,>

