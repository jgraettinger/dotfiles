return {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
        { "<C-\\>", desc = "Toggle floating terminal" },
        { "<leader>tt", desc = "Toggle floating terminal" },
        { "<leader>th", desc = "Toggle horizontal terminal" },
        { "<leader>tv", desc = "Toggle vertical terminal" },
    },
    opts = {
        -- Don't use open_mapping — it binds in terminal mode too,
        -- which swallows Ctrl-\ and breaks the native Ctrl-\ Ctrl-n
        -- escape sequence.
        direction = "float",
        float_opts = {
            border = "curved",
        },
    },
    config = function(_, opts)
        require("toggleterm").setup(opts)
        vim.keymap.set("n", "<leader>tt", "<cmd>1ToggleTerm direction=float<cr>", { desc = "Toggle floating terminal" })
        vim.keymap.set("n", "<leader>th", "<cmd>1ToggleTerm direction=horizontal size=15<cr>", { desc = "Toggle horizontal terminal" })
        vim.keymap.set("n", "<leader>tv", "<cmd>2ToggleTerm direction=vertical size=80<cr>", { desc = "Toggle vertical terminal" })
    end,
}
