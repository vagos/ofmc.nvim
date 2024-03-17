au BufRead,BufNewFile *.[aA][nN][bB] set filetype=anb

:lua << EOF

if not require("null-ls") then
    return
end

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
