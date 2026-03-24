-- Set leader key before anything else
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Load core config
require("options")
require("keymaps")

-- Load plugins (auto-discovers lua/plugins/*.lua)
require("lazy").setup("plugins")

-- Show cheat sheet on bare startup (no file args)
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argc() == 0 and vim.api.nvim_buf_get_name(0) == "" then
            local cheatsheet = vim.fn.stdpath("config") .. "/cheatsheet.md"
            vim.cmd.edit(cheatsheet)
            vim.bo.buftype = "nofile"
            vim.bo.bufhidden = "wipe"
            vim.bo.modifiable = false
        end
    end,
})
