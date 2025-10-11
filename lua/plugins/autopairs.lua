return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function()
        local npairs = require('nvim-autopairs')  -- Ensure npairs is loaded first
        local Rule = require('nvim-autopairs.rule')
        local cond = require('nvim-autopairs.conds')

        npairs.setup({
            check_ts = true,  -- Ensure that Treesitter is being checked
            map_cr = true,    -- Enable mapping of <CR>
            map_complete = true -- Enable completion for pair completion
        })

        -- Adding custom rules
        npairs.add_rule(Rule("$", "$", "tex"))

        npairs.add_rules({
            Rule("$", "$", {"tex", "latex"})
                :with_pair(cond.not_after_regex("%%"))      -- Don't add a pair if the next character is %
                :with_pair(cond.not_before_regex("xxx", 3))  -- Don't add if previous character is "xxx"
                :with_move(cond.none())                       -- Don't move right when repeating character
                :with_del(cond.not_after_regex("xx"))        -- Don't delete if the next character is "xx"
                :with_cr(cond.none()),                        -- Disable newline on <CR>
        })

        npairs.add_rules({
            Rule("$", "$", "tex")
                :with_pair(function(opts)
                    if opts.line == "aa $" then
                        return false
                    end
                end)
        })

        -- Regex rules
        npairs.add_rules({
            Rule("u%d%d%d%d$", "number", "lua")
                :use_regex(true),

            Rule("x%d%d%d%d$", "number", "lua")
                :use_regex(true)
                :replace_endpair(function(opts)
                    return opts.prev_char:sub(#opts.prev_char - 3, #opts.prev_char)
                end)
        })

        -- Special key functionality
        npairs.add_rules({
            Rule("b%d%d%d%d%w$", "", "vim")
                :use_regex(true, "<tab>")
                :replace_endpair(function(opts)
                    return opts.prev_char:sub(#opts.prev_char - 4, #opts.prev_char) .. "<esc>viwU"
                end)
        })

        -- Exclude certain filetypes
        npairs.add_rule(
            Rule("$", "$")
                :with_pair(cond.not_filetypes({"lua", "rust", "julia", "python"}))
        )
    end
}
