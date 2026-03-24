return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    config = function()
        require("nvim-treesitter").setup()

        -- Install parsers (async, no-op if already present)
        require("nvim-treesitter").install({
            "lua", "rust", "go", "bash",
            "json", "yaml", "toml",
            "markdown", "markdown_inline", "vimdoc",
        })

        -- Enable treesitter highlight for every buffer
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)
            end,
        })

        -- Treesitter-based indentation
        vim.o.foldmethod = "expr"
        vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.o.foldlevel = 99

        -- Incremental node selection via treesitter
        local function get_node_range(node)
            local sr, sc, er, ec = node:range()
            return sr, sc, er, ec
        end

        vim.keymap.set("n", "<CR>", function()
            local node = vim.treesitter.get_node()
            if not node then return end
            local sr, sc, er, ec = get_node_range(node)
            vim.api.nvim_buf_set_mark(0, "<", sr + 1, sc, {})
            vim.api.nvim_buf_set_mark(0, ">", er + 1, ec - 1, {})
            vim.cmd("normal! gv")
        end, { desc = "Init treesitter selection" })

        vim.keymap.set("v", "<CR>", function()
            local node = vim.treesitter.get_node()
            if not node then return end
            -- Walk up to expand selection
            local parent = node:parent()
            if parent then
                local sr, sc, er, ec = get_node_range(parent)
                vim.api.nvim_buf_set_mark(0, "<", sr + 1, sc, {})
                vim.api.nvim_buf_set_mark(0, ">", er + 1, ec - 1, {})
                vim.cmd("normal! gv")
            end
        end, { desc = "Expand treesitter selection" })

        vim.keymap.set("v", "<BS>", function()
            local node = vim.treesitter.get_node()
            if not node then return end
            -- Walk down to shrink: pick the child that covers the cursor
            local cursor = vim.api.nvim_win_get_cursor(0)
            local row, col = cursor[1] - 1, cursor[2]
            for child in node:iter_children() do
                if child:range() ~= nil then
                    local sr, sc, er, ec = child:range()
                    if (row > sr or (row == sr and col >= sc)) and (row < er or (row == er and col <= ec)) then
                        vim.api.nvim_buf_set_mark(0, "<", sr + 1, sc, {})
                        vim.api.nvim_buf_set_mark(0, ">", er + 1, ec - 1, {})
                        vim.cmd("normal! gv")
                        return
                    end
                end
            end
        end, { desc = "Shrink treesitter selection" })
    end,
}
