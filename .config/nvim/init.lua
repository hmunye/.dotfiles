vim.g.mapleader = " "
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.keymap.set("n", "-", vim.cmd.Ex)
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.opt.mouse = "a"
vim.opt.guicursor = ""
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)
vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300
vim.opt.colorcolumn = "80"
vim.opt.spelllang = "en_us"
vim.opt.spell = true
vim.opt.spellfile = os.getenv("HOME") .. "/.config/nvim/spell/en.add"

-- Built-in auto-completion fix
-- vim.cmd("set completeopt+=noselect")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    {
        "blazkowolf/gruber-darker.nvim",
        name = "gruber-darker",
        config = function()
            require("gruber-darker").setup({
                bold = true,
                invert = {
                    signs = false,
                    tabline = false,
                    visual = false,
                },
                italic = {
                    strings = false,
                    comments = false,
                    operators = false,
                    folds = false,
                },
                undercurl = true,
                underline = false,
            })
            vim.cmd("colorscheme gruber-darker")
            vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
        end
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                pickers = {
                    find_files = {
                        hidden = true,
                    },
                },
            })

            local builtin = require("telescope.builtin")

            vim.keymap.set("n", "<leader>ff", builtin.find_files)
            vim.keymap.set("n", "<leader>fg", builtin.git_files)
            vim.keymap.set("n", "<leader>fs", function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") })
            end)
        end,
    },
    {
        'stevearc/oil.nvim',
        opts = {},
        config = function()
            require("oil").setup({
                view_options = {
                    show_hidden = true
                },
            })

            vim.keymap.set("n", "-", "<CMD>Oil<CR>")
        end,

    },
    change_detection = { notify = false },
})

vim.lsp.config["clangd"] = {
    cmd = { "clangd" },
    filetypes = { "c", "cpp" },
    root_markers = { "" }
}

vim.lsp.config["rust_analyzer"] = {
    cmd = { "rustup", "run", "stable", "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml" },
    settings = {
        ["rust_analyzer"] = {
            cargo = {
                allFeatures = true,
            },
        }
    }
}

vim.lsp.enable({ "clangd", "rust_analyzer" })

vim.diagnostic.enable(not vim.diagnostic.is_enabled())

--            vim.diagnostic.config({
--                float = {
--                    focusable = false,
--                    style = "minimal",
--                    border = "rounded",
--                    source = true,
--                    header = "",
--                    prefix = "",
--                },
--                virtual_text = true,
--            })

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local hm_group = augroup("HM", {})
local yank_group = augroup("HighlightYank", {})

autocmd("LspAttach", {
    group = hm_group,
    callback = function(e)
        local opts = { buffer = e.buf }

        vim.keymap.set("n", "gd", function()
            vim.lsp.buf.definition()
        end, opts)
        vim.keymap.set("n", "gr", function()
            vim.lsp.buf.references()
        end, opts)
        vim.keymap.set("n", "K", function()
            vim.lsp.buf.hover()
        end, opts)
        vim.keymap.set("n", "<leader>ws", function()
            vim.lsp.buf.workspace_symbol()
        end, opts)
        vim.keymap.set("n", "<leader>ca", function()
            vim.lsp.buf.code_action()
        end, opts)
        vim.keymap.set("n", "<leader>rn", function()
            vim.lsp.buf.rename()
        end, opts)
        vim.keymap.set("i", "<C-h>", function()
            vim.lsp.buf.signature_help()
        end, opts)

        local client = vim.lsp.get_client_by_id(e.data.client_id)

        if not client then
            return
        end

        if client:supports_method("textDocument/formatting") then
            autocmd("BufWritePre", {
                buffer = e.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = e.buf, id = client.id })
                end,
            })
        end

        --        if client:supports_method('textDocument/completion') then
        --            vim.lsp.completion.enable(true, client.id, e.buf, { autotrigger = true })
        --        end
    end,
})

autocmd("TextYankPost", {
    group = yank_group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 40,
        })
    end,
})
