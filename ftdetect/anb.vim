au BufRead,BufNewFile *.[aA][nN][bB] set filetype=anb

function! HighlightTypes()
    " Clear previously defined matches to avoid duplicates
    call clearmatches()

    " Open the file, search for the Types section, and extract identifiers
    let l:lines = readfile(expand('%'))
    let l:pattern = '\v(Agent|Number|Function|Symmetric_key)\s*\zs[a-zA-Z_,0-9 ]*'
    for l:line in l:lines
        " Echo line (can be read in the message history with :messages)
        if l:line =~ l:pattern
            " Extract and highlight each identifier found
            let l:identifiers = matchlist(l:line, l:pattern)
            " Remove Agent, Number, Function, and Symmetric_key from the list
            call remove(l:identifiers, 1)
            " split identifiers by comma and remove leading/trailing whitespace
            let l:identifiers = l:identifiers[0]
            let l:identifiers = split(l:identifiers, ',')
            let l:identifiers = map(l:identifiers, 'substitute(v:val, ''^\\s*\\(.*\\)\\s*\\$'', ''\\1'', '''')')
            for l:id in l:identifiers
                call matchadd('Identifier', '\<' . l:id . '\>')
            endfor
        endif
    endfor
endfunction

:lua << EOF
local null_ls = require("null-ls")

-- Define a custom diagnostic source
local ofmc_diagnostics = {
    method = null_ls.methods.DIAGNOSTICS,
    filetypes = {"anb", "AnB"},
    generator = null_ls.generator({
        command = "ofmc",
        to_stdin = false,
        from_stderr = true,
        format = "raw",
        args = {"-e", vim.fn.expand("%:p")},

        on_output = function(params, done)
            local diagnostics = {}
                if params.output:match("error at") then
                    local lnum, col, message = params.output:match("ofmc: AnB Parse error at line (%d+), column (%d+) - (.+)")
                    table.insert(diagnostics, {
                        row = tonumber(lnum),
                        col = tonumber(col),
                        source = "ofmc",
                        message = message,
                        severity = vim.diagnostic.severity.ERROR,
                    })
                end
            done(diagnostics)
        end,
    }),
}

-- Register the custom source
null_ls.register(ofmc_diagnostics)
EOF

" Trigger the function when files of type 'anb' are opened or written
autocmd BufRead,BufWritePost *.[aA][nN][bB] call HighlightTypes()
