return {
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        opts = {
            formatters_by_ft = {
                rust = { "rustfmt" },
                go = { "goimports", "gofmt" },
                lua = { "stylua" },
            },
            format_on_save = {
                timeout_ms = 3000,
                lsp_format = "fallback",
            },
        },
    },
    {
        "mfussenegger/nvim-lint",
        event = "BufWritePost",
        config = function()
            local lint = require("lint")
            lint.linters_by_ft = {
                go = { "golangcilint" },
            }
            vim.api.nvim_create_autocmd("BufWritePost", {
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
}
