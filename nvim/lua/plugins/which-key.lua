return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        wk.add({
            { "<leader>f", group = "Find" },
            { "<leader>g", group = "Git" },
            { "<leader>h", group = "Hunk" },
            { "<leader>t", group = "Terminal" },
            { "<leader>r", group = "Refactor" },
            { "<leader>c", group = "Code" },
            { "<leader>i", group = "Inlay" },
        })
    end,
}
